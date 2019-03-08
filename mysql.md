# Mysql 5.7

## Restart the server

    service mysql restart

## Allow the server to listen on a public interface

Edit `/etc/mysql/mysql.conf.d/mysqld.cnf`. Then comment the line `bind-address  = 127.0.0.1`.

    [mysqld]
    pid-file    = /var/run/mysqld/mysqld.pid
    socket      = /var/run/mysqld/mysqld.sock
    datadir     = /var/lib/mysql
    log-error   = /var/log/mysql/error.log
    # By default we only accept connections from localhost
    # bind-address  = 127.0.0.1
    # Disabling symbolic-links is recommended to prevent assorted security risks
    symbolic-links=0

Then restart the server:

    service mysql restart

## Get the server version

    echo 'SHOW VARIABLES LIKE "%version%"' | mysql -u root -p

## Dump all the database

    mysqldump --create-options --lock-all-tables -u root -p --all-databases > dump.sql

## User management

* USER_LOGIN: name of the user.
* USER_PASSWORD: user passer.
* ROOT_PASSWORD: administrator password for the user.
* BASE_NAME: name of the database.

### Listing all users

    export ROOT_PASSWORD='root_password'

    mysql -u root -p"${ROOT_PASSWORD}" -e "SELECT * FROM mysql.user\G;"

### Listing all connexions allowed for a given user

    export ROOT_PASSWORD='root_password'
    export USER_LOGIN='user-login'

    mysql -u root -p"${ROOT_PASSWORD}" -e "SELECT Host FROM mysql.user WHERE User='${USER_LOGIN}';"

### Listing all active connections

    export ROOT_PASSWORD='root_password'

    mysql -u root -p"${ROOT_PASSWORD}" -e "show processlist;"

If you want to select only the secured connections:

    mysql --ssl-mode=REQUIRED -u root -p"${ROOT_PASSWORD}" -e "show processlist;"

### Creating a user

The user can open a local connection only:

    export USER_LOGIN='user_login'
    export USER_PASSWORD='user_password'
    export ROOT_PASSWORD='root_password'

    mysql -u root -p"${ROOT_PASSWORD}" -e "CREATE USER '${USER_LOGIN}'@'localhost' IDENTIFIED BY '${USER_PASSWORD}';"

The user can open a remote connection only:

    export USER_LOGIN='user_login'
    export USER_PASSWORD='user_password'
    export ROOT_PASSWORD='root_password'

    mysql -u root -p"${ROOT_PASSWORD}" -e "CREATE USER '${USER_LOGIN}'@'%' IDENTIFIED BY '${USER_PASSWORD}';"

### Setting user authorizations

The authorizations apply to a local connection only:

    export USER_LOGIN='user_login'
    export ROOT_PASSWORD='root_password'
    export BASE_NAME='base_name'

    mysql -u root -p"${ROOT_PASSWORD}" -e "grant select on \`${BASE_NAME}\`.* to '${USER_LOGIN}'@'localhost';"
    mysql -u root -p"${ROOT_PASSWORD}" -e "flush privileges;"

The authorizations apply to a remote connection only:

    export USER_LOGIN='user_login'
    export ROOT_PASSWORD='root_password'
    export BASE_NAME='base_name'

    mysql -u root -p"${ROOT_PASSWORD}" -e "grant select on \`${BASE_NAME}\`.* to '${USER_LOGIN}'@'%';"
    mysql -u root -p"${ROOT_PASSWORD}" -e "flush privileges;"

### Removing a user for a given "locality"

**Warning**: you must remove couples (`user`, `locality`).

    export USER_LOGIN='user_login'
    export ROOT_PASSWORD='root_password'

    # locality = any remote hosts
    mysql -u root -p"${ROOT_PASSWORD}" -e "DROP USER '${USER_LOGIN}'@'%'"
    # locality = localhost
    mysql -u root -p"${ROOT_PASSWORD}" -e "DROP USER '${USER_LOGIN}'@'localhost'"

### Listing all couples (user, locality)

    export ROOT_PASSWORD='root_password'

    mysql -u root -p"${ROOT_PASSWORD}" -e "SELECT User,Host,ssl_type FROM mysql.user\G;"

## Dump all SQL requests

Edit the file `/etc/mysql/mysql.conf.d/mysqld.cnf`. Then set the configuration below:

    general_log = on
    general_log_file=/usr/log/general.log

The configuration lools something like:

    [mysqld]
    pid-file    = /var/run/mysqld/mysqld.pid
    socket      = /var/run/mysqld/mysqld.sock
    datadir     = /var/lib/mysql
    log-error   = /var/log/mysql/error.log
    # By default we only accept connections from localhost
    # bind-address  = 127.0.0.1
    # Disabling symbolic-links is recommended to prevent assorted security risks
    symbolic-links=0
    general_log = on
    general_log_file=/tmp/sql.debug

Then restart the server:

    service mysql restart





