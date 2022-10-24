# Moving Auth from the App To The Mesh With Envoy and OPA

Daniel Popescu, Yelp

Ben Plotnick, Cruise Automation


Istio - would use if starting Yelp today

Didn't have that so went with incrementally building security into


## Authentication

Handle identity resolution for computers and humans
Identity must be unforgeable
Avoid impacting developer velocity




Used to use HAProxy swapped out Envoy

Don't support sidecars for historical reasons (Mesos)

For computur to computer - introduced Envoy for Egress from service -> Ingress to next service (MTLS between Envoy proxies)


Human Auth

Integration Envoy with ockta

Envoy has build in support for JWT

Ockta issues short lived tokens that Envoy verifies

Created  a Yelp Curl library to handle this

Key being a short lived token to minimize risk of user token being stolen

## Authorization

### Requirements

- prevent unauthorized access
- least privilege - deny by default
- available for any service
- avoid impacting developer productivity
- policies should be easy to use and understand



## OPA
Rego

Unit test support for policies

Created service "OPA Policy Manager" - abstraction layer over OPA to limit exposure to the complexity of Rego


OPA manager uploads archive of policies to an S3 bucket
Envoy ext_authz interface  decides if caller can hit service using the policies


## Now

OPA Deployed everywhere
requests to sensitive services are authorized


Have an authorization results dashboard to allow tracking


## Future

Phase policy rollout
    test new policies / canary

Improvements to identity attestation
 - client certs?
 - SPIRE


## Future Ideas 0 Other use cases

K8s adminission controller
Docker Authz
SSH and sudo
Terraform
Kafka

all of these have pluggable authorization - can use OPA with

