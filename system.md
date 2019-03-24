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

