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
docker image inspect zilla-examples/grpc-echo:latest --format 'Image Found {{.RepoTags}}'

+ helm install zilla-grpc-kafka-proxy chart --namespace zilla-grpc-kafka-proxy --create-namespace --wait --timeout 3m
NAME: zilla-grpc-kafka-proxy
LAST DEPLOYED: Tue Apr 18 14:46:24 2023
NAMESPACE: zilla-grpc-kafka-proxy
STATUS: deployed
REVISION: 1
TEST SUITE: None
+ kubectl port-forward --namespace zilla-grpc-kafka-proxy service/zilla 9090
+ nc -z localhost 9090
+ kubectl port-forward --namespace zilla-grpc-kafka-proxy service/grpc-echo 8080
+ sleep 1
+ nc -z localhost 9090
Connection to localhost port 9090 [tcp/websm] succeeded!
+ nc -z localhost 8080
Connection to localhost port 8080 [tcp/http-alt] succeeded!
```

### Verify behavior

```bash
grpcurl -insecure -proto chart/files/proto/echo.proto  -d '{"message":"World"}' localhost:9090 example.EchoService.EchoUnary
```

```bash
grpcurl -insecure -proto chart/files/proto/echo.proto -H  -d @ localhost:9090 example.EchoService.EchoStream
```

### Teardown

The `teardown.sh` script stops port forwarding, uninstalls Zilla and deletes the namespace.

```bash
$ ./teardown.sh
+ pgrep kubectl
24494
24495
+ killall kubectl
+ helm uninstall zilla-grpc-kafka-proxy --namespace zilla-grpc-kafka-proxy
release "zilla-grpc-kafka-proxy" uninstalled
+ kubectl delete namespace zilla-grpc-kafka-proxy
namespace "zilla-grpc-kafka-proxy" deleted
```
