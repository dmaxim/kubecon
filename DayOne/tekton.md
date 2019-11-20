# Tekton

Andrea Frittoli, IBM
Vincent Demeester, Red Hat


Issue will only run on Google cloud at this point


Set up projects used for building K8s style CI/CD systems

declarative pipelines

Build images with k8s tools - source-to-image, buildah, 

## Tekton Pipeline

Pipeline composed of CRDs

Step
Task
Pipeline

PipelineResource
TaskRun
PiplineRun


## Tekton projects

github.com/tectoncd/catalog - shareable task definition - example build of  go app


## Initial Plumbing

inherits its plumbin from Knative

- Infrastructure on Google Cloud

Got out of Knative

Prow - K8s based CI/CD system


Steps toward independence from Knative


