## Flux

- Can store files in an OCI registry instead of Git
- Integration with cosign to validate artifacts

Look at fluxcd/community - Contributor ladder

# How we revolutionized developer experience with 3.5 platform engineers

Kognic

External DNS project - auto create DNS entries from the cluster - need credentials to create - may be able to do this with Azure DNS Zone
Work with Load Balancer types?

## Strategy

- Unlbocking developers
- Removing time consuming tasks from the platform team
- Removing time consuming tasks from the developers

# Kyverno Introduction and Overview

Why do we need policies

- Security
- Guardrails
- More people get involved - different backgrounds may not know best practices
- Tribal knowledge is compoartmentalized
- K8s is hard

What can policy deliver?

- Define law (Security)
- Ensure consistency (Governance)
- Provide feedback (Observability)
- Perform tasks (Automation)

- Reduces risk
- Sets expectations
- Creates consistency
- Saves time

## What is Kyverno
- Govern in Greek
- K8s admission controller
- Purpose build for K8s
- Largest policy library of any policy engine

## Featurs
- Validation
- Mutation
- Generation
- Image verification
- Policy Reports
- CLI

## Kyverno Can (examples)
- Pod security - all pods cannot run as root
- Fine-grained RBAC - only users with a specific role can create secrets with x label
- Cost control - only one service of type LoadBalancer may be created in AWS
- Ops automation - sycn a config map when cert is updated
- Multi-tenancy - create these resources every time a new namespace is created
- Supply chain security - all images with this name must be signed...

Example Policy

````
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-labels
spec:
  validationFailureAction: enforce
  background: true
  rules:
  - name: check-for-team
    match:
      any:
      - resources:
        kinds:
        - Pod
    validate:
      message: "The label team is required"
      pattern:
        metadata:
          labels:
            team: "?*"
````

## Generate functionality
- Allows for creating new resources based upon triggers
- The source of the resource definition can be defined in a policy or be a clone of existing resources
- Synchronization
- Tamper resistance
- Works on existing items

## Image Verification
* Container iamge signature verification via Cosign

## Similar Policy Engines
- OPA - REGO
- Cloud Custodian - YAML, additional targets not just K8s (Azure, AWS, Terraform)