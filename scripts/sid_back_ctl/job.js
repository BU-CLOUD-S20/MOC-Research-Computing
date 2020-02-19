const Joi = require('joi');
const pino = require('pino')();

BACKEND_ENV = 'development';

var KubernetesJobTemplate = function (it, containers, volumes) {

    var t = {
        'apiVersion': 'batch/v1',
        'kind': 'Job',
        'metadata': {
            'name': `sid-job-${it.jobId}`,
        },
        'spec': {
            'ttlSecondsAfterFinished': 100,
            'backoffLimit': 0,
            'template': {
                'metadata': {
                    'labels': {
                        'sid_app': `${it.jobType}-${it.jobId}`,
                        'sid_jobId': it.jobId,
                        'sid_application': `${it.application}`,
                        'sid_application_version': `${it.application_version}`,
                        'sid_userID': `${it.userName}`,
                        'sid_jobType': `${it.type}`
                    }
                },
                'spec': {
                    'serviceAccountName': 'sid-job-runner',
                    'volumes': volumes,
                    'restartPolicy': 'Never',
                    'priorityClassName': 'interactive-job',
                    'containers': containers
                }
            }
        }
    };

    // In case we want to run the container as a specific user (e.g., root)
    if (undefined != it.runAsUser) {
        t.spec.template.spec.securityContext = {
            "runAsUser": it.runAsUser
        };
    }

    return t;
};

var CasApplicationContainerTemplate = function (it) {
    return {
        "name": "cas-app-proxy",
        "image": "hmdc/cas-app-proxy:v1.0.1-1",
        "ports": [{
            "containerPort": 8000,
            "protocol": "TCP"
        }],
        "readinessProbe": {
            "httpGet": {
                "path": `/${it.jobId}`,
                "port": 8000,
            },
            "initialDelaySeconds": 10,
            "periodSeconds": 10
        },
        "env": [{
            "name": "JOB_ID",
            "value": it.jobId,
        },
        {
            "name": "CAS_VALID_USER",
            "value": it.userName
        },
        {
            "name": "PROXY_DESTINATION",
            "value": `http://127.0.0.1:${it.port}`
        },
        {
            "name": "PROXYING_MODE",
            "value": it.proxying_mode
        },
        {
            "name": "NODE_ENV",
            "value": "production"
        },
        {
            "name": "CAS_SERVICE_URL",
            "value": `https://aws.${BACKEND_ENV}.sid.hmdc.harvard.edu/${it.jobId}/authenticate`
        },
        {
            "name": "CAS_SERVER_BASE_URL",
            "value": `https://aws.${BACKEND_ENV}.sid.hmdc.harvard.edu/${it.jobId}`
        },

        ],
        "resources": {
            "requests": {
                "ephemeral-storage": "1Gi"
            },
            "limits": {
                "ephemeral-storage": "1Gi"
            }
        }
    };
};

var ContainerTemplate = function (it) {
    let spec = {
        name: it.container_name,
        image: it.container_image,
        readinessProbe: {
            tcpSocket: {
                port: it.port,
            },
            initialDelaySeconds: 10,
            periodSeconds: 10
        },
        resources: {
            requests: {
                cpu: it.cpu,
                memory: `${it.memory * 1024}Mi`,
                "ephemeral-storage": "4Gi"
            },
            limits: {
                cpu: it.cpu,
                memory: `${it.memory * 1024}Mi`,
                "ephemeral-storage": "4Gi"
            }
        },
        // FIXME: Per hmdc/sid#542, these are application specific environment
        // variables being defined globally for all apps. Need to add
        // support for per-application env variables to applications.json
        // schema. See hmdc/sid#608
        "env": [{
            "name": "JOB_ID",
            "value": it.jobId
        }, {
            "name": "DISABLE_AUTH",
            "value": "true"
        }, {
            "name": "ROOT",
            "value": "TRUE"
        }, {
            "name": "GRANT_SUDO",
            "value": "yes"
        }]
    };

    // Optional command and args parameters
    if (it['command']) spec['command'] = it['command'];
    if (it['args']) spec['args'] = it['args'];

    if (it.storage) {
        spec.volumeMounts = [{
            "name": "rclone-mount",
            "mountPath": `/mnt/${it.storage.provider}`,
            "mountPropagation": "HostToContainer"
        }
        ];
    }

    // Some applications (such as Firefox and Chrome) need more /dev/shm
    if (!spec.volumeMounts) {
        spec.volumeMounts = [];
    }

    spec.volumeMounts.push({
        "mountPath": "/dev/shm",
        "name": "dshm"
    });

    return spec;
};

var KubernetesServiceTemplate = function (it) {
    return {
        "apiVersion": "v1",
        "kind": "Service",
        "metadata": {
            "name": `sid-service-${it.jobId}`,
            "namespace": "default"
        },
        "spec": {
            "ports": [{
                "port": 80,
                "targetPort": 8000
            }],
            "selector": {
                "sid_jobId": it.jobId
            },
            "type": "ClusterIP",
            "sessionAffinity": "None"
        }
    };
};

var KubernetesIngressTemplate = function (it) {
    return {
        "apiVersion": "extensions/v1beta1",
        "kind": "Ingress",
        "metadata": {
            "name": `sid-ingress-${it.jobId}`,
            "annotations": {
                "kubernetes.io/ingress.class": "nginx",
                "nginx.org/websocket-services": `sid-service-${it.jobId}`,
                "nginx.ingress.kubernetes.io/ssl-redirect": "false",
                "nginx.ingress.kubernetes.io/force-ssl-redirect": "false"
            }
        },
        "spec": {
            "rules": [{
                "http": {
                    "paths": [{
                        "path": `/${it.jobId}`,
                        "backend": {
                            "serviceName": `sid-service-${it.jobId}`,
                            "servicePort": 80
                        }
                    }]
                }
            }]
        }
    };
};

var KubernetesJobSchema = Joi.object().keys({
    userName: Joi.string().alphanum().min(6).max(8).required(),
    application: Joi.string().alphanum().required(),
    application_version: Joi.string().required(),
    jobId: Joi.string().guid().required(),
    container_name: Joi.string().required(),
    container_image: Joi.string().required(),
    command: Joi.optional(),
    args: Joi.optional(),
    runAsUser: Joi.number().integer().optional(),
    type: Joi.string().valid(['interactive']).required(),
    proxying_mode: Joi.string().valid(['xpra', 'rstudio', 'none']).required(),
    port: Joi.number().integer().min(7999).when('type', {
        is: Joi.string().regex(/^interactive$/),
        then: Joi.required()
    }),
    storage: Joi.object(),
    cpu: Joi.number().integer().min(1).required(),
    memory: Joi.number().integer().min(1).required(),
});

var StorageContainer = function (it) {
    const storage = it.storage;
    return {
        "name": "rclone-mount",
        "image": "hmdc/rclone-mount:v1.49.1-1",
        "securityContext": {
            "privileged": true
        },
        "env": [{
            "name": "GDRIVE_CLIENT_ID",
            "value": process.env.GDRIVE_CLIENT_ID
        },
        {
            "name": "GDRIVE_CLIENT_SECRET",
            "value": process.env.GDRIVE_CLIENT_SECRET
        },
        {
            "name": "GDRIVE_ACCESS_TOKEN",
            "value": storage.access_token
        },
        {
            "name": "GDRIVE_REFRESH_TOKEN",
            "value": storage.refresh_token
        },
        ],
        "volumeMounts": [{
            "name": "fuse-device-mount",
            "mountPath": "/dev/fuse"
        },
        {
            "name": "rclone-mount",
            "mountPath": "/mnt",
            "mountPropagation": "Bidirectional"
        }
        ],
        "resources": {
            "requests": {
                "ephemeral-storage": "1Gi"
            },
            "limits": {
                "ephemeral-storage": "1Gi"
            }
        }

    };
};

var KubernetesVolumeTemplate = function (it) {

    // Some applications (such as Firefox and Chrome) need more /dev/shm
    var volumes = [{
        "name": "dshm",
        "emptyDir": {
            "medium": "Memory"
        }
    }];

    if (it.storage === undefined || it.storage === null) return volumes;

    var _volumes = volumes;
    volumes = _volumes.concat([
        {
            "name": "fuse-device-mount",
            "hostPath": {
                "path": "/dev/fuse"
            }
        }, {
            "name": "rclone-mount",
            "hostPath": {
                "path": `/mnt/${it.jobId}`,
                "type": "DirectoryOrCreate"
            }
        }
    ]);

    return volumes;
};

var KubernetesJobSpecification = function (it) {
    const results = Joi.validate(it, KubernetesJobSchema);
    const volumes = KubernetesVolumeTemplate(it);

    if (results.error) {
        pino.error(results.error);
        return {
            error: results.error
        };
    }

    if (it.type === 'interactive') {
        let containers = [
            CasApplicationContainerTemplate(it),
            ContainerTemplate(it)
        ];

        if (it.storage) containers.push(StorageContainer(it));

        const job = KubernetesJobTemplate(it, containers, volumes);

        return {
            error: null,
            result: {
                ingress: KubernetesIngressTemplate(it),
                service: KubernetesServiceTemplate(it),
                job: job
            }
        };
    }

    return {
        error: null,
        result: KubernetesJobTemplate(it, [ContainerTemplate(it)])
    };

};

module.exports = KubernetesJobSpecification;
