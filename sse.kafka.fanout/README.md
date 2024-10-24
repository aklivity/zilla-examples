# sse.kafka.fanout

Listens on http port `7114` or https port `7114` and will stream back whatever is published to the `events` topic in Kafka.

## Requirements

- jq, nc
- Compose compatible host
- sse-cat

### Install sse-cat client

Requires Server-Sent Events client, such as `sse-cat` version `2.0.5` or higher on `node` version `14` or higher.

```bash
npm install -g sse-cat
```

## Setup

The `setup.sh` script will install the Open Source Zilla image in a Compose stack along with any necessary services definined in the [compose.yaml](compose.yaml) file.

```bash
./setup.sh
```

- alternatively with the docker compose command:

```bash
docker compose up -d
```

### Verify behavior

Connect `sse-cat` client first, then send `Hello, world ...` from `kafkacat` producer client.
Note that the `Hello, world ...` message will not arrive until after using `kafkacat` to produce the `Hello, world ...` message in the next step.

```bash
sse-cat http://localhost:7114/events
```

output:

```text
Hello, world ...
```

```bash
echo "Hello, world `date`" | docker compose -p zilla-sse-kafka-fanout exec -T kafkacat \
  kafkacat -P -b kafka:29092 -t events -k 1
```

Note that only the latest messages with distinct keys are guaranteed to be retained by a compacted Kafka topic, so use different values for `-k` above to retain more than one message in the `events` topic.

### Browser

Browse to `http://localhost7114/index.html` and make sure to visit the `localhost` site and trust the `localhost` certificate.

Click the `Go` button to attach the browser SSE event source to Kafka via Zilla.

All non-compacted messages with distinct keys in the `events` Kafka topic are replayed to the browser.

Open the browser developer tools console to see additional logging, such as the `open` event.

Additional messages produced to the `events` Kafka topic then arrive at the browser live.

### Reliability

Simulate connection loss by stopping the `zilla` service in the `docker` stack.

```bash
docker compose -p zilla-sse-kafka-fanout stop zilla
```

This causes errors to be logged in the browser console during repeated attempts to automatically reconnect.

Simulate connection recovery by starting the `zilla` service again.

```bash
docker compose -p zilla-sse-kafka-fanout start zilla
```

Any messages produced to the `events` Kafka topic while the browser was attempting to reconnect are now delivered immediately.

Additional messages produced to the `events` Kafka topic then arrive at the browser live.

## Teardown

The `teardown.sh` script will remove any resources created.

```bash
./teardown.sh
```

- alternatively with the docker compose command:

```bash
docker compose down --remove-orphans
```
