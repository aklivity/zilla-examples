#!/bin/bash
set -e

NAMESPACE="${NAMESPACE:-zilla-http-kafka-asyncapi-proxy}"
docker-compose -p $NAMESPACE down --remove-orphans
