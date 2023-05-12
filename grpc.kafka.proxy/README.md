# grpc..kafka.proxy

Listens on https port `9090` and uses kafka as proxy to talk to `grpc_echo` on tcp port `8080`.

### Requirements

- bash, jq, nc, grpcurl
- Kubernetes (e.g. Docker Desktop with Kubernetes enabled)
- kubectl
- helm 3.0+

### Build the grpc-echo docker image

```bash
$ docker build -t zilla-examples/grpc-echo:latest .
 => exporting to image
  => => exporting layers
 => => writing image sha256:8ad3819be40334045c01d189000c63a1dfe22b2a97ef376d0c6e56616de132c7 
 => => naming to docker.io/zilla-examples/grpc-echo:latest
```

### Setup

The `setup.sh` script:
- installs Zilla to the Kubernetes cluster with helm and waits for the pod to start up
- starts port forwarding

```bash
$ ./setup.sh
+ docker image inspect zilla-examples/grpc-echo:latest --format 'Image Found {{.RepoTags}}'
Image Found [zilla-examples/grpc-echo:latest]
+ ZILLA_CHART=../zilla-0.1.0-develop-SNAPSHOT.tgz
+ helm install zilla-grpc-kafka-proxy ../zilla-0.1.0-develop-SNAPSHOT.tgz --namespace zilla-grpc-kafka-proxy --create-namespace --wait [...]
NAME: zilla-grpc-kafka-proxy
LAST [...]
NAMESPACE: zilla-grpc-kafka-proxy
STATUS: deployed
REVISION: 1
Zilla has been installed.
[...]
+ helm install zilla-grpc-kafka-proxy-kafka chart --namespace zilla-grpc-kafka-proxy --create-namespace --wait --timeout 2m
NAME: zilla-grpc-kafka-proxy-kafka
LAST DEPLOYED: [...]
NAMESPACE: zilla-grpc-kafka-proxy
STATUS: deployed
TEST SUITE: None
++ kubectl get pods --namespace zilla-grpc-kafka-proxy --selector app.kubernetes.io/instance=kafka -o name
+ KAFKA_POD=pod/kafka-74675fbb8-7knvx
+ kubectl exec --namespace zilla-grpc-kafka-proxy pod/kafka-74675fbb8-7knvx -- /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic echo-requests --if-not-exists
Created topic echo-requests.
++ kubectl get pods --namespace zilla-grpc-kafka-proxy --selector app.kubernetes.io/instance=kafka -o name
+ KAFKA_POD=pod/kafka-74675fbb8-7knvx
+ kubectl exec --namespace zilla-grpc-kafka-proxy pod/kafka-74675fbb8-7knvx -- /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic echo-responses --if-not-exists
Created topic echo-responses.
+ kubectl port-forward --namespace zilla-grpc-kafka-proxy service/zilla-grpc-kafka-proxy 9090
+ kubectl port-forward --namespace zilla-grpc-kafka-proxy service/kafka 9092 29092
+ nc -z localhost 9090
+ kubectl port-forward --namespace zilla-grpc-kafka-proxy service/grpc-echo 8080
+ sleep 1
+ nc -z localhost 9090
Connection to localhost port 9090 [tcp/websm] succeeded!
+ nc -z localhost 9092
Connection to localhost port 9092 [tcp/XmlIpcRegSvc] succeeded!
+ nc -z localhost 8080
Connection to localhost port 8080 [tcp/http-alt] succeeded!
```

### Verify behavior

Echo one message via unary rpc.
```bash
$ grpcurl -insecure -proto proto/echo.proto -d '{"message":"Hello World"}' localhost:9090 example.EchoService.EchoUnary
```
```
{
  "message": "Hello World"
}
```

