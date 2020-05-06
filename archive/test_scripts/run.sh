#!/usr/bin/bash

SID_HOME=~/src/sid
VM_DRIVER=kvm2
SIZE_CPU=4
SIZE_MEM=8000

if [[ "$1" == "clean" ]]; then
	minikube delete
	sudo docker stop $(sudo docker ps -a -q)
	sudo docker kill $(docker ps -q)
	sudo docker rm $(docker ps -a -q)
	sudo docker system prune -a
	sudo docker volume prune
	sudo docker rm $(sudo docker ps -a -q)
	sudo docker volume rm $(sudo docker volume ls -qf dangling=true)
	sudo docker network rm $(sudo docker network ls -q)
	sudo kill -9 $(sudo lsof -t -i :27017 -s TCP:LISTEN)
	tmux kill-server
	#sudo lsof -nP | grep LISTEN
else
	### MINIKUBE SETUP
	minikube start --memory ${SIZE_MEM} --cpus ${SIZE_CPU} --vm-driver ${VM_DRIVER}
	kubectl create -f ${SID_HOME}/kube-seed/permissions.yaml
	kubectl create -f ${SID_HOME}/kube-seed/priorityclasses.yaml
	minikube addons enable ingress


	### UPDATE IP
	sudo sed -E -e 's/^[0-9.]+( +aws\.development\.sid\.hmdc\.harvard\.edu)/'$(minikube ip)'\1/' -i  /etc/hosts


	### DOCKER SETUP
	sudo docker run -t -d -p 6379:6379 redis
	sudo docker run -t -d -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=mongoadmin -e MONGO_INITDB_ROOT_PASSWORD=secret mongo


	### MONGO IMPORT
	MONGO_SEED_DIR=${SID_HOME}/mongo-seed
	mongoimport -h localhost -u mongoadmin -p secret --db rce_database --collection VMDs --type json --file ${MONGO_SEED_DIR}/limits.json --jsonArray --authenticationDatabase admin
	mongoimport -h localhost -u mongoadmin -p secret --db rce_database --collection applications --type json --file ${MONGO_SEED_DIR}/applications.json --jsonArray --authenticationDatabase admin


	### SID WORKER 
	tmux new-session -d -s sid_worker
	tmux send-keys -t sid_worker.0 "cd ${SID_HOME}" C-m
	tmux send-keys -t sid_worker.0 'export KUBERNETES_CA_CERT=$(base64 ~/.minikube/ca.crt)' C-m
	tmux send-keys -t sid_worker.0 "export KUBERNETES_URL=$(kubectl config view --minify | grep server | cut -f 2- -d ':' | tr -d ' ')" C-m
	tmux send-keys -t sid_worker.0 "export KUBERNETES_TOKEN=$(kubectl describe secret $(kubectl get secrets | grep \^sid-job-runner | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d ' ')" C-m
	tmux send-keys -t sid_worker.0 "node ${SID_HOME}/worker/index.js" C-m


	### SETUP DEMO CAS SEVER
	USE_MOCK_CAS=1
	CAS_URL='https://casserver.herokuapp.com/cas'


	### BYPASS GOOGLE DRIVE CREDENTIALS
	#GDRIVE_CLIENT_ID=$(heroku config:get --app iqss-sid-env-uat GDRIVE_CLIENT_ID)
	#GDRIVE_CLIENT_SECRET=$(heroku config:get --app iqss-sid-env-uat GDRIVE_CLIENT_SECRET)
	GDRIVE_CLIENT_ID=xyz
	GDRIVE_CLIENT_SECRET=xyz


	### RUN FRONTEND
	cd ${SID_HOME}
	sudo env GDRIVE_CLIENT_ID=${GDRIVE_CLIENT_ID} GDRIVE_CLIENT_SECRET=${GDRIVE_CLIENT_SECRET} GDRIVE_CALLBACK_URL=https://development.sid.hmdc.harvard.edu/auth/storage/google/callback DEBUG='*' BACKEND_ENV=development NODE_ENV=local EXPRESS_SECRET=abc serverBaseURLHarvardLogin='https://development.sid.hmdc.harvard.edu' serviceURLHarvardLogin='https://development.sid.hmdc.harvard.edu/login' ssoBaseURLHarvardLogin="${CAS_URL}" USE_MOCK_CAS=${USE_MOCK_CAS} MONGODB_URI='mongodb://mongoadmin:secret@localhost/rce_database?authSource=admin' ${SID_HOME}/node_modules/gulp/bin/gulp.js run
fi
