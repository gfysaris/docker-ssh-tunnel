FROM ubuntu:20.04

RUN apt-get update -y && apt-get install -y openssh-server && \
	/usr/bin/ssh-keygen -A

ADD tunnel.sh /opt/tunnel.sh
CMD /opt/tunnel.sh
