# http.echo

Listens on http port `7114` and will echo back whatever is sent to the server.
Listens on https port `7143` and will echo back whatever is sent to the server.

### Requirements

- bash, jq, nc
- Kubernetes (e.g. Docker Desktop with Kubernetes enabled)
- kubectl
- helm 3.0+
- curl

### Setup

The `setup.sh` script:

- installs Zilla to the Kubernetes cluster with helm and waits for the pods to start up
- starts port forwarding

```bash
./setup.sh
```

output:

```text
+ ZILLA_CHART=oci://ghcr.io/aklivity/charts/zilla
+ helm upgrade --install zilla-http-echo oci://ghcr.io/aklivity/charts/zilla --namespace zilla-http-echo --wait [...]
NAME: zilla-http-echo
LAST DEPLOYED: [...]
NAMESPACE: zilla-http-echo
STATUS: deployed
REVISION: 1
NOTES:
Zilla has been installed.
[...]
+ nc -z localhost 7114
+ kubectl port-forward --namespace zilla-http-echo service/zilla 7114 7143
+ sleep 1
+ nc -z localhost 7114
Connection to localhost port 7114 [tcp/http-alt] succeeded!
```

### Verify behavior

```bash
curl -d "Hello, world" -H "Content-Type: text/plain" -X "POST" http://localhost:7114/
```

output:

```text
Hello, world
```

```bash
curl -d "Hello, world" -H "Content-Type: text/plain" -X "POST" http://localhost:7114/ --http2-prior-knowledge
```

output:

```text
Hello, world
```

```bash
curl --cacert test-ca.crt -d "Hello, world" -H "Content-Type: text/plain" -X "POST" https://localhost:7143/ --http1.1
```

output:

```text
Hello, world
```

```bash
curl --cacert test-ca.crt -d "Hello, world" -H "Content-Type: text/plain" -X "POST" https://localhost:7143/ --http2
```

output:

```text
Hello, world
```

### Teardown

The `teardown.sh` script stops port forwarding, uninstalls Zilla and deletes the namespace.

```bash
./teardown.sh
```

output:

```text
+ pgrep kubectl
99999
+ killall kubectl
+ helm uninstall zilla-http-echo --namespace zilla-http-echo
release "zilla-http-echo" uninstalled
+ kubectl delete namespace zilla-http-echo
namespace "zilla-http-echo" deleted
```
