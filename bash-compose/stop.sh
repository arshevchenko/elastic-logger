#!/bin/bash

docker stop lasticsearch logstash kibana-ui
docker rm elasticsearch logstash kibana-ui
