#!/bin/bash

  mysqld_safe &

  until mysqladmin ping --silent
  do
          sleep 2
  done

if [ ! -d "/var/lib/mysql/mysql" ]; then

mysql -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

fi

mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' \
    /etc/mysql/mariadb.conf.d/50-server.cnf

exec mysqld_safe

