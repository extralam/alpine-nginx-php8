#!/usr/bin/env sh
apk --no-cache add curl
echo "Waiting for process to start..."
sleep 10
curl --silent --fail http://app:80 | grep 'PHP 8.1.1'
