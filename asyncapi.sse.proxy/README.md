# asyncapi.sse.proxy

Listens on http port `7114` and will stream back whatever is published to `sse_server` on tcp port `7001`.

## Requirements

- nc
- Compose compatible host

## Setup

The `setup.sh` script starts the docker compose stack defined in the [compose.yaml](compose.yaml) file.

```bash
./setup.sh
```

- alternatively with the docker compose command:

```bash
docker compose up -d
```

### Verify behavior

Connect `curl` client first to Zilla over SSE.

```bash
curl -N --http2 -H "Accept:text/event-stream" -v "http://localhost:7114/events/1"
```

output:

```text
*   Trying 127.0.0.1:7114...
* Connected to localhost (127.0.0.1) port 7114 (#0)
> GET /events/1 HTTP/1.1
> Host: localhost:7114
> User-Agent: curl/7.88.1
> Connection: Upgrade, HTTP2-Settings
> Upgrade: h2c
> HTTP2-Settings: AAMAAABkAAQCAAAAAAIAAAAA
> Accept:text/event-stream
>
< HTTP/1.1 200 OK
< Content-Type: text/event-stream
< Transfer-Encoding: chunked
< Access-Control-Allow-Origin: *
<
event:event name
data:{ "id": 1, "name": "Hello World!" }
```

From another terminal send an invalid data from `nc` client. Note that the invalid event will not arrive to the client.

```bash
echo '{ "name": "event name", "data": { "id": -1, "name": "Hello World!" } }' | nc -c localhost 7001
```

Now send a valid event, where the id is non-negative and the message will arrive to `curl` client.

```bash
echo '{ "name": "event name", "data": { "id": 1, "name": "Hello World!" } }' | nc -c localhost 7001
```

## Teardown

The `teardown.sh` script will remove any resources created.

```bash
./teardown.sh
```

- alternatively with the docker compose command:

```bash
docker compose down --remove-orphans
```
