# grpc.proxy

Listens on https port `7151` and will echo back whatever is published to `grpc-echo` on tcp port `50051`.

## Requirements

- Compose compatible host
- [grpcurl](https://github.com/fullstorydev/grpcurl)

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

#### Unary Stream

Echo `{"message":"Hello World"}` message via unary rpc.

```bash
grpcurl -insecure -proto echo.proto  -d '{"message":"Hello World"}' localhost:7153 grpc.examples.echo.Echo.UnaryEcho
```

output:

```json
{
  "message": "Hello World"
}
```

#### Bidirectional streaming

Echo messages via bidirectional streaming rpc.

```bash
grpcurl -insecure -proto echo.proto -d @ localhost:7153 grpc.examples.echo.Echo.BidirectionalStreamingEcho
```

Paste below message.

```json
{
  "message": "Hello World"
}
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
