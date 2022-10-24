# Open Telemetry


Sergey Kanzhelev, Microsoft
Morgan McLean, Google


Components you add to applications to get tracing / telemetry information

## Parts

APIs
Integrations

Libraries - sampling, context propagation

Exporters - send data to backend store
Collectors - run as a network service or agent, act as a proxy to send to a backend


Can incorporate Azure monitor

## API Surfaces
- Configuration of SDK
- API for code instrumentation
- processing and enriching of telemetry
- exporter development



node example - does not require creating spans, add to project and create config
see example on github

## Long Running Tasks

Custom instrumentation requires creating a span (no custom not necessary to create)

Need to look at what the default tracing is

## Basic Sampling

Use custom Sampler to filter out traffic like calls to the /health endpoint

(can also filter in a collector, Sampler is earlier in the process)



C# example

services.AddOpenTelemetry(b => {
    b.AddRequestCollector()
        .UseZipkin()
})

What is necessary for sending via Jaeger? Example showed specifying Zipking endoint

Can Implement custom sampler


## Custom Attribute

Add more information to a span


## Resource API

Environment name is an important custom attribute that will be used to slice the telemetry

The resoure API is used to define global attributes for the process


## Custom attributes as a dimension

FlightID for feature flight


## Distributed Context

Set scope of attribute



using(DistributedContext.SetCurrent...)


### Propaagation of custom attributes

FlightId propagation across components
 - use it as a metrics dimension or
 - attribute spans


Plugged in context propagation into ASP.NET (context propagation is built in for .NET) - other languages need to use the API

Create an instance of an Activity 

var activity = new Activity("CallToX")
 .AddBaggage("FlightId", "green);

activity.Start();

try{

}
finally {
    ativity.End()?
}

AddProcessorPipeline - setting flightId as context propagator

## Instrumentation API

Two Choices:

1. Build an OpenTelemetry integration that hooks into callbacks or performance APIs provided by the client
2. Instrument the shared code with OpenTElemetry APIs

2 is preferred

## You should always propagate the context

can use span.IsRecording to skip if client of library is not using

## Named tracers

Disable tracers

## Metrics

not affected by sampling

## Performance Best Practices

- only manually create spans for long running tasks
- don't create spans for every function call
- use time event to idnicate event occurrence vs. child span




https://github.com/open-telemetry/community
cncf-opentelemetry-community@lists.cncf.io

SIG and community meetings - 


10:55 - 12:25 maintainer track



What does this do?

services.AddOpenTelemetry(builder =>
{
    builder
        .SetSampler(Samplers.AlwaysSample)
        //.UseZipkin()

        // you may also configure request and dependencies collectors
        //.AddRequestCollector()
        //.AddDependencyCollector()

        // Add custom attributes
        //.SetResource(new Resource(new Dictionary<string, string>() { { "service.name", "my-service" } }))
});