# Firefox over VNC
#
# VERSION               0.1
# DOCKER-VERSION        0.2

FROM ubuntu:16.04

# make sure the package repository is up to date
RUN	echo "deb http://archive.ubuntu.com/ubuntu xenial main universe" > /etc/apt/sources.list
RUN	apt-get update

# Install vnc, xvfb in order to create a 'fake' display and firefox
RUN	apt-get install -y x11vnc xvfb openbox dwm supervisor

# Install the specific tzdata-java we need
RUN apt-get -y install wget
RUN wget --no-check-certificate http://archive.ubuntu.com/ubuntu/pool/main/t/tzdata/tzdata_2021a-0ubuntu0.16.04_all.deb
RUN dpkg -i tzdata_2021a-0ubuntu0.16.04_all.deb

# Install Firefox and Java Plugins
RUN apt-get install -y firefox icedtea-8-plugin icedtea-netx openjdk-8-jre openjdk-8-jre-headless hsetroot
RUN	mkdir ~/.vnc
RUN apt-get install -y curl unzip
RUN curl -OL https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.zip && unzip v1.4.0.zip && mv noVNC-1.4.0 /opt
RUN curl -OL https://github.com/novnc/websockify/archive/refs/tags/v0.11.0.zip && unzip v0.11.0.zip && mv websockify-0.11.0 /opt/noVNC-1.4.0/utils/websockify


# Reduce java security so Avocents will work
# RUN sed -i 's/^jdk.certpath.*/jdk.certpath.disabledAlgorithms=MD2/g' /etc/java-8-openjdk/security/java.security
# RUN sed -i 's/^jdk.tls.disabledAlgorithms.*/jdk.tls.disabledAlgorithms=SSLv3/g' /etc/java-8-openjdk/security/java.security
# RUN bash -c 'echo "hsetroot -solid \"#5C066D\"" >> /etc/X11/openbox/autostart'

# Autostart firefox (might not be the best way to do it, but it does the trick)
# RUN bash -c 'echo "exec openbox-session &" >> ~/.xinitrc'
RUN bash -c 'echo "exec dwm &" >> ~/.xinitrc'
RUN	bash -c 'echo "firefox --kiosk" >> ~/.xinitrc'
RUN bash -c 'chmod 755 ~/.xinitrc'
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# VOLUME /home/www/Downloads
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]


