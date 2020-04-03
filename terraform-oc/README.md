# Terraform for Openshift

Terraform will be used to deploy the front and middleware. 

Although there is no Openshift Provider for terraform, we can utilize the [kubernetes provider](https://www.terraform.io/docs/providers/kubernetes/index.html "Kube Provider") as Openshift exposes the full kubernetes API. 

---

## Basics

[TUTORIAL: Using the Kubernetes Provider with Openshift](https://medium.com/@fabiojose/platform-as-code-with-openshift-terraform-1da6af7348ce "tutorial")

Provider.tf: provider file logins into openshift

modules: define a set of resources (frontend and middleware)


---


