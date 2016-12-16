#!/bin/sh

# Configuration
CLIENT_URL=yolo
CONTAINER_NAME=yolo
DB_CONTAINER_NAME=db_yolo
DB_ROOT_PASS=4gef2da1
DB_NAME=yolo
DB_USER=yolo
DB_PASS=y0l0

# Création des containers
## Base de données
docker run -d \
    -e MYSQL_ROOT_PASSWORD=$DB_ROOT_PASS \
    -e MYSQL_DATABASE=$CONTAINER_NAME \
    -e MYSQL_USER=$DB_USER \
    -e MYSQL_PASSWORD=$DB_PASS \
    --name $DB_CONTAINER_NAME mariadb
## Application
docker run -d --link $DB_CONTAINER_NAME:mysql \
	--name $CONTAINER_NAME \
	-p 8080:80 \
	-v $PWD:/var/www/html octree/apache
