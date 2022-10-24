# Prow Deep Dive

Alvaro Aleman, Loodse
Steve Kuznetsov, Red Hat


use Prow for testing
## Prow: Inrepoconfig


Job configuration currently 

there is a single repository for all jobs

inrepoconfig - allows for configuration of jobs in the repository that stores the code

This allows for having job with code so when you change job you see if broke the build as opposed to centrol repo where this is detached.



New process

PR -> on repo with code and job - runs build?



## Challenges:  Tide and Retesting

now all pull requests are unique

## Prow:  Improvements for Admins

Adding metrics and observability

- looks like they are using Prometheus for alerting




## Summary 

Don't use Prow

