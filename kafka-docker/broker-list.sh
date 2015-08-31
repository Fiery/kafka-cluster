#!/bin/bash

CONTAINERS=$(docker ps | grep 9092 | awk '{print $1}')
BROKERS=$(for CONTAINER in $CONTAINERS; do docker port $CONTAINER 9092 | sed -e "s/0.0.0.0:/$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTAINER):/g"; done)
echo $BROKERS | sed -e 's/ /,/g'
