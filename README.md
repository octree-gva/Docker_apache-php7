# Usage

In first place, you have to build the image :

```bash
git clone https://github.com/octree-gva/Docker_apache-php7.git && cd Docker_apache-php7
docker build -t octree/apache .
```

Then, you can run it and mapping your files :

```bash
docker run -d -p 8080:80 --name my_app -v $PWD/dist:/var/www/html octree/apache
```

- `-d` : Run the container in background. You can see logs with `docker logs -f my_app`.
- `-p 8080:80` : Map the listening port on `localhost:8080`.
- `-v $PWD/dist:/var/www/html` : Provide your local files to the Apache server.

## Database

It could be useful to bind a database to your app. To do so, run a database container :

```bash
docker run -d --name my_db -e MYSQL_ROOT_PASSWORD=my-secret-pw mariadb
```

Then, bind it with your app container :

```bash
docker run -d --link my_db:mysql -p 8080:80 --name my_app -v $PWD/dist:/var/www/html octree/apache-php7
```

> You have to run the database container before the app container.

The database will be accessible in your app container with the hostname `mysql`. 

# Customization

## Add php extentions

The image comes with some default php extensions. If you want to add more extensions, you can add them to the Dockerfile.

Then, re-build the image.

## Modify Apache configuration

In this repository, you can find two configuration files used by the image.

- `apache2.conf`: Global configuration of Apache
- `default-site.conf`: configuration for the default enabled site in Apache.
- `default-php.ini`: configuration for php

You can modify them as you wish and re-build the image.

## Configure the database

According to the [documentation of the mariadb image](https://hub.docker.com/_/mariadb/), you can configure the database with env variables while you running it.

To create a database and an associated user :

```bash
docker run -d \
	-e MYSQL_ROOT_PASSWORD=my_root_secret_pw \
	-e MYSQL_DATABASE=my_app_db \
	-e MYSQL_USER=my_user \
	-e MYSQL_PASSWORD=my_user_secret_pw \
	--name my_db mariadb
```

# Pack your app

If you need to have a packaged image that contains all of your files, you can add this line to the Dockerfile :

```dockerfile
ADD ./dist /var/www/html
```

And build the image.

```bash
docker build -t my_app_image .
```

Then, it's easy to deploy your app because it's not even necessary to map your file in the container.

