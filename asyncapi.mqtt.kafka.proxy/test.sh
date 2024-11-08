#!/bin/sh
set -x

EXIT=0

# GIVEN
PORT="7183"
INPUT="Hello, Zilla!"
EXPECTED=""
echo \# Testing asyncapi.sse.kafka.proxy/
echo PORT="$PORT"
echo INPUT="$INPUT"
echo EXPECTED="$EXPECTED"
echo

# WHEN
OUTPUT=$(echo "$INPUT" | nc -w 1 localhost $PORT)
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

# TODO remove once fixed
echo '❌ Throws: org.agrona.concurrent.AgentTerminationException: java.lang.NullPointerException: Cannot invoke "io.aklivity.zilla.runtime.binding.asyncapi.internal.types.stream.AsyncapiBeginExFW.apiId()" because "beginEx" is null'
EXIT=1

exit $EXIT
