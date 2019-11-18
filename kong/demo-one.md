
https://kubecon.konglabs.io/


## Install Helm


kubectl -n kube-system create serviceaccount tiller

kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

helm init --service-account tiller

kubectl get pods --namespace kube-system

## Install Kong


k apply -f https://bit.ly/kong-ingress-dbless


## Set up environment variables

export PROXY_IP=$(kubectl get -o jsonpath="{.spec.clusterIP}" service -n kong kong-proxy) - this only works when making calls from within the cluster


export PROXY_IP=$(kubectl get -o jsonpath="{.spec.externalIP}" service -n kong kong-proxy) 

## Verify environment variable

curl -i $PROXY_IP

## Setup sample services

curl -sL  https://bit.ly/sample-echo-service | kubectl apply -f -

curl -sL  https://bit.ly/sample-httpbin-service | kubectl apply -f - 

## Configure a basic proxy

