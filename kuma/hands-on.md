

https://github.com/Kong/kuma/tree/master/examples/kubernetes/kuma-demo


 cd examples/kubernetes/kuma-demo/


## Install Kuma

Download

wget https://kong.bintray.com/kuma/kuma-0.3.0-ubuntu-amd64.tar.gz



tar xvzf kuma-0.3.0-ubuntu-amd64.tar.gz
cd bin/ && ls
envoy   kuma-cp   kuma-dp   kuma-tcp-echo kumactl




 ## Deploy sample marketplace application

 kubectl apply -f http://bit.ly/kuma1116

or
kuma/kubernetes/kuma-demo

kubectl apply -f kuma-demo-aio.


## Download and extract

kuma

Install control plane

./kumactl instll control-plane | kubectl apply -f


## Check install

k get pods -n kuma-system

## Delete existing demo pods to restart

kubectl delete pods --all -n kuma-demo


## Port forward App

k get pods -n kuma-demo

kubectl port-forward ${KUMA_DEMO_APP_POD_NAME} -n kuma-demo 8080:80

k port-forward  kuma-demo-app-85bb496b68-2cb8g -n kuma-demo 8080:80

## Portforward Kuma Control Plan

kubectl -n kuma-system port-forward ${KUMA_CP_POD_NAME} 5681

k -n kuma-system port-forward kuma-control-plane-9c8b76556-phwht 5681

k get pods -n kuma-system

## Configure kumactl to point towards the control plan address

./kumactl config control-planes add --name=minikube --address=http://localhost:5681


## Enable MTLS

apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
  namespace: kuma-system
spec:
  mtls:
    ca:
      builtin: {}
    enabled: true


k apply -f kuma-mtls.yaml

./kumactl get meshes

## Enable traffic permissions

k apply -f traffic-permissions.yaml

./kumactl get traffic-permissions

## Delete Everyone Permission

k delete -f traffic-permissions.yaml

## Deploy Logstash

kubectl apply -f http://bit.ly/kumalog


## Configure Logging

