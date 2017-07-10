#!/bin/sh

for worker in $(ls storm | grep "worker-[0-9]"); do
    PORT=${worker:7:4}
    cat > /usr/share/logstash/pipeline/storm-worker-$1-$2-$PORT.conf << EOF
input {
    stdin{}
}

filter {
    multiline {
      pattern => "^\d"
      negate => true
      what => previous
    }

    grok {
        match =>{
            "message" => "%{DATA:times} %{DATA:module} \[%{LOGLEVEL:log_level}\] %{GREEDYDATA:log_message}"
        }

        tag_on_failure => [ "Parsing error" ]
    }

    date {
        match => [ "times", "ISO8601" ]
        target => "@timestamp"
    }

    mutate {

        add_field => {
            "port" => "$PORT"
            "datacenter" => "$1"
        }

        replace => {
            "host" => "$2" 
            "message" => "%{log_message}"
        }

        remove_field => [ "times", "log_message", "@version"]
    }
}


output {
    stdout {
        codec => "rubydebug"
    }

    elasticsearch {
        hosts => "elasticsearch:9200"
        index => "storm"
    }
}
EOF

logstash -f /usr/share/logstash/pipeline/storm-worker-$1-$2-$PORT.conf < storm/$worker 
done
