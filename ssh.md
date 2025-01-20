# SSH

## Tell the SSH client not to try all private keys

```bash
ssh -o IdentitiesOnly=yes user@host
````

## Tell the SSH client to use only one identity file

```bash
ssh -o IdentitiesOnly=yes \
    -o IdentityFile=identity.key \
    user@host
```

> The identity file is the private key to use.

## authorized_keys or authorized_keys2 ?

**Answer**: use `authorized_keys`.

[What's the difference between "authorized_keys" and "authorized_keys2"?]
(https://serverfault.com/questions/116177/whats-the-difference-between-authorized-keys-and-authorized-keys2)

## How to copy a public key on a remote server ?

Use `ssh-copy-id`:

```bash
ssh-copy-id -o IdentitiesOnly=yes -i /path/to/public/key login@host
````

## SSH tunneling

### Definitions

| Term       | Definition                                                                                     |
|------------|------------------------------------------------------------------------------------------------|
| **Client** | means the machine where you start ssh. This machine is refered to by "**local**".              |
| **Server** | means the machine you want to connect to with ssh. This machine is refered to by "**remote**". |

![](images/ssh-tunnel-def-1.png)

### Local port forwarding

Local port forwarding is mostly used to connect to a remote service on an internal network such as a database or VNC server.

```
ssh -L 8080:<remote server>:80 <jump server>
```

> _By convention_, the SSH command is executed on the "local server."

All connections to port 8080 on the "local server" will be forwarded to port 80 on the "remote server."

![](images/ssh-local-port-forwarding.png)


### Remote port forwarding

Remote port forwarding is mostly used to give access to an internal service to someone from the outside.

```
ssh -R 8080:<remote server>:80 <jump server>
```

All connections to port 8080 on the "remote server" will be forwarded to port 80 on the "local server."

![](images/ssh-remote-port-forwarding.png)

