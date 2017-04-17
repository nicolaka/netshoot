#!/usr/bin/env sh
HOST=$1
PORT=$2
COUNT=0

echo "Listener started on port $PORT"
nc -k -l $PORT > /dev/null &

echo "Sending traffic to $HOST on port $PORT every 10 seconds"

while true; do
	echo $(hostname) | nc -q 0 $HOST $PORT
	RESULT=$?
	if [ $RESULT -eq 0 ]; then
		COUNT=$((COUNT+1))
		echo "Sent $COUNT messages to $HOST:$PORT"
	fi
	sleep 10
done
