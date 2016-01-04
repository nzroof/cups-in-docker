FROM debian:sid

MAINTAINER Graeme Gellatly "graemeg@roof.co.nz"

# Install cups
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

RUN apt-get install -y\
    cups\
    cups-bsd\
    cups-pdf\
    locales\
    sudo\
    whois\

# Install all drivers
RUN apt-get install -y printer-driver-all
# Install HP drivers
RUN apt-get install -y hpijs-ppds hp-ppd hplip

# Setup UTF-8 locale
RUN sed -i "s/^#\ \+\(en_US.UTF-8\)/\1/" /etc/locale.gen
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8 ENV LC_ALL en_US.UTF-8 ENV LANGUAGE en_US:en

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mkdir /var/lib/apt/lists/partial

# Disbale some cups backend that are unusable within a container
RUN mv /usr/lib/cups/backend/parallel /usr/lib/cups/backend-available/ &&\
    mv /usr/lib/cups/backend/serial /usr/lib/cups/backend-available/ &&\
    mv /usr/lib/cups/backend/usb /usr/lib/cups/backend-available/

ADD etc-cups /etc/cups
RUN mkdir -p /etc/cups/ssl
VOLUME /etc/cups/
VOLUME /var/log/cups
VOLUME /var/spool/cups
VOLUME /var/cache/cups

ADD etc-pam.d-cups /etc/pam.d/cups

EXPOSE 631

ADD start_cups.sh /root/start_cups.sh
RUN chmod +x /root/start_cups.sh
CMD ["/root/start_cups.sh"]
