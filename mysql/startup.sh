#!/bin/bash

echo ">  base url: $BASE_URL"

MYSQL_ALLOW_EMPTY_PASSWORD=yes

useradd -r mysql -u 1000
usermod -G staff mysql

RUN sed -e 's/user.=.mysql/user=root/' -i /etc/mysql/my.cnf

TARGET_UID=$(stat -c "%u" /var/lib/mysql)
echo '-- Setting mysql user to use uid '$TARGET_UID
usermod -o -u $TARGET_UID mysql || true

TARGET_GID=$(stat -c "%g" /var/lib/mysql)
echo '-- Setting mysql group to use gid '$TARGET_GID
groupmod -o -g $TARGET_GID mysql || true

echo '* Starting MySQL' 
chown -R mysql:root /var/run/mysqld/

if [ ! -f /etc/mysql/my.cnf ] ; then
     cp /usr/share/mysql/my-default.cnf /etc/mysql/my.cnf 
fi 

chmod 777 -R /var/log/mysql/

service mysql restart

if [ ! -f /var/lib/mysql/libdata1 ]; then

	mysql_install_db

	echo "CREATE DATABASE IF NOT EXISTS $BASE_URL" > /createdb.sql
	mysql < /createdb.sql

	echo "CREATE USER 'pfay'@'localhost' IDENTIFIED BY 'pfay123'; "; > /createdb.sql
	mysql < /createdb.sql

	echo "GRANT ALL PRIVILEGES ON $BASE_URL.* TO pfay@localhost IDENTIFIED BY 'pfay123';" > /createdb.sql
	mysql < /createdb.sql
	
else
	cd /usr ; /usr/bin/mysqld_safe &
fi

service mysql restart

tail -f /var/log/*.log
