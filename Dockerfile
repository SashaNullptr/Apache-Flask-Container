FROM ubuntu:16.04

MAINTAINER Sasha Fox "sashanullptr@gmail.com"

# Ubuntu 16.04 doesn't have a repository for Python 3.6 by default but it is
# required by a few dependencies.
RUN apt-get update
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get update

# Install basic build requirements.
RUN apt-get install -y python3.6 python3.6-dev
RUN apt-get install -y python3-pip
RUN python3.6 -m pip install --upgrade pip

# Install HTTP Server
RUN apt-get install -y apache2 apache2-dev

# Install the python 3.6 version of mod-WSGI for apache2
# This will ensure that the python3.6 interpreter will be used by the WSGI process.
RUN python3.6 -m pip install mod_wsgi

COPY ./requirements.txt /app_files/requirements.txt

RUN python3.6 -m pip install -r /app_files/requirements.txt
# Append to end of apache2.conf
COPY ./apache2_files/apache2_addon.txt ./app_files/apache2_addon.txt
RUN cat ./app_files/apache2_addon.txt | tee -a /etc/apache2/apache2.conf >/dev/null

RUN a2enmod rewrite

# Since we'll be mapping things to 000-default.conf via docker volumes we need
# to enable and disable the site to trigger a refresh.
RUN a2dissite 000-default
RUN a2ensite 000-default

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

CMD apachectl -D FOREGROUND
