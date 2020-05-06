resource "openstack_compute_keypair_v2" "my-cloud-key" {
  name       = "my-key"
  public_key = "ssh-rsa AAAAB3............"
}

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
