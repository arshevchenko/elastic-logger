#!/bin/bash

# Remove and stop containers
docker stop elasticsearch logstash kibana-ui
docker rm elasticsearch logstash kibana-ui
