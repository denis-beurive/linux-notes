# Apache 2.4

## Make sure that Apache is running

Let's say that Apache listens to the port 80 (HTTP) and/or 443 (HTTPS):

    # sudo netstat -tulpn | grep LISTEN | egrep ':(80|443)\s+'
    tcp6       0      0 :::80                   :::*                    LISTEN      4422/apache2        

Apache may not be listening on the expected ports. Let's try this:

    # sudo netstat -tulpn | grep LISTEN | egrep "apache2?"
    tcp6       0      0 :::80                   :::*                    LISTEN      4422/apache2  

If peering through the interfaces does not reveal any activities, let's try this:

    # ps awx | grep apache2
    18734 ?        Ss     0:00 /usr/sbin/apache2 -k start
    18735 ?        S      0:00 /usr/sbin/apache2 -k start
    18736 ?        S      0:00 /usr/sbin/apache2 -k start
    18737 ?        S      0:00 /usr/sbin/apache2 -k start
    18738 ?        S      0:00 /usr/sbin/apache2 -k start
    18739 ?        S      0:00 /usr/sbin/apache2 -k start

Try to get a document:

    cd /tmp/ && wget http://localhost:80

## LOG files / Troubleshooting

First, make sure that Apache is running and is listening on the expected ports.
Then look at the LOG files:

* `/var/log/apache2/access.log`
* `/var/log/apache2/error.log`
* `/var/log/apache2/other_vhosts_access.log`

    sudo tail -f /var/log/apache2/access.log /var/log/apache2/error.log /var/log/apache2/other_vhosts_access.log

If an error occurs, you can get information with the commands below:

    systemctl status apache2.service
    journalctl -xe

## Test the configuration

    /usr/sbin/apachectl configtest

## Check the virtual hosts

    /usr/sbin/apachectl -S

## Start the server

    /usr/sbin/apachectl -S && /usr/sbin/apachectl configtest && service apache2 start && echo "OK"    

## Stop the server

    service apache2 stop && echo "OK"

## Reload the configuration

    /usr/sbin/apachectl -S && /usr/sbin/apachectl configtest && service apache2 reload && echo "OK"

> Sometimes it seems that reloading the configuration does not actually reload _all_ the configuration. I've had trouble with "mod_wsgi". If the expected result is not what you expected (you think that the configuration has not been reloaded), then try to restart the server.

## Restart the server

    /usr/sbin/apachectl -S && /usr/sbin/apachectl configtest && service apache2 restart && echo "OK"

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

## Typical virtual host configuration file for a Python application

This example works with "`mod_wsgi`".

    <VirtualHost *:80>
        ServerName example.net
        ServerAlias www.example.net

        WSGIDaemonProcess thermo user=thermo group=thermo threads=5
        WSGIScriptAlias / /home/thermo/projects/thermo_test/www/www.wsgi

        <Directory /home/thermo/projects/thermo_test/www>
            WSGIProcessGroup thermo
            WSGIApplicationGroup %{GLOBAL}
            Require all granted
        </Directory>
    </VirtualHost>

> Note : when using "`mod_wsgi`", reloading the server configuration may not be enough for a modification to take effect. If you notice that the expected configuration does not take effect, then restart Apache.

