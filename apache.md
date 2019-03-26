# Apache 2.4

## Make sure that Apache is running

Let's say that Apache listens to the port 80:

    # netstat -an | grep :80
    tcp6       0      0 :::80                   :::*                    LISTEN   

Make sure that the process is running:

    # ps awx | grep apache2
    18734 ?        Ss     0:00 /usr/sbin/apache2 -k start
    18735 ?        S      0:00 /usr/sbin/apache2 -k start
    18736 ?        S      0:00 /usr/sbin/apache2 -k start
    18737 ?        S      0:00 /usr/sbin/apache2 -k start
    18738 ?        S      0:00 /usr/sbin/apache2 -k start
    18739 ?        S      0:00 /usr/sbin/apache2 -k start

Try to get a document:

    cd /tmp/ && wget http://localhost:80

## LOG files

* `/var/log/apache2/access.log`
* `/var/log/apache2/error.log`
* `/var/log/apache2/other_vhosts_access.log`

    sudo tail -f /var/log/apache2/access.log /var/log/apache2/error.log /var/log/apache2/other_vhosts_access.log

## Test the configuration

    /usr/sbin/apachectl configtest

## Check the virtual hosts

    /usr/sbin/apachectl -S

## Reload the configuration

    /usr/sbin/apachectl -S && /usr/sbin/apachectl configtest && service apache2 reload && echo "OK"

## Restart the server

    /usr/sbin/apachectl -S && /usr/sbin/apachectl configtest && service apache2 restart && echo "OK"

 ## Make sure that Apache is running and listening

    netstat -tulpn | grep LISTEN | egrep ':(80|443)\s+'
    ps awx | grep apache2
    cd /tmp/ && wget http://localhost:80

LOG files:

* `/var/log/apache2/access.log`
* `/var/log/apache2/error.log`
* `/var/log/apache2/other_vhosts_access.log`

If an error occurs, you can get information with the commands below:

    systemctl status apache2.service
    journalctl -xe

And:

    sudo tail -f /var/log/apache2/access.log /var/log/apache2/error.log /var/log/apache2/other_vhosts_access.log

## List available modules

    ls /etc/apache2/mods-available/*.load

## List activated modules

    apache2ctl -t -D DUMP_MODULES

or:

    ls /etc/apache2/mods-enabled/*.load

## Activate a module

    a2enmod <module name> && service apache2 restart && echo "OK"

## Find out who the Apache user is

    egrep "export\s+(APACHE_RUN_USER|APACHE_RUN_GROUP)=" /etc/apache2/envvars

## Activate a virtual host configuration

The configuration file (`example.com.conf`, in this example) must be located in the directory "`/etc/apache2/sites-available`".

    sudo a2ensite example.com.conf

> Eventually: `sudo systemctl reload apache2`

## Disable a virtual host configuration

    sudo a2dissite example.com.conf

> Eventually: `sudo systemctl reload apache2`

## Typical virtual host configuration file for a PHP application

File `/etc/apache2/sites-available/your_domainFile.conf`:

    <VirtualHost *:80>
            ServerName your_domain.fr
            ServerAlias www.your_domain.fr

            DocumentRoot "/home/dokuwiki"
            LogLevel debug
            ErrorLog "${APACHE_LOG_DIR}/dokuwiki-error.log"
            CustomLog "${APACHE_LOG_DIR}/dokuwiki-access.log" common

            Options Indexes FollowSymLinks

            <Directory />
                    Require all granted
                    RewriteEngine On
                    LogLevel alert rewrite:trace3
                    RewriteCond %{REQUEST_FILENAME} !-f
                    RewriteRule ^ index.php [QSA,L]
            </Directory>
    </VirtualHost>
    <Directory /home/dokuwiki>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

Make sure that `mod-rewrite` is activated:

    ls -l /etc/apache2/mods-enabled/rewrite*

