# Going beyond the node.. Virtual Kubelet Deep Dive

Brian Goff
Deep Kapur

kubelet - makes sure containers are running in a pod
communicates with the container runtime

## Virtual kubelet

virtual kubelet announces that it is a node

Github

virtual-kubelet/virtual-kubelet

1.0 released on 7/9/2019

1.2 Nov 6

Is a library
Provides
  node controller
    node provider
  pod controller
    pod provider


can implement your own node / pod provider

## VK Provider

provide the plumbing to support pod lifecycle and supporting resources
- transform the declarative API model to an imperative one

Conform to current VK API

Use a callback mechanism for getting data like secrets and configmaps w/o direct access to K8s API server


## Notifying of pod status updates

async
non-async (old way)

## Why build a provider?

- flexible abstraction to extend a cluster
- more granular resource consumption = unit consumption is a pod
- hybrid clusters - traditional cluster with a cloud based VK
- high availability deployments
- Alternative to Kubelet - VK as a node agent in a different kind of node

Azure Container Instances (ACI) utilize

## Challenges

- networking, config, private networking, kube-proxy
- what is the max node resource
- VK versioning
- monitoring pods spun out via VK (supporting HPA)


## Current Providers

many 
including ACI
and Hashicorp Nomad

ACI - mostly used for and best fit for "burst"

Demo

Setup different VKs to run in specific regions




## Road Ahead

custom pod GC policies
metrics
helpers for building providers - currently a lot of shared code between providers
runtime-less (maybe?) 


VK Community meetings every other week on Wedensdays at 11am PST

slack channel #virtual-kubelet




