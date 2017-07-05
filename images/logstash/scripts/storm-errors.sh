#!/bin/sh

cat > /usr/share/logstash/pipeline/storm-errors-$1-$2.conf << EOF

input {
    stdin{}
}

filter {
    multiline {
        pattern => "^(worker)"
        negate => "true"
        what => previous
    }

    grok {
        match =>{
            "message" => "worker-%{DATA:port} %{DATA:times} %{DATA:module} \[%{LOGLEVEL:loglevel}\] %{GREEDYDATA:log_message}"
        }

        tag_on_failure => [ "Parsing error" ]
    }

    date {
        match => [ "times", "ISO8601" ]
        target => "@timestamp"
    }

    mutate {

        add_field => {
            "datacenter" => "$1"
        }

        replace => {
            "host" => "$2"
            "message" => "%{log_message}" 
        }

        remove_field => [ "timest", "log_message", "@version"]
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

logstash -f /usr/share/logstash/pipeline/storm-errors-$1-$2.conf < storm/worker-errors.log 

