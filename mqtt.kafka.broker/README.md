# mqtt.kafka.broker

This is the resource folder for the running the [MQTT Kafka broker guide](https://docs.aklivity.io/zilla/latest/how-tos/mqtt/mqtt.kafka.broker.html) found on our docs.

## Setup

The `setup.sh` script will:

- create the necessary kafka topics
- create an MQTT broker at `mqtt://localhost:7183`

```bash
./setup.sh
```

### Using this example

Follow the steps on our [MQTT Kafka broker guide](https://docs.aklivity.io/zilla/latest/how-tos/mqtt/mqtt.kafka.broker.html#send-a-greeting)

### Teardown

The `teardown.sh` script will remove any resources created.

```bash
./teardown.sh
```
