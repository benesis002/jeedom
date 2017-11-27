FROM jeedom/jeedom:latest

MAINTAINER benesis002@outlook.com

RUN apt-get update
RUN apt-get -y dist-upgrade

# For Openzwave
RUN mkdir -p /tmp/jeedom/openzwave/
RUN git clone https://github.com/jeedom/plugin-openzwave.git /var/www/html/plugins/openzwave
RUN chmod +x /var/www/html/plugins/openzwave/resources/install_apt.sh
RUN /var/www/html/plugins/openzwave/resources/install_apt.sh
RUN mkdir -p /var/www/html/plugins/openzwave/data && \
  chown -R www-data.www-data /var/www/html/plugins/openzwave/data

#For Homebridge
RUN https://github.com/jeedom/plugin-homebridge.git /var/www/html/plugins/homebridge
RUN chmod +x /var/www/html/plugins/homebridge/resources/install_homebridge.sh
RUN /var/www/html/plugins/homebridge/resources/install_homebridge.sh
RUN mkdir -p /var/www/html/plugins/homebridge/data && \
  chown -R www-data.www-data /var/www/html/plugins/homebridge/data

RUN echo "service dbus start" >> /root/init.sh
RUN echo "avahi-daemon &" >> /root/init.sh
