#!/bin/bash

#!/bin/sh
if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters use run-server.sh <instance_name>"
    return;
fi


docker stop $1
docker rm $1
docker run -d --name $1 -v /data/$1/html/:/var/www/html/ --env BASE_URL="$1" -v /data/$1/mysql/:/var/lib/mysql pierrefay/apache2-mysql

cp /etc/hosts /etc/hosts_sav
sed -i -e "/$1/d" /etc/hosts
CONTAINER_ID=$(docker ps | grep "$1 "| awk '{print $1}')
IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTAINER_ID)
echo "$IP www.$1.lan"
