#!/bin/bash
set -e

NAMESPACE=zilla-mqtt-kafka-broker-asyncapi
docker-compose -p $NAMESPACE down --remove-orphans
