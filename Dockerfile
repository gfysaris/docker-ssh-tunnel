FROM alpine:3.6
MAINTAINER Remie Bolte <r.bolte@gmail.com>

RUN apk add --update openssh openssh-keygen openssh-client && rm -rf /var/cache/apk/*; \
	/usr/bin/ssh-keygen -A

ADD tunnel.sh /opt/tunnel.sh
CMD /opt/tunnel.sh
