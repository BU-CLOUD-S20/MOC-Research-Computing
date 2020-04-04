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

## Containerizing Node applications

[TUTORIAL: using docker to build node containers](https://nodejs.org/fr/docs/guides/nodejs-docker-webapp/ "tutorial")

The sid frontend and backend worker need to be containerized before being deployed on openshift. for this we will use Docker. Automation of the image build process can be done with the terraform docker provider

<br>

---


