export KUBERNETES_CA_CERT=$(base64 ~/.minikube/ca.crt)
export KUBERNETES_URL=$(kubectl config view --minify | grep server | cut -f 2- -d ':' | tr -d ' ')
export KUBERNETES_TOKEN=$(kubectl describe secret $(kubectl get secrets | grep \^sid-job-runner | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d ' ')
node main.js