# asyncapi.openapi.petstore

## Running locally

This example runs using Docker compose. You will find the setup scripts in the [compose](./docker/compose) folder.

### Setup

The `setup.sh` script will:

- Configured Zilla instance
- Start kafka
- Create Kafka topics

```bash
./compose/setup.sh
```

### Use the API

Use the `asyncapi.openapi.petstore/openapi.yaml` OpenAPI spec in an API tool. ex. [swagger](https://editor.swagger.io/) or [postman](https://learning.postman.com/docs/getting-started/importing-and-exporting/importing-and-exporting-overview/)

### Teardown

The `teardown.sh` script will remove any resources created.

```bash
./compose/teardown.sh
```
