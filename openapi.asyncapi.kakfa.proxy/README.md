# openapi.asyncapi.proxy

## Setup

The `setup.sh` script will:

- Configure Zilla instance

```bash
./compose/setup.sh
```

### Test

#### Create Pet

```bash
curl -X POST --location 'http://localhost:7114/pets' \
     --header 'Content-Type: application/json' \
     --header 'Idempotency-Key: 1' \
     --data '{ "id": 1, "name": "Spike" }'
```

#### Retrieve Pets

```bash
curl --location 'http://localhost:7114/pets' --header 'Accept: application/json'
```

### Teardown

The `teardown.sh` script will remove any resources created.

```bash
./compose/teardown.sh
```
