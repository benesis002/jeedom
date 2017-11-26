FROM debian:latest

MAINTAINER benesis002@outlook.com

ENV SHELL_ROOT_PASSWORD Mjeedom96

RUN apt-get update && apt-get install -y wget openssh-server supervisor mysql-client

RUN echo "root:${SHELL_ROOT_PASSWORD}" | chpasswd && \
  sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
  sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

RUN mkdir -p /var/run/sshd /var/log/supervisor
RUN rm /etc/motd
ADD https://raw.githubusercontent.com/jeedom/core/master/install/motd /etc/motd
RUN rm /root/.bashrc
ADD https://raw.githubusercontent.com/jeedom/core/master/install/bashrc /root/.bashrc
ADD https://raw.githubusercontent.com/jeedom/core/master/install/OS_specific/Docker/supervisord.conf /etc/supervisor/conf.d/supervisord$

ADD https://raw.githubusercontent.com/jeedom/core/master/install/install.sh /root/install_docker.sh
RUN chmod +x /root/install_docker.sh
RUN /root/install_docker.sh -s 1;exit 0
RUN /root/install_docker.sh -s 2;exit 0
RUN /root/install_docker.sh -s 4;exit 0
RUN /root/install_docker.sh -s 5;exit 0
RUN /root/install_docker.sh -s 7;exit 0
RUN /root/install_docker.sh -s 10;exit 0

# For Openzwave
RUN mkdir -p /tmp/jeedom/openzwave/dependance
RUN git clone https://github.com/jeedom/plugin-openzwave.git /var/www/html/plugins/openzwave
RUN chmod +x /var/www/html/plugins/openzwave/resources/install_apt.sh
RUN /var/www/html/plugins/openzwave/resources/install_apt.sh
RUN mkdir -p /var/www/html/plugins/openzwave/data && \
  chown -R www-data.www-data /var/www/html/plugins/openzwave/data

# Droit root
RUN echo "www-data ALL=(ALL) NOPASSWD: ALL" | (EDITOR="tee -a" visudo)

ADD https://raw.githubusercontent.com/jeedom/core/master/install/OS_specific/Docker/init.sh /root/init.sh
RUN chmod +x /root/init.sh
CMD ["/root/init.sh"]
