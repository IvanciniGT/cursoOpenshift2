
# Montar un contenedor con el MySQL
## Descargar la imagen
docker pull mysql:8.0
## Crear contenedor
docker container create \
    --name mimysql \
    -e MYSQL_ROOT_PASSWORD=password \
    -e MYSQL_DATABASE=mibd \
    -e MYSQL_USER=usuario \
    -e MYSQL_PASSWORD=password \
    -v /home/ubuntu/environment/datos/mysql:/var/lib/mysql \
    -p 172.17.0.1:3307:3306 \
    mysql:8.0
## Arrancarlo
docker start mimysql
# docker logs mimysql

# Montar un contenedor con el Wordpress
## Descargar la imagen
docker pull wordpress:php8.1-apache # Mejor una imagen con apache ya montao!
## Crear contenedor
docker container create \
    --name miwp \
    -e WORDPRESS_DB_HOST=172.17.0.1:3307 \
    -e WORDPRESS_DB_USER=usuario \
    -e WORDPRESS_DB_PASSWORD=password \
    -e WORDPRESS_DB_NAME=mibd \
    -v /home/ubuntu/environment/datos/wp:/var/www/html \
    -p 8080:80 \
    wordpress:php8.1-apache
## Arrancarlo
docker start miwp

