# http.filesystem

Listens on http port `7114` and serves files from the Zilla container's `/var/www` subdirectory.

## Requirements

- jq, nc
- Compose compatible host
- curl

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

```bash
curl http://localhost:7114/index.html
```

output:

```html
<html>
  <head>
    <title>Welcome to Zilla!</title>
  </head>
  <body>
    <h1>Welcome to Zilla!</h1>
  </body>
</html>
```

```bash
curl --cacert test-ca.crt http://localhost:7114/index.html
```

output:

```html
<html>
  <head>
    <title>Welcome to Zilla!</title>
  </head>
  <body>
    <h1>Welcome to Zilla!</h1>
  </body>
</html>
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
