FROM logstash:5.4.0-alpine

USER root

RUN apk add --no-cache curl python py-yaml py-jinja2
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-multiline

RUN mkdir /configs
RUN mkdir /templates

COPY ./templates/ /templates/
COPY ./config/ /configs/
COPY ./entrypoint.py /

RUN chmod +x /entrypoint.py

ENTRYPOINT ["/entrypoint.py"]
