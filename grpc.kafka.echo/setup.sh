#!/bin/bash
set -ex

# Install Zilla to the Kubernetes cluster with helm and wait for the pod to start up
ZILLA_CHART="${ZILLA_CHART:-oci://ghcr.io/aklivity/charts/zilla}"
ZILLA_VERSION="${ZILLA_VERSION:-^0.9.0}"
NAMESPACE="${NAMESPACE:-zilla-grpc-kafka-echo}"

kubectl get ns $NAMESPACE || kubectl create ns $NAMESPACE
kubectl create configmap protobuf-files --from-file=./proto/ -n $NAMESPACE -o yaml --dry-run=client | kubectl apply -f -

# Install Zilla to the Kubernetes cluster with helm and wait for the pod to start up
echo "==== Installing $ZILLA_CHART to $NAMESPACE with $KAFKA_BROKER($KAFKA_BOOTSTRAP_SERVER) ===="
helm upgrade --install zilla $ZILLA_CHART --version $ZILLA_VERSION --namespace $NAMESPACE --wait \
    --values values.yaml \
    --set-file zilla\\.yaml=zilla.yaml \
    --set-file secrets.tls.data.localhost\\.p12=tls/localhost.p12

# Install Kafka to the Kubernetes cluster with helm and wait for the pod to start up
helm upgrade --install kafka chart --namespace $NAMESPACE --wait

# Create the echo-messages topic in Kafka
KAFKA_POD=$(kubectl get pods --namespace $NAMESPACE --selector app.kubernetes.io/instance=kafka -o name)
kubectl exec --namespace $NAMESPACE "$KAFKA_POD" -- \
    /opt/bitnami/kafka/bin/kafka-topics.sh \
        --bootstrap-server localhost:9092 \
        --create \
        --topic echo-messages \
        --if-not-exists

# Start port forwarding
kubectl port-forward --namespace $NAMESPACE service/zilla 7151 7153 > /tmp/kubectl-zilla.log 2>&1 &
kubectl port-forward --namespace $NAMESPACE service/kafka 9092 29092 > /tmp/kubectl-kafka.log 2>&1 &

until nc -z localhost 7151; do sleep 1; done
until nc -z localhost 7153; do sleep 1; done
until nc -z localhost 9092; do sleep 1; done
