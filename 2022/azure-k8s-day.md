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


# Manage multiple clusters with K8s fleet manager

Demo

Create a fleet manager hub and add clusters to it

# Azure Servie Operator

K8s native way to deploy Azure resources

Connect 

````
export IDENTITY=$(az ad signed-in-user show --query "id" --output tsv)
export ROLE="Azure Kubernetes Fleet Manager RBAC Cluster Admin"

az role assignment create --role "${ROLE}" --assignee ${IDENTITY} --scope ${FLEET_ID}

az fleet get-credentials -n demo -g rg-test --file hub

KUBECONFIG=hub kubectl get memberclusters

````

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

Can then deploy to the hub, adding a CRD instance for a service export and cluster resource placement

````

apiVersion: networking.fleet.azure.com/v1alpha1
kind: ServiceExport
metadata:
  name: demo
  namespace: demo
````

Resource placement

````
apiVersion: fleet.azure.com/v1alpha1
kind: ClusterResourcePlacement
metadata:
  name: demo
spec:
  resourceSelectors:
    - group: ""
      version: v1
      kind: Namespace
      name: demo
  policy:
    affinity:
      clusterAffinity:
        clusterSelectorTerms:
          - labelSelector:
              matchLabels:
                fleet.azure.com/location: eastus
````

If multiple clusters have matching selector - resource deployed to both

Need a multi cluster service (incorporates a load balancer to balance traffic across clusters)

````
apiVersion: networking.fleet.azure.com/v1alpha1
kind: MultiClusterService
metadata:
  name: demo
  namespace: demo
spec:
  serviceImport:
    name: demo

````

## Fleet Roadmap
- Gateway API + L7 load balancing
- Multi-cluster service mesh
- Fleet-level identity federation
- At-scale AKS cluster lifecycle management
- Azure Service Operator integration
- Region failover
- Arc-enabled Kubernetes as member clusters


# Secure your K8s environment

## Recommended Best Practices

### Build
- Leverage Microsoft Defender for Containers for static analysis of images with GitHub Actions

### Registry
- Leverage MS Defender for Containers to protect images in ACR
- Use Notary V2 Signing to provide code integrity (public preview in Q1 23)

### Cluster
- AAD / Azure RBAC for AuthN / AuthZ
- Managed identity (Use instead of service principals at the cluster level)
- Azure Policy - best practices (build on top of OPA Gatekeeper)
- MS Defender for Containers to secure the API server
- Image Cleaner to remove vulnerable stale images from the cluster (Preview)
- AKS 1.25 (Preview)

### Node
- Auto-Upgrade node-image SKU to stay on latest patched VHD
- Node Authorization to prevent node to node attacks
- MS Defennder for Containers for Host protection
- Mariner for minimal OS
- Confidential VM for encrypted VM capabilities

### Application
- MS Defender for Containers for Runtime security (incorporating Falco)
- CSI Secret Store or KMS for image secrets management
- Workload Identity (preview)


## Planned capabilities (Next 4 to 6 Months)

### Build Security
- Image secret scanning
- Image malware scanning

### Registry security
- Notary V2
- Vulnerability assessment of ditroless / scratch images
- Publich Preview Image Quarantine

### Cluster Security
- CIS-Metrics-SErver kubelet-secure-tls
- CIS Windows
- GA Image cleaner
- Public preview federated identity credential on AKS
- Public preview instance metadata restriction
- GA Custom CA trust (if need certs on nodes to allow access through proxy can manage in AKS)
- Airgapped-no-egress
- Azure policy on by default
- Risk-baseed prioritization by attack vectors

### Node Security
- Kernel isolation public preview
- CIS Disable SSH Public preview
- Trusted VM
- AAD Enabled SSH public preview
- GA Disable SSH
- Mariner CoS public preview
- GA Mariner CoS

### Application Security
- Agentless posture
- Drift prevention process
- CIS Kubernetes benchmark in MDC
- CIS Ubuntu benchmare in MDC
- CIS Windows benchmarek in MDC
- User namespace public preview
- Public preview secrets discovery
- GA Secrets discovery
- GA Workload identity



## Workload Identity
Going GA early January

AKS workload "asks" Azure AD can I access this resource?  AAD issues an Access Token for the pod.  Pod uses access token

1. Kubectl projects service account token to the workload at a configurable path
2. AKS workload sends projected, signed service account token and requests and AAD access token.
3. AAD checks the trust on the app and validates using the incoming token agains the OpenID Discover Document.
4. AAD issues access token for the AKS workload.
5. AKS workload uses the AD access token to access Azure resources.

feature flag to enabled workload id
enable OICD issuer on cluster

Bind service account to managed identity.  
Tutorial for accessing key vault - 

## Image Cleaner
will now clean on a schedule anything listed in the image list

"crictl purge" stale images 
stale images with criteria (High or critical vuln is an example)
Stale images sit on the node




# Azure Service Operator
K8s native way to deploy Azure resources


## What is Azure Service Operator
- way to provision Azure resources through the K8s API 
- goal-seeking and eventually consistent
- K8s Native - works with standard K8s tooling (Kustomize), avoids ARM ids in payloads as much as possible, K8s understands resource relationship and ownership


## Advantages
- Developer - defines Azure resources in YAML along with K8s resources
- No hassle CI/CD pipelines - example integrate with Flux
- Gitops integrated resource creation
- desired state

## Compare to ARM templates / BICEP
### ASO
- desired state / goal seeking
- error-correcting

### ARM Templates / BICEP
- Create for creation, updates can be harder
- State of source can diverge from template (after template submission)



## ASO Compared to Terraform

### ASO
- Desired state / goal seeking
- error-correcting
- K8s native
- Supports fewer resources (currently)

### Terraform
- Plan based
- No automatic error correction
- Not K8s natives (has integrations though)
- Supports more resources


https://github.com/azure-samples/azure-service-operator-samples

## ASO Compared to Crossplane

### ASO
- Maintained by Azure
- Mostly autogenerated
- Only Azure
- Think "Low level" exposing Azure as it is

### Crossplane
- Maintained by community
- Manually crafted
- Multiple cloud support
- Think "high level" exposes Azure, but also higher-level concepts

