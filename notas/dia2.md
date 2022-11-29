
# Contenedor

Entorno aislado donde ejecutar procesos dentro de un SO ( normalmente Linux).

Aislado???
- Su propia configuración red
- Su propio sistema de archivos
- Sus propias variables de entorno
- Podría tener limitaciones de acceso al HW

Los contenedores se crean desde IMAGENES DE CONTENEDOR

# Imagenes de contenedores

Es un fichero comprimido (tar) con:
- Una app YA INSTALADA
- Dependencias, librerias YA INSTALADAS que mi app pueda necesitar
- Y otras que sean de utilidad

Además, se incluyen algunas configuraciones acerca de la imagen, y los programas que hay dentro.

Las imágenes las encontrábamos en Registries de repos de imágenes de contenedor:
- Docker hub

Como se identifica una imagen de contenedor:
- Repository
    - Registry ? Opcional
    - Id = Nombre del software que vamos a instalar
- Tag ~= Versión del software que se encuentra dentro de la imagen
 
Al crear un contenedor, se le dota de un sistema de archivos (filesystem)... y cómo se montaba ese fs?
Tiene capas... al menos 2:
- Capas (n) - Volumenes - Punto de montaje en el fs del contenedor que apunta a un almacenamiento interno/externo
- Capa 1 - Capa contenedor - Recoge los cambios al fs . Al borrar el contenedor se elimina.
- Capa 0 - Capa imagen - Inalterable

Para qué sirven los volumenes:
- Persistencia de los datos del contenedor tras su borrado
- Compartir datos entre contenedores
- Inyectar ficheros/carpetas al fs del contenedor

Existen unos cuantos gestores de contenedores en el mercado:
- Docker
- Containerd
- CRIO
- Podman : Manager de pods

# Docker:

A la hora de trabajar, teníamos un cliente llamado "docker" cuya estructura de comandos era bastante sencilla:

$ docker [TIPO_OBJETO] [VERBO] <args>
            image       pull                    docker pull
                        push                    docker push
                        list                    docker images
                        rm                      docker rmi
                        inspect 
            container   create
                        attach
                        exec
                        rm
                        logs
                        start
                        stop
                        restart
                        inspect

docker run :            Normalmente se usa SOLO cuando creamos contenedores de un solo uso.
    image pull
    container create
    container start
    container attach
    

# Redes

## NIC 

Dispositivo para conectarnos a una red: Network Interface Card

## Interfaz de red

Qué es? Nos da acceso a una red... desde el punto de vista del SO. Abstracción sobre las NICs

Cuantas interfaces de red tiene una computadora?
- Red virtual interna a la máquina. Loopback. 127.0.0.1 -> localhost
    - Comunicar internamente procesos que tengo en mi computadora
- Interfaz de ethernet  172.31.16.180


Computadora A
    NIC 1       - IF 1 ----- Ethernet 1
    NIC 2       - IF 2 ----- Ethernet 2
    
Computadora A
    NIC 1       --- IF 1 -- Ethernet 1 ... con la misma IP... como si fuesen solo 1 NIC
    NIC 2       --/

Computadora A
    NIC 1       ----IF1- Ethernet 1... IP 1
                  \-IF2- Ethernet 1... Tiene su propia IP aquí abajo: IP 2
    
    -------------------------Red de Amazon---------------------------------
    |                                                                   |
172.31.16.180:8080                                                      IP ?
    |           ---> Puerto 80 : 172.17.0.2                             |
  IvanPC                                                              MenchuPC
  |
  |- 127.0.0.1- Loopback 
  |
  |- 172.17.0.1 - Docker --- 172.17.0.2 --- Contenedor nginx
                                            Abre el puerto 80

# Sobre las imágenes de contenedor

Hemos dicho que una imagen contiene un software ya instalado.... pero... 
podría ser que yo quisiera "PARAMETRIZAR" esa instalación... o al menos su ejecución.

Monto una BBDD.. Pero y la contraseña del usuario administrador de la BBDD??

Las imágenes de contenedor suelen admitir cierta parametrización


# Wordpress

Montar un sitio web: Programado en php
Corre encima de un Apache, Nginx
BBDD

El puerto externo que tiene que quedar expuesto es el 8080


# YAML 

ML -> Markup Language
GNU:GNU is Not UNIX
YAML -> YAML ain't Markup Language

YA < - Yet another

Es un lenguaje de marcado de información: 

De proposito general: XML, SGML, JSON
De dominio especifico: HTML

Hoy en día YAML se ha comido JSON... LITERALMENTE !

# Docker compose

Es un cliente alternativo a dockerd.

Su ventaja radica en usar un lenguaje DECLARATIVO para definir los contenedores.
Ese mismo concepto lo encontraremos en Kubernetes y Openshift, Ansible, Puppet, Terraform 


# Lenguaje imperativo
Felopín, IF "ALGO" debajo de la ventana:
                QUITA "ALGO"
Felopín, IF silla == null:
                Vete al IKEA a por SILLA
Felipin, Pon la silla debajo de la ventana !

Felipin, Quiero una silla debajo de la ventana      No le digo el cómo... ES SU PROBLEMA !!!
Felipin, Debe haber una silla debajo de la ventana 

# No nos gusta el lenguaje imperativo.... sobre todo disponiendo de lenguaje declarativo

# Entornos de producción:

- Alta disponibilidad
- Escalabilidad