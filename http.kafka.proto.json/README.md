# http.kafka.proto.json

This example allows a protobuf object to be sent to a REST edpoint as JSON that gets validated and converted to the protobuf when it is produced onto Kafka.

## Setup

The `setup.sh` script will install the Open Source Zilla image in a Compose stack along with any necessary services defined in the [compose.yaml](compose.yaml) file.

```bash
./setup.sh
```

- alternatively with the docker compose command:

```bash
docker compose up -d
```

## Bug scenarios

Each of the below scenarios are run from a fresh install of zilla and kafka

### Sending invalid JSON breaks subsequent requests

1. `POST` a valid request getting a `204` back

```bash
curl --location 'http://localhost:7114/requests' \
--header 'Content-Type: application/json' \
--data '{
    "message": "hello world",
    "count": 10
}' -v
```

1. `POST` an invalid request getting a `400` back and logs `MODEL_PROTOBUF_VALIDATION_FAILED A message payload failed validation. Cannot find field: invalid in message Request.` to stdout

```bash
curl --location 'http://localhost:7114/requests' \
--header 'Content-Type: application/json' \
--data '{
    "message": "hello world",
    "count": 10,
    "invalid": "field"
}' -v
```

1. `POST` a valid request getting a `400` back and logs `MODEL_PROTOBUF_VALIDATION_FAILED A message payload failed validation. Field Request.message has already been set..` to stdout

```bash
curl --location 'http://localhost:7114/requests' \
--header 'Content-Type: application/json' \
--data '{
    "message": "hello world",
    "count": 10
}' -v
```

### Sending an invalid `message` field

Sending an invalid `message` field causes subsequent requests to take ~10 min to get a `204` but the message doesn't show up onto kafka

1. `POST` a valid request getting a `204` back

```bash
curl --location 'http://localhost:7114/requests' \
--header 'Content-Type: application/json' \
--data '{
    "message": "hello message",
    "count": 10
}' -v
```

1. `POST` an invalid `"messages"` field request getting a `400` back and immediately post the correct payload after. Run both curl commands at the same time and sometimes the second one works and other times it will hang until it gets a `204` back after ~10min and the message is not on the Kafka topic

```bash
curl --location 'http://localhost:7114/requests' \
--header 'Content-Type: application/json' \
--data '{
    "messages": "hello messages",
    "count": 10
}' -v
curl --location 'http://localhost:7114/requests' \
--header 'Content-Type: application/json' \
--data '{
    "message": "hello messages",
    "count": 10
}' -v
```

## Teardown

```bash
./teardown.sh
```
