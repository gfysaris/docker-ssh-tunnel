#!/bin/sh

if [ ! -z "$PRIVATE_KEY" ]; then
  echo "Found private key in environment variables"
  echo $PRIVATE_KEY | base64 -d > /private-ssh-key;
  chmod 400 /private-ssh-key
else
	ssh-keygen -q -t rsa -f ~/.ssh/ssh_tunnel
	cat ~/.ssh/ssh_tunnel.pub >> ~/.ssh/authorized_keys
	cp ~/.ssh/ssh_tunnel /private-ssh-key
	chmod 600 ~/.ssh/authorized_keys
	chmod 400 /private-ssh-key
fi

echo "PermitEmptyPasswords = yes" >> /etc/ssh/sshd_config
echo "PermitRootLogin = yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication = no" >> /etc/ssh/sshd_config
echo "ChallengeResponseAuthentication = no" >> /etc/ssh/sshd_config
echo "PubkeyAuthentication = yes" >> /etc/ssh/sshd_config
mkdir /run/sshd

echo "Starting SSHD (jump server mode)"
/usr/sbin/sshd -D &
sleep 2

if [ -z "$USERNAME" ]; then
	HOST=${REMOTE_HOST:-localhost}
else
	HOST=$USERNAME@${REMOTE_HOST:-localhost}
fi

echo "Starting tunnel on $HOST to ${BIND_ADDRESS:-127.0.0.1}:$PORT"
ssh -o StrictHostKeyChecking=no \
		-o UserKnownHostsFile=/dev/null \
		-o GlobalKnownHostsFile=/dev/null \
		-o ServerAliveInterval=${KEEP_ALIVE:-180} \
		-i /private-ssh-key \
		-L *:$PORT:${BIND_ADDRESS:-127.0.0.1}:$PORT \
		$HOST -N;
