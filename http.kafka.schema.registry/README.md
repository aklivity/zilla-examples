# http.kafka.schema.registry

This simple http.kafka.schema.registry example illustrates how to configure Karapace Schema Registry in zilla to validate messages while produce and fetch to a Kafka topic.

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
curl 'http://localhost:8081/subjects/items-snapshots-value/versions' \
--header 'Content-Type: application/json' \
--data '{
  "schema":
    "{\"fields\":[{\"name\":\"id\",\"type\":\"string\"},{\"name\":\"status\",\"type\":\"string\"}],\"name\":\"Event\",\"namespace\":\"io.aklivity.example\",\"type\":\"record\"}",
  "schemaType": "AVRO"
}'
```

output:

```text
{"id":1}%
```

### Validate created Schema

```bash
curl 'http://localhost:8081/schemas/ids/1'
```

```bash
curl 'http://localhost:8081/subjects/items-snapshots-value/versions/latest'
```

### Verify behavior for a valid event

Send a `PUT` request for a specific item.

```bash
curl -v \
    -X "POST" "http://localhost:8080/items" \
    -H "Idempotency-Key: 1" \
    -H "Content-Type: avro/binary" \
    --data-binary "@avro/data.avro"
```

output:

```text
...
> POST /items HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.88.1
> Accept: */*
> Idempotency-Key: 1
> Content-Type: avro/binary
> Content-Length: 13
>
< HTTP/1.1 204 No Content
```

`GET` request to fetch specific item.

```bash
curl -k -v https://localhost:9090/items/1
```

output:

```text
...
< HTTP/1.1 200 OK
< Content-Length: 13
< Content-Type: avro/binary
< Etag: AQIABA==
<
* Connection #0 to host localhost left intact
id0positive
```

### Verify behavior for Invalid event

`POST` request.

```bash
curl -v \
    -X "POST" "http://localhost:8080/items" \
    -H "Idempotency-Key: 2" \
    -H "Content-Type: avro/binary" \
    --data-binary "@avro/invalid_data.avro"
```

output:

```text
...
> POST /items HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.88.1
> Accept: */*
> Idempotency-Key: 2
> Content-Type: avro/binary
> Content-Length: 4
>
< HTTP/1.1 400 Bad Request
< Transfer-Encoding: chunked
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
99998
99999
+ killall kubectl
+ helm uninstall zilla-http-kafka-schema-registry zilla-http-kafka-schema-registry-kafka --namespace zilla-http-kafka-schema-registry
release "zilla-http-kafka-schema-registry" uninstalled
release "zilla-http-kafka-schema-registry-kafka" uninstalled
+ kubectl delete namespace zilla-http-kafka-schema-registry
namespace "zilla-http-kafka-schema-registry" deleted
```
