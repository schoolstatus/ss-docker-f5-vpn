## F5 BigIP Docker Image

### Purpose
F5's linux client is flaky when attempting to run multiple instances from a single machine.  This can be avoided running each instance as a container.  Using docker's port translation as a crude NAT implementation, the container host can relay connections accordingly.

### How to Use
The container must be passed the following environment variables before launch:

```
VPN_REMOTE_IP
VPN_REMOTE_PORT
VPN_SERVER
VPN_USER
VPN_PASS
```

On launch, the container will init the connection, handle routing the remote IP to f5's `tun0` interface, and setup an iptables NAT rule that forwards the containers local port to the same port definied in `VPN_REMOTE_PORT`.

### Build Steps
```
export TAG=latest
docker build --platform linux/amd64 -t ss-f5-vpn:$TAG .
docker tag ss-f5-vpn:$TAG [my_aws_acct_id].dkr.ecr.us-east-1.amazonaws.com/ss-f5-vpn:$TAG
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin [my_aws_acct_id].dkr.ecr.us-east-1.amazonaws.com && docker push [my_aws_acct_id].dkr.ecr.us-east-1.amazonaws.com/ss-f5-vpn:$TAG
```

