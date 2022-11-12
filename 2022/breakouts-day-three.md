
# Crossplane Intro and Deep Dive

Idea is to create a control plane for your cloud

Declarative - extensible module

Can create individual resources but better can create an XRD

## XRD - Composite Resource
Custom api group
specify a schema

Then define a composition which implements the XRD

Patches - enable propagation of data from an XR to a MR (managed resource)

## Extending Crossplane

### Providers
* you can build a provider to manage anything with an API
* CRUD operations for cloud resources, on-prem services, etc

### Configurations (Using existing providers)
* Compose resources from providers
* Define your control plane's declarative APIs and abstractsion
* this is what devs see

Both are Crossplane packages / opinionated OCI Images

Check - marketplace.upboud.io/providers

Look at Kyverno


https://tinyurl.com/3b5cyfap

Have code generators to convert a Terraform provider to a Crossplane Provider


# Extend Your Microservices with Pluggable Components Via Dapr

Before v1.9 component required Go and merge into Dapr
Can now write a component to extend Dapr in any language that supports gRPC



# Dynamically Testing Individual Microservice Releases in Production

Test on an ongoing basis

tetrate - mesh on top of Istio to simplify the managing a multi cluster Istio mesh

# Security in the Cloud with Falco

Falco now supports ARM64

Look into Falcosidekick

Integration with CoSign
There is a UI

# Cortex


Long time storage for Prometheus
* Scalable
* HA
* Multi-tenant

Prom remote write to Cortex
Grafana to Cortex for view
Can send metrics from OpenTelemetry to Cortex
Can also send metrics directly from apps using "REmote Write format"


# Cloud Custodian

YAML DSL for policies on querying resources, filtering them and taking actions
*Azure / AWS / K8s/ Terraform

K8s can scan or run as an admission controller
Require labels ...

Terraform provider will do static analysis

Targeted to the cloud vs. OPA that is more generic
OPA is more verbose

Different from Kyverno
* K8s focus
* does not manage cloud / Terraform


# One API to Rule Them All? What the Gateway API Means for Service Meshes

Service Mesh Interface spec

Example of standards

````
---
kind: HTTPRouteGroup
metadata:
  name: ab-test
matches:
- name: firefox-users
  headers:
    user-agent: ".*Firefox.*"
---
kind: TrafficSplit
metadata:
  name: ab-test
spec:
  service: website
  matches:
  - kind: HTTPRouteGroup
    name: ab-test
  backends:
  - service: website-v1
    weight: 0
  - service: website-v2
    weight: 100
````

## SMI Issues
* initial design decisions did not match with direction of community
* key maintainers moved to other projects
* no resources advanced from alpha


## Gateway API - follow on to SMI
- Introduced to build a unified service networking model for K8s
- Learns from the mistakes of Ingress and vendor APIs to build a new API that is extensible
- API recently graduated to Beta with over 15 implementations

## Gateway API Resources
- GatewayClass
- Gateway -> HTTPRoutes
- HttpRoute -> Service

## Resource Examples
````
kind: HTTPRoute
metadata:
  name: my-route
spec:
  parentRefs:
  - kind: Gateway
    name: test-gateway
  rules:
  - backends:
    - name: test-svc
      port: 8080
---
kind: Gateway
metadata:
  name: test-gateway
spec:
  gatewayClassName: gw-load-balancer
  listeners:
  - name: prod-web
    port: 80
    protocol: HTTP
````

## Gateway API Mesh Management and Administration (GAMMA initiative)
Idea to add east / west traffic management to the standard north / south traffic management of a gateway


## Current Resource Examples for East / West

````
apiVersion: gateway.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: foot
spec:
  parentRefs:
  - kind: Service
    name: foot
  rules:
    backendRefs:
    - kind: Service
      name: foo
      weight: 90
    - kind: Service
      name: foo-v2
      weight: 10

````

## Future
- Authorization Policy
- Egress
- Workload Policy Attachment


# Scaling Azure

## Best Practices
### Use Azure CNI Networking
- greater separation of resources and controls
- larger node scale per cluster
- easior on-premises / hybrid routing
- with Dynamic IP assignment (preview) you can prevent IP wastage
- Better network performance

### Use Managed NAT
- Allows +1M outbound flows solving for SNAT port exhaustion (64k per IP)
- Use --outbound-type managedNatGateway during cluster creation
-- AKS provisions and manages the NAT gateway creation and pool management

### Plan the IP Addresses
- Use --max-pod setting to control IPs allocated per node and maximize IP utilization
- Subnet size >= $ Nodes + # Pods + # network resources + daemonsets
- Don't overlap CID ranges across cluster, docker bridge, service address ranges
- Use VNET peering for large cross-cluster / region workloads

## East / West Networking

### Dynamic IP Assignment
- Dynamically assigns / scales IPs from VNet
- All the functionality of Azure CNI

Only pull an IP adress when pod needs it

Without the default is to assign ip address based on max-pods per node even when the Ips are not used

Isuue if alot of scaling will require a lot of dynamic assingment

### Overlay CNI (Preview)
- Overlay IP space for your pods
- Up to 250 pods per node, while only using 1 VM IP from your network

Use 1 IP per node and pods live in an overlay network


