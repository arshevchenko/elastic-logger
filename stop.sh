#!/bin/bash

docker stop elasticsearch logstash kibana-ui
docker rm elasticsearch logstash kibana-ui
