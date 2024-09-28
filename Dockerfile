FROM ubuntu:latest

RUN apt-get update
RUN apt-get --assume-yes upgrade
RUN apt install tor --assume-yes
RUN apt install nginx --assume-yes

# Update the torrc file to uncomment the following lines
#  HiddenServiceDir /var/lib/tor/my_website/
# HiddenServicePort 80 127.0.0.1:80
RUN sed -i 's;#HiddenServiceDir /var/lib/tor/hidden_service/;HiddenServiceDir /var/lib/tor/hidden_service/;' /etc/tor/torrc
RUN sed -i 's;#HiddenServicePort 80 127.0.0.1:80;HiddenServicePort 80 127.0.0.1:80;' /etc/tor/torrc


# Remove default nginx config
RUN rm -vf /etc/nginx/nginx.conf
RUN rm -vf /etc/nginx/sites-{available,enabled}/default

# Redirect stdout and stderr to corresponding nginx logs
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Create the directory to host our service files
RUN mkdir -p /var/www/hiddenservice

# Create a volume mapped from host machine
VOLUME /var/www/hiddenservice

# Create a volume to read the private key from
VOLUME /secret


COPY nginx/nginx.conf /etc/nginx/
COPY nginx/hiddenservice.conf /etc/nginx/sites-available/hiddenservice.conf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
