
provider "kubernetes" {
  host = "https://k-openshift.osh.massopen.cloud:8443"

  token = "..."

  load_config_file = false
}
