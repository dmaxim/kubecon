# Azure Kubernetes Day

https://azuredaywithkubernetes2022.com/video/

Projected 500 million new cloud native apps over 2023

## Stronger Developer Velocity

Means more successful developers and better outcomes for your business

- Higher revenue growth
- Higher innovation
- More satisfied customers
- Higher developer satisfaction and retention rates
- Improved collaboration
- Better software

## Cloud Native

- Agility
- Reliability
- Security
- Scalability

## Benefits of K8s

- Infrastructure abstraction - applications can be developed independent of the environment
- Declarative configuration - declare the desired state and have K8s manage it for you
- Scheduling - no need to schedule each container manually
- Velocity - faster development cycle due to declarative configuration
- Self-healing - continuous action to maintain desired state leads to self-healing when issues arise
- Sclability - easier to scal manually or automatically
- Deliver value to the business instead of spending time building infrastructure in order to deliver value

## Azure CNI powered by Cilium

Integrates the scalable and flexible Azure IPAM control plane with the robust dataplane offered by Cilium OSS to create a modern container networking stack that meets the demans of cloud native workloads

Available in public preview

Azure Networking (IPAM - IP Address Management)
Azure CNI - Pods get IPs from the vnet
Overlay Mode - IPs for pods are non-routable (nodes in a VNET - pods in isolated IP space)
Kubenet does this but there is a performance penalty due to the overhead in routing

Started looking at eBPF

Demo

```

az group create --name rg-aks-cilium --location westcentralus

az network vnet create -g rg-aks-cilium --location westcentralus --name vnet-akscilium --address-prefixes 10.0.0.0/8 -o none

az network vnet subnet create -g rg-aks-cilium --vnet-name vnet-akscilium --name nodesubnet --address-prefixes 10.240.0.0/16 -o none

az aks create -n aks-cluster-cilium -g rg-aks-cilium -l westcentralus \
  --network-plugin azure --vnet-subnet-id /subscriptions... \
  --pod-subnet-id /subscriptions/... \
  --enable-cilium-dataplane

```

## Multi-cluster management - Azure Kubernetes Fleet Manager

- Fleet managed hub cluser
- run multi-cluster workloads and services and ensure consistent configuration, access and governance across your k8s environments

## WASM workloads via containerd shim

- Run you WebAssembly workloads on AKS and on the same node as your regular containers, leveraling all the constructus you already know from networking (CNI, Load Balancing...)

## Sustainable AKS

Guidance to help optimize workloads for energy efficiency

### Green Software Principles

- Energy efficiency - consume the least amount of electricity possible
- Hardware efficiency - use the least amount of embodied carbon possible
- Carbon Awareness - do more when the electricity is clean and less when it's dirty

scaling to zero
stop cluster when not using

# Developer Productivity

https://aka.ms/aks-dev/repo

- Draft for generating a Dockerfile

## Bridge to K8s

- Route traffic from the cluster to local environment for dev / debugging
- Useful when have multiple service dependencies
- Deploy app to K8s and debug locally - can use subdomain routing to deploy a dev (individual) specific instance and route to local VS Code

## VS Code extensions

- Developer tools for AKS
- Bridge to K8s

Example

Using cert from Azure Key Vault in an Ingress

```

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.azure.com/tls-cert-keyvault-uri: "URL of the cert"
  name:  test-frontend
  namespace: test-ns
spec:
  ingressClassName: webapprouting.kubernetes.azure.com
  rules:
  - host: myhost.com
  http:
   ...
tls:
- hosts:
  - myhost.com
  secretName: keyvault-test-frontend

```

Integration with Azure DNS Zone that autogenerates DNS entry for Ingress in AKS

# Troubleshooting your Apps on AKS

## Common application problems in AKS

- Application crashes (OOMKill)
- Node resource contention (Sharing system and user pods)
- Node resource exhaustion (Disk I/O, SNAT ports)
- Improper probes
- Lack of PodDisruptionBudgets

## Pods keep restarting or are non-responsive

### Application Crashes

- Check pod logs via Container Insights or kubectl logs
- kubectl logs -p will show logs from previous iteration of the pod

### Check your resource limits

- Pods can't exceed CPU limits - they just get capped
- Pods that exceed memory limits get OOMKilled and restarted

### CPU, memory, disk or PID presssure

- Make sure you have appropriate process limits set
- Move to larget nodes if appropriate
- Add anti-affinity rules to keep heavy talkers apart
- Use dedicated node pools if necessary (kube-system on dedicated node pool to prevent misbehaving pods from causing system pods from being moved)

Pod disruption budget - if do not have at least 1 app can be completely shutdown during an upgrade

Look at storage - if you are using standard v4 you do not have caching, basically attached to a standard hard disk drive

### Disk issues

Standard_D4s_v4 (s => supports premium storage)

## Service trouble shooting

Can describe the service to see the endpoints the service is forwarding to

## SNAT

Managed NAT gateway for egress instead of Service Load Balancer
As the cluster node count increases SNAT ports per node descreases
If a pod makes a lot of outbound connections can exhaust available ports

## AKS Periscope

- Open source tool integrated with Azure CLI - az aks kollect

- Collects a point-in-time snapshot of the cluster state into a storage accound

## Inspektor Gadget

kubectl gadget top block-io

k gadget top tcp

k gadget top file

# Running AKS at scale

## Responsible for upgrading node images

- Happens as part of an K8s upgrade, but there are image updates issued between upgrades

### Auto Upgrade Channels

- None (Disable)
- Patch (THe current minor version)
- Stable (N-1 minor)
- Rapid (Go fast mode)
- Node Image

Can set when updates happen with maintenance windows

### Maintenance Demo

```
az aks nodepool update -n worker -g kubecon --cluster-name test-cluster --max-surge "30%"

az aks upgrade --resource-group kubecon --name test-cluster --node-image-only

az maintenace assignment create --maintenance-configuration-id "/subscriptions/x/providers/Microsoft.Maintenance/publicMaintenanceConfigurations/aks-mrp-cfg-weekday_utc8" --name preProdUpdates --provider-name "Microsoft.ContainerService" --resource-group kubecon --resource-name test-cluster --resource-type "managedClusters"


```
