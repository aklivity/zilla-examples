#!/bin/sh
set -x

EXIT=0

# create schema
curl 'http://localhost:8081/subjects/items-snapshots-value/versions' \
--header 'Content-Type: application/json' \
--data '{
  "schema":
    "{\"fields\":[{\"name\":\"id\",\"type\":\"string\"},{\"name\":\"status\",\"type\":\"string\"}],\"name\":\"Event\",\"namespace\":\"io.aklivity.example\",\"type\":\"record\"}",
  "schemaType": "AVRO"
}'

# GIVEN
PORT="7114"
INPUT='{"id": "123", "status": "OK"}'
EXPECTED='{"id":"123","status":"OK"}'
echo \# Testing http.kafka.avro.json/valid
echo PORT="$PORT"
echo INPUT="$INPUT"
echo EXPECTED="$EXPECTED"
echo

# send message
curl -k http://localhost:7114/items -H 'Idempotency-Key: 1'  -H 'Content-Type: application/json' -d "$INPUT"

# WHEN
sleep 2
OUTPUT=$(curl -k http://localhost:$PORT/items/1)
RESULT=$?
echo RESULT="$RESULT"

# THEN
echo OUTPUT="$OUTPUT"
echo EXPECTED="$EXPECTED"
echo
if [ "$RESULT" -eq 0 ] && [ "$OUTPUT" = "$EXPECTED" ]; then
  echo ✅
else
  echo ❌
  EXIT=1
fi

# GIVEN
PORT="7114"
INPUT='{"id": 123,"status": "OK"}'
EXPECTED='404'
echo \# Testing http.kafka.avro.json/invalid
echo PORT="$PORT"
echo INPUT="$INPUT"
echo EXPECTED="$EXPECTED"
echo

# send message
curl -k http://localhost:7114/items -H 'Idempotency-Key: 2'  -H 'Content-Type: application/json' -d "$INPUT"

# WHEN
sleep 2
OUTPUT=$(curl -w "%{http_code}" http://localhost:$PORT/items/2)
RESULT=$?
echo RESULT="$RESULT"

# THEN
echo OUTPUT="$OUTPUT"
echo EXPECTED="$EXPECTED"
echo
if [ "$RESULT" -eq 0 ] && [ "$OUTPUT" = "$EXPECTED" ]; then
  echo ✅
else
  echo ❌
  EXIT=1
fi

exit $EXIT
