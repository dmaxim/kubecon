# Cloud Native Buildpacks

currently CNCF sandbox

Emily Casey, Google

Terence Lee, Heroku

built on top of older tech out of Heroku

buildpacks.io

CNB - open standard


## pack 

Project supporting cnb


pack cli

pack build 

provide tag
and publish registry

multiple build packs can be used to create an image

dependencies include run image to use at runtime

dependencies installed are part of the build pack (Node, React...)


Builder image - package of multple build pack layers

## Lifecycle

### Detect
 - detect what build packs should run

### Restore

### Analyze

### Build

calls the build binary in each build pack

### Export

assembles final layers into image

### Cache

caches any necessary dependencies
retreives on next runs build phase


layers in build processa are cached

## Can Swap Base Images as part of buildpack

Me - patches really only need to swap out copy step instead of re-building
Me - integration tests should be run againts runtime image

"rebase" an image

Process - upload a patched version of the OS to the registry
Create a new image directly agains the registry
Update a config file that desribes the layers


## pack
    Developer oriented

## kpack

    pivotal open source project

    rebuilding at scale

    
## Heroku

## Tekton

## Google Cloud Run Button