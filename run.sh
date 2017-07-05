#!/bin/bash

for port in $(seq 8081 8090); do
    if [[ ! $(netstat -tlp | grep ":$port") ]]
    then
       echo "Kibana will exposed at $port"
       export KIBANA_PORT=$port
    fi

    export HOST_PATH=$1
done

docker-compose up -d
