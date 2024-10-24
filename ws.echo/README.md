# ws.echo

Listens on ws port `7114` and will echo back whatever is sent to the server.
Listens on wss port `7114` and will echo back whatever is sent to the server.

## Requirements

- jq, nc
- Compose compatible host
- wscat

## Setup

The `setup.sh` script will install the Open Source Zilla image in a Compose stack along with any necessary services defined in the [compose.yaml](compose.yaml) file.

```bash
./setup.sh
```

- alternatively with the docker compose command:

```bash
docker compose up -d
```

### Install wscat

```bash
npm install wscat -g
```

### Verify behavior

```bash
wscat -c ws://localhost:7114/ -s echo
```

Type a `Hello, world` message and press `enter`.

output:

```text
Connected (press CTRL+C to quit)
> Hello, world
< Hello, world
```

```bash
wscat -c wss://localhost:7114/ --ca test-ca.crt -s echo
```

Type a `Hello, world` message and press `enter`.

output:

```text
Connected (press CTRL+C to quit)
> Hello, world
< Hello, world
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
