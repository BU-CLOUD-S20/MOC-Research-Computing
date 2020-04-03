
resource "kubernetes_deployment" "Middleware" {
    metadata {
      namespace = "on-demand-research-computing-k8-env"
      name = "redis"
    }

    spec {
      replicas = 2 
      selector {
        match_labels = {
          test = "middleware"
        }
      }

      template {
        metadata {
          labels = {
            test = "middleware"
          }
        }
      spec {
        container {
          image = "redis"
          name  = "redis"
          env {
            name  = "environment"
            value = "test"
          }
        }
        container {
          image = "mongo"
          name  = "mongodb"
          env {
            name  = "environment"
            value = "test"
          }
        }
      }
    }
  }
}