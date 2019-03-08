# Apache 2.4

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

## Typical configuration file

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

