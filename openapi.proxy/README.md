# openapi.proxy

This example demonstrates creating an HTTP request proxy where the available endpoints are defined in an OpenAPI schema [petstore-openapi.yaml](./petstore-openapi.yaml).

## Setup

The `setup.sh` script starts the docker compose stack defined in the [compose.yaml](compose.yaml) file.

```bash
./setup.sh
```

- alternatively with the docker compose command:

```bash
docker compose up -d
```

## Test

```bash
curl 'http://localhost:7114/pets' --header 'Accept: application/json'
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
