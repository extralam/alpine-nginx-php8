# Docker PHP-FPM 8 & 8.1 & Nginx 1.20 on Alpine Linux

* Built on the lightweight and secure Alpine Linux distribution
* Very small Docker image size 
* Uses PHP 8 for better performance, lower CPU usage & memory footprint
* Optimized for 100 concurrent users
* Optimized to only use resources when there's traffic (by using PHP-FPM's on-demand PM)
* The servers Nginx, PHP-FPM and supervisord run under a non-privileged user (nobody) to make it more secure
* The logs of all the services are redirected to the output of the Docker container (visible with `docker logs -f <container name>`)
* Follows the KISS principle (Keep It Simple, Stupid) to make it easy to understand and adjust the image to your needs

![nginx 1.18.0](https://img.shields.io/badge/nginx-1.18-brightgreen.svg)
![php 8](https://img.shields.io/badge/php-8-brightgreen.svg)
![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)

### Versioning
| Docker Tag | Git Release | Nginx Version | PHP Version | Alpine Version |
|-----|-------|-----|--------|--------|
| latest/8.1.1 | Master Branch |1.20.0 | 8.1.1 | 3.15 |
| 8.1.0 | - |1.20.0 | 8.1.0 | 3.15 |
| 8.1.0RC6 | - |1.20.0 | 8.1.0RC6 | 3.14 |
| 8.0.13 | - |1.18.0 | 8.0.13 | 3.14 |
| release-8.0.6 | - |1.18.0 | 8.0.6 | 3.12 |


### Includes

* Composer
* WP-CLI
* GD2
* Various other extensions (like SimpleXML)
* MySQL CLI

This image is built on GitHub actions and hosted on the GitHub Docker images repo. It is also available under `extralam/alpine-nginx-php8` on [Docker Hub](https://hub.docker.com/r/extralam/alpine-nginx-php8).

### Usage

Fetch the prebuilt image in your custom images:

Docker Hub:

```
docker pull extralam/alpine-nginx-php8
```

GitHub:
```
docker pull docker.pkg.github.com/extralam/alpine-nginx-php8/alpine-nginx-php8
```

If you get "no basic auth credentials", see [this page](https://docs.github.com/en/free-pro-team@latest/packages/using-github-packages-with-your-projects-ecosystem/configuring-docker-for-use-with-github-packages).

#### Start Nginx, PHP and MySQL via docker-compose

This is convenient for developing Laravel, WordPress or Drupal sites. It includes MySQL and phpMyAdmin

```
docker-compose up
```

Now you can access your site at http://localhost:8080 and the MySQL database at `db:3306`.

The folder `./src-compose` will be created and you can put your project files there.

The urls are:
* Web: http://localhost:80
* phpMyAdmin: http://localhost:8081

###### File permission issues

If you copied files into `./src-compose` you need to run:

```
sudo chown -R nobody:nogroup ./src-compose
sudo chmod -R 777 ./src-compose
```

This makes sure that the files have the correct owner inside the container but remain writable outside of it.

#### Quick build / run

```
docker build . -t php 
docker run -p 80:80 -t php
```

Go to:  
http://localhost/

## Configuration
In [config/](config/) you'll find the default configuration files for Nginx, PHP and PHP-FPM.
If you want to extend or customize that you can do so by mounting a configuration file in the correct folder.

## Acknowledgements

This image was inspired by [TrafeX/docker-php-nginx](https://github.com/TrafeX/docker-php-nginx) and [this subsequent fork](https://github.com/khromov/docker-php-nginx).
