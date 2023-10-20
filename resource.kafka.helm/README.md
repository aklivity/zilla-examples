# resource.kafka.helm

## Requirements

- helm 3.0+
- Kubernetes
- kubectl

## Setup

The `setup.sh` script:

- creates an instance of `docker.io/bitnami/kafka`
- creates an instance of `docker.io/provectuslabs/kafka-ui`

```bash
./setup.sh
```

## Teardown

The `teardown.sh` script stops running containers and removes orphans.

```bash
./teardown.sh
```
