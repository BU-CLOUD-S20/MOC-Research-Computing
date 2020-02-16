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