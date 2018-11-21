FROM jelmersnoeck/ssh-tunnel
MAINTAINER Remie Bolte <r.bolte@gmail.com>

RUN if [ ! -z "$PRIVATE_KEY" ]; then\
	  echo $PRIVATE_KEY | base64 --decode > /private-ssh-key; \
	fi
