# http.kafka.schema.registry

Listens on http port `8080` or https port `9090` and will serve cached responses from the `items-snapshots` topic in Kafka.

### Requirements

- bash, jq, nc
- Kubernetes (e.g. Docker Desktop with Kubernetes enabled)
- kubectl
- helm 3.0+
- kcat

### Install kcat client

Requires Kafka client, such as `kcat`.

```bash
brew install kcat
```

### Setup

The `setup.sh` script:

- installs Zilla and Kafka to the Kubernetes cluster with helm and waits for the pods to start up
- creates the `items-snapshots` topic in Kafka with the `cleanup.policy=compact` topic configuration
- starts port forwarding

```bash
./setup.sh
```

output:

```text
+ ZILLA_CHART=oci://ghcr.io/aklivity/charts/zilla
+ VERSION=0.9.46
+ helm install zilla-http-kafka-schema-registry oci://ghcr.io/aklivity/charts/zilla --version 0.9.46 --namespace zilla-http-kafka-schema-registry [...]
NAME: zilla-http-kafka-schema-registry
LAST DEPLOYED: [...]
NAMESPACE: zilla-http-kafka-schema-registry 
STATUS: deployed
REVISION: 1
Zilla has been installed.
[...]
+ nc -z localhost 8080
Connection to localhost port 8080 [tcp/http-alt] succeeded!
+ nc -z localhost 8081
Connection to localhost port 8081 [tcp/sunproxyadmin] succeeded!
+ nc -z localhost 9092
Connection to localhost port 9092 [tcp/XmlIpcRegSvc] succeeded!
```

### Register Schema

```bash
curl 'http://localhost:8081/subjects/items-snapshots/versions' \
--header 'Content-Type: application/json' \
--data '{
  "schema":
    "{\"type\":\"record\",\"name\":\"Record\",\"fields\":[{\"name\":\"greeting\",\"type\":\"string\"}]}",
  "schemaType": "AVRO"
}'
```

### Validate created Schema

```bash
curl 'http://localhost:8081/schemas/ids/1/schema'
```

### Verify behavior

Send a `PUT` request for a specific item.

```bash
curl -v \
    -X "PUT" "http://localhost:8080/items/5cf7a1d5-3772-49ef-86e7-ba6f2c7d7d07" \
    -H "Idempotency-Key: 1" \
    -H "Content-Type: application/json" \
    -H "Prefer: respond-async" \
    -d "{\"greeting\":\"Hello, world\"}"
```

### Verify behavior

Retrieve all the items

```bash
curl -v http://localhost:8080/items
```

### Teardown

The `teardown.sh` script stops port forwarding, uninstalls Zilla and Kafka and deletes the namespace.

```bash
./teardown.sh
```

output:

```text
+ pgrep kubectl
99998
99999
+ killall kubectl
+ helm uninstall zilla-http-kafka-schema-registry zilla-http-kafka-schema-registry-kafka --namespace zilla-http-kafka-schema-registry
release "zilla-http-kafka-schema-registry" uninstalled
release "zilla-http-kafka-schema-registry-kafka" uninstalled
+ kubectl delete namespace zilla-http-kafka-schema-registry
namespace "zilla-http-kafka-schema-registry" deleted
```
