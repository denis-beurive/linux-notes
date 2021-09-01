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

