# System

## User

### Create a user

    useradd --base-dir /home --shell=/bin/bash --create-home user_name

### Add a user to a group

    usermod -a -G group_name user_name

### List all groups which a user belongs to

    groups user_name

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

