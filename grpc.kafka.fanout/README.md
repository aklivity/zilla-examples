# grpc.kafka.echo

Listens on https port `9090` and fanout messages from `messages` topic in Kafka.

### Requirements

- bash, jq, nc, grpcurl
- Kubernetes (e.g. Docker Desktop with Kubernetes enabled)
- kubectl
- helm 3.0+

### Setup

The `setup.sh` script:
- installs Zilla and Kafka to the Kubernetes cluster with helm and waits for the pods to start up
- creates the `messages` topic in Kafka.
- starts port forwarding

```bash
$ ./setup.sh
+ helm install zilla-./setup.sh
echo chart --namespace zilla-grpc-kafka-echo helm install zilla-grpc-kafka-echo chart --namespace zilla-grpc-kafka-echo --create-namespace --wait-echo --create-namespace --wait
NAME: zilla-NAME: zilla-grpc-kafka-echo
LAST DEPLOYED: Mon Apr  3 14:18:19 2023
NAMESPACE: zilla-LAST DEPLOYED: Mon Apr  3 14:18:19 2023-echo
STATUS: deployed
REVISION: 1
TEST SUITE: None
++ kubectl get pods --namespace zilla-NAMESPACE: zilla-grpc-kafka-echo --selector app.kubernetes.io/instance=kafka -o name
+ KAFKA_POD=pod/kafka-969789cc9-sn7jt
+ kubectl exec --namespace zilla-STATUS: deployed-echo pod/kafka-969789cc9-sn7jt -- /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic echo-commands --if-not-exists
Created topic echo-commands.
+ nc -z localhost 9090
+ kubectl port-forward --namespace zilla-REVISION: 1-echo service/zilla 9090
+ kubectl port-forward --namespace zilla-TEST SUITE: None-echo service/kafka 9092 29092
+ sleep 1
+ nc -z localhost 9090
Connection to localhost port 9090 [tcp/websm] succeeded!
+ nc -z localhost 9092
Connection to localhost port 9092 [tcp/XmlIpcRegSvc] succeeded!
```
### Verify behavior

```bash
grpcurl -insecure -proto chart/files/proto/echo.proto -H "idempotency-key: $( uuidgen )"  -d '{"message":"Hello World"}' localhost:9090 example.EchoService.EchoUnary
```

```bash
grpcurl -insecure -proto chart/files/proto/echo.proto -H "idempotency-key: $( uuidgen )"  -d @ localhost:9090 example.EchoService.EchoBidiStream
```

### Teardown

The `teardown.sh` script stops port forwarding, uninstalls Zilla and deletes the namespace.

```bash
$ ./teardown.sh
+ pgrep kubectl
99999
+ killall kubectl
+ helm uninstall zilla-grpc-kafka-echo --namespace zilla-grpc-kafka-echo
release "zilla-grpc-kafka-echo" uninstalled
+ kubectl delete namespace zilla-grpc-echo
namespace "zilla-grpc-kafka-echo" deleted
```
