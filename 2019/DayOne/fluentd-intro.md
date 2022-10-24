# Fluentd Intro

Yuta Iwama

Logging driver in GCP

Latest version 1.8.0rc3

## Architecture

Input
Parser
Filter
Buffer
Formatter
Output


## Copy plugin 

Can be used to multicast to destinations

Example:  Elasticsearch and Azure Blob Storage

## Images

Community Base

https://hub.docker.com/r/fluent/fluentd


debian or alpine


Docker Official

https://hub.docker.com/_/fluentd


Me - need to ony use official image


## fluent-logger

is a client library for sending data to Fluentd

## Docker Logger Driving

Fluentd runs as logging driver of Docker by default

Can't be used in K8s

## K8s Daemonset


## Announcements 

New Features

Service discovery helper
File single buffer plugins
MonitorAgent and Prometheus plugins expose more metrics
HTTP server helper

