#!/bin/sh

# GIVEN
ZILLA_PORT="7114"
KAFKA_PORT="9092"
ITEM_ID="5cf7a1d5-3772-49ef-86e7-ba6f2c7d7d07"
GREETING="Hello, World!"
GREETING_DATE="Hello, World! $(date)"
EXPECTED="{\"greeting\":\"$GREETING_DATE\"}"

echo \# Testing http.kafka.sync
echo ZILLA_PORT="$ZILLA_PORT"
echo KAFKA_PORT="$KAFKA_PORT"
echo ITEM_ID="$ITEM_ID"
echo GREETING="$GREETING"
echo GREETING_DATE="$GREETING_DATE"
echo EXPECTED="$EXPECTED"
EXIT=0
echo \# Testing http.kafka.sync/
echo

# WHEN
# send request to zilla
curl -vs \
  -X "PUT" http://localhost:$ZILLA_PORT/items/$ITEM_ID \
  -H "Idempotency-Key: 1" \
  -H "Content-Type: application/json" \
  -d "{\"greeting\":\"$GREETING\"}" | tee .testoutput &

# fetch correlation id from kafka with kcat
CORRELATION_ID=$(docker compose -p zilla-http-kafka-sync exec kcat kafkacat -C -b localhost:$KAFKA_PORT -t items-requests -J -u | jq -r '.headers | index("zilla:correlation-id") as $index | .[$index + 1]')
echo CORRELATION_ID="$CORRELATION_ID"
if [ -z "$CORRELATION_ID" ]; then
  echo ❌
  EXIT=1
fi

# push response to kafka with kcat
echo "{\"greeting\":\"$GREETING_DATE\"}" |
  docker compose -p zilla-http-kafka-sync exec kcat \
    kafkacat -P \
    -b localhost:$KAFKA_PORT \
    -t items-responses \
    -k "$ITEM_ID" \
    -H ":status=200" \
    -H "zilla:correlation-id=$CORRELATION_ID"

# fetch the output of zilla request
OUTPUT=$(cat .testoutput)
echo
echo OUTPUT="$OUTPUT"

# THEN
rm .testoutput
if [ "$OUTPUT" = "$EXPECTED" ]; then
  echo ✅
else
  echo ❌
  EXIT=1
fi

exit $EXIT
