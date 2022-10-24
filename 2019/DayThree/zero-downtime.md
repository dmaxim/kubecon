# The Gotchas of Zero-Downtime Traffic with K8s

Leigh Capili, Weaveworks




Better to use 
ENTRYPOINT in Docker file


Stop Signal to a pod

K8s does

1. send the process a SIGTERM
2. if the proces has not exited after the termination grace period send SIGKILL


## Readiness / Liveness Probes

Be intentional with timeouts and periods

Liveness probes are dangerous - faild pod gets killed,

Check default behavior for liveness and readiness

Want liveness period to be much longer than rediness


Make sure the initial delay on the liveness probe is "significantly" greater than the total wait time for your rediness probe; don't want liveness running befor a probe may be ready


## PreStop lifecycle hook

Do your pods need a pre-stop?

When pod is shutdown the app is very likely receiving calls.  Stop could interupt a live call


Delete a pod

  Pod is marked as Terminating - async notification that pod no longer exists; so can get traffic routed to terminated pod

  Pre-stop

  do not "stop receiving connections" -> start draining connections



  stealthybox/zero-downtime



Delay in the shutdown of a pod (using post-stop web hook)

Demo example just used bin/sleep - may need to install

The sleep allows connections to complete while the cluster has time to catch up while the pod is marked terminating


Maxunavailable

User percentage or 0 when replica count == 1


## MaxSurge

Watch the setting - do not want to chew up your capacity with the surge - small surge


## Mismatched signal lifecycle with side-cars

if your app is in gracefull shutdown and the proxy is not sleeping, it will exit and drop your db connections

this example applies to cloudsql-proxy

The side car gets shutdown before app

Look at adding a buffer so side-car shuts down long after application


## Rules of Uptime
1. entrypoint should handle or pass signals  (use of ENTRYPOINT in docker image)
2. STOPSIGNAL may need to be changed
3. Use greater set of periods for liveness probes
4. Sleep in preStop hooks to drain connections
5. Use the new apps/v1 deployment  (percentage available for max surge)
6. Keep your app warm during a RollingUpdate
7. Synchronize shutdown of side-cars

