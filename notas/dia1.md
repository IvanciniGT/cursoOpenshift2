# Software

Para escribirlo uso un Lenguaje de programación.
    JAVA, C, C++, PYTHON ----> Traducirlo al lenguaje que habla el SO
                      Compilación
                      Interpretación (traducción entiempo real): Intérprete (el intérprete si depende del SO)
                            JAVA        JVM
                            PYTHON      cython

# Instalaciones de software

## Método clásico

            App 1 + App 2 + App 3           Problemas:  - Compartición de recursos:
    ---------------------------------                       App1 tiene un bug (100% CPU). .... App1 OFFLINE
             Sistema Operativo                                                                 App2 y App3 OFFILNE
    ---------------------------------                   - Incompatibilidad de Conf. SO
                  HIERRO                                - Incompatibilidad de librerias, frameworks, dependencias
                                                        - Seguridad

## Método basado en Máquinas virtuales

        App 1    |   App 2 + App 3          
    ---------------------------------       Problemas:  - Mayor complejidad en la configuración
         SO 1    |       SO 2                           - Desperdicio de los recursos de mi Hardware
    ---------------------------------                   - Peor rendimiento de las aplciaciones              
         MV1     |       MV2
    ---------------------------------                  
        Hipervisor: VMWare, Citrix
        Virtualbox, Hyperv, kvm
    ---------------------------------                  
            Sistema Operativo                              
    ---------------------------------                  
                HIERRO                              

## Método basado en Contenedores

        App 1    |   App 2 + App 3       
    ---------------------------------       
         C1      |       C2
    ---------------------------------                  
        Gestor de contenedores:
        Docker, ContainerD, Podman, 
        CRIO
    ---------------------------------                  
      Sistema Operativo (hab. LINUX)
    ---------------------------------                  
        HIERRO físico o virtual                        

# Contenedor

Los contenedores son una forma alternativa de "instalar"(desplegar) / ejecutar software.

> Un contenedor es un entorno aislado en el que ejecutar procesos dentro de un SO (Linux).
> Entorno aislado:
>>  Un contenedor tiene su propia configuración de red -> Su(s) propia(s) IP(s)
>>  Un contenedor tiene su propio sistema de archivos
>>  Un contenedor tiene sus propias variables de entorno
>>  Un contenedor puede tener limitaciones de acceso al hardware

Los contenedores se crean desde IMAGENES DE CONTENEDOR.

Los contenedores además, tienen una gran ventaja sobre las maquinas virtuales u otro tipo de técnicas de despliegue/ejecución de procesos:
- ESTAN ESTANDARIZADOS: HAY UN ESTANDAR: Cloud Native Computing foundation

Implicaciones:
- 1º Da igual el ejecutor de contenedores que use. 
     Cualquier cosa que esté en una imagen de contenedor, haya sido generada por la herramienta que sea, 
     funciona, en cualquier ejecutor de contenedores.
- 2º También está estandarizada la forma de operar con el software que tengo en un contenedor e imágenes de contenedor.

# Imagen de contenedor

Es un triste fichero comprimido (tar) que incluye:
- Una instalación de un software (o varias)
- Junto con otros programas que sean necesarios (YA INSTALADOS)
- Junto con otros programas que puedan ser de utilidad

Las imagenes de contenedor las encontramos en REGISTRIES DE REPOSITORIOS DE IMAGENES DE CONTENEDOR.
El más utilizado: 
- Docker hub
- QUAY.io       < Registry de REDHAT

Una imagen viene identificada por 3 conceptos:
- REPOSITORY
        - REGISTRY  Habitualmente no lo indicamos. Se toma el que haya configurado en el gestor de contenedores que usemos
        - REPO_ID   nginx
- TAG: Esto propiamente lo que identifica una IMAGEN DE CONTENEDOR:
    - latest            No... por qué? Es un tag variable.
    - 1.22.1            No... por qué? Porque si sale una versión que arregle bugs, me interesa.
    - 1.22              A la última 1.22 que haya en cada momento. ESTA ES LA GUAY PARA ENTORNOS DE PROD
    - 1                 A la última 1... que hoy podría ser la 1.22.7 y mañana la 1.23.1
     
