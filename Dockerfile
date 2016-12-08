FROM debian:jessie
MAINTAINER Tim Izzo - Octree <tim@octree.ch>

RUN apt-get update && apt-get install -y wget
RUN echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list
RUN wget https://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg
RUN apt-get update && apt-get install -y apache2 php php-curl php-tidy php-gd
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN a2enmod rewrite

ADD apache2.conf /etc/apache2/apache2.conf
ADD default-site.conf /etc/apache2/sites-enabled/000-default.conf

ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

EXPOSE 80
VOLUME /var/www/html

CMD /etc/init.d/apache2 start && tail -f /var/log/apache2/*

