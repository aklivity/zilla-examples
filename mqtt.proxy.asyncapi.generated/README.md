# mqtt.proxy.asyncapi.generated

Listens on mqtt port `7183` and will forward mqtt publish messages and proxies subscribes to mosquitto MQTT broker listening on `1883` for topic `smartylighting/streetlights/1/0/event/+/lighting/measured`.

Note that the `zilla.yaml` config used by the proxy was generated based on `asyncapi.yaml`.

For example:

```bash
cat streetlights-mqtt-asyncapi.yaml | \
  docker run --rm -e ZILLA_INCUBATOR_ENABLED='true' -i ghcr.io/aklivity/zilla \
    generate --template asyncapi.mqtt.proxy --input /dev/stdin --output /dev/stdout | \
  tee zilla.yaml
```

## Requirements

- bash, jq, nc
- Docker
- Kubernetes (e.g. Docker Desktop with Kubernetes enabled)
- kubectl
- helm 3.0+
- mosquitto
- kcat

## Setup

The `setup.sh` script:

- installs Zilla to the Kubernetes cluster with helm and waits for the pod to start up
- installs mosquitto MQTT broker to the Kubernetes cluster with helm and waits for the pod to start up
- starts port forwarding

```bash
./setup.sh
```

```text
Connection to localhost port 7183 [tcp/ibm-mqisdp] succeeded!
Connection to localhost port 1883 [tcp/idmaps] succeeded!
```

### Install mqtt client

Requires MQTT 5.0 client, such as Mosquitto clients.

```bash
brew install mosquitto
```

### Verify behavior

Connect a subscribing client to mosquitto broker to port `1883`. Using mosquitto_pub client publish `{"id":"1","status":"on"}` to Zilla on port `7183`. Verify that the message arrived to on the first client.
```bash
docker run -it --rm eclipse-mosquitto \
mosquitto_sub --url mqtt://host.docker.internal:7183/'smartylighting/streetlights/1/0/event/+/lighting/measured'
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
docker run -it --rm eclipse-mosquitto \
mosquitto_pub --url mqtt://host.docker.internal:7183/'smartylighting/streetlights/1/0/event/1/lighting/measured' -d \
  -m '{"id":"1","status":"on"}'
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
docker run -it --rm eclipse-mosquitto \
mosquitto_pub --url mqtt://host.docker.internal:7183/'smartylighting/streetlights/1/0/event/1/lighting/measured' -d \
  -m '{"id":"1","stat":"off"}' --repeat 2 --repeat-delay 3
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

### Teardown

The `teardown.sh` script stops port forwarding, uninstalls Zilla and mosquitto broker and deletes the namespace.

```bash
./teardown.sh

```

output:

```text
namespace "mqtt-proxy-asyncapi-generated" deleted
```
