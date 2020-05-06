# your Kubernetes cluster name here
cluster_name = "k8s-test-cluster"

# list of availability zones available in your OpenStack cluster
#az_list = ["nova"]

# SSH key to use for access to nodes
public_key_path = "~/.ssh/id_rsa.pub"

# image to use for bastion, masters, standalone etcd instances, and nodes
image = "centos-7-x86_64"

# user on the node (ex. core on Container Linux, ubuntu on Ubuntu, etc.)
ssh_user = "cent"

# 0|1 bastion nodes
number_of_bastions = 1
flavor_bastion = "fb430023-276f-49bb-8919-49de5111170a" #m1.s2.large

# standalone etcds
number_of_etcd = 0

# masters
number_of_k8s_masters = 0

number_of_k8s_masters_no_etcd = 0

number_of_k8s_masters_no_floating_ip = 1

number_of_k8s_masters_no_floating_ip_no_etcd = 0

# flavor_k8s_master = "02483ee4-1012-452f-9dc1-abf1c951ea39"
flavor_k8s_master = "fb430023-276f-49bb-8919-49de5111170a" #m1.s2.large

# nodes
number_of_k8s_nodes = 0

number_of_k8s_nodes_no_floating_ip = 1

# flavor_k8s_node = "02483ee4-1012-452f-9dc1-abf1c951ea39"
flavor_k8s_node = "fb430023-276f-49bb-8919-49de5111170a" #m1.s2.large

# GlusterFS
# either 0 or more than one
#number_of_gfs_nodes_no_floating_ip = 0
#gfs_volume_size_in_gb = 150
# Container Linux does not support GlusterFS
#image_gfs = "<image name>"
# May be different from other nodes
#ssh_user_gfs = "ubuntu"
#flavor_gfs_node = "<UUID>"

# networking
network_name = "k8s-test-net"

external_net = "71b97520-69af-4c35-8153-cdf827d96e60"

subnet_cidr = "10.2.0.0/24"

floatingip_pool = "external"

bastion_allowed_remote_ips = ["0.0.0.0/0"]
master_allowed_remote_ips = ["0.0.0.0/0"]