- Versiones en software:    Cuándo incrementamos?
    - El primer 1: MAYOR        Al hacer un cambio de diseño, que puede implecar no retrocompatibilidad.
    - El 22:       MINOR        Al aumentar funcionalidad
    - El otro 1:   MICRO        Al arreglar bugs

- En un entorno de prod me interesa? 


## Imaginad que quiero instalar MS SQL Server en mi computadora:

1º Tener preparado el SO, con las configuraciones y dependencias necesarios
2º Descargar/Conseguir un instalador del software 
3º Instalar el software: Ejecutar ese instalador + Configuraciones -> Instalación de SQL Server
    c:\Archivos de programa\SQLServer  -> ZIP -> email
                                           v
                                           Imagen de contenedor

Linux es el Kernel de SO más usado del mundo?

Linux no es un SO... es un kernel de SO.
Que se usa en muchos SO:
    - GNU/Linux
        RHEL
        OpenSuse
        Debian -> Ubuntu
        Fedora
    - Android


Windows tiene kernel? Todos los SO tiene kernel.
Cuántos kernel ha tenido MS a lo largo de su historia? 2
- DOS -> MS-DOS, Windows 2, Windows 3, Windows 95, Windows 98, Windows Millenium
- NT  -> Windows NT, XP, Server, Windows 7, Windows 8 , Windows 10, Windows 11, Windows Server

### Tipos de software

- Sistema Operativo
- Aplicación        Un programa con una GUI pensado para interacturar con humanos.
------------------------------------------------ V Todo eso lo puedo meter en un contenedor
- Demonio           Un programa que corre en segundo plano... que no interactuan con nadie
    - Servicio      Cuando un demonio interactua con otros programas
- Driver
- Libreria
- Script
- Comando

El software de microsoft: SQL Server Database

.net Framework -> .net core ( con ejecución sobre linux)
C++
VB
ASP
C#

# Quiero instalar un servidor web, en la máquinita que hemos contradado en AMAZON, que tiene UBUNTU (kernel Linux)

Apache httpd -> nginx
Nginx por defecto funciona en que puerto? 80

curl http://IP:80

# Docker

Gestor de contenedores / imágenes de contenedor

cliente docker es un comando que ejecutamos con la siguiente sintaxis:

$ docker [TIPO_OBJETO] [VERBO] <args>
            CONTAINER   create  start   stop    restart logs attach
            IMAGE       pull
            NETWORK     
            VOLUME
            ...
                        list inspect rm 
                        
docker image list                                   docker images
docker container list                               docker ps


docker run 
    = docker image pull + docker container create + docker start + docker attach

# Kubernetes

Hoy en día los entornos de producción de TODAS las empresas está operados por Kubernetes.

Mi misión cono sysadmin es darle configuraciones (instrucciones) al kubernetes, 
    acerca de cómo quiero que mi entorno de producción sea operado.
    

nginx CPU > 50%

Nginx 1 - 55%
Nginx 2 - 55% ---> OFLINE

Cluster de Kubernetes
    Maquina 1
        kubelet
        docker: containerd, crio
            nginx1 --> Limitacions de Recursos
    Maquina 2
        kubelet
        docker: containerd, crio
            mysql2 --> Sus propias limitaciones de recursos
    Maquina 3   CATAPLOF
        kubelet
        docker: containerd, crio
    Maquina N
        kubelet
        docker: containerd, crio
            nginx2 --> Limitacions de Recursos
            nginx3 --> Limitacions de Recursos
            mysql1 --> Sus propias limitaciones de recursos

En un entorno de prod, cuando tengo un cluster (software) 3 nginx... que necesito delante: BALANCEADOR DE CARGA

Cliente A ----> Web 1   ---->   BALANCEADOR DE CARGA    ----->  nginx1: web 1: IP 1
                                    IP balanceo                 nginx2: web 1: IP 2
                                        v                       nginx3: web 1: IP 3
                                    fqdn (DNS)

