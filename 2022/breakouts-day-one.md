# Building a Day1 / Day2 Application Operations Platform on CNCF Projects

Premise - all infrastructure, deployments, configuration managed via GitOps. Can use GitOps proceses to keep infrastructure in the desired state (automatic remediation of changes outside of source control). Application observability and response via GitOps.

Some CNCF projects that provide the funcitionality

- Argo (or Flux)
- Crossplane
- Jaeger
- Fluentd
- Prometheus
- Keptn
- Managed K8s (managed cluster that provisions work load clusters)

# Argo Project
https://github.com/kubecon-us-2022-argo/control-plane


- Use SSO
- Define Applications in YAML
- Define applications sets in YAML will create applications in folder (project)
- Replace tickets with pull requests

Use gitops to manage applications in ArgoCD

Single - Sign-on OIDC integration (Test with Azure AD?) via Dex

Example configuration

```
name: Okta
issuer: https://dev-123456.oktaprview.com
clientID: <client id>
clientSecret: <client secret>
# optional set of OICD scopes to request
requestedScopes:
  - openid
  - profile
  - email
# Optional set of OIDC claims to request
requestedIDTokenClaims:
  groups: {"essential" : true}
```

Then need to configure authz

Uses casbin

```
p, my-org:team-alpha, applications, sync, my-project/*, allow

g, my-org:team-beta, role:admin
```

Argo project configuration

```
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: my-project
spec:
  sourceRepos:
    - '*'
  destinations:
    - namespace: 'team-ns'
      server: http://my-cluster:8001
  roles:
  - name: admin
    policies:
      - p, proj:my-project:read-only, applications, get, my-project/*, allow
    groups:
      - my-org/my-team

```

# Securing the IAC Supply Chain

Need to be cognizant of providers (allow lists). Using public opens source providers for Terraform would need to verify the publisher and prevent people from pulling from un-approved providers.

Crossplane takes a step towards this as can limit who installs providers in the K8s cluster

## Sigstore

- Rekor
- Fulcio
- cosign cli

cosign can use public / private key to sign image and push to OCI registry

Moving to keyless signing - rely on Fulcio and Rekor

- Using identity provider (Google, Azure AD, GitHub...)
- Id token sent back to cosign
- Cosign sends token to Fulcio to get a short-lived certificate
- Sign image and push to OCI registry
- Rekor can be used to verify signature

Look for "Live of a Sigstore Signature.."

Crossplane packages are already stored in OCI registries

## Call to Action

- sign and validate your IAC
- centralize the execution of your IAC
- know your IaC sources
- Scan IaC with static / dynamic analysis tools
- Run with least privilege credentials

# Istio

1.16 release in November

- jwt based routing
- external Authz integration

- Flux integration to allow upgrading Istio with a PR

- Ambient mode - waypoint proxy only required if you need layer 7 functionality (trace / observability?)

- 2/3 of Envoy CVEs are related to layer 4 functionality. So if don't need layer 7 functionality it is a little more secure to just use ztunnel without waypoint proxy

# LinkerD, Flagger and Cluster API

- Cluster API intent is to reduce the need for custom resource definitions
- Flagger can hook into observability stack to verify a new version of an application is working - will shift more traffic to new version as observability looks good "Progressive Delivery"


# KEDA - Real Time and Serverless Scaling in K8s

* Scale based upon events
* 55+ integrated event sources (Prometheus, RabbitMQ, Kafka, SQS, PostgreSQL...)
* Uses HPA


NOTE: Trigger section of ScaledObject

````

apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: rabbitmq-consumer
  namespace: default
spec:
  scaleTargetRef:
    name: rabbitmq-consumer
  pollingInterval: 5  # Optional - default 30 seconds
  cooldownPeriod: 30 # Optional - default 300 seconds
  maxReplicaCount: 30 # Optional - default 100
  fallback: # Optional
    failureThreshold: 1
    replicas: 4
  triggers:
    - type: rabbitmq
      metadata:
        queueName: hello
        queueLength: "5"
      authenticationRef:
        name: rabbitmq-consumer-trigger
---
apiVersion: keda.sh/v1alpha1
kind: TriggerAuthentication
metadata:
  name: rabbitmq-consumer-trigger
  namespace: default
spec:
  secretTargetRef:
    - parameter: host
      name: rabbitmq-consumer-secret
      key: RabbitMqHost
---

````

Failure threshold - run that number of processors if there are errors are occurring


## Scaled Object
* Can target Deployment, StatefulSet or Custom Resource with /scale (Any resource that implements scale functionality)
* Multiple scalers can be defined as triggers for the target workload
* User can specify HPA related settings to tweak the scaling behavior


## ScaledJob
* Schedule job based on events
* Useful option to handle processing long running executions

Long running process HPA may kill application because metric that caused start / scale no longer exists

## Advanced features
* Ability to specify fallback
* Users can still tewak HPA settings - if necessary
* Ability to pause autoscaling
* KEDA exposes Prometheus metrics
* Users can extend KEDA implementing External Scalers via gRPC interface or Metrics API scalers via Rest API

## Authentication
* Re-use trigger authentication across ScaledObject/ScaledJobs with TriggerAuthentication (namespaced) or ClusterTriggerAuthentication

### Out-of-the-box integration with sources such as:
* Environment variables (on scale target)
* Kubernetes secrets
* Pod Identity
* HashiCorp Vault
* Azure Key Vault

## What is next for KEDA?
* Cache metrics values in KEDA metrics server
* Custom logic for evaluation when there are multiple triggers in ScaledObject
* CloudEvents integration
* OpenTelemetry integration
* Open interface for Predictive autoscaling
* POC - Carbon aware autoscaling`


# Knative More than Just Serverless Containers

* Autoscaling - activator sits in front of HTTP endpoint / service

Mentioned the use of cloud native build packs as part of the func cli that will detect app type and build and publish an image.  Configure standard build pack for application / resource type.

How would it handle a .NET project with multiple project dependencies

Camel K ??

