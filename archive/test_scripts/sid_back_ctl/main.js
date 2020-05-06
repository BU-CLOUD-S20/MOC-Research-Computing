const K8SJob = require('./job');
const uuidV1 = require('uuid/v1');
const pino = require('pino')();
const KubernetesClient = require('kubernetes-client').Client;

const k8s_url = process.env.KUBERNETES_URL;
const k8s_token = process.env.KUBERNETES_TOKEN;
const k8s_ca = process.env.KUBERNETES_CA_CERT;

const app_info = {
    desktop: {
        name: "desktop",
        version: "1.1.8-1",
        default: true,
        defaultInJobSelection: true,
        container: "hmdc/sid-desktop:v1.1.8-1",
        registry: "dockerhub",
        proxying_mode: "xpra",
        port: 8080
    }
};

const app = app_info.desktop;

const settings = {
    userName: "casuser",
    jobId: uuidV1(),
    type: "interactive",
    cpu: 1,
    memory: 4,
    storage: undefined,
    application: app.name,
    application_version: app.version,
    container_name: app.name,
    container_image: app.container,
    proxying_mode: app.proxying_mode,
    port: app.port
};

// If you want to use Jupyter and RStudio please check the arguments and additional command (see sample json response)

const job = K8SJob(settings);

const client = new KubernetesClient({
    config: {
        url: k8s_url,
        auth: {
            bearer: k8s_token,
        },
        ca: Buffer.from(k8s_ca, 'base64').toString()
    }
})

let request_k8s = async function (k8s_url, k8s_token, k8s_ca, jobs) {
    const client = new KubernetesClient({
        config: {
            url: k8s_url,
            auth: {
                bearer: k8s_token,
            },
            ca: Buffer.from(k8s_ca, 'base64').toString()
        }
    })
    await client.loadSpec();
    try {
        await client.apis.batch.v1.namespaces('default').jobs.post({
            body: jobs.job
        });
        await client.apis.extensions.v1beta1.namespaces('default').ingresses.post({
            body: jobs.ingress
        });
        await client.api.v1.namespaces('default').services.post({
            body: jobs.service
        });
    } catch (e) {
        pino.error({
            action: 'kubernetes_create_job',
            message: e.toString(),
            job: jobs.data.job,
            ingress: jobs.data.ingress,
            service: jobs.data.service
        });
    }
}

pino.info(job.result)
request_k8s(k8s_url, k8s_token, k8s_ca, job.result);