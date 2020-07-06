#!/bin/sh

echo "Starting SSHD (jump server mode)"
echo "PermitEmptyPasswords = yes" >> /etc/ssh/sshd_config
echo "PermitRootLogin = yes" >> /etc/ssh/sshd_config
/usr/sbin/sshd -D > /dev/null &

if [ ! -z "$PRIVATE_KEY" ]; then
  echo "Found private key in environment variables"
  echo $PRIVATE_KEY | base64 -d > /private-ssh-key;
  chmod 400 /private-ssh-key
fi

if [ -z "$USERNAME" ]; then
	HOST=$REMOTE_HOST
else
	HOST=$USERNAME@$REMOTE_HOST
fi

echo "Starting tunnel on ${BIND_ADDRESS:-127.0.0.1}:$PORT to $HOST"
if [ -f "/private-ssh-key" ]; then
	ssh -o StrictHostKeyChecking=no \
	    -o UserKnownHostsFile=/dev/null \
	    -o GlobalKnownHostsFile=/dev/null \
	    -o ServerAliveInterval=${KEEP_ALIVE:-180} \
	    -i /private-ssh-key \
	    -L *:$PORT:${BIND_ADDRESS:-127.0.0.1}:$PORT \
	    $HOST -N;
else
	ssh -o StrictHostKeyChecking=no \
	    -o UserKnownHostsFile=/dev/null \
	    -o GlobalKnownHostsFile=/dev/null \
	    -o ServerAliveInterval=${KEEP_ALIVE:-180} \
	    -L *:$PORT:${BIND_ADDRESS:-127.0.0.1}:$PORT \
	    $HOST -N;
fi