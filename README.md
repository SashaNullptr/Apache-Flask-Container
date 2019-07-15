# Apache2 Flask Container

## What is this repo?

A Docker file for  hosting Flask apps with apache2 acting as the HTTP server.


## Run The Docker Image

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
