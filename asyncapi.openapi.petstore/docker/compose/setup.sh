#!/bin/bash
set -e

if [[ -z "$KAFKA_HOST" && -z "$KAFKA_PORT" ]]; then
  export KAFKA_HOST=host.docker.internal
  export KAFKA_PORT=9092
  # echo "==== This example requires env vars KAFKA_HOST and KAFKA_PORT for a running kafka instance. Setting to the default ($KAFKA_HOST:$KAFKA_PORT) ===="
fi

NAMESPACE=zilla-kafka-openapi-asyncapi

# Start or restart Zilla
if [[ -z $(docker-compose -p $NAMESPACE ps -q zilla) ]]; then
  docker-compose -p $NAMESPACE up -d
  
  TOPICS=$(docker run --rm -v ./../../asyncapi.yaml:/workdir/asyncapi.yaml mikefarah/yq '.channels | .. | select(has("address")) | .address' asyncapi.yaml)
  for topic in $TOPICS
  do
    docker run --rm bitnami/kafka bash -c "
    echo 'Creating $topic for $KAFKA_HOST:$KAFKA_PORT'
    /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_HOST:$KAFKA_PORT --create --if-not-exists --topic $topic;
    "
  done
else
  docker-compose -p $NAMESPACE restart --no-deps zilla
fi
