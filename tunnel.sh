#!/bin/sh

if [ ! -z "$PRIVATE_KEY" ]; then
  echo $PRIVATE_KEY | base64 -d > /private-ssh-key;
  chmod 400 /private-ssh-key
fi

ssh -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o GlobalKnownHostsFile=/dev/null \
    -o ServerAliveInterval=${KEEP_ALIVE:-180} \
    -i /private-ssh-key \
    -L *:$PORT:${BIND_ADDRESS:-127.0.0.1}:$PORT \
    $USERNAME@$REMOTE_HOST -N