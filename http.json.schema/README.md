# http.json.schema

Listens on https port `7114` and will response back whatever is hosted in `nginx` on that path after enforcing validation.

## Requirements

- Compose compatible host

## Setup

The `setup.sh` script will install the Open Source Zilla image in a Compose stack along with any necessary services defined in the [compose.yaml](compose.yaml) file.

```bash
./setup.sh
```

- alternatively with the docker compose command:

```bash
docker compose up -d
```

### Verify behavior for valid content

```bash
curl http://localhost:7114/valid.json
```

output:

```text
{
    "id": 42,
    "status": "Active"
}
```

### Verify behavior for invalid content

```bash
curl http://localhost:7114/invalid.json
```

output:

```text
curl: (18) transfer closed with 37 bytes remaining to read
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
