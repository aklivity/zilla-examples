# http.kafka.schema.inline

This simple http.kafka.schema.inline example illustrates how to configure inline schema in zilla to validate messages while produce and fetch to a Kafka topic.

### Requirements

- bash, jq, nc
- Kubernetes (e.g. Docker Desktop with Kubernetes enabled)
- kubectl
- helm 3.0+

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
+ helm install zilla-http-kafka-schema-inline oci://ghcr.io/aklivity/charts/zilla --version 0.9.46 --namespace zilla-http-kafka-schema-inline --create-namespace --wait --values values.yaml --set-file 'zilla\.yaml=zilla.yaml' --set-file 'secrets.tls.data.localhost\.p12=tls/localhost.p12'
Pulled: ghcr.io/aklivity/charts/zilla:0.9.46
Digest: sha256:4b0a63b076db9b53a9484889a11590b77f3184217c3d039973c532f25940adbc
NAME: zilla-http-kafka-schema-inline
[...]
Created topic items-snapshots.
+ kubectl port-forward --namespace zilla-http-kafka-schema-inline service/zilla-http-kafka-schema-inline 8080 9090
+ nc -z localhost 8080
+ kubectl port-forward --namespace zilla-http-kafka-schema-inline service/kafka 9092 29092
+ sleep 1
+ nc -z localhost 8080
Connection to localhost port 8080 [tcp/http-alt] succeeded!
+ nc -z localhost 9092
Connection to localhost port 9092 [tcp/XmlIpcRegSvc] succeeded!
```

### Verify behavior for a valid event

`POST` request

```bash
curl -k -v -X POST https://localhost:9090/items -H 'Idempotency-Key: 1'  -H 'Content-Type: application/json' -d '{"id": "123","status": "OK"}'
```

output:

```text
...
> POST /items HTTP/2
> Host: localhost:9090
> user-agent: curl/7.88.1
> accept: */*
> idempotency-key: 1
> content-type: application/json
> content-length: 28
>
* We are completely uploaded and fine
< HTTP/2 204
```

`GET` request to fetch specific item.

```bash
curl -k -v https://localhost:9090/items/1
```

output:

```text
...
* Connection state changed (MAX_CONCURRENT_STREAMS == 2147483647)!
< HTTP/2 200
< content-length: 28
< content-type: application/json
< etag: AQIAAg==
<
* Connection #0 to host localhost left intact
{"id": "123","status": "OK"}%
```

### Verify behavior for Invalid event

`POST` request.

```bash
curl -k -v -X POST https://localhost:9090/items -H 'Idempotency-Key: 2'  -H 'Content-Type: application/json' -d '{"id": 123,"status": "OK"}'
```

output:

```text
...
> POST /items HTTP/2
> Host: localhost:9090
> user-agent: curl/7.88.1
> accept: */*
> idempotency-key: 2
> content-type: application/json
> content-length: 26
>
* We are completely uploaded and fine
< HTTP/2 400
```

`GET` request to verify whether Invalid event is produced

```bash
curl -k -v https://localhost:9090/items/2
```

output:

```text
...
> GET /items/2 HTTP/2
> Host: localhost:9090
> user-agent: curl/7.88.1
> accept: */*
>
< HTTP/2 404
< content-length: 0
```

### Teardown

The `teardown.sh` script stops port forwarding, uninstalls Zilla and Kafka and deletes the namespace.

```bash
./teardown.sh
```

output:

```text
+ pgrep kubectl
96938
96939
+ killall kubectl
+ helm uninstall zilla-http-kafka-schema-inline zilla-http-kafka-schema-inline-kafka --namespace zilla-http-kafka-schema-inline
release "zilla-http-kafka-schema-inline" uninstalled
release "zilla-http-kafka-schema-inline-kafka" uninstalled
+ kubectl delete namespace zilla-http-kafka-schema-inline
namespace "zilla-http-kafka-schema-inline" deleted
```
