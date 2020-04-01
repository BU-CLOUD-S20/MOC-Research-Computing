# Deploying a VM in OpenStack via Terraform

Basically follow tutorial https://galaxyproject.github.io/training-material/topics/admin/tutorials/terraform/tutorial.html

Log in to the OpenStack dashboard, create Application Credentials and save as clouds.yaml
 
Create a new directory, put clouds.yaml in it and go into it.

Create a providers.tf file with the following contents:
```
provider "openstack" {
  cloud = "openstack"
}
```

Create key pairsso you can get public key

Create a new file, main.tf with the following structure. In public_key, write the complete value of your public key that you foun.
```
resource "openstack_compute_keypair_v2" "my-cloud-key" {
  name       = "my-key"
  public_key = "ssh-rsa AAAAB3Nz..."
}
```

    brew install terraform
    terraform init
    terraform plan
    terraform apply

If everything is fine, add information of the VM which you want to launch in main.tf like below:
```
resource "openstack_compute_instance_v2" "terraform" {
  name            = "terraform-vm"
  image_name      = "Ubuntu 18 LTS"
  flavor_name     = "m1.tiny"
  key_pair        = "${openstack_compute_keypair_v2.my-cloud-key.name}"
  security_groups = ["default"]

  network {
    name = "default_network"
  }
}
```

    terraform apply

Done! Can run below to check the result

    terraform show
