# CNI Intro

Bryan Boreham, Weaveworks
Dan Williams, Red Hat

CNI is not tied to K8s

Created as a common interface that can be used by any container runtime and any network

Runtime (K8s, Mesos, CloudFoundry)

Continaer without network interface 
Runtime makes a call to CNI to add a network interface to a container

(ADD, DEL, CHECK and VERSION)

Plugins are developed for a network time


CNI sits between the runtime and the container


## CNI Project

### Specification

github.com/contaienrnetworking/cni

### Set of reference and example plugins

gitub.com/containernetworking/plugins



