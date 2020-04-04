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
          port{
              container_port = 8080
          }
          env {
            name  = "environment"
            value = "test"
          }
        }
        container {
          image = "node"
          name  = "frontend"
          port{
              container_port = 8080
          }
          env {
            name  = "environment"
            value = "test"
          }
        }
      }
    }
  }
}