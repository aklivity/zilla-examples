# asyncapi.mqtt.proxy

Listens on mqtt port `7183` and will forward mqtt publish messages and proxies subscribes to mosquitto MQTT broker listening on `1883` for topic `smartylighting/streetlights/1/0/event/+/lighting/measured`.

## Requirements

- Compose compatible host
- mosquitto

## Setup

The `setup.sh` script will install the Open Source Zilla image in a Compose stack along with any necessary services defined in the [compose.yaml](compose.yaml) file.

```bash
./setup.sh
```

- alternatively with the docker compose command:

```bash
docker compose up -d
```

### Verify behavior

Connect a subscribing client to mosquitto broker to port `1883`. Using mosquitto_pub client publish `{"id":"1","status":"on"}` to Zilla on port `7183`. Verify that the message arrived to on the first client.

```bash
docker compose -p zilla-asyncapi-mqtt-proxy exec -T mosquitto-cli \
mosquitto_sub --url mqtt://zilla:7183/smartylighting/streetlights/1/0/event/+/lighting/measured --debug
```

output:

```
Client null sending CONNECT
Client auto-5A1C0A41-0D16-497D-6C3B-527A93E421E6 received CONNACK (0)
Client auto-5A1C0A41-0D16-497D-6C3B-527A93E421E6 sending SUBSCRIBE (Mid: 1, Topic: smartylighting/streetlights/1/0/event/+/lighting/measured, QoS: 0, Options: 0x00)
Client auto-5A1C0A41-0D16-497D-6C3B-527A93E421E6 received SUBACK
Subscribed (mid: 1): 0
{"id":"1","status":"on"}
```

```bash
docker compose -p zilla-asyncapi-mqtt-proxy exec -T mosquitto-cli \
mosquitto_pub --url mqtt://zilla:7183/smartylighting/streetlights/1/0/event/1/lighting/measured --message '{"id":"1","status":"on"}' --debug
```

output:

```
Client null sending CONNECT
Client 244684c7-fbaf-4e08-b382-a1a2329cf9ec received CONNACK (0)
Client 244684c7-fbaf-4e08-b382-a1a2329cf9ec sending PUBLISH (d0, q0, r0, m1, 'smartylighting/streetlights/1/0/event/1/lighting/measured', ... (24 bytes))
Client 244684c7-fbaf-4e08-b382-a1a2329cf9ec sending DISCONNECT
```

Now attempt to publish an invalid message, with property `stat` instead of `status`.

```bash
docker compose -p zilla-asyncapi-mqtt-proxy exec -T mosquitto-cli \
mosquitto_pub --url mqtt://zilla:7183/smartylighting/streetlights/1/0/event/1/lighting/measured --message '{"id":"1","stat":"off"}' --repeat 2 --repeat-delay 3 --debug
```

output:

```
Client null sending CONNECT
Client e7e9ddb0-f8c9-43a0-840f-dab9981a9de3 received CONNACK (0)
Client e7e9ddb0-f8c9-43a0-840f-dab9981a9de3 sending PUBLISH (d0, q0, r0, m1, 'smartylighting/streetlights/1/0/event/1/lighting/measured', ... (23 bytes))
Received DISCONNECT (153)
Error: The client is not currently connected.
```

Note that the invalid message is rejected with error code `153` `payload format invalid`, and therefore not received by the subscriber.

## Teardown

The `teardown.sh` script stops the compose stack.

```bash
./teardown.sh
```
