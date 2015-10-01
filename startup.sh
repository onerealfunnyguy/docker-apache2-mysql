#!/bin/bash
echo ">  base url: $BASE_URL"
/opt/elasticsearch/bin/elasticsearch &

if [ ! -f /usr/share/mysql/my-default.cnf ] ; then
     cp /etc/mysql/my.cnf /usr/share/mysql/my-default.cnf
fi 
mysql_install_db

echo 'starting mysql service...'
/usr/sbin/service mysql start

if [ ! -f /var/lib/mysql/libdata1 ]; then
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

	echo "GRANT ALL PRIVILEGES ON $BASE_URL.* TO akeneo_pim@localhost IDENTIFIED BY '$BASE_URL';" > /createdb.sql
	mysql < /createdb.sql
	
else
	/usr/bin/mysqld_safe
fi
echo "$SECURE_MYSQL" 

cp -f /var/www/html/000-default.conf /etc/apache2/sites-available/000-default.conf
cp -f /var/www/html/php.ini /etc/php5/apache2/php.ini

echo 'reboot apache service...' 
service apache2 restart

echo '...end of the startup !' 

tail -f /var/log/apache2/*.log > /var/www/html/logs-server.log
