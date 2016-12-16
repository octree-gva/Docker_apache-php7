FROM debian:jessie
MAINTAINER Octree <sysadmin@octree.ch>

# Installation des paquets
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update && apt-get -qqy install sudo wget lynx telnet \
	nano curl make git-core locales bzip2 apache2 php5-cli libapache2-mod-php5 \
	php5-mysqlnd php5-mcrypt php5-tidy php5-curl php5-gd vim \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Importation de la configuration de Apache
COPY apache2.conf /etc/apache2/apache2.conf
COPY default-site.conf /etc/apache2/sites-enabled/000-default.conf
COPY default-php.ini /etc/php5/apache2/php.ini

# Configuration de Apache
RUN a2enmod rewrite
RUN a2enmod headers

# Création du dossier source
RUN rm -rf /var/www/html/*
WORKDIR /var/www/html
VOLUME /var/www/html

EXPOSE 80

CMD chown -R www-data:www-data /var/www/html && \
	/etc/init.d/apache2 start && \
		tail -f /var/log/apache2/*

