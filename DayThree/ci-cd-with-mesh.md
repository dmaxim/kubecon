# Supercharge Your Microservices CI/CD with Service Mesh and K8s

Brian Redmond, Microsoft
Program Manager - Customer Success


## Mesh gives you

Observability
Traffic shaping
latency aware load balancing
Security (autorization, encryption, etc)
Retries and circuit breaking
Distributed tracing

- features for modern server side software in a way that is uniform across your stack, decoupled from the software


## Linkerd

easy

## Flagger

from Weaveworks

a K8s operator automating canary deploys using service mesh and metrics

Supports
Istio
LInkerd
AppMesh
Nginx
GLOO

## Service Mesh Interface (SMI) for K8s

A K8s interface that provides traffic routing, traffic telemetry and traffic policy

abstracts the underlying mesh (Istio, Consul, Linkerd...)

SMI concept is similar to Ingress Controller which is implemented by (Nginx...)


## SMI Initial Focus

traffic split
traffic ..


