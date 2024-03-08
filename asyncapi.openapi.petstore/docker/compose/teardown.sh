#!/bin/bash
set -e

NAMESPACE=zilla-kafka-openapi-asyncapi
docker-compose -p $NAMESPACE down --remove-orphans
