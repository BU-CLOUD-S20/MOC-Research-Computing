<br>

# Terraform for Openshift

<br>
Terraform will be used to deploy the frontend, middleware, and backend. 

Although there is no Openshift Provider for terraform, we can utilize the [kubernetes provider](https://www.terraform.io/docs/providers/kubernetes/index.html "Kube Provider") as Openshift exposes the full kubernetes API. 

<br>

---

<br>

## Basics

[TUTORIAL: Using the Kubernetes Provider with Openshift](https://medium.com/@fabiojose/platform-as-code-with-openshift-terraform-1da6af7348ce "tutorial")

Provider.tf: provider file logins into openshift

modules: define a set of resources (frontend, middleware, and backend)

  - *./modules/frontend/frontend-resources.tf:* where the frontend resources are defined (openshift)
  - *./modules/backend/backend-resources.tf:* where the backend resources are defined (openstack)

current plan is to build whole frontend/middlware solution as a single pod. this will allow for easy networking between the components, and quickly scaling up and down 

<br>

---

<br>

## Containerizing Node applications and Private Docker Repo

[TUTORIAL: using docker to build node containers](https://nodejs.org/fr/docs/guides/nodejs-docker-webapp/ "tutorial")

The sid frontend and backend worker need to be containerized before being deployed on openshift. for this we will use Docker. 

The docker images will need to be built, tagged, and pushed to the Openshift Docker Registry before being able to deploy any of the front or middleware. 

to do this you must perform the following:
~~~
//login into Openshift via CLI
oc login https://k-openshift.osh.massopen.cloud:8443 --token=<TOKEN>


add the following to the /etc/docker/daemon.json (create if needed)

{
  "insecure-registries" : ["docker-registry-default.k-apps.osh.massopen.cloud"]
  
}



//login into the private docker registry on Openshift
docker login -u <account_name> -p `oc whoami -t` docker-registry-default.k-apps.osh.massopen.cloud


//copy dockerfiles to sid directory
cp $Git_DIR/scripts/docker/Dockerfile-gulp   $Sid_DIR/
cp $Git_DIR/scripts/docker/Dockerfile-worker $Sid_DIR/

//build and tag 
sudo docker build -t docker-registry-default.k-apps.osh.massopen.cloud/on-demand-research-computing-k8-env/worker:latest -f Dockerfile-worker .

sudo docker build -t docker-registry-default.k-apps.osh.massopen.cloud/on-demand-research-computing-k8-env/gulp:latest -f Dockerfile-gulp .

//push to Openshift Repo
docker push docker-registry-default.k-apps.osh.massopen.cloud/on-demand-research-computing-k8-env/worker:latest

docker push docker-registry-default.k-apps.osh.massopen.cloud/on-demand-research-computing-k8-env/gulp:latest

cd $Git_DIR/terraform-oc/

terraform init

terraform apply

~~~
<br>

---


