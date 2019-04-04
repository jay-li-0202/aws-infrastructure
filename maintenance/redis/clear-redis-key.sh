#!/bin/bash
STARTSWITH="$1"

RCLI=/usr/bin/redis-cli
HOST=127.0.0.1
PORT=6379
RCMD="$RCLI -h $HOST -p $PORT -c "

./scan-match.sh $STARTSWITH | while read -r KEY ; do
    $RCMD del $KEY
done
