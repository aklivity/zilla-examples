# quickstart

Creates a full featured instance of Zilla on port `7114`. Follow the [Zilla Quickstart](https://docs.aklivity.io/zilla/latest/quickstart) to discover some of what Zilla can do!

## Requirements

- docker

## Setup

The `setup.sh` script:

- creates a Zilla instance running in docker.
- creates an instance of `docker.io/bitnami/kafka`
- adds the necessary topics
- hosts a `provectuslabs/kafka-ui` [instance](http://localhost:80)
- starts the route_guide_server and route_guide_client from the [gRPC basics tutorial](https://grpc.io/docs/languages/go/basics/)
- hosts [prometheus metrics](http://localhost:7190/metrics)

```bash
./setup.sh
```

## Teardown

The `teardown.sh` script stops running containers and removes orphans.

```bash
./teardown.sh
```

mqtt connection over ws

2023-09-15 12:32:45 started
2023-09-15 12:32:49 org.agrona.concurrent.AgentTerminationException: java.lang.IllegalArgumentException: invalid length: -1463812099
2023-09-15 12:32:49     at io.aklivity.zilla.runtime.engine/io.aklivity.zilla.runtime.engine.internal.registry.DispatchAgent.doWork(DispatchAgent.java:681)
2023-09-15 12:32:49     at org.agrona.core/org.agrona.concurrent.AgentRunner.doDutyCycle(AgentRunner.java:291)
2023-09-15 12:32:49     at org.agrona.core/org.agrona.concurrent.AgentRunner.run(AgentRunner.java:164)
2023-09-15 12:32:49     at java.base/java.lang.Thread.run(Thread.java:1623)
2023-09-15 12:32:49 Caused by: java.lang.IllegalArgumentException: invalid length: -1463812099
2023-09-15 12:32:49     at org.agrona.core/org.agrona.concurrent.UnsafeBuffer.boundsCheckWrap(UnsafeBuffer.java:1669)
2023-09-15 12:32:49     at org.agrona.core/org.agrona.concurrent.UnsafeBuffer.wrap(UnsafeBuffer.java:246)
2023-09-15 12:32:49     at io.aklivity.zilla.runtime.binding.ws/io.aklivity.zilla.runtime.binding.ws.internal.types.Array32FW.wrap(Array32FW.java:117)
2023-09-15 12:32:49     at io.aklivity.zilla.runtime.binding.ws/io.aklivity.zilla.runtime.binding.ws.internal.types.stream.HttpBeginExFW.wrap(HttpBeginExFW.java:32)
2023-09-15 12:32:49     at io.aklivity.zilla.runtime.binding.ws/io.aklivity.zilla.runtime.binding.ws.internal.types.OctetsFW.get(OctetsFW.java:15)
2023-09-15 12:32:49     at io.aklivity.zilla.runtime.binding.ws/io.aklivity.zilla.runtime.binding.ws.internal.stream.WsServerFactory.newStream(WsServerFactory.java:176)
2023-09-15 12:32:49     at io.aklivity.zilla.runtime.engine/io.aklivity.zilla.runtime.engine.internal.registry.DispatchAgent.handleBeginInitial(DispatchAgent.java:1350)
2023-09-15 12:32:49     at io.aklivity.zilla.runtime.engine/io.aklivity.zilla.runtime.engine.internal.registry.DispatchAgent.handleDefaultReadInitial(DispatchAgent.java:1118)
2023-09-15 12:32:49     at io.aklivity.zilla.runtime.engine/io.aklivity.zilla.runtime.engine.internal.registry.DispatchAgent.handleReadInitial(DispatchAgent.java:1058)
2023-09-15 12:32:49     at io.aklivity.zilla.runtime.engine/io.aklivity.zilla.runtime.engine.internal.registry.DispatchAgent.handleRead(DispatchAgent.java:1005)
2023-09-15 12:32:49     at io.aklivity.zilla.runtime.engine/io.aklivity.zilla.runtime.engine.internal.concurent.ManyToOneRingBuffer.read(ManyToOneRingBuffer.java:181)
2023-09-15 12:32:49     at io.aklivity.zilla.runtime.engine/io.aklivity.zilla.runtime.engine.internal.registry.DispatchAgent.doWork(DispatchAgent.java:675)
2023-09-15 12:32:49     ... 3 more
2023-09-15 12:32:49 stopped
2023-09-15 12:32:49     Suppressed: java.lang.Exception: [engine/data#3]        [0x03030000000001a1] streams=[consumeAt=0x00037c50 (0x0000000000037c50), produceAt=0x00037c50 (0x0000000000037c50)]
2023-09-15 12:32:49             at io.aklivity.zilla.runtime.engine/io.aklivity.zilla.runtime.engine.internal.registry.DispatchAgent.doWork(DispatchAgent.java:679)
2023-09-15 12:32:49             ... 3 more
