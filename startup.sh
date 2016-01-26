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


if [ ! -f /usr/share/mysql/my-default.cnf ] ; then
     cp /etc/mysql/my.cnf /usr/share/mysql/my-default.cnf
fi 

if [ ! -f /var/lib/mysql/libdata1 ]; then

	mysql_install_db
	cd /usr ; /usr/bin/mysqld_safe &

	echo 'user configuration in the database...'  
	MYSQL_ROOT_PASSWORD=""
	SECURE_MYSQL=$(expect -c "
	set timeout 10
	spawn mysql_secure_installation
	expect \"Enter current password for root (enter for none):\"
	send \"$MYSQL\r\"
	expect \"Change the root password?\"
	send \"n\r\"
	expect \"Remove anonymous users?\"
	send \"n\r\"
	expect \"Disallow root login remotely?\"
	send \"n\r\"
	expect \"Remove test database and access to it?\"
	send \"n\r\"
	expect \"Reload privilege tables now?\"
	send \"y\r\"
	expect eof
	")

	echo "CREATE DATABASE IF NOT EXISTS $BASE_URL" > /createdb.sql
	mysql < /createdb.sql

	echo "CREATE USER 'pfay'@'localhost' IDENTIFIED BY 'pfay123'; "; > /createdb.sql
	mysql < /createdb.sql

	echo "GRANT ALL PRIVILEGES ON $BASE_URL.* TO pfay@localhost IDENTIFIED BY 'pfay123';" > /createdb.sql
	mysql < /createdb.sql
	
else
	cd /usr ; /usr/bin/mysqld_safe &
fi
echo "$SECURE_MYSQL" 

cp -f /var/www/html/000-default.conf /etc/apache2/sites-available/000-default.conf
cp -f /var/www/html/php.ini /etc/php5/apache2/php.ini
cp -f /var/www/html/envvars /etc/apache2/envvars
echo 'reboot apache service...' 
service apache2 restart
service mysql restart

echo '...end of the startup !' 

tail -f /var/log/apache2/*.log > /var/www/html/logs-server.log
