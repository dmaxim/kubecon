# Helm 3 Deep Dive

Taylor Thomas, Microsoft Azure
Martin Hickery, IBM

"it's more than just tiller being gone"


## New Functionality

- chart changes
    API version is V2 for Helm 3
    API version is V1 for Helm 2

    Type - application or library  chart

        library cannot be installed

    dependencies / requirements in chart file

    Value validation
        validation on - install, upgrade, template, lint


- chart repo

    Helm Hub - central catalog for chart repos; allows for search for charts across multiple repos

    No chart repos added OOTB anymore


- release upgrade strategy

    Helm 2 - merge / upgrade compares: most recent chart manifest and the prosed

    Helm 3 - 3 way merge; includes the cluster state
        if you had injected a sidecar in Helm 2 would use the modified state, Helm 3 respects deploy changes like sidecars

- test framework

    Tests as jobs

- oci registry support
    experimental feature (no backwards compatibility features)

    allows pushing a chart into a Docker registry (anything that is OCI compliant)


## Architecture Changes

### No More Tiller
    helm now talks to K8s API server directly

    XDG base specification support - provides defined way of where configuration is stored 
        example: ${HOME}/.cache/helm/

    helm init has been removed

### Release storage update

- stored as secrets by default (default was configmaps in v2 - could configure to use secrets)
- stored in the namespace of the release (unique release per namespace)
- Helm "release" object has changed
- Release name prefixed with "sh.helm.release.v1"


### CRD Changes

- CRDS are installed only - no modifications or delete  (Upsert)
- CRDs now go in the crds/ directory to be automatically installed
- Installaton can be skipped with --skip-crds
- crd-install hooks are ignored with a warning in Helm 3

### New Go SDK


## Migration

Helm 2 charts still work in Helm 3 - caveat - Helm 3 will no longer create namespaces on the fly - need to manually create ns
Diffence between 2 and 3 is mostly architectural and insfrastructure changes
Need to add crds separately

How to migrate server 2 to 3

2to3 plugin

https://github.com/helm/helm-2to3


helm plugin list
helm 2to3 convert postgress

All this does is move the release information.  It does not move existing k8s releases.


## Helm 3 Security


### K8s
RBAC


Heml

Per User basis - delegated to K8s security - uses kubeconfig - based on your credentials


## What is next?

