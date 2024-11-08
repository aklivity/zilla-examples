#!/bin/sh
set -x

EXIT=0

# GIVEN
PORT="7114"
EXPECTED='{
    "id": 42,
    "status": "Active"
}'
echo \# Testing http.json.schema/valid.json
echo PORT="$PORT"
echo EXPECTED="$EXPECTED"
echo

# WHEN
OUTPUT=$(curl http://localhost:$PORT/valid.json)
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
EXPECTED="curl: (18) transfer closed with 37 bytes remaining to read"
echo \# Testing http.json.schema/invalid.json
echo PORT="$PORT"
echo EXPECTED="$EXPECTED"
echo

# WHEN
OUTPUT=$(curl http://localhost:$PORT/invalid.json)
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
echo '❌ Tested on main. and does not work with described instructions'
EXIT=1

exit $EXIT
