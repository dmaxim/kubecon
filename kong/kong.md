# Kubernetes Ingress With Kong



Ingress spec for k8s.

V1 releasing with 1.18?

Plan for v2 next summer.

External name services in k8s allow routing from inside a cluster to an external service


## Ingress spec

extensions.v1beta1

-> 

v.15

networking.vbeta1

Coming soon

networking.v1


Can have regex based routing on path

can have *.test.something.com for host names


### Need to update existing Ingress definitions when upgrade to v 1.15


Ingress Controller and Proxy are paired - example nginx proxy and nginx ingress controller

Can use multiple controllers (different controllers with a single proxy?)

Scale proxy with number of services

Segment your workflow

## Kong

Ingress controller

## API Gateway

### Authentication

can use OAuth at Kong layer to eliminate need for authenticating against each service


### Security

### Logging

### Transformations

can transform requests - example updated externalId to clientId in request - can replace in request


### Load Balancing



Kong - calls to database - what is this functionality


Can do an internal API gateway.  Or use Kuma for East - West traffic

### Kong has a plugin architecture

Auth, Logging ... are plugins can have a plugin to send to datadog / prometheus

There is a Fluentd plugin to send to Elastcisearch

The API gateway is your proxy

Can configure multiple Kong proxies can talk to a redis instance to mange cache

What kind of traffic is cached - it is configurable

css, images ....


Functionality implemented as a pipeline

Cient  => API Key? -> Rate Limit ? -> Logging => Server


Latency Metrics

Time Kong takes to process the request and time upstream server takes

(each step in Kong pipeline there is not latency metrics for each step - would need to implement something yourself)

Kong - uses Zipkin plugin (also works with Jaeger) for distributed tracing

supports L4 and L7
  http, text, SNI (encrypted database traffic)


### Can write your own plugins

Could we add our logging plugin?

## Ingress With Kong

Combine controller with proxy

Kong config - in memory or in a database

### Custom Resources
KongPlugins
KongIngress
KongConsumer

Kong - can auto provisions certs from Lets Encrypt - works with cert manager








