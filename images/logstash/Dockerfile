FROM logstash:5.3.1

WORKDIR /opt

ADD entrypoint.sh ./
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
