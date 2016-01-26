from ubuntu 

RUN apt-get update  
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade 

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2  build-essential wget curl php5 libapache2-mod-php5 php-pear php5-mysql php5-curl php5-gd php5-mcrypt php5-intl php5-apcu mysql-server-5.6 mysql-client-5.6 git vim php5-cli wget zip

RUN DEBIAN_FRONTEND=noninteractive php5enmod mcrypt
RUN DEBIAN_FRONTEND=noninteractive a2enmod rewrite

ADD ./startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh


EXPOSE 80
EXPOSE 3306

VOLUME ["/var/www/html"]
CMD ["/bin/bash","/usr/local/bin/startup.sh"]
