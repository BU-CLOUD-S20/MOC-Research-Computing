resource "openstack_compute_keypair_v2" "my-cloud-key" {
  name       = "my-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfkwujdOhJfk8PPsupm/MSvQsARLIqVhQ+oGPGLEUnwYHYoKsdZSUzMgTLfRv1NBKBLEoCiLXdQ/nk5WcecQnPxm7IAJChZ9VVUT6nK8+1VLm5MGeaGcsf6eHdCZfUyn9Vtab4UE+eBibhSwHLax7u8pBehHgAMocC3X1NIixXIct6FEa14c2IaeXiGyto3EVo/UuaQnkI71fmlcyhtdjg42anLjDgMA+L2Y5N04SmNeLHoAHwZ9n91ZZcE0wiRVlmdWk5auDWfUqzZLBTf/mmfuqhUNkhD4oD9H2RJgi1eR8TRlgm3rOhMwBHWGo+LeRygB6h2JzMDNJ75k6lBO2V Generated-by-Nova" 
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
