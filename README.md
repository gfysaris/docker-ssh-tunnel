# SSH Tunnel

This SSH Tunnel provides a simplistic way to set up an SSH tunnel to a remote
host to securely connect without having to expose your host too much.

## Usage

### Private key file

The container assumes your private key doesn't have a password and is mounted
under `/private-ssh-key`.

You can also provide the private key by setting the `PRIVATE_KEY` environment
variable with the base64 encoded string.

### Configuration

- `$PORT` the port you want to forward
- `$USERNAME` the username for your ssh key
- `$REMOTE_HOST` the remote host you want to set up a local tunnel for
- `$BIND_ADDRESS` the address you want to bind the tunnel to. (default: `127.0.0.1`)
- `$PRIVATE_KEY` the private key (base64 encoded string)

### Running the tunnel

With private key mounted from the filesystem

```
$ docker run --rm -p "9200:9200" \
    -v $(pwd)/private-key:/private-ssh-key \
    -e PORT=9200 \
    -e USERNAME=elasticsearch \
    -e REMOTE_HOST=my-es-host \
    remie/ecs-ssh-tunnel
```

with private key provided via environment variables (base64 encoded)

```
$ docker run --rm -p "9200:9200" \
    -e PRIVATE_KEY=paste_your_base64_encoded_key_here \
    -e PORT=9200 \
    -e USERNAME=elasticsearch \
    -e REMOTE_HOST=my-es-host \
    remie/ecs-ssh-tunnel
```
