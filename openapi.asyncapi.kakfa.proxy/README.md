# openapi.asyncapi.kakfa.proxy

## Setup

The `setup.sh` script will install the Open Source Zilla image in a Compose stack along with any necessary services defined in the [compose.yaml](compose.yaml) file.

```bash
./setup.sh
```

- alternatively with the docker compose command:

```bash
docker compose up -d
```

### Test

#### Create Pet

```bash
curl 'http://localhost:7114/pets' \
     --header 'Content-Type: application/json' \
     --header 'Idempotency-Key: 1' \
     --data '{ "id": 1, "name": "Spike" }'
```

#### Retrieve Pets

```bash
curl 'http://localhost:7114/pets' --header 'Accept: application/json'
```

## Teardown

The `teardown.sh` script will remove any resources created.

```bash
./teardown.sh
```
