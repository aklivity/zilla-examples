# grpc.kafka.proxy

Listens on https port `7153` and uses kafka as proxy to talk to `grpc-echo` on tcp port `50051`.

## Requirements

- bash, jq, nc, grpcurl
- Kubernetes (e.g. Docker Desktop with Kubernetes enabled)
- kubectl
- helm 3.0+

## Setup

The `setup.sh` script:

- installs Zilla to the Kubernetes cluster with helm and waits for the pod to start up
- starts port forwarding

```bash
./setup.sh
```

output:

```text
+ ZILLA_CHART=oci://ghcr.io/aklivity/charts/zilla
+ helm upgrade --install zilla-grpc-kafka-proxy oci://ghcr.io/aklivity/charts/zilla --namespace zilla-grpc-kafka-proxy --create-namespace --wait [...]
NAME: zilla-grpc-kafka-proxy
LAST [...]
NAMESPACE: zilla-grpc-kafka-proxy
STATUS: deployed
REVISION: 1
Zilla has been installed.
[...]
+ helm upgrade --install zilla-grpc-kafka-proxy-kafka chart --namespace zilla-grpc-kafka-proxy --create-namespace --wait --timeout 2m
NAME: zilla-grpc-kafka-proxy-kafka
LAST DEPLOYED: [...]
NAMESPACE: zilla-grpc-kafka-proxy
STATUS: deployed
TEST SUITE: None
++ kubectl get pods --namespace zilla-grpc-kafka-proxy --selector app.kubernetes.io/instance=kafka -o name
+ KAFKA_POD=pod/kafka-74675fbb8-7knvx
+ kubectl exec --namespace zilla-grpc-kafka-proxy pod/kafka-74675fbb8-7knvx -- /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic echo-requests --if-not-exists
Created topic echo-requests.
+ kubectl exec --namespace zilla-grpc-kafka-proxy pod/kafka-74675fbb8-7knvx -- /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic echo-responses --if-not-exists
Created topic echo-responses.
+ kubectl port-forward --namespace zilla-grpc-kafka-proxy service/zilla 7153
+ kubectl port-forward --namespace zilla-grpc-kafka-proxy service/kafka 9092 29092
+ nc -z localhost 7153
+ kubectl port-forward --namespace zilla-grpc-kafka-proxy service/grpc-echo 8080
+ sleep 1
+ nc -z localhost 7153
Connection to localhost port 7153 [tcp/websm] succeeded!
+ nc -z localhost 9092
Connection to localhost port 9092 [tcp/XmlIpcRegSvc] succeeded!
+ nc -z localhost 8080
Connection to localhost port 8080 [tcp/http-alt] succeeded!
```

## Verify behavior

### Unary Stream

Echo `{"message":"Hello World"}` message via unary rpc.

```bash
grpcurl -insecure -proto proto/echo.proto  -d '{"message":"Hello World"}' localhost:7153 grpc.examples.echo.Echo.UnaryEcho
```

output:

```json
{
  "message": "Hello World"
}
```

Verify the message payload, followed by a tombstone to mark the end of the request.

```bash
kcat -C -b localhost:9092 -t echo-requests -J -u | jq .
```

output:

```json
{
  "topic": "echo-requests",
  "partition": 0,
  "offset": 0,
  "tstype": "create",
  "ts": 1683828554432,
  "broker": 1,
  "headers": [
    "zilla:service",
    "grpc.examples.echo.Echo",
    "zilla:method",
    "UnaryEcho",
    "zilla:reply-to",
    "echo-responses",
    "zilla:correlation-id",
    "c3c3eb97-313f-4cf0-aa6c-f83c1080e649-cdd8170a6db4597eb33ba423f67e19e2"
  ],
  "key": "c3c3eb97-313f-4cf0-aa6c-f83c1080e649-cdd8170a6db4597eb33ba423f67e19e2",
  "payload": "\n\u000bHello World"
}
{
  "topic": "echo-requests",
  "partition": 0,
  "offset": 1,
  "tstype": "create",
  "ts": 1683828554442,
  "broker": 1,
  "headers": [
    "zilla:service",
    "grpc.examples.echo.Echo",
    "zilla:method",
    "UnaryEcho",
    "zilla:reply-to",
    "echo-responses",
    "zilla:correlation-id",
    "c3c3eb97-313f-4cf0-aa6c-f83c1080e649-cdd8170a6db4597eb33ba423f67e19e2"
  ],
  "key": "c3c3eb97-313f-4cf0-aa6c-f83c1080e649-cdd8170a6db4597eb33ba423f67e19e2",
  "payload": null
}
% Reached end of topic echo-requests [0] at offset 2
```

### Bidirectional streaming

Echo messages via bidirectional streaming rpc.

