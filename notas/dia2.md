
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

# Kubernetes

# En kubernetes no se pueden configurar contenedores, sino pods

# Qué es un POD?

Un conjunto de contenedores que:
- Comparten configuración de red... Y por tanto se pueden hablar entre si mediante: localhost
- Se despliegan en la misma máquina 
- Escalan juntos
- Pueden compartir volumenes locales

# Escenario 1: Instalación de wordpress

- Mysql
- Wordpress (apache+php)

Los quiero en 2 pods o en 1 pod? 
    En un pod: Mala decisión 
        - Comparten configuración de red.... Me interesa eso? Bueno
        - Se despliegan en la misma maquina... Me interesa eso? No aporta nada... al contrario
        - Escalan juntos? Me interesa eso? .... NI DE COÑA !!!!!!!!
    Cada uno en su pod... 2 pods.

# Escenario 2: Instalación de servidores web
 
 Apache ---> access_log < ---- filebeat / fluent
  ^                             ^
  C1                            C2
  
En el mismo pod o en distintos pods?
    En un pod:  GENIAL !
        - Comparten configuración de red.... Me interesa eso? Nada... no me molesta ni me aporta... no hay comunicación de red
        - Se despliegan en la misma maquina... Me interesa eso? MONTONON: Tener un volumen compartido RAM
        - Escalan juntos? Me interesa eso? .... POR SUPUESTO: Cada Apache lleva su filebeat... chupando rueda... peago al culo!
                                                Filebeat es un SIDECAR del Apache
        - Pueden compartir volumenes locales? PUES CLARO !

########################################################################################################################
#               Arquitectura de red de kubernetes
########################################################################################################################

Supermercado                                                                    Cluster de Kubernetes
    Carnicería                                                                  Servicio
        Sacar numero: Pantalla / Altavoz                                        Balanceador de carga
        Nevera / Mostrador                                                      Volumen
            Productos: Carne                                                        Datos
        Puesto de trabajo 1:                                                    Maquina donde corren los procesos/contenedores
            Cuchillos                                                               CPU
            tabla                                                                   RAM
            báscula                                                                 GPU
            Carnicero1                                                          Pods... contenedores
        Puesto de trabajo 2:
            Carnicero2
    Pescadería                                                                  Servicio
    Frutería
    Cajas
        Fila única... PANTALLA                                                  Balanceador de carga
        Puesto de trabajo:
            Caja con monedas, cinta transportadora
            Cajero
    Puertas clientes                                                            Proxy reverso - IngressController - Router (OpenShift)
    Puertas mercancias
    Puerta de personal
    CARTELES: Informan de donde están los servicios                             DNS
    Gerente del supermercado                                                    Kubernetes
        Perfil de un empleado                                                   Imagen de contenedor
YO -> Productos: Datos

Se parece eso a la tienda de ultramarinos de la esquina, la que lleva el tio Pere !     Docker

# Cómo se llaman esas cosas en Kubernetes: TIPOS DE OBJETOS EN KUBERNETES

## POD

Conjunto de contenedores que .....
Sabeis cuántos pods vamos a crear en un cluster de Kubernetes? NINGUNO !
No creamos pods en el cluster de Kubernetes. Nadie crea pod en el cluster de kubernetes

Pero si vamos a tener muchos pods ahí dentro del cluster... pues si nosotros no creamos esos pods... quien los creará?
Kubernetes... al fin y al cabo es su cluster... "El cluster de Kubernetes"

Nosotros le damos instrucciones a Kubernetes para que cree pods. Y eso lo hacemos a través de:

## DEPLOYMENT

Plantilla de POD + Número de replicas

## STATEFULSET

Plantilla de POD + Plantilla de Peticion De Volumen persistente + Número de replicas

## DAEMONSET

Plantilla de POD (Kubernetes se asegura que tenga un pod creado desde esa plantilla en cada nodo del cluster).

Nosotros los usamos poco... por no decir nada!
Se usan para cosas más de infraestructura (administradores del cluster)

## SERVICE

Una entrada en el DNS de kubernetes + ALGO MAS QUE OS CUENTO MAÑANA: IP de balanceo de carga

---------------------------------------------- Red de la empresa
| Cluster de Producción
||==IP(M1,VM1)==Maquina 1
||-------IP_PA1_1----- Pod Apache App1 - 1
||
||==IP(M2,VM2)==Maquina 2
||-------IP_BBDD------ Pod BBDD
||
||==IP(M3,VM3)==Maquina 3
||-------IP_PA1_2----- Pod Apache App1 - 2
||
||==IP(M4,VM4)==Maquina N
||
||- Servidor de DNS
        basedatos = IP_BBDD

Pregunta: Que configuración pongo en el Apache, para que pueda acceder a la BBDD? IP/HOST donde está la BBDD...
Cúal pongo? IP_BBDD? Funcionaría esto? Funcionaría GUAY !
                     Queremos esto?    NI DE COÑA ! Por qué? 
                     - Primero, que no conozco la IP
                     - Segundo, estoy en un entorno de HA, y en cuanto se mueva el POD, se le cambia la IP
Qué voy a necesitar? Un fqdn -> DNS