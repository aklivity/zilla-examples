#!/bin/bash
set -e

NAMESPACE="${NAMESPACE:-zilla-quickstart}"
export ZILLA_VERSION="${ZILLA_VERSION:-latest}"
export KAFKA_BROKER="${KAFKA_BROKER:-kafka}"
export KAFKA_BOOTSTRAP_SERVER="${KAFKA_BOOTSTRAP_SERVER:-host.docker.internal:9092}"
INIT_KAFKA="${INIT_KAFKA:-true}"

# Start or restart Zilla
if [[ -z $(docker-compose -p "$NAMESPACE" ps -q zilla) ]]; then
  echo "==== Running the $NAMESPACE example with $KAFKA_BROKER($KAFKA_BOOTSTRAP_SERVER) ===="
  docker-compose -p $NAMESPACE up -d

  if [[ $INIT_KAFKA == true ]]; then
    docker run --rm bitnami/kafka bash -c "
    echo 'Creating topics for $KAFKA_BOOTSTRAP_SERVER'
    /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_BOOTSTRAP_SERVER --create --if-not-exists --topic items-crud --config cleanup.policy=compact
    /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_BOOTSTRAP_SERVER --create --if-not-exists --topic events-sse --config cleanup.policy=compact
    /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_BOOTSTRAP_SERVER --create --if-not-exists --topic echo-service-messages
    /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_BOOTSTRAP_SERVER --create --if-not-exists --topic route-guide-requests
    /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_BOOTSTRAP_SERVER --create --if-not-exists --topic route-guide-responses
    /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_BOOTSTRAP_SERVER --create --if-not-exists --topic iot-messages
    /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_BOOTSTRAP_SERVER --create --if-not-exists --topic iot-retained --config cleanup.policy=compact
    /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_BOOTSTRAP_SERVER --create --if-not-exists --topic iot-sessions --config cleanup.policy=compact
    "
  fi

else
  docker-compose -p $NAMESPACE restart --no-deps zilla
fi