Verify the message payload, followed by a tombstone to mark the end of the request.
```bash
$ kcat -C -b localhost:9092 -t echo-requests -J -u | jq .
```
```
{
  "topic": "echo-requests",
  "partition": 0,
  "offset": 0,
  "tstype": "create",
  "ts": 1682639950943,
  "broker": 1,
  "headers": [
    "zilla:service",
    "example.EchoService",
    "zilla:method",
    "EchoUnary",
    "zilla:correlation-id",
    "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e"
  ],
  "key": "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e",
  "payload": "\n\u000bHello World"
}
{
  "topic": "echo-requests",
  "partition": 0,
  "offset": 1,
  "tstype": "create",
  "ts": 1682639950945,
  "broker": 1,
  "headers": [
    "zilla:service",
    "example.EchoService",
    "zilla:method",
    "EchoUnary",
    "zilla:correlation-id",
    "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e"
  ],
  "key": "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e",
  "payload": null
}
% Reached end of topic echo-requests [0] at offset 2
```

Verify the message payload, followed by a tombstone to mark the end of the response.
```bash
$ kcat -C -b localhost:9092 -t echo-responses -J -u | jq .
```
```
{
  "topic": "echo-responses",
  "partition": 0,
  "offset": 0,
  "tstype": "create",
  "ts": 1682639951093,
  "broker": 1,
  "headers": [
    "zilla:correlation-id",
    "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e"
  ],
  "key": "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e",
  "payload": "\n\u000bHello World"
}
{
  "topic": "echo-responses",
  "partition": 0,
  "offset": 1,
  "tstype": "create",
  "ts": 1682639951094,
  "broker": 1,
  "headers": [
    "zilla:correlation-id",
    "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e",
    "zilla:status",
    "0"
  ],
  "key": "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e",
  "payload": null
}
% Reached end of topic echo-responses [0] at offset 2
```

Echo each message via bidirectional streaming rpc.
```bash
$ grpcurl -insecure -proto proto/echo.proto -d @ localhost:9090 example.EchoService.EchoBidiStream
```
```
{
  "message": "Hello World"
}
```
```
{
  "message": "Hello World"
}
```
```
{
  "message": "Hello World"
}
```
```
{
  "message": "Hello World"
}
```

Verify the message payloads, followed by a tombstone to mark the end of each request.
```bash
$ kcat -C -b localhost:9092 -t echo-requests -J -u | jq .
```
```
{
  "topic": "echo-requests",
  "partition": 0,
  "offset": 0,
  "tstype": "create",
  "ts": 1682639950943,
  "broker": 1,
  "headers": [
    "zilla:service",
    "example.EchoService",
    "zilla:method",
    "EchoUnary",
    "zilla:correlation-id",
    "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e"
  ],
  "key": "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e",
  "payload": "\n\u000bHello World"
}
{
  "topic": "echo-requests",
  "partition": 0,
  "offset": 1,
  "tstype": "create",
  "ts": 1682639950945,
  "broker": 1,
  "headers": [
    "zilla:service",
    "example.EchoService",
    "zilla:method",
    "EchoUnary",
    "zilla:correlation-id",
    "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e"
  ],
  "key": "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e",
  "payload": null
}
{
  "topic": "echo-requests",
  "partition": 0,
  "offset": 2,
  "tstype": "create",
  "ts": 1682640151057,
  "broker": 1,
  "headers": [
    "zilla:service",
    "example.EchoService",
    "zilla:method",
    "EchoStream",
    "zilla:correlation-id",
    "2de3f344-150a-42e2-bcf8-e7c7150d51bf-d41d8cd98f00b204e9800998ecf8427e"
  ],
  "key": "2de3f344-150a-42e2-bcf8-e7c7150d51bf-d41d8cd98f00b204e9800998ecf8427e",
  "payload": "\n\u000bHello World"
}
{
  "topic": "echo-requests",
  "partition": 0,
  "offset": 3,
  "tstype": "create",
  "ts": 1682640159066,
  "broker": 1,
  "headers": [
    "zilla:service",
    "example.EchoService",
    "zilla:method",
    "EchoStream",
    "zilla:correlation-id",
    "2de3f344-150a-42e2-bcf8-e7c7150d51bf-d41d8cd98f00b204e9800998ecf8427e"
  ],
  "key": "2de3f344-150a-42e2-bcf8-e7c7150d51bf-d41d8cd98f00b204e9800998ecf8427e",
  "payload": "\n\u000bHello World"
}
{
  "topic": "echo-requests",
  "partition": 0,
  "offset": 4,
  "tstype": "create",
  "ts": 1682640161636,
  "broker": 1,
  "headers": [
    "zilla:service",
    "example.EchoService",
    "zilla:method",
    "EchoStream",
    "zilla:correlation-id",
    "2de3f344-150a-42e2-bcf8-e7c7150d51bf-d41d8cd98f00b204e9800998ecf8427e"
  ],
  "key": "2de3f344-150a-42e2-bcf8-e7c7150d51bf-d41d8cd98f00b204e9800998ecf8427e",
  "payload": null
}
% Reached end of topic echo-requests [0] at offset 5
```

