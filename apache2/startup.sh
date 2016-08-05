#!/bin/bash

echo ">  base url: $BASE_URL"


echo 'putting your personal config files...'
cp -f /var/www/html/000-default.conf /etc/apache2/sites-available/000-default.conf
cp -f /var/www/html/php.ini /etc/php5/apache2/php.ini
cp -f /var/www/html/envvars /etc/apache2/envvars

echo 'reboot apache service...' 
service apache2 restart

echo '...end of the startup !' 

tail -f /var/log/apache2/*.log > /var/www/html/logs-server.log
