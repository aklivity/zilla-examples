# zilla.quickstart

Listens on ws port `8080` and will echo back whatever is sent to the server.

## Requirements

- docker

## Setup

The `setup.sh` script:

- installs Zilla to the Kubernetes cluster with helm and waits for the pod to start up
- starts port forwarding

```bash
./setup.sh
```

## Teardown

The `teardown.sh` script stops port forwarding, uninstalls Zilla and deletes the namespace.

```bash
./teardown.sh
```



## Stuff i found 
  http_filesystem_proxy:
    type: http-filesystem
    kind: proxy
    routes:
      - when:
          - path: /
        with:
          path: index.html # if excluded doesn't throw an error
        exit: filesystem_server
  filesystem_server:
    type: filesystem
    kind: server
    options:
      location: /var/www/ # if specific file doesn't throw and error


 this thing:


  http_server:
    type: http
    kind: server
    routes:
      - when:
          - headers:
              :scheme: http
              :authority: localhost:8080
              :path: /api # adding this breaks the route
              content-type: application/json
        exit: http_kafka_proxy
  http_kafka_proxy:
    type: http-kafka
    kind: proxy
    routes:
      - when:
          - method: POST
            path: /api/events/{id}
        exit: kafka_cache_client
        with:
          capability: produce
          topic: events
          key: ${params.id}
      




## commands
curl -X POST http://localhost:8080/sse/event/1 -H 'Content-Type: application/json' -d '{"greeting":"Hello, world"}'


docker run -it --rm \
    --network zilla-network \
    bitnami/kafka:latest kafka-topics.sh --list  --bootstrap-server kafka:29092
