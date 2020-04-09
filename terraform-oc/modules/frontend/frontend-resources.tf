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
            name  = "MONGO_INITDB_ROOT_USERNAME"
            value = "mongoadmin"
          }
          env {
            name  = "MONGO_INITDB_ROOT_PASSWORD"
            value = "secret"
          }
        }
        container {
          image = "docker-registry.default.svc:5000/on-demand-research-computing-k8-env/worker:v2"
          name  = "worker"
          port{
              container_port = 8080
          }
          env {
            name  = "BACKEND_ENV"
            value = "development"
          }
          env {
            name  = "KUBERNETES_CA_CERT"
            value = "ABABABABABBABABABABBABABAB"
          }
          env {
            name  = "KUBERNETES_URL"
            value = "10.0.0.1"
          }
          env {
            name  = "KUBERNETES_TOKEN"
            value = "BABABABBABABABABABABBABABABAB"
          }
        }
        container {
          image = "docker-registry.default.svc:5000/on-demand-research-computing-k8-env/gulp:v3"
          name  = "frontend"
          port{
              container_port = 3000
          }
          env {
            name  = "GDRIVE_CLIENT_ID"
            value = "test"
          }
          env {
            name  = "GDRIVE_CLIENT_SECRET"
            value = "test"
          }
          env {
            name  = "GDRIVE_CALLBACK_URL"
            value = "https://development.sid.hmdc.harvard.edu/auth/storage/google/callback"
          }
          env {
            name  = "DEBUG"
            value = "*"
          }
          env {
            name  = "BACKEND_ENV"
            value = "development"
          }
          env {
            name  = "NODE_ENV"
            value = "local"
          }
          env {
            name  = "EXPRESS_SECRET"
            value = "abc"
          }
          env {
            name  = "serverBaseURLHarvardLogin"
            value = "https://development.sid.hmdc.harvard.edu"
          }
          env {
            name  = "serviceURLHarvardLogin"
            value = "https://development.sid.hmdc.harvard.edu/login"
          }
          env {
            name  = "ssoBaseURLHarvardLogin"
            value = "test"
          }
          env {
            name  = "USE_MOCK_CAS"
            value = "0"
          }
          env {
            name  = "MONGODB_URI"
            value = "mongodb://mongoadmin:secret@localhost/rce_database?authSource=admin"
          }

        }
      }
    }
  }
}
