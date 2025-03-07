# mqtt.kafka.proxy

In this guide, you create Kafka topics and use Zilla to mediate MQTT broker messages onto those topics.

## Setup

The `setup.sh` script starts the docker compose stack defined in the [compose.yaml](compose.yaml) file.

- create an MQTT broker at `mqtt://localhost:7183`

```bash
./setup.sh
```

- alternatively with the docker compose command:

```bash
docker compose up -d
```

### Using this example

Using `mosquitto-cli` subscribe to the `zilla` topic.

```bash
docker compose -p zilla-mqtt-kafka-proxy exec -T mosquitto-cli \
mosquitto_sub --url mqtt://zilla:7183/zilla --debug
```

output:

```text
Client null sending CONNECT
Client null received CONNACK (0)
Client null sending SUBSCRIBE (Mid: 1, Topic: zilla, QoS: 0, Options: 0x00)
Client null received SUBACK
Subscribed (mid: 1): 0
Client null received PUBLISH (d0, q0, r0, m0, 'zilla', ... (12 bytes))
Hello Zilla!
```

In a separate session, publish a valid message on the `zilla` topic.

```bash
docker compose -p zilla-mqtt-kafka-proxy exec -T mosquitto-cli \
mosquitto_pub --url mqtt://zilla:7183/zilla --message 'Hello Zilla!' --debug
```

output:

```
Client null sending CONNECT
Client null received CONNACK (0)
Client null sending PUBLISH (d0, q0, r0, m1, 'zilla', ... (12 bytes))
Client null sending DISCONNECT
```

## Teardown

The `teardown.sh` script will remove any resources created.

```bash
./teardown.sh
```
