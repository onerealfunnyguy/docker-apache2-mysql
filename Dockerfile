from ubuntu 

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common

RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade 


RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 php5 libapache2-mod-php5 php-pear build-essential php5-mongo php5-mysql php5-curl php5-gd php5-mcrypt php5-intl php5-apcu mysql-server-5.6 mysql-client-5.6 git curl vim php5-cli wget zip openjdk-7-jre mongodb-server

RUN DEBIAN_FRONTEND=noninteractive php5enmod mcrypt
RUN DEBIAN_FRONTEND=noninteractive a2enmod rewrite

RUN DEBIAN_FRONTEND=noninteractive wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.1.zip
RUN DEBIAN_FRONTEND=noninteractive unzip elasticsearch-1.7.1.zip 
RUN DEBIAN_FRONTEND=noninteractive mv -f elasticsearch-1.7.1 /opt/elasticsearch

RUN DEBIAN_FRONTEND=noninteractive curl -sS https://getcomposer.org/installer | php
RUN DEBIAN_FRONTEND=noninteractive mv composer.phar /usr/local/bin/composer

ADD ./startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

EXPOSE 80
EXPOSE 3306

VOLUME ["/var/www/html"]
CMD ["/bin/bash","/usr/local/bin/startup.sh"]
