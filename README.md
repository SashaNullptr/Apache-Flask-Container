# Apache2 Flask Container

## What is this repo?

A template for hosting Flask apps with Apache2 acting as the HTTP server.

## Outline

The Dockerfile works by copying Flask app project files directly into the
container and installing dependencies at build time.

## Build Arguments

The Dockerfile needs to know where core app files are located so they can be
copied onto the container. Project files are specific via build arguments. The
following *must* be specified at build time.

| Argument        | Description                               |
|-----------------|-------------------------------------------|
| APP_ROOT_DIR    | Project root directory                    |
| FLASK_ROOT_FILE | Root Flask app Python file                |
| WSGI_FILE       | WSGI file that references FLASK_ROOT_FILE |
| APACHE_CONF     | Apache2 `.conf` file                       |

For example if our Flask app had the following layout:

```shell
.
├── Dockerfile
├── apache2_files
│   └── app.conf
│   └── app.wsgi
├── example_app
│   ├── __init__.py
│   └── ...
├── flask_app.py
```

We'd want our build args set up like so:

| Argument        | File Path                |
|-----------------|--------------------------|
| APP_ROOT_DIR    | ./example_app            |
| FLASK_ROOT_FILE | ./flask_app.py           |
| WSGI_FILE       | ./apache2_files/app.wsgi |
| APACHE_CONF     | ./apache2_files/app.conf |

## Build The Docker Image

Using the example project layout given above we'd build our container
as follows

``` shell
docker build -dt \
  --build-arg APP_ROOT_DIR="./example_app" \
  --build-arg FLASK_ROOT_FILE="./flask_app.py" \
  --build-arg WSGI_FILE="./apache2_files/app.wsgi" \
  --build-arg APACHE_CONF="./apache2_files/app.conf" \
  --name flask-app \
  .
```

## Run The Docker Image

The only thing that really needs to be handled when running the resulting container is port
mapping. Port 80 is exposed by default and if there's a desire to map this to an
alternate port on the host that needs to be handled with the `-p` run flag.

``` shell
docker run -dt \
  -p 5000:80 \
  --name flask-app \
  --restart=always \
  flask-app
```

## Example Docker-Compose File

Again assuming our project is laid out as in our example we could tie everything
together using a Docker-Compose file.

```yaml
version: '2.2'
services:

  flask:
    restart: always
    image: flask_app:latest
    build:
      context: ./
      args:
        APP_ROOT_DIR: ./
        FLASK_ROOT_FILE: ./flask_app.py
        WSGI_FILE: ./apache2_files/app.wsgi
        APACHE_CONF: ./apache2_files/app.conf
    networks:
      - external_network
    healthcheck:
        test: curl --fail http://localhost:5000/ping || exit 1
        interval: 10s
        timeout: 2s
        retries: 5
    ports:
      - 5000:80

networks:
  external_network:
    driver: bridge
    ipam:
      driver: default

```

## Limitations

Only plain HTTP communication with the resulting app is supported "out of the box"
at the moment.

### Manually adding SSL Encryption

Here's an example of the steps required to _manually_ set up SSL certificates
through Let's Encrypt after a container is already provisioned and running.

``` shell
# Base Ubuntu Docker image cannot add PPA's by default
# We need to install software-properties-common in order to enable this functionality
apt-get install software-properties-common

add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install python-certbot-apache

certbot --apache -d $SITE_URL
# Select `app.conf` when prompted

a2enmod rewrite

# Set up cron job to handle automatic renewal of certificates.
(crontab -l 2>/dev/null; echo "15 3 * * * /usr/bin/certbot renew --quiet") | crontab -
```
