FROM ubuntu:16.04

MAINTAINER Sasha Fox "sashanullptr@gmail.com"

# Ubuntu 16.04 doesn't have a repository for Python 3.6 by default but it is
# required by a few dependencies.
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

# Make directory for the app
RUN mkdir /var/www/example_app

COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip3 install -r requirements.txt

COPY . /app

# Set permissions for www directory
RUN chown -R www-data  /var/www
RUN chgrp -R www-data  /var/www
RUN chmod -R 755  /var/www
RUN chmod g+s  /var/www
# Set permissions for WSGI directory
RUN chmod -R 755 /var/www/wsgi_scripts

# Append to end of apache2.conf
COPY ./apache2_files/apache2_addon.txt
RUN cat ./apache2_files/apache2_addon.txt | sudo tee -a /etc/apache2/apache2.conf >/dev/null

# Add app .conf file to apache2's sites-available
COPY ./apache2_files/app.conf /etc/apache2/sites-available
# Disable default site
RUN a2dissite 000-default
# Enable app site
RUN a2ensite app
# Reload apache2
RUN service apache2 restart

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

CMD ["apachectl ", "-D", "FOREGROUND"]