```bash
grpcurl -insecure -proto proto/echo.proto -d @ localhost:7153 grpc.examples.echo.Echo.BidirectionalStreamingEcho <<EOM
{"message":"Hello World, first"}
{"message":"Hello World, stream"}
{"message":"Hello World, stream"}
{"message":"Hello World, stream"}
{"message":"Hello World, last"}
EOM
```

output:

```json
{
  "message": "Hello World, first"
}
{
  "message": "Hello World, stream"
}
{
  "message": "Hello World, stream"
}
{
  "message": "Hello World, stream"
}
{
  "message": "Hello World, last"
}
```

Verify the message payloads arrived in order, followed by a tombstone to mark the end of the response.

```bash
kcat -C -b localhost:9092 -t echo-responses -J -u | jq .
```

output:

```json
{
  "topic": "echo-responses",
  "partition": 0,
  "offset": 4,
  "tstype": "create",
  "ts": 1721162975117,
  "broker": 1,
  "headers": [
    "zilla:correlation-id",
    "d8b57dd3-d0e8-4b99-86ce-a7c79cd7d49a-46ae5cdb4b46cbb367cbad0bea36a56f"
  ],
  "key": "d8b57dd3-d0e8-4b99-86ce-a7c79cd7d49a-46ae5cdb4b46cbb367cbad0bea36a56f",
  "payload": "\n\u0012Hello World, first"
}
{
  "topic": "echo-responses",
  "partition": 0,
  "offset": 5,
  "tstype": "create",
  "ts": 1721162975117,
  "broker": 1,
  "headers": [
    "zilla:correlation-id",
    "d8b57dd3-d0e8-4b99-86ce-a7c79cd7d49a-46ae5cdb4b46cbb367cbad0bea36a56f"
  ],
  "key": "d8b57dd3-d0e8-4b99-86ce-a7c79cd7d49a-46ae5cdb4b46cbb367cbad0bea36a56f",
  "payload": "\n\u0013Hello World, stream"
}
{
  "topic": "echo-responses",
  "partition": 0,
  "offset": 6,
  "tstype": "create",
  "ts": 1721162975117,
  "broker": 1,
  "headers": [
    "zilla:correlation-id",
    "d8b57dd3-d0e8-4b99-86ce-a7c79cd7d49a-46ae5cdb4b46cbb367cbad0bea36a56f"
  ],
  "key": "d8b57dd3-d0e8-4b99-86ce-a7c79cd7d49a-46ae5cdb4b46cbb367cbad0bea36a56f",
  "payload": "\n\u0013Hello World, stream"
}
{
  "topic": "echo-responses",
  "partition": 0,
  "offset": 7,
  "tstype": "create",
  "ts": 1721162975117,
  "broker": 1,
  "headers": [
    "zilla:correlation-id",
    "d8b57dd3-d0e8-4b99-86ce-a7c79cd7d49a-46ae5cdb4b46cbb367cbad0bea36a56f"
  ],
  "key": "d8b57dd3-d0e8-4b99-86ce-a7c79cd7d49a-46ae5cdb4b46cbb367cbad0bea36a56f",
  "payload": "\n\u0013Hello World, stream"
}
{
  "topic": "echo-responses",
  "partition": 0,
  "offset": 8,
  "tstype": "create",
  "ts": 1721162975117,
  "broker": 1,
  "headers": [
    "zilla:correlation-id",
    "d8b57dd3-d0e8-4b99-86ce-a7c79cd7d49a-46ae5cdb4b46cbb367cbad0bea36a56f"
  ],
  "key": "d8b57dd3-d0e8-4b99-86ce-a7c79cd7d49a-46ae5cdb4b46cbb367cbad0bea36a56f",
  "payload": "\n\u0011Hello World, last"
}
{
  "topic": "echo-responses",
  "partition": 0,
  "offset": 9,
  "tstype": "create",
  "ts": 1721162975117,
  "broker": 1,
  "headers": [
    "zilla:correlation-id",
    "d8b57dd3-d0e8-4b99-86ce-a7c79cd7d49a-46ae5cdb4b46cbb367cbad0bea36a56f",
    "zilla:status",
    "0"
  ],
  "key": "d8b57dd3-d0e8-4b99-86ce-a7c79cd7d49a-46ae5cdb4b46cbb367cbad0bea36a56f",
  "payload": null
}
% Reached end of topic echo-responses [0] at offset 9
```

## Teardown

The `teardown.sh` script stops port forwarding, uninstalls Zilla and deletes the namespace.

```bash
./teardown.sh
```

output:

```text
+ pgrep kubectl
99997
99998
99999
+ killall kubectl
+ helm uninstall zilla-grpc-kafka-proxy zilla-grpc-kafka-proxy-kafka --namespace zilla-grpc-kafka-proxy
release "zilla-grpc-kafka-proxy" uninstalled
release "zilla-grpc-kafka-proxy-kafka" uninstalled
+ kubectl delete namespace zilla-grpc-kafka-proxy
namespace "zilla-grpc-kafka-proxy" deleted
```
