As a developer, I want an easy way to run different samples and use the code to configure my own usecases.

## Acceptance criteria

- Single entry point to run all samples `startup.sh`
- Each sample shouldn't have extra complexity that distracts from the demonstrated use
- Each sample has a `setup.sh` and `teardown.sh` script that handles everything for the dev
- A sample should be testable via a `test.sh` script
- Sample variations are self contained and adjusted by changing profiles

## Catagories

- Quickstart
  - Low barrier of entry, fast success, 5min proof of function
  - Used to confirm Zilla does work
  - hosted
- Cookbook
  - Teaching focused
  - Organized by use case
  - Exhaustive explanation
  - Used to guide
  - Variable backend vendors
  - Supports simple `BYOK` with feature flags and profiles
- Examples
  - Feature focused
  - Organized by function
  - Short copy & paste oriented
  - Used to add or troubleshoot features
  - Static backend vendors
  - `BYOK` requires manual editing of the example
- Demo
  - Show and Tell focused
  - End to End, Real world scenarios
  - Quick setup and walkthrough
  - Used to showcase multiple functions & use cases
  - hosted when possible

### Quickstart

All resources in `zilla-docs` repo

- [x] gRPC Kafka proxy
- [x] HTTP Kafka proxy
- [x] MQTT Broker Kafka proxy
- [ ] HTTP Kafka Async
- [ ] MQTT over WS

### Cookbooks

All resources in `zilla-docs` repo

- [ ] Web Streaming
- [ ] gRPC service mesh
- [ ] Typed REST API
  - [ ] JSON-Avro
  - [ ] JSON-Proto
  - [ ] JSONSchema
- [x] MQTT broker with WS
- [ ] JWT Authn with Keycloak
  - [x] SSE JWT
  - [x] HTTP JWT
  - [x] MQTT JWT
  - [ ] WS
- [ ] K8s HA resources and autoscaling
- [ ] Kafka auth methods
  - [x] Sasl/scram
  - [ ] Sasl/SSL
  - [ ] RP, CC clouds
  - [ ] Kafka APIs, (Warpstream, VoltDB, etc.)

### Examples

All resources in `zilla-examples` repo

- [x] Kafka mapping
  - [x] REST Sync (crud)
  - [x] REST Async
  - [x] SSE
  - [x] MQTT
  - [x] gRPC
- [ ] Kafka Fanin/Fanout
  - [x] Http oneway
  - [x] SSE Fanout
  - [ ] gRPC oneway
  - [x] gRPC Fanout
- [ ] Asycapi Kafka
  - [x] REST Sync
  - [ ] REST Async
  - [x] SSE
  - [x] MQTT
- [ ] Kafka Schemas
  - [ ] Avro
  - [ ] JsonSchema
  - [ ] Transforms
- [ ] API gateway proxy
  - [ ] Schemas
    - [x] Asycapi proxy
      - [x] SSE
      - [x] MQTT
    - [x] OpenAPi proxy
  - [x] HTTP proxy
  - [x] gRPC proxy
- [x] Filesystem
  - [x] Web host
  - [x] Config server
- [ ] Install on
  - [ ] Linux server
  - [ ] Helm with ingress
  - [x] k8s autoscaling
  - [ ] ArgoCD
  - [ ] Portainer

### Demos

All resources in `zilla-demos` repo

- [x] MQTT
- [x] gRPC
- [x] Open/AsyncAPI
- [x] Web

### Extra

Evaluate for best fit

- `.echo` & `.reflect` examples
- http crud vs sync
- adding `tls`
- routing when not necessary

## Tasks

- [ ] https://github.com/aklivity/zilla-examples/issues/149
- [ ] Move some examples to cookbooks and mange in the docs repo
  - [ ] MQTT broker
  - [ ] Quickstart
  - [ ] Kafka and RP sasl examples
- [x] update the `startup.sh` script to pull from any repo that has sample artifacts
