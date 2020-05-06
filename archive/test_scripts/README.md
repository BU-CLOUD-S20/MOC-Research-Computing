# Helper Scripts

## `run.sh`
After installing all the requirement, you can use this script to run the Sid service.

**Make sure you have `tmux` installed.** You can use your favorite package manager to install tmux. 

Firstly, set up some variables in script:
```bash
SID_HOME=~/src/sid #Root dir of local Sid git repo
VM_DRIVER=kvm2 #Specific VM driver in K8S
SIZE_CPU=4 #Cores of CPU in K8S
SIZE_MEM=8000 #Memory in K8S (in MiB)
```
Then make a clean up:
```
bash run.sh clean
```
You can now run the Sid service in your local machine:
```
bash run.sh
```
> The dockers are running in background.
>
> The Sid Worker Nodejs Server runs in a tmux session, use `tmux attach -t sid_worker` to see the output, use `Ctrl-B D` to detach current tmux session.

---------

## `sid_back_ctl`
*Currently, this helper script is not fully functional.*

Firstly, following the instruction to run Kubernetes with ingress enabled. Then get in to `sid_ctl` directory and run `bash run.sh`. This script will deploy a "1 CPU / 4Gi Mem" Sid-Desktop application in Kubernetes. After that, you can use `kubectl delete --all pods` to release resource.

Note that you don't need to run docker (Redis and MongoDB) and make other setups. But if you want to access the link, you have to **update** host file by:
```bash  
sudo sed -E -e 's/^[0-9.]+( +aws\.development\.sid\.hmdc\.harvard\.edu)/'$(minikube ip)'\1/' -i  /etc/hosts
```