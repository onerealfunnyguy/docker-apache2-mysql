from ubuntu:latest

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade 

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 build-essential wget curl php5 libapache2-mod-php5 php-pear php5-mysql php5-curl php5-gd php5-mcrypt php5-intl php5-apcu git vim php5-cli wget zip 

RUN DEBIAN_FRONTEND=noninteractive php5enmod mcrypt
RUN DEBIAN_FRONTEND=noninteractive a2enmod rewrite

RUN DEBIAN_FRONTEND=noninteractive wget https://dev.mysql.com/get/mysql-apt-config_0.7.3-1_all.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.7.3-1_all.deb

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install mysql-client

ADD ./startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

EXPOSE 80
EXPOSE 3306

VOLUME ["/var/www/html"]
CMD ["/bin/bash","/usr/local/bin/startup.sh"]
