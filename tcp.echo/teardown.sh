#!/bin/sh
set -e

docker compose -p "${NAMESPACE:-zilla-tcp-echo}" down --remove-orphans
