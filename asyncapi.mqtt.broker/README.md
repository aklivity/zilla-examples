# asyncapi.mqtt.broker

## Running locally

This example runs using Docker compose. You will find the setup scripts in the [compose](./docker/compose) folder.

### Setup

The `setup.sh` script will:

- Configured Zilla instance
- Start kafka
- Create Kafka topics
- Start a MQTT message simulator

```bash
./compose/setup.sh
```

### Subscribe

Subscribe to the sensor data:

```
docker run -it --rm eclipse-mosquitto \
mosquitto_sub --url mqtt://host.docker.internal:7183/sensors/#
```

### Teardown

The `teardown.sh` script will remove any resources created.

```bash
./compose/teardown.sh
```
