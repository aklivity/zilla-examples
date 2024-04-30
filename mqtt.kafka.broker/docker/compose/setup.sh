#!/bin/bash
set -e

NAMESPACE="${NAMESPACE:-zilla-mqtt-kafka-broker}"
export ZILLA_VERSION="${ZILLA_VERSION:-latest}"
export KAFKA_BROKER="${KAFKA_BROKER:-kafka}"
export KAFKA_HOST="${KAFKA_HOST:-host.docker.internal}"
export KAFKA_PORT="${KAFKA_PORT:-9092}"
BOOTSTRAP_KAFKA="${BOOTSTRAP_KAFKA:-true}"

# Start or restart Zilla
if [[ -z $(docker-compose -p $NAMESPACE ps -q zilla) ]]; then
  echo "==== Running the $NAMESPACE example with $KAFKA_BROKER($KAFKA_HOST:$KAFKA_PORT) ===="
  docker-compose -p $NAMESPACE up -d

  if [[ $BOOTSTRAP_KAFKA == true ]]; then
    # Create the mqtt topics in Kafka
    docker run --rm bitnami/kafka:3.2 bash -c "
    echo 'Creating topics for $KAFKA_HOST:$KAFKA_PORT'
    /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_HOST:$KAFKA_PORT --create --if-not-exists --topic mqtt-messages
    /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_HOST:$KAFKA_PORT --create --if-not-exists --topic mqtt-devices --config cleanup.policy=compact
    /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_HOST:$KAFKA_PORT --create --if-not-exists --topic mqtt-retained --config cleanup.policy=compact
    /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_HOST:$KAFKA_PORT --create --if-not-exists --topic mqtt-sessions --config cleanup.policy=compact
    "
  fi

else
  docker-compose -p $NAMESPACE restart --no-deps zilla
fi
