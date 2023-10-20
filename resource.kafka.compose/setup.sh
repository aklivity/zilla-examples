#!/bin/bash
set -e

NAMESPACE=zilla-resource-kafka
docker-compose -p $NAMESPACE down --remove-orphans
docker-compose -p $NAMESPACE up -d
