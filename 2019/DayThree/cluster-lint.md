# Checking Best Practices with Clusterlint

Varsha Varadarajan
Adom Wolfe Gordon

Digital Ocean


DOKS - Digital Ocean Kubernetes Service

if a node breaks automatically replaced

upgrades work like AKS

Node labels are not persistent - is this an issue with AKS

I assume taints persist

Node filesystems are not persistent


## Clusterlint

on github

queries live clusters for resources


Fetches resources
checks the resource
reports

Owner of each resource identified



## Check Groupds

DOKS
security
basic

... resources in the default namespace



## Check API
custom can be written
checks register themselves


## Supressing Checks

Via command line API
Via annotations



## Other tools

### Manifest based

kubeval
copper
kube-lint

Run as part of CI

### Security

kube-bench

### Dashboard

Polaris

### Command line report tool

Popeye

