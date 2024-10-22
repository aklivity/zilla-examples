# http.json.validate

Listens on https port `7114` and will response back whatever is hosted in `nginx` on that path after enforcing validation.

### Requirements

- bash, jq, nc
- Kubernetes (e.g. Docker Desktop with Kubernetes enabled)
- kubectl
- helm 3.0+

### Setup

The `setup.sh` script:

- installs Zilla and Nginx to the Kubernetes cluster with helm and waits for the pods to start up
- copies the web contents to the Nginx pod
- starts port forwarding

```bash
./setup.sh
```

### Verify behavior for valid content

```bash
curl http://localhost:7114/valid.json
```

output:

```text
{
    "id": 42,
    "status": "Active"
}
```

### Verify behavior for invalid content

```bash
curl http://localhost:7114/invalid.json
```

output:

```text
curl: (18) transfer closed with 37 bytes remaining to read
```

### Teardown

The `teardown.sh` script stops port forwarding, uninstalls Zilla and Nginx and deletes the namespace.

```bash
./teardown.sh
```
