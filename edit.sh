#!/bin/bash
set -e

for d in */ ; do
echo ${d/./-}
dir=${d/\//}
cat <<EOT > $d/setup.sh
#!/bin/sh
set -e

# Start or restart Zilla
if [ -z "\$(docker compose ps -q zilla)" ]; then
docker compose up -d
else
docker compose up -d --force-recreate --no-deps zilla
fi
EOT
cat <<EOT > $d/teardown.sh
#!/bin/sh
set -e

docker compose -p "\${NAMESPACE:-zilla-${dir//./-}}" down --remove-orphans

EOT

if [[ $d == *"kafka"* ]]; then
cat <<EOT > $d/compose.yaml
name: \${NAMESPACE:-zilla-${dir//./-}}
services:
  zilla:
    image: ghcr.io/aklivity/zilla:\${ZILLA_VERSION:-latest}
    pull_policy: always
    restart: unless-stopped
    ports:
      - 7114:7114
    environment:
      KAFKA_BOOTSTRAP_SERVER: ${KAFKA_BOOTSTRAP_SERVER:-kafka:29092}
    volumes:
      - ./zilla.yaml:/etc/zilla/zilla.yaml
    command: start -v -e

  kafka:
    image: bitnami/kafka:3.5
    restart: unless-stopped
    ports:
      - 9092:9092
      - 29092:29092
    healthcheck:
      test: /opt/bitnami/kafka/bin/kafka-cluster.sh cluster-id --bootstrap-server kafka:29092 || exit 1
      interval: 1s
      timeout: 60s
      retries: 60
    environment:
      ALLOW_PLAINTEXT_LISTENER: "yes"
      KAFKA_CFG_NODE_ID: "1"
      KAFKA_CFG_BROKER_ID: "1"
      KAFKA_CFG_GROUP_INITIAL_REBALANCE_DELAY_MS: "0"
      KAFKA_CFG_CONTROLLER_QUORUM_VOTERS: "1@127.0.0.1:9093"
      KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP: "CLIENT:PLAINTEXT,INTERNAL:PLAINTEXT,DOCKER:PLAINTEXT,CONTROLLER:PLAINTEXT"
      KAFKA_CFG_CONTROLLER_LISTENER_NAMES: "CONTROLLER"
      KAFKA_CFG_LOG_DIRS: "/tmp/logs"
      KAFKA_CFG_PROCESS_ROLES: "broker,controller"
      KAFKA_CFG_LISTENERS: "CLIENT://:9092,INTERNAL://:29092,DOCKER://:19092,CONTROLLER://:9093"
      KAFKA_CFG_INTER_BROKER_LISTENER_NAME: "INTERNAL"
      KAFKA_CFG_ADVERTISED_LISTENERS: "CLIENT://localhost:9092,INTERNAL://kafka:29092,DOCKER://host.docker.internal:19092"
      KAFKA_CFG_AUTO_CREATE_TOPICS_ENABLE: "true"

  kafka-init:
    image: bitnami/kafka:3.5
    user: root
    depends_on:
      kafka:
        condition: service_healthy
        restart: true
    deploy:
      restart_policy:
        condition: none
        max_attempts: 0
    entrypoint: ["/bin/sh", "-c"]
    command:
      - |
        echo -e "Creating kafka topic";
        /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --create --if-not-exists --topic items-requests
        /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --create --if-not-exists --topic items-responses --config cleanup.policy=compact
        echo -e "Successfully created the following topics:";
        /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --list;

  kafka-ui:
    image: ghcr.io/kafbat/kafka-ui:latest
    restart: unless-stopped
    ports:
      - 8080:8080
    depends_on:
      kafka:
        condition: service_healthy
        restart: true
    environment:
      KAFKA_CLUSTERS_0_NAME: local
      KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS: kafka:29092

  kcat:
    image: confluentinc/cp-kafkacat:7.1.9
    command: "bash"
    stdin_open: true
    tty: true

networks:
  default:
    driver: bridge
EOT
else
cat <<EOT > $d/compose.yaml
name: \${NAMESPACE:-zilla-${dir//./-}}
services:
  zilla:
    image: ghcr.io/aklivity/zilla:\${ZILLA_VERSION:-latest}
    pull_policy: always
    restart: unless-stopped
    ports:
      - 7114:7114
    environment:
      ENV: env
    volumes:
      - ./zilla.yaml:/etc/zilla/zilla.yaml
    command: start -v -e

networks:
  default:
    driver: bridge
EOT
fi
done
