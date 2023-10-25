#!/bin/bash
set -e

NAMESPACE=zilla-quickstart
# Clear out any old containers
docker-compose -p $NAMESPACE down --remove-orphans

[[ -z "$KAFKA_HOST" && -z "$KAFKA_PORT" ]] && printf "==== This example requires a running kafka instance ====\n$USAGE" && exit 0;
docker run --rm bitnami/kafka bash -c "
echo 'Creating topics for $KAFKA_HOST:$KAFKA_PORT'
/opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_HOST:$KAFKA_PORT --create --if-not-exists --topic items-crud --config cleanup.policy=compact
/opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_HOST:$KAFKA_PORT --create --if-not-exists --topic events-sse --config cleanup.policy=compact
/opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_HOST:$KAFKA_PORT --create --if-not-exists --topic echo-service-messages
/opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_HOST:$KAFKA_PORT --create --if-not-exists --topic route-guide-requests
/opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_HOST:$KAFKA_PORT --create --if-not-exists --topic route-guide-responses
/opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_HOST:$KAFKA_PORT --create --if-not-exists --topic iot-messages
/opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_HOST:$KAFKA_PORT --create --if-not-exists --topic iot-sessions --config cleanup.policy=compact
/opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server $KAFKA_HOST:$KAFKA_PORT --create --if-not-exists --topic iot-retained --config cleanup.policy=compact
"

# Start Zilla
docker-compose -p $NAMESPACE up -d
