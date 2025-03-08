# tls.echo

Listens on tls port `23456` and will echo back whatever is sent to the server.

## Requirements

- docker compose
- openssl

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
openssl s_client -connect localhost:23456 -CAfile test-ca.crt -quiet -alpn echo
```

output:

```text
depth=1 C = US, ST = California, L = Palo Alto, O = Aklivity, OU = Development, CN = Test CA
verify return:1
depth=0 C = US, ST = California, L = Palo Alto, O = Aklivity, OU = Development, CN = localhost
verify return:1
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
