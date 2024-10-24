# mqtt.kafka.broker

This is the resource folder for the running the [MQTT Kafka broker guide](https://docs.aklivity.io/zilla/latest/how-tos/mqtt/mqtt.kafka.broker.html) found on our docs.

## Setup

The `setup.sh` script will install the Open Source Zilla image in a Compose stack along with any necessary services defined in the [compose.yaml](compose.yaml) file.

- create an MQTT broker at `mqtt://localhost:7183`

```bash
./setup.sh
```

- alternatively with the docker compose command:

```bash
docker compose up -d
```

### Using this example

Follow the steps on our [MQTT Kafka broker guide](https://docs.aklivity.io/zilla/latest/how-tos/mqtt/mqtt.kafka.broker.html#send-a-greeting)

## Teardown

The `teardown.sh` script will remove any resources created.

```bash
./teardown.sh
```
