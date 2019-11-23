# windows Containers

Patrick Lang, Microsoft
Michael Michael, VMWARE

## Best Practices

Already have a windows OS node selector

For 1.17

Adding a new field where windows nodes will label with the version of the OS that is running

Can use selector for Windows and specific windows specific version


Need to taint the windows nodes


## RuntimeClasses

in v16 - can define a runtime class once for the cluster;
give it a name like Windows2016 - 

Can than add a line to a deployment to add a runtime class


Is this 1.16 or 1.17

## Resources

Server core needs at least 200Mi of memory to start

For windows cannot add a cap on CPU can only specify shares

Newer versions will allow CPU% cap


Memory considerations

- no pod evictions due to memory pressure -> processes page to disk -> slow performance
- use kubelet-reserve and system-resserve to keep 2Gi+ for the node processes
- Always use limits and reserves - honored in scheduler

## Testing and Enforcing Best Practices

- OPA - tool sand Rego language for writing policies

- Gatekeeper - admission controller to block deployments failing policies

- Conftest - uses OPA to test yaml on your own box

Can contribute policies to Gatekeeper


## Node Patching

### In-Place
1. Cordon Node
2. Wait
3. Drain
4. Run Windows update, reboot
5. Uncordon node

### Swap
1. Cordon node
2. Wait
3. Drain Node
4. Replace + ReJoin Windows Node
5. Uncordon node

## Containers and Node OS Upgrade

The major version of the container OS and Host OS must match

Issue when you upgrade the Node OS

This will no longer be an issue when HyperV Isoloation is release which will not required OS match

## Cluster API
K8s style API to cluster creation, config and mangement

## Version Support
Current Support

Windows Server 2019
Windows Server Version 1903

Survey on OS support plan
https://bit.ly/347mOUi


## Windows Container Layers


Application Layer (Dev provided)
Service Brokerage (Dev provided)
Runtime Layer (Dev provided)
Base OS Image (MS Provided)


## CI / CD Solutions

AppVeyor
Azure Container Registry Tasks
...

## Log Monitor

https://bit.ly/2KE5VZP

OpenSource tool that can collect the binary logs that are used by Windows and stream the logs to stdout

### Using Log Monitor

In Docker Image
  download log monitor release
  cp config file into image (json settings file)

JSON file - config event sources including event logs, http logs...

## State of Fluent Bit

Builds available on Windows - beta in 1.1

Progress tracked

https://github.com/fluent/fluent-bit/issues/960


## Node Metrics

Prometheus K8s scraper - already ported to Windows

WMI Exporter

## Compliance

Integrate with CI/CD
host images in a private registry
Scanning
    Aqua
    Twislock
    Anchore Enterprise (under investigation)

## DR

Back up your K8s state and PVs  (Velero)

Velero is working on windows supportin

## Look at Windows SIG









