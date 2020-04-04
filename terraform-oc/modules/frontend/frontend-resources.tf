resource "kubernetes_deployment" "sidfrontend" {
    metadata {
      namespace = "on-demand-research-computing-k8-env"
      name = "sid-front-and-middleware"
    }

    spec {
      replicas = 3 
      selector {
        match_labels = {
          test = "frontend"
        }
      }

      template {
        metadata {
          labels = {
            test = "frontend"
          }
        }
      spec {
        container {
          image = "redis"
          name  = "redis"
          port{
              container_port = 6379
          }
          env {
            name  = "environment"
            value = "test"
          }
        }
        container {
          image = "mongo"
          name  = "mongodb"
          port{
              container_port = 27017
          }
          env {
            name  = "environment"
            value = "test"
          }
        }
        container {
          image = "node"
          name  = "worker"
          env {
            name  = "environment"
            value = "test"
          }
        }
        container {
          image = "node"
          name  = "frontend"
          env {
            name  = "environment"
            value = "test"
          }
        }
      }
    }
  }
}