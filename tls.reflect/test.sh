#!/bin/sh
set -x

EXIT=0

# GIVEN
PORT="23456"
INPUT1="Hello, Zilla!"
INPUT2="Bye, Zilla!"
EXPECTED="Hello, Zilla!
Bye, Zilla!"

echo \# Testing tls.reflect/
echo PORT="$PORT"
echo INPUT="$INPUT"
echo EXPECTED="$EXPECTED"
echo

# WHEN
OUTPUT=$(
echo "$INPUT1" | timeout 2 openssl s_client -connect localhost:$PORT -CAfile test-ca.crt -quiet -alpn echo
echo "$INPUT2" | timeout 2 openssl s_client -connect localhost:$PORT -CAfile test-ca.crt -quiet -alpn echo)
RESULT=$?
echo RESULT="$RESULT"

# THEN
echo OUTPUT="$OUTPUT"
echo EXPECTED="$EXPECTED"
echo

# RESULT=124 (timeout) is a valid case, as we timeout openssl command explicity

if [ "$RESULT" -eq 124 ] && [ "$OUTPUT" = "$EXPECTED" ]; then
  echo ✅
else
  echo ❌
  EXIT=1
fi

exit $EXIT
