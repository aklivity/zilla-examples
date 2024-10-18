#!/bin/sh

# GIVEN
PORT="12345"
INPUT="Hello, Zilla!"
EXPECTED="Hello, Zilla!"
EXIT=0
echo \# Testing sse.kafka.fanout/
echo PORT=$PORT
echo INPUT=$INPUT
echo EXPECTED=$EXPECTED
echo

# WHEN
OUTPUT=$(echo $INPUT)
RESULT=$?
echo OUTPUT=
echo RESULT=

# THEN
if [ $RESULT -eq 0 ] && [ "$OUTPUT" = "$EXPECTED" ]; then
    echo ✅
else
  echo ❌
  EXIT=1
fi

exit $EXIT
