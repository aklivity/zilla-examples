#!/bin/sh
set -xe

# GIVEN
PORT="7114"
EXPECTED='[{"id":1,"name":"string","tag":"string"}]'
EXIT=0
echo \# Testing openapi.proxy/
echo PORT=$PORT
echo EXPECTED="$EXPECTED"
echo

# WHEN
OUTPUT=$(curl --silent --location "http://localhost:$PORT/pets" --header 'Accept: application/json')
RESULT=$?
echo OUTPUT=$OUTPUT
echo RESULT=$RESULT

# THEN
echo OUTPUT="$OUTPUT"
echo EXPECTED="$EXPECTED"
echo
if [ $RESULT -eq 0 ] && [ "$OUTPUT" = "$EXPECTED" ]; then
  echo ✅
else
  echo ❌
  EXIT=1
fi

exit $EXIT
