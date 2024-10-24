# openapi.proxy

This example demonstrates creating an HTTP request proxy where the available endpoints are defined in an OpenAPI schema [petstore-openapi.yaml](./petstore-openapi.yaml).

## Setup

The `setup.sh` script will install the Open Source Zilla image in a Compose stack along with any necessary services defined in the [compose.yaml](compose.yaml) file.

```bash
./setup.sh
```

- alternatively with the docker compose command:

```bash
docker compose up -d
```

## Test

```bash
curl --location 'http://localhost:7114/pets' --header 'Accept: application/json'
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
