#!/bin/bash

docker run -d -n elasticsearch \
           -p 9200:9200 -p 9300:9300 \
           -e ES_JAVA_OPTS="-Xms1g -Xmx1g" \
              elasticsearch:5.4.0-alpine


docker build -t log_elk ./images/logstash/
docker run -d -n logstash      \
           -v $1:/opt/ \
           -v images/logstash/pipeline/:/usr/share/logstash/pipeline/ \
           -v images/logstash/config/logstash.yml:/usr/share/logstash/config/logstash.yml \
           -e ES_JAVA_OPTS="-Xms1g -Xmx1g" \
           -links elasticsearch            \
              log_elk


for port in $(seq 8081 8090); do
    if [[ ! $(netstat -tlp | grep ":$port") ]]
    then
        echo "Kibana will exposed at $port"
        KIBANA_PORT=$port
    fi
done
   

docker run -d -n kibana-ui \
           -p $KIBANA_PORT:5601   \
           -links elacticseasrch \
              kibana:5.4.3 
