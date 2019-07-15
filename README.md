# Apache2 Flask Container

## What is this repo?

A Docker file for  hosting Flask apps with apache2 acting as the HTTP server.

## How Does This Container Work?

We need to map host app files to the following directories:

* App root directory `/var/www/app/`
* Flask root file `/var/www/app/flask_app.py`
* WSGI file `/var/www/app/flask_app.py`

## Run The Docker Image

### Using built-in `conf` file

```shell
docker run -dt \
  -v ./example_app:/var/www/app/example_app
  -v ./flask_app.py:/var/www/app/flask_app.py
  -v ./apache2_files/app.wsgi:/var/www/wsgi_scripts/app.wsgi
  -p 5000:80 \
  --name flask-app \
  --restart=always \
  sashanullptr/flask-apache
```


### Using a Custom `conf` file

```shell
docker run -dt \
  -v ./example_app:/var/www/app/example_app
  -v ./flask_app.py:/var/www/app/flask_app.py
  -v ./apache2_files/app.wsgi:/var/www/wsgi_scripts/app.wsgi
  -v ./apache2_files/app.conf:/etc/apache2/sites-available/000-default.conf
  -p 5000:80 \
  --name flask-app \
  --restart=always \
  sashanullptr/flask-apache
```
