from ubuntu 

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common
RUN DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:chris-lea/redis-server

RUN apt-get update  
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade 

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2  build-essential python python-prettytable python-bs4 wget curl php5 libapache2-mod-php5 php-pear php5-mysql php5-curl php5-gd php5-mcrypt php5-intl php5-apcu mysql-server-5.6 mysql-client-5.6 git vim php5-cli wget zip redis-server
RUN DEBIAN_FRONTEND=noninteractive curl -sS http://files.magerun.net/n98-magerun-latest.phar -o n98-magerun.phar
RUN DEBIAN_FRONTEND=noninteractive chmod +x ./n98-magerun.phar
RUN DEBIAN_FRONTEND=noninteractive mv ./n98-magerun.phar /usr/bin/magerun
RUN DEBIAN_FRONTEND=noninteractive php5enmod mcrypt
RUN DEBIAN_FRONTEND=noninteractive a2enmod rewrite

RUN DEBIAN_FRONTEND=noninteractive curl -sS https://getcomposer.org/installer | php
RUN DEBIAN_FRONTEND=noninteractive mv composer.phar /usr/local/bin/composer

ADD ./startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh


EXPOSE 80
EXPOSE 3306

VOLUME ["/var/www/html"]
CMD ["/bin/bash","/usr/local/bin/startup.sh"]
