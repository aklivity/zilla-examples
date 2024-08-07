# grpc.proxy

Listens on https port `7153` and will echo back whatever is published to `grpc-echo` on tcp port `50051`.

### Requirements

- bash, jq, nc, grpcurl
- Kubernetes (e.g. Docker Desktop with Kubernetes enabled)
- kubectl
- helm 3.0+

### Setup

The `setup.sh` script:

- installs Zilla to the Kubernetes cluster with helm and waits for the pod to start up
- starts port forwarding

```bash
./setup.sh
```

output:

```text
+ ZILLA_CHART=oci://ghcr.io/aklivity/charts/zilla
+ helm upgrade --install zilla-grpc-proxy oci://ghcr.io/aklivity/charts/zilla --namespace zilla-grpc-proxy --create-namespace --wait [...]
NAME: zilla-grpc-proxy
LAST DEPLOYED: [...]
NAMESPACE: zilla-grpc-proxy
STATUS: deployed
REVISION: 1
NOTES:
Zilla has been installed.
[...]
+ helm upgrade --install zilla-grpc-proxy-grpc-echo chart --namespace zilla-grpc-proxy --create-namespace --wait --timeout 2m
NAME: zilla-grpc-proxy-grpc-echo
LAST DEPLOYED: [...]
NAMESPACE: zilla-grpc-proxy
STATUS: deployed
REVISION: 1
TEST SUITE: None
+ kubectl port-forward --namespace zilla-grpc-proxy service/zilla 7153
+ kubectl port-forward --namespace zilla-grpc-proxy service/grpc-echo 8080
+ nc -z localhost 7153
+ sleep 1
+ nc -z localhost 7153
Connection to localhost port 7153 [tcp/websm] succeeded!
+ nc -z localhost 8080
Connection to localhost port 8080 [tcp/http-alt] succeeded!
```

### Verify behavior

#### Unary Stream

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

#### Bidirectional streaming

Echo messages via bidirectional streaming rpc.

```bash
grpcurl -insecure -proto proto/echo.proto -d @ localhost:7153 grpc.examples.echo.Echo.BidirectionalStreamingEcho
```

Paste below message.

```json
{
  "message": "Hello World"
}
```

### Teardown

The `teardown.sh` script stops port forwarding, uninstalls Zilla and deletes the namespace.

```bash
./teardown.sh
```

output:

```text
+ pgrep kubectl
99998
99999
+ killall kubectl
+ helm uninstall zilla-grpc-proxy zilla-grpc-proxy-grpc-echo --namespace zilla-grpc-proxy
release "zilla-grpc-proxy" uninstalled
release "zilla-grpc-proxy-grpc-echo" uninstalled
+ kubectl delete namespace zilla-grpc-proxy
namespace "zilla-grpc-proxy" deleted
```
