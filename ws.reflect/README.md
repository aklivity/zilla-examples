# ws.reflect

Listens on ws port `7114` and will echo back whatever is sent to the server, broadcasting to all clients.

## Requirements

- docker compose
- wscat

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
wscat -c ws://localhost:7114/ -s echo
```

Type a `Hello, one` message and press `enter`.

output:

```text
Connected (press CTRL+C to quit)
> Hello, one
< Hello, one
< Hello, two
```

```bash
wscat -c wss://localhost:7114/ --ca test-ca.crt -s echo
```

Type a `Hello, two` message and press `enter`.

output:

```text
Connected (press CTRL+C to quit)
< Hello, one
> Hello, two
< Hello, two
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
