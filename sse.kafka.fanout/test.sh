#!/bin/sh
set -x

EXIT=0

# GIVEN
PORT="7114"
KAFKA_BOOTSTRAP_SERVER="kafka:29092"
INPUT='{"id": 1,"name":"Hello World!"}'
EXPECTED='data:{ "id": 1, "name": "Hello World!"}'
echo \# Testing sse.kafka.fanout/
echo PORT="$PORT"
echo KAFKA_BOOTSTRAP_SERVER="$KAFKA_BOOTSTRAP_SERVER"
echo INPUT="$GREETING"
echo EXPECTED="$GREETING_DATE"
echo

# WHEN
# send request to zilla
timeout 3s curl -N --http2 -H "Accept:text/event-stream" "http://localhost:$PORT/events" | tee .testoutput &

# push response to kafka with kafkacat
echo "$INPUT" |
  docker compose -p zilla-http-kafka-sync exec -T kafkacat \
    kafkacat -P \
    -b $KAFKA_BOOTSTRAP_SERVER \
    -t events \
    -k "1"

# fetch the output of zilla request; try 5 times
for i in $(seq 0 5); do
  sleep $i
  OUTPUT=$(cat .testoutput | grep "^data:")
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
