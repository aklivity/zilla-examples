#!/bin/bash
set -e

## Setting up env
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

NAMESPACE="${NAMESPACE:-zilla-quickstart}"
KAFKA_BOOTSTRAP_SERVER="${KAFKA_BOOTSTRAP_SERVER:-kafka.zilla-kafka-broker.svc.cluster.local:9092}"
KAFKA_USER="${KAFKA_USER:-admin}"
KAFKA_PASS="${KAFKA_PASS:-admin}"
SASL_JAAS="org.apache.kafka.common.security.scram.ScramLoginModule required username=\"$KAFKA_USER\" password=\"$KAFKA_PASS\";"

echo "NAMESPACE=$NAMESPACE"
echo "KAFKA_BOOTSTRAP_SERVER=$KAFKA_BOOTSTRAP_SERVER"
echo "KAFKA_USER=$KAFKA_USER"
echo "KAFKA_PASS=$KAFKA_PASS"
echo "SASL_JAAS=$SASL_JAAS"

## Installing services
# Print public ports
# echo "==== $NAMESPACE Ingress controller is serving ports: $(kubectl get svc -n $NAMESPACE ingress-nginx-controller --template "{{ range .spec.ports }}{{.port}} {{ end }}")"
# Zilla Taxi Demo
kubectl get ns $NAMESPACE || kubectl create ns $NAMESPACE
# kubectl create configmap kafka-ssl-files --from-file=./kafka/client.truststore.p12 --from-file=./kafka/client.keystore.p12 -n $NAMESPACE -o yaml --dry-run=client | kubectl apply -f -
kubectl create configmap protobuf-files --from-file=./echo.proto --from-file=./route_guide.proto -n $NAMESPACE -o yaml --dry-run=client | kubectl apply -f -
kubectl create secret generic deploy-secrets --from-env-file=.env -n $NAMESPACE -o yaml --dry-run=client | kubectl apply -f -

helm upgrade --install zilla oci://ghcr.io/aklivity/charts/zilla --version 0.9.84 -n $NAMESPACE --wait \
    --set-file zilla\\.yaml=zilla.yaml \
    --values values.yaml

helm upgrade --install kafka-ui kafka-ui/kafka-ui --version 1.4.2 -n $NAMESPACE \
    --set yamlApplicationConfig.kafka.clusters[0].name="$NAMESPACE-cc-kafka" \
    --set yamlApplicationConfig.kafka.clusters[0].bootstrapServers="$KAFKA_BOOTSTRAP_SERVER" \
    --set yamlApplicationConfig.kafka.clusters[0].properties.sasl\\.jaas\\.config="$SASL_JAAS" \
    --values kafka-ui/kafka-ui-values.yaml
