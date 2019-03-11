# System

## SSH

### Tell the SSH client not to try all private keys

    ssh -o IdentitiesOnly=yes user@host

### Tell the SSH client to use only one identity file

    ssh -o IdentitiesOnly=yes \
        -o IdentityFile=identity.key \
        user@host

### Links

[What's the difference between "authorized_keys" and "authorized_keys2"?]
(https://serverfault.com/questions/116177/whats-the-difference-between-authorized-keys-and-authorized-keys2)

## Host

### Print detailed information about the machine

    inxi -Fxz

> APT package: `inxi`

### Restart the network

    sudo /etc/init.d/network-manager restart

## User management

### Print information about a user

    finger www-data

## Security

### Antivirus

Clam AV: [https://www.makeuseof.com/tag/command-line-clam-antivirus-linux/](https://www.makeuseof.com/tag/command-line-clam-antivirus-linux/)

    sudo apt-get install clamav clamav-freshclam

Refresh the database of viruses signatures:

    sudo freshclam

Scan a directory recursively:

    sudo clamscan -r /home/
    
or:

    sudo clamscan -ri /home/

> The option "i" tells Clam to print the paths of infected files only.

