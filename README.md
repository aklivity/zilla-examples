# Zilla Examples

[![Slack Community][community-image]][community-join]

This repo contains a collection of [example folders](#examples) that can be used individually to demonstrate a some of Zilla's features. If this is your first step on your journey with Zilla we would encourage you to try our [Quickstart](https://docs.aklivity.io/zilla/latest/tutorials/quickstart/kafka-proxies.html).

## Prerequisites

[![Docker]][compose-install][![Kubernetes]][kubernetes-install][![Kafka]][kafka-install][![Postman]][postman-url]

You will need an environment with [Compose][compose-install] or [Helm][helm-install] and [Kubernetes][kubernetes-install] installed. Check out our [Postman collections][postman-url] for more ways to interact with an example.


## Getting Started

The `startup.sh` script is meant to help setup and teardown the necessary components for each of the examples. Using it is the easiest way to interact with each example.

Usage:

```text
startup.sh [ EXAMPLE_FOLDER ] [ -h --kafka-host KAFKA_HOST ] [ -p --kafka-port KAFKA_PORT ] [ -d --workdir WORKDIR] [ -v --version VERSION] [ -k --k8s ] [ -m --use-main ] [ --no-kafka] [ --auto-teardown]
```

Install and run any of the examples using this script:

```bash
./startup.sh -m <example.name>
```

You can specify your own `KAFKA_HOST` and `KAFKA_PORT` or the `WORKDIR` where you want the examples to be downloaded.

```bash
./startup.sh -m <example.name> -h $KAFKA_HOST -p $KAFKA_PORT -d /tmp
```

Alternatively, you can run this script the same way without downloading the repository.

```bash
wget -qO- https://raw.githubusercontent.com/aklivity/zilla-examples/main/startup.sh | sh -s -- -m <example.name>
```

![demo](.assets/demo.gif)

## Examples

| Name                                                               | Description                                                                                         |
| ------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------- |
| [tcp.echo](tcp.echo)                                               | Echoes bytes sent to the TCP server                                                                 |
| [tcp.reflect](tcp.reflect)                                         | Echoes bytes sent to the TCP server, broadcasting to all TCP clients                                |
| [tls.echo](tls.echo)                                               | Echoes encrypted bytes sent to the TLS server                                                       |
| [tls.reflect](tls.reflect)                                         | Echoes encrypted bytes sent to the TLS server, broadcasting to all TLS clients                      |
| [http.filesystem](http.filesystem)                                 | Serves files from a directory on the local filesystem                                               |
| [http.filesystem.config.server](.http.filesystem.config.server)    | Serves files from a directory on the local filesystem, getting the config from a http server        |
| [http.echo](http.echo)                                             | Echoes request sent to the HTTP server from an HTTP client                                          |
| [http.echo.jwt](http.echo.jwt)                                     | Echoes request sent to the HTTP server from a JWT-authorized HTTP client                            |
| [http.proxy](http.proxy)                                           | Proxy request sent to the HTTP server from an HTTP client                                           |
| [http.kafka.sync](http.kafka.sync)                                 | Correlates HTTP requests and responses over separate Kafka topics                                   |
| [http.kafka.async](http.kafka.async)                               | Correlates HTTP requests and responses over separate Kafka topics, asynchronously                   |
| [http.kafka.cache](http.kafka.cache)                               | Serves cached responses from a Kafka topic, detect when updated                                     |
| [http.kafka.oneway](http.kafka.oneway)                             | Sends messages to a Kafka topic, fire-and-forget                                                    |
| [http.kafka.crud](http.kafka.crud)                                 | Exposes a REST API with CRUD operations where a log-compacted Kafka topic acts as a table           |
| [http.kafka.sasl.scram](http.kafka.sasl.scram)                     | Sends messages to a SASL/SCRAM enabled Kafka                                                        |
| [http.redpanda.sasl.scram](http.redpanda.sasl.scram)               | Sends messages to a SASL/SCRAM enabled Redpanda Cluster                                             |
| [kubernetes.prometheus.autoscale](kubernetes.prometheus.autoscale) | Demo Kubernetes Horizontal Pod Autoscaling feature based a on a custom metric with Prometheus       |
| [grpc.echo](grpc.echo)                                             | Echoes messages sent to the gRPC server from a gRPC client                                          |
| [grpc.kafka.echo](grpc.kafka.echo)                                 | Echoes messages sent to a Kafka topic via gRPC from a gRPC client                                   |
| [grpc.kafka.fanout](grpc.kafka.fanout)                             | Streams messages published to a Kafka topic, applying conflation based on log compaction            |
| [grpc.kafka.proxy](grpc.kafka.proxy)                               | Correlates gRPC requests and responses over separate Kafka topics                                   |
| [grpc.proxy](grpc.proxy)                                           | Proxies gRPC requests and responses sent to the gRPC server from a gRPC client                      |
| [amqp.reflect](amqp.reflect)                                       | Echoes messages published to the AMQP server, broadcasting to all receiving AMQP clients            |
| [mqtt.kafka.broker](mqtt.kafka.broker)                             | Forwards MQTT publish messages to Kafka, broadcasting to all subscribed MQTT clients                |
| [mqtt.kafka.broker.jwt](mqtt.kafka.broker.jwt)                     | Forwards MQTT publish messages to Kafka, broadcasting to all subscribed JWT-authorized MQTT clients |
| [mqtt.proxy.asyncapi](mqtt.proxy.asyncapi)                         | Forwards validated MQTT publish messages and proxies subscribes to an MQTT broker                   |
| [quickstart](quickstart)                                           | Starts endpoints for all protocols (HTTP, SSE, gRPC, MQTT)                                          |
| [sse.kafka.fanout](sse.kafka.fanout)                               | Streams messages published to a Kafka topic, applying conflation based on log compaction            |
| [sse.proxy.jwt](sse.proxy.jwt)                                     | Proxies messages delivered by the SSE server, enforcing streaming security constraints              |
| [ws.echo](ws.echo)                                                 | Echoes messages sent to the WebSocket server                                                        |
| [ws.reflect](ws.reflect)                                           | Echoes messages sent to the WebSocket server, broadcasting to all WebSocket clients                 |

Read the [docs][zilla-docs].
Try the [examples][zilla-examples].
Join the [Slack community][community-join].

[community-image]: https://img.shields.io/badge/slack-@aklivitycommunity-blue.svg?logo=slack
[community-join]: https://join.slack.com/t/aklivitycommunity/shared_invite/zt-sy06wvr9-u6cPmBNQplX5wVfd9l2oIQ
[Docker]: https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white
[Kubernetes]: https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white
[Kafka]: https://img.shields.io/badge/Apache%20Kafka-000?style=for-the-badge&logo=apachekafka
[Postman]: https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white
[zilla-docs]: https://docs.aklivity.io/zilla
[zilla-examples]: https://github.com/aklivity/zilla-examples
[compose-install]: https://docs.docker.com/compose/gettingstarted/
[helm-install]: https://helm.sh/docs/intro/install/
[kubernetes-install]: https://kubernetes.io/docs/tasks/tools/
[kafka-install]: https://kafka.apache.org/
[postman-url]: https://www.postman.com/aklivity-zilla/

### testing

for d in */ ; do
    ./startup.sh $d --auto-teardown >> /tmp/test-zilla.log
done

for d in */ ; do
    echo $d
done

- [x] grpc.kafka.fanout
- [x] grpc.kafka.proxy
- [ ] grpc.proxy
http.filesystem.config.server
http.proxy
kubernetes.prometheus.autoscale
mqtt.proxy.asyncapi
sse.proxy.jwt
