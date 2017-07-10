#!/bin/bash

docker run -d --name=int_elasticsearch \
           -p 9200:9200 -p 9300:9300 \
           -e ES_JAVA_OPTS="-Xms1g -Xmx1g" \
              elasticsearch:5.4.0-alpine


docker build -t log_elk ./images/logstash/
docker run -d --name=int_logstash      \
           -v $1:/opt/ \
           -v $PWD/images/logstash/pipeline/:/usr/share/logstash/pipeline/ \
           -v $PWD/images/logstash/config/logstash.yml:/usr/share/logstash/config/logstash.yml \
           -e ES_JAVA_OPTS="-Xms1g -Xmx1g" \
           --link int_elasticsearch            \
              log_elk


for port in $(seq 8081 8090); do
    if [[ ! $(netstat -tlp | grep ":$port") ]]
    then
        echo "Kibana will exposed at $port"
        KIBANA_PORT=$port
    break
    fi
done
   

docker run -d --name=int_kibana-ui \
           -p $KIBANA_PORT:5601   \
           --link int_elasticsearch \
              kibana:5.4.3 
