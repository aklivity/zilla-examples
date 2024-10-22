# grpc.echo

Listens on tcp port `7151` and will echo grpc message sent by client.

## Requirements

- jq, nc, grpcurl
- Compose compatible host
- [ghz](https://ghz.sh/docs/install)

## Setup

The `setup.sh` script will install the Open Source Zilla image in a Compose stack along with any necessary services defined in the [compose.yaml](compose.yaml) file.

```bash
./setup.sh
```

- alternatively with the docker compose command:

```bash
docker compose up -d
```

### Verify behavior

#### Unary Stream

Echo `{"message":"Hello World"}` message via unary rpc using `grpcurl` command.

```bash
grpcurl -insecure -proto echo.proto  -d '{"message":"Hello World"}' localhost:7151 example.EchoService.EchoUnary
```

output:

```json
{
  "message": "Hello World"
}
```

#### Bidirectional Stream

Echo messages via bidirectional streaming rpc.

```bash
grpcurl -insecure -proto echo.proto -d @ localhost:7151 example.EchoService.EchoBidiStream
```

Paste below message.

```json
{
  "message": "Hello World"
}
```

### Bench

```bash
ghz --config bench.json \
    --proto echo.proto \
    --call example.EchoService/EchoBidiStream \
    localhost:7151
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
