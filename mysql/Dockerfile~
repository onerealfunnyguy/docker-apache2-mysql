from ubuntu:latest

RUN apt-get update  
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget expect vim

RUN DEBIAN_FRONTEND=noninteractive wget https://dev.mysql.com/get/mysql-apt-config_0.7.3-1_all.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.7.3-1_all.deb

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install mysql-server mysql-client

ADD ./startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

EXPOSE 3306
VOLUME ["/var/lib/mysql"]

CMD ["/bin/bash","/usr/local/bin/startup.sh"]
