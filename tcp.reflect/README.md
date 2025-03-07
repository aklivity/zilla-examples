# tcp.reflect

Listens on tcp port `12345` and will echo back whatever is sent to the server, broadcasting to all clients.

## Requirements

- nc
- Compose compatible host

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

Connect each client first, then send `Hello, one` from first client, then send `Hello, two` from second client.

```bash
nc localhost 12345
```

Type a `Hello, one` message and press `enter`.

output:

```text
Hello, one
Hello, one
Hello, two
```

```bash
nc localhost 12345
```

Type a `Hello, two` message and press `enter`.

output:

```text
Hello, one
Hello, two
Hello, two
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
