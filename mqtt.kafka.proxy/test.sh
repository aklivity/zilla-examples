#!/bin/sh
set -x

EXIT=0

# GIVEN
PORT="7183"
INPUT='Hello Zilla!'
EXPECTED='Hello Zilla!'
echo \# Testing mqtt.kafka.proxy
echo PORT="$PORT"
echo INPUT="$INPUT"
echo EXPECTED="$EXPECTED"
echo

# WHEN

OUTPUT=$(
  docker compose -p zilla-mqtt-kafka-proxy exec -T mosquitto-cli \
    timeout 5s mosquitto_sub --url mqtt://zilla:"$PORT"/zilla &

  SUB_PID=$!

  sleep 1

  docker compose -p zilla-mqtt-kafka-proxy exec -T mosquitto-cli \
    mosquitto_pub --url mqtt://zilla:"$PORT"/zilla --message "$INPUT"

  wait $SUB_PID
)

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
