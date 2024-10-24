# http.proxy

Listens on https port `7143` and will response back whatever is hosted in `nginx` on that path.

## Requirements

- Compose compatible host
- [nghttp2](https://nghttp2.org/)

### Install nghttp2 client

nghttp2 is an implementation of HTTP/2 client.

```bash
brew install nghttp2
```

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
nghttp -ansy https://localhost:7143/demo.html
```

output:

```text
***** Statistics *****

Request timing:
  responseEnd: the  time  when  last  byte of  response  was  received
               relative to connectEnd
 requestStart: the time  just before  first byte  of request  was sent
               relative  to connectEnd.   If  '*' is  shown, this  was
               pushed by server.
      process: responseEnd - requestStart
         code: HTTP status code
         size: number  of  bytes  received as  response  body  without
               inflation.
          URI: request URI

see http://www.w3.org/TR/resource-timing/#processing-model

sorted by 'complete'

id  responseEnd requestStart  process code size request path
 13   +921.19ms       +146us 921.05ms  200  320 /demo.html
  2   +923.02ms *  +912.81ms  10.21ms  200   89 /style.css
```

you get `/style.css` response as push promise that nginx is configured with.

## Teardown

The `teardown.sh` script will remove any resources created.

```bash
./teardown.sh
```

- alternatively with the docker compose command:

```bash
docker compose down --remove-orphans
```