Kubernetes se ofrece en distribuciones:
- K8S
- K3S
- Minikube
- Openshift (distro de kubernetes que fabrica REDHAT) = K8S + configuraciones y funcionalidades adicionales de REDHAT
- TAMZU     (distro de kubernetes que fabrica VMWARE)

# Un contenedor

Es un entorno aislado donde ejecutar procesos...
Puedo ejecutar yo procesos adicionales en ese "entorno aislado"
SI: docker exec

# Qué era UNIX®? 

Un SO que fabricaba la gente de los lab BELL de AT&T. 
Esto se dejó de fabricar hará 20 años.

# Qué es UNIX®? 

NO ES UN SO. Es un estandar (de hecho 2: POSIX + SUS) acerca de cómo montar un SO.

# Hoy en día un SO UNIX es un SO que se ha certificado que cumple con esos estándares:

- MacOS: UNIX®
- AIX: IBM: UNIX®
- HP-UX
- Solaris

# POSIX? 

Un estandar acerda de como montar un SO para que apps pueden correr sin cambios en ellas.
Aqui se definen, entre otras cosas, cómo debe ser el Sistema de Archivos de un SO que cumpla con este estandar:

/
    bin/        Comandos ejecutables
    etc/        Configuraciones
    home/       Carpetas de usuarios
    root/       Carpeta del usuario root
    tmp/        Carpeta para temporales... que al reiniciar el servidor, se borran automaticamente
    opt/        Aplicaciones
    var/        Datos de aplicaciones

# FileSystem del HOST: Ubuntu (GNU-Linux) que es un SO POSIX? Eso creemos 

/ (1)
    datos/
        mariadb1/ ----> /var/mariadb (contenedor mariadb1)
            mibbdd.db
        mariadb2/ ----> /var/mariadb (contenedor mariadb2)
            otrabbdd.db
    bin/
        ls
        mkdir
        ps
    var/
        lib/
            docker/
                    containers
                            ... minginx/
                                        /datos = Enlace simbolico a la carpeta /home/ubuntu/environment/curso
                                    
                            ... mimariadb/              Recoge los cambios que se hagan sobre la imagen base
                                            var/
                                                mariadb/
                                                        log/mariadb.log
                            ... mimariadb2/
                                            var/
                                                mariadb/
                                                        log/mariadb.log
                    images/
                            ... mariadb/ (2)
                                        bin/
                                            ls
                                            mkdir
                                            bash
                                        var/
                                            mariadb/
                                        etc/
                                            mariadb/
                                        opt/
                                        home/
                                        root/
                                        tmp/
    etc/
        docker/
    opt/
    home/
    root/
    tmp/

# El sistema de archivos de un contenedor.

Se monta mediante la superposición de varias CAPAS !
- VOLUMENES: Punto de montaje adicional en el FS del contenedor
    /var/mariadb/datos
- CAPA 1: CAPA del contenedor.                           Aquí se guardan los ficheros propios del contenedor y sus cambios.
- CAPA 0: CAPA BASE: La capa de la imagen de contenedor. Esta capa es inalterable! Nadie tiene permisos de escritura en ella


Engañamos a los procesos que corren dentro de un contenedor, para hacerles creer que su RAIZ: "/" no es (1), sino (2).
    Esto se puede hacer en unix desde hace 40 años: chroot

nginx 1.21.1 ---> Tengo en /var/nginx su web que sirve... html.... php
Quiero pasar a nginx 1.21.2. Qué hago con contenedores?
    Me cargo el de la version 1.21.1... y creo uno nuevo con la 1.21.2

Los volumenes se usan para muchas cosas:

1- PERSISTENCIA TRAS BORRADO DE UN CONTENEDOR
2- Inyectar ficheros al contenedor
3- Compartir datos (ficheros) entre contenedores

Tipos de volumenes.
- FS Host
- En un cloud
- En una cabina de almacenamiento
- En el host, pero en RAM

Contenedor 1
    Apache / Nginx
            vvv
        access_log  Soporte en RAM (Montar 2 archivos rotados de los de 50kbs)
            ^^^
    Fluentd     >                   logstash >   ELASTIC SEARCH < Kibana
Contenedor 2
    