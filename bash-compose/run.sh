#!/bin/bash

docker run -d --name=elasticsearch \
           -p 9200:9200 -p 9300:9300 \
           -e ES_JAVA_OPTS="-Xms1g -Xmx1g" \
              elasticsearch:5.4.0-alpine


docker build -t log_elk ./images/logstash/
docker run -d --name=logstash      \
           -v $1:/opt/ \
           -v images/logstash/pipeline/:/usr/share/logstash/pipeline/ \
           -v images/logstash/config/logstash.yml:/usr/share/logstash/config/logstash.yml \
           -e ES_JAVA_OPTS="-Xms1g -Xmx1g" \
           -link elasticsearch            \
              log_elk


for port in $(seq 8081 8090); do
    if [[ ! $(netstat -tlp | grep ":$port") ]]
    then
        echo "Kibana will exposed at $port"
        KIBANA_PORT=$port
    fi
done
   

docker run -d --name=kibana-ui \
           -p $KIBANA_PORT:5601   \
           -link elacticsearch \
              kibana:5.4.3 
