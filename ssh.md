# SSH

## Tell the SSH client not to try all private keys

    ssh -o IdentitiesOnly=yes user@host

## Tell the SSH client to use only one identity file

    ssh -o IdentitiesOnly=yes \
        -o IdentityFile=identity.key \
        user@host

## authorized_keys or authorized_keys2 ?

**Answer**: use `authorized_keys`.

[What's the difference between "authorized_keys" and "authorized_keys2"?]
(https://serverfault.com/questions/116177/whats-the-difference-between-authorized-keys-and-authorized-keys2)
