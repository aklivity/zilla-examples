#!/bin/sh
set -x

EXIT=0

# GIVEN
PORT="7151"

EXPECTED='{
  "message": "test"
}'
echo \# Testing grpc.kafka.fanout/example.FanoutService.FanoutServerStream
echo PORT="$PORT"
echo INPUT="$INPUT"
echo EXPECTED="$EXPECTED"
echo

# WHEN

sleep 5

(docker compose -p zilla-grpc-kafka-fanout exec kafkacat kafkacat -P -b kafka.examples.dev:29092 -t messages -k -e /tmp/binary.data)

OUTPUT=$(timeout 3s docker run --network zilla-grpc-kafka-fanout_default --rm -v ./fanout.proto:/fanout.proto fullstorydev/grpcurl -plaintext -proto fanout.proto  -d '' zilla.examples.dev:$PORT example.FanoutService.FanoutServerStream)
RESULT=$?
echo RESULT="$RESULT"
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
