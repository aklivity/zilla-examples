#!/bin/sh
set -x

EXIT=0

# GIVEN
PORT="7114"
INPUT1="Hello from client 1"
INPUT2="Hello from client 2"

echo \# Testing ws.reflect
echo PORT="$PORT"
echo INPUT1="$INPUT1"
echo INPUT2="$INPUT2"

# WHEN

for i in $(seq 1 5); do
  echo "$INPUT1" | docker compose -p zilla-ws-reflect exec -T websocat websocat --one-message --protocol echo ws://zilla:7114/

  if [ $? -eq 0 ]; then
    echo "✅ Zilla is reachable."
    break
  fi

  sleep 2
done

{
  docker compose -p zilla-ws-reflect exec -T websocat websocat --one-message --no-close --protocol echo ws://zilla:$PORT/ &
  PID1=$!
  (echo "$INPUT2"; sleep 2) | docker compose -p zilla-ws-reflect exec -T websocat websocat --one-message --no-close --protocol echo ws://zilla:$PORT/ &
  PID2=$!

  wait $PID1 $PID2
} > output.out 2>&1

RESULT1=$?
RESULT2=$?
OUTPUT=$(cat output.out)

# THEN
COUNT=$(echo "$OUTPUT" | grep -Fx "$INPUT2" | wc -l)

if [ "$RESULT1" -eq 0 ] && [ "$RESULT2" -eq 0 ] && [ "$COUNT" -eq 2 ]; then
  echo ✅
else
  echo ❌
  EXIT=1
fi

exit $EXIT
