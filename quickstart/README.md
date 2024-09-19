# quickstart

Follow the [Zilla Quickstart](https://docs.aklivity.io/zilla/latest/how-tos/quickstart/) to discover some of what Zilla can do!

## Running locally

This quickstart runs using Docker compose.

### Setup

The `setup.sh` script will:

- Configured Zilla instance with REST, SSE, gRPC, MQTT protocols configured
- Create Kafka topics
- Start a gRPC Route Guide server
- Start a MQTT message simulator

- Setup with a bitnami Kafka cluster

    ```bash
    ./setup.sh
    ```

- Setup with a Redpanda cluster

    ```bash
    KAFKA_VENDOR_PROFILE=redpanda ./setup.sh
    ```

- alternatively with the plain docker compose command respectively

    ```bash
    docker compose --profile bitnami --profile init-bitnami up -d
    ```

    ```bash
    docker compose --profile redpanda --profile init-redpanda up -d
    ```

### Using this quickstart

You can interact with this quickstart using our [Postman collection](https://www.postman.com/aklivity-zilla/workspace/aklivity-zilla-quickstart/overview)

### Teardown

The `teardown.sh` script will remove any resources created.

```bash
./teardown.sh
```
