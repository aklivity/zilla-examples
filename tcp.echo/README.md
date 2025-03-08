# tcp.echo

Listens on tcp port `12345` and will echo back whatever is sent to the server.

## Requirements

- nc
- docker compose

## Setup

The `setup.sh` script starts the docker compose stack defined in the [compose.yaml](compose.yaml) file.

```bash
./setup.sh
```

- alternatively with the docker compose command:

```bash
docker compose up -d
```

### Verify behavior

```bash
nc localhost 12345
```

Type a `Hello, world` message and press `enter`.

output:

```text
Hello, world
Hello, world
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
