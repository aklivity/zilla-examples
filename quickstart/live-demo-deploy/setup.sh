#!/bin/bash
set -e

## Setting up env
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

NAMESPACE="${NAMESPACE:-zilla-quickstart}"
ZILLA_NAME="${ZILLA_NAME:-zilla-proxy}"
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
# Zilla Taxi Demo
kubectl get ns $NAMESPACE || kubectl create ns $NAMESPACE
# kubectl create configmap kafka-ssl-files --from-file=./kafka/client.truststore.p12 --from-file=./kafka/client.keystore.p12 -n $NAMESPACE -o yaml --dry-run=client | kubectl apply -f -
kubectl create configmap protobuf-files --from-file=./route_guide.proto -n $NAMESPACE -o yaml --dry-run=client | kubectl apply -f -
kubectl create secret generic deploy-secrets --from-env-file=.env -n $NAMESPACE -o yaml --dry-run=client | kubectl apply -f -

# Install Ingress Controller
while ! kubectl apply -f ingress-deploy.yaml; do echo "Retrying to apply resources"; sleep 3; done
# Create ingress controller tcp-services configmap
kubectl create configmap tcp-services \
    --from-literal=7183="$NAMESPACE/$ZILLA_NAME:7183" \
    --from-literal=7151="$NAMESPACE/$ZILLA_NAME:7151" \
    -n ingress-nginx -o yaml --dry-run=client | kubectl apply -f -
echo "==== Ingress controller is serving ports: $(kubectl get svc -n ingress-nginx ingress-nginx-controller --template "{{ range .status.loadBalancer.ingress }} {{.ip}} {{ end }} | {{ range .spec.ports }}{{.port}} {{ end }}")"

# MQTT Simulator
helm upgrade --install mqtt-simulator ../k8s/helm/mqtt-simulator -n $NAMESPACE \
    --set brokerUrl="$ZILLA_NAME.$NAMESPACE.svc.cluster.local" \
    --set brokerPort="7183"

# gRPC Route Guide Server
helm upgrade --install route-guide-server ../k8s/helm/route-guide-server -n $NAMESPACE

# create Kafka UI
helm upgrade --install kafka-ui kafka-ui/kafka-ui --version 1.4.2 -n $NAMESPACE \
    --set yamlApplicationConfig.kafka.clusters[0].name="$NAMESPACE-cc-kafka" \
    --set yamlApplicationConfig.kafka.clusters[0].bootstrapServers="$KAFKA_BOOTSTRAP_SERVER" \
    --set yamlApplicationConfig.kafka.clusters[0].properties.sasl\\.jaas\\.config="$SASL_JAAS" \
    --values kafka-ui/kafka-ui-values.yaml

# install Zilla
helm upgrade --install $ZILLA_NAME /Users/adanelz/Code/zilla/cloud/helm-chart/src/main/helm/zilla --version 0.9.84 -n $NAMESPACE \
    --set env.ROUTE_GUIDE_SERVER_HOST="route-guide-server.$NAMESPACE.svc.cluster.local" \
    --set-file zilla\\.yaml=zilla.yaml \
    --values values.yaml
