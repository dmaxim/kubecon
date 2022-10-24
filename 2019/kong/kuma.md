# Kuma

slack:

https://chat.kuma.io

kuma.io/instll


Trend

## Data In Motion  (vs data at rest, vs app movement (Hadoop))


## Decentralized applications

Fast and reliable

## Smarter

IOT



Replacing reliability of the CPU with the unreliability of the network

## KUMA

Universal Service Mesh

Based on Envoy

Can also run on environments other than K8s / containers

Can use with VMs as well as K8s

Kuma has an admin API
CLI client to interact with service mesh

## Multi-Tenancy

Each service mesh has it's own CA



### Easy to use

kumactl install control-plane | kubetl apply -f-

or 

In VM

kuma-cp run &

L4

augment networking and connectivity of any service

not just http or GRPC - 
    database communication..


## Features

Identity (Mututal TLS)

Traffic Permissions

Traffic Logging

Kong Gateway Integration

...and more

side-car proxy



## Kuma Injector

Listens to K8s API server to inject side-car into pods

## On Universal

Need to store configuration information - (Can be PostgreSQL or in memory like Kong)

## Demo Guy

Kevin Chen


Will be providing enterprise support next year

Kong $$

Kong Enterprise - extends Kong Gateway

Will hook Kuma into the Kong Enterprise product

## Integration between Kong and Kuma for North South

Kong is ingress and egress




## Existing Service Mesh Issues

Many are focused 100% on K8s (don't allow extending service mesh to existing VMS)

Complexity - some are extremely complex to use and some are not multi-tenant

Some require separate installs for each cluster - Istio

Istio - can be run on outside of K8s but it is complex


## Version 0.4

Focus on tracing


Will be adding some L7 in 0.4 - example add some ability to access header information

(Example Istio - allows traffing routing based upon identity - which Kuma does not currently allow)