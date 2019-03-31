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

To scan all LOG files at once:

    sudo tail -f /var/log/apache2/access.log /var/log/apache2/error.log /var/log/apache2/other_vhosts_access.log

Please note that you can also use `screen`. [This configuration](code/screen-1.rc) (let's name it `screen.rc`) creates 4 regions vertically stacked on top of each others.

* the first region display the content of the file `/var/log/apache2/access.log`.
* the second region display the content of the file `/var/log/apache2/error.log`.
* the third region display the content of the file `/var/log/apache2/other_vhosts_access.log`.
* the last region will receive the focus.

To run a screen, use this command: `screen -c screen.rc`

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

        WSGIDaemonProcess thermo user=thermo group=thermo threads=5 home=/home/thermo
        WSGIScriptAlias / /home/thermo/projects/thermo_test/www/www.wsgi

        <Directory /home/thermo/projects/thermo_test/www>
            WSGIProcessGroup thermo
            WSGIApplicationGroup %{GLOBAL}
            Require all granted
        </Directory>
    </VirtualHost>

> Please note the parameters passed to the directive `WSGIDaemonProcess`.
>
> Any paths (to files) defined within the Python WSGI handler will be relative to the value of `home`. That is, in this example, `/my_file` (within the Python WSGI handler) will points to `/home/thermo/my_file`.

> Note : when using "`mod_wsgi`", reloading the server configuration may not be enough for a modification to take effect. If you notice that the expected configuration does not take effect, then restart Apache.

## Install certificate with "Let's encrypt"

Make sure that the SSL module is enabled:

    # ls -l /etc/apache2/mods-enabled/ | grep ssl
    lrwxrwxrwx 1 root root 26 Mar 28 14:50 ssl.conf -> ../mods-available/ssl.conf
    lrwxrwxrwx 1 root root 26 Mar 28 14:50 ssl.load -> ../mods-available/ssl.load

> If necessary, enable the SSL module: `a2enmod SSL`.

Add backports to your sources.list:

    deb http://deb.debian.org/debian stretch-backports main

Read [this document](https://backports.debian.org/Instructions/)

Then install CertBot:

    apt-get install certbot python-certbot-apache -t stretch-backports

> Before you generate the certificate, you should know that some verification is performed based on the domain name. The domain names that are being "certificated" must be declared in the DNS. If, for example, you declare aliases in a virtual host (ex: `ServerAlias www.your_domain.fr`), then **these aliases must be declared in the DNS**.

At last, generate certificates and configure Apache:

    certbot --apache

> The certificates will be stored in the directory `/etc/letsencrypt/live/`.

Please read the file `/etc/letsencrypt/live/README`, as it tells you where to find the various files that you will need to configure your virtual hosts:

    `/etc/letsencrypt/live/[cert name]/privkey.pem`  : the private key for your certificate.
    `/etc/letsencrypt/live/[cert name]/fullchain.pem`: the certificate file used in most server software.
    `/etc/letsencrypt/live/[cert name]/chain.pem`    : used for OCSP stapling in Nginx >=1.3.7.
    `/etc/letsencrypt/live/[cert name]/cert.pem`     : will break many server configurations, and should not be used without reading further documentation (see link below).

Make sure that Apache is configured so that:

    * Apache listens for incoming HTTP requests on port `80`.
    * Apache listens for incoming HTTPS requests on port `443`.

To do that, edit the file `/etc/apache2/ports.conf`. You should have:

    # cat /etc/apache2/ports.conf 
    # If you just change the port or add more ports here, you will likely also
    # have to change the VirtualHost statement in
    # /etc/apache2/sites-enabled/000-default.conf

    Listen 80

    <IfModule ssl_module>
        Listen 443
    </IfModule>

    <IfModule mod_gnutls.c>
        Listen 443
    </IfModule>

If necessary, you may need to adapt your virtual hosts:

Without SSL:

    <VirtualHost *:80>
        ...
    </VirtualHost>

With SSL:

    <VirtualHost *:80 *:443>
        SSLEngine on
        SSLCertificateFile /etc/letsencrypt/live/your_domain.net/fullchain.pem
        SSLCertificateKeyFile /etc/letsencrypt/live/your_domain.net/privkey.pem

        ...
    </VirtualHost>

Check the Apache configuration:

    /usr/sbin/apachectl -S && /usr/sbin/apachectl configtest && echo "OK"

**Note**: make sure that you see a line that starts with "`*:443`":

    root@vps645190:/etc/apache2/sites-available#  /usr/sbin/apachectl -S && /usr/sbin/apachectl configtest && echo "OK"
    VirtualHost configuration:
    *:443                  your_domain.net (/etc/apache2/sites-enabled/www.conf:1)
    *:80                   your_domain.net (/etc/apache2/sites-enabled/www.conf:1)

Restart Apache:

    service apache2 restart && echo "OK"

Make sure that Aapche listens on the port 443:

    netstat -tulpn | grep LISTEN | grep 443

Make sure that you can perform HTTP and HTTPS requests:

    wget http://your_domain.net
    wget https://your_domain.net