Verify the message payloads, followed by a tombstone to mark the end of each response.
```bash
$ kcat -C -b localhost:9092 -t echo-responses -J -u | jq .
```
```
{
  "topic": "echo-responses",
  "partition": 0,
  "offset": 0,
  "tstype": "create",
  "ts": 1682639951093,
  "broker": 1,
  "headers": [
    "zilla:correlation-id",
    "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e"
  ],
  "key": "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e",
  "payload": "\n\u000bHello World"
}
{
  "topic": "echo-responses",
  "partition": 0,
  "offset": 1,
  "tstype": "create",
  "ts": 1682639951094,
  "broker": 1,
  "headers": [
    "zilla:correlation-id",
    "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e",
    "zilla:status",
    "0"
  ],
  "key": "457e5954-ca4d-4794-9f4f-407103c99c5e-d41d8cd98f00b204e9800998ecf8427e",
  "payload": null
}
{
  "topic": "echo-responses",
  "partition": 0,
  "offset": 2,
  "tstype": "create",
  "ts": 1682640151072,
  "broker": 1,
  "headers": [
    "zilla:correlation-id",
    "2de3f344-150a-42e2-bcf8-e7c7150d51bf-d41d8cd98f00b204e9800998ecf8427e"
  ],
  "key": "2de3f344-150a-42e2-bcf8-e7c7150d51bf-d41d8cd98f00b204e9800998ecf8427e",
  "payload": "\n\u000bHello World"
}
{
  "topic": "echo-responses",
  "partition": 0,
  "offset": 3,
  "tstype": "create",
  "ts": 1682640159073,
  "broker": 1,
  "headers": [
    "zilla:correlation-id",
    "2de3f344-150a-42e2-bcf8-e7c7150d51bf-d41d8cd98f00b204e9800998ecf8427e"
  ],
  "key": "2de3f344-150a-42e2-bcf8-e7c7150d51bf-d41d8cd98f00b204e9800998ecf8427e",
  "payload": "\n\u000bHello World"
}
{
  "topic": "echo-responses",
  "partition": 0,
  "offset": 4,
  "tstype": "create",
  "ts": 1682640161646,
  "broker": 1,
  "headers": [
    "zilla:correlation-id",
    "2de3f344-150a-42e2-bcf8-e7c7150d51bf-d41d8cd98f00b204e9800998ecf8427e",
    "zilla:status",
    "0"
  ],
  "key": "2de3f344-150a-42e2-bcf8-e7c7150d51bf-d41d8cd98f00b204e9800998ecf8427e",
  "payload": null
}
% Reached end of topic echo-responses [0] at offset 5
```

### Teardown

The `teardown.sh` script stops port forwarding, uninstalls Zilla and deletes the namespace.

```bash
$ ./teardown.sh
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
