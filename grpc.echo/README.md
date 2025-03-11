# grpc.echo

Listens on tcp port `7151` and will echo grpc message sent by client.

## Requirements

- docker compose
- [grpcurl](https://github.com/fullstorydev/grpcurl)
- [ghz](https://ghz.sh/docs/install)

## Setup

To `start` the Docker Compose stack defined in the [compose.yaml](compose.yaml) file, use:

```bash
docker compose up -d
```

### Verify behavior

#### Unary Stream

Echo `{"message":"Hello World"}` message via unary rpc using `grpcurl` command.

```bash
grpcurl -plaintext -proto echo.proto -d '{"message":"Hello World"}' \
    localhost:7151 example.EchoService.EchoUnary
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
grpcurl -plaintext -proto echo.proto -d @ \
    localhost:7151 example.EchoService.EchoBidiStream
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

To remove any resources created by the Docker Compose stack, use:

```bash
docker compose down
```

- alternatively with the docker compose command:

```bash
docker compose down --remove-orphans
```
