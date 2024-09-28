#!/bin/bash

mkdir -p /var/lib/tor/hidden_service/
cp /secret/* /var/lib/tor/hidden_service/

chown debian-tor:debian-tor -R /var/lib/tor/hidden_service/
chmod 700 -R /var/lib/tor/hidden_service/

/etc/init.d/tor start &&\
onion="$(cat "/var/lib/tor/hidden_service/hostname")"
cp /var/lib/tor/hidden_service/* /secret/
cd /etc/nginx/sites-enabled &&\
ln -sf ../sites-available/hiddenservice.conf &&\
sed -i "s/YOUR_HIDDEN_SERVICE_HERE.onion;/$onion;/" hiddenservice.conf &&\
nginx -t &&\
echo -e "\n***** $onion *****\n" &&\
echo "$onion" > /var/www/hiddenservice/hostname &&\
nginx -g 'daemon off;'
