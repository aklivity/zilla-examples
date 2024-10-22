#!/bin/sh
set -x

# GIVEN
ZILLA_PORT="7114"
KAFKA_BOOTSTRAP_SERVER="kafka:29092"
ITEM_ID="$(date +%s)"
GREETING="Hello, World! $ITEM_ID"
GREETING_DATE="Hello, World! $(date)"
EXPECTED="{\"greeting\":\"$GREETING_DATE\"}"
EXIT=0

echo \# Testing http.kafka.sync/
echo ZILLA_PORT="$ZILLA_PORT"
echo KAFKA_BOOTSTRAP_SERVER="$KAFKA_BOOTSTRAP_SERVER"
echo ITEM_ID="$ITEM_ID"
echo GREETING="$GREETING"
echo GREETING_DATE="$GREETING_DATE"
echo

docker compose ps zilla --format "{{.Name}} {{.Health}}"
docker compose logs zilla
docker compose logs kafka

# WHEN
# send request to zilla
timeout 60s curl \
  -X "PUT" http://localhost:$ZILLA_PORT/items/$ITEM_ID \
  -H "Idempotency-Key: $ITEM_ID" \
  -H "Content-Type: application/json" \
  -d "{\"greeting\":\"$GREETING\"}" | tee .testoutput &

# fetch correlation id from kafka with kcat
CORRELATION_ID=$(docker compose -p zilla-http-kafka-sync exec -T kcat kafkacat -C -c 1 -o-1 -b $KAFKA_BOOTSTRAP_SERVER -t items-requests -J -u | jq -r '.headers | index("zilla:correlation-id") as $index | .[$index + 1]')
echo CORRELATION_ID="$CORRELATION_ID"
if [ -z "$CORRELATION_ID" ]; then
  echo ❌
  EXIT=1
fi

# push response to kafka with kcat
echo "{\"greeting\":\"$GREETING_DATE\"}" |
  docker compose -p zilla-http-kafka-sync exec -T kcat \
    kafkacat -P \
    -b $KAFKA_BOOTSTRAP_SERVER \
    -t items-responses \
    -k "$ITEM_ID" \
    -H ":status=200" \
    -H "zilla:correlation-id=$CORRELATION_ID"


# fetch the output of zilla request
for i in $(seq 1 10); do
  sleep $i
  OUTPUT=$(cat .testoutput)
  if [ -n "$OUTPUT" ]; then
    break
  fi
done
rm .testoutput

# THEN
echo OUTPUT="$OUTPUT"
echo EXPECTED="$EXPECTED"
echo
if [ "$OUTPUT" = "$EXPECTED" ]; then
  echo ✅
else
  echo ❌
  EXIT=1
fi

exit $EXIT
