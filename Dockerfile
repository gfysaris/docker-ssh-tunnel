FROM alpine:3.6
MAINTAINER Remie Bolte <r.bolte@gmail.com>

RUN apk add --update openssh-client && rm -rf /var/cache/apk/*
ADD tunnel.sh /opt/tunnel.sh

CMD /opt/tunnel.sh
