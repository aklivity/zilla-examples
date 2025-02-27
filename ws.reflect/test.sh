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
OUTPUT1=$(docker compose -p zilla-ws-reflect exec -T wscat wscat -c ws://zilla:$PORT/ -s echo -x "$INPUT1" | tee client1.out) &
PID1=$!
OUTPUT2=$(docker compose -p zilla-ws-reflect exec -T wscat wscat -c ws://zilla:$PORT/ -s echo -x "$INPUT2" | tee client2.out) &
PID2=$!

wait $PID1
RESULT1=$?
wait $PID2
RESULT2=$?

OUTPUT1=$(cat client1.out)
OUTPUT2=$(cat client2.out)

# THEN
if [ "$RESULT1" -eq 0 ] && [ "$RESULT2" -eq 0 ] && \
   echo "$OUTPUT1" | grep -q "$INPUT1" && echo "$OUTPUT1" | grep -q "$INPUT2" && \
   echo "$OUTPUT2" | grep -q "$INPUT1" && echo "$OUTPUT2" | grep -q "$INPUT2"; then
  echo ✅
else
  echo ❌
  EXIT=1
fi

exit $EXIT
