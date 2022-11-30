# Qué es un POD?

Conjunto de contenedores qué?
- Comparten configuración de red: Se hablan mediante localhost
- Se despliegan en el mismo host
- Escalan simultaneamente
- Pueden compartir volumenes locales

Realmente en Kubernetes no configuramos PODs ... Qué configuramos? Plantillas de pods

Esas plantillas las configuramos desde distintos objetos:

- DEPLOYMENT
    Plantilla + número de replicas
    Todas las instancias (PODs) comparten volumen de almacenamiento
- STATEFULSET
    Plantilla del pod + Plantilla pvc + número de replicas
    En este caso, cada instancia (POD) tendrá su propio volumen de almacenamiento
- DAEMONSET
    Plantilla (kubernetes ya genera 1 instancia por máquina del cluster)

Cluster producción Wordpress
                                            POD WP 1 - clienteA -> PDF
                                            POD WP 2                            DEPLOYMENT
    Cliente A    Balanceador                POD WP 3
    Cliente B                               POD WP 4 - cliente B -> ? PDF ?
                                            POD WP 5
    
    POD MariaDB- Galera - 1 : Instancia de mariadb en ejecución en un servidor  DATO1           DATO3
    POD MariaDB- Galera - 2 : Instancia de mariadb en ejecución en un servidor  DATO1   DATO2           
    POD MariaDB- Galera - 3 : Instancia de mariadb en ejecución en un servidor          DATO2   DATO3

    Cada base de datos DEBE TENER su propio fichero. Y de hecho, cada instancia guarda una parte de la información NO TODO
    
    > Los WP, deben desplegarse mediante un DEPLOYMENT o mediante un STATEFULSET ?

    Apache
        php 
            coleccion de ficheros HTML prediseñados

---

# REDES EN KUBERNETES                                                       192.168.1.2
                                                                                ^
                                                                           app2.prod.es
        Balanceador de carga (SYSADMIN)                                DNS  (SYSADMIN)         Cliente
        |                                                               |  app1.prod.es          |
        192.168.1.2:80 => 192.168.1.101:30080 | 192.168.1.102:30080     |       V           192.168.2.200  [app1.prod.es]
        |              => 192.168.1.103:30080 | 192.168.1.104:30080     |  192.168.1.2           |
        |                                                               |                        |
---------------------------------------------- Red de la empresa    -------------------------------------------
|                                                                                           
| Cluster de Producción
|
||==IP(192.168.1.101 , 10.0.2.1 )==Maquina 1
||      Netfilter:      10.0.4.1    -> 10.0.3.3    | 10.0.3.4    [round-robin]
||                      10.0.4.2:80 -> 10.0.3.1:80 | 10.0.3.2:80 [round-robin]
||                      10.0.4.4:80 -> 10.0.3.17:80 
||                      10.0.4.3:80 -> 10.0.3.5:80 
||                      192.168.1.101:30080 -> ingresscontroller:80
||-------10.0.3.17:80---- Pod Apache App2 - 1
||-------10.0.3.1:80----- Pod Apache App1 - 1
||                              DB_HOST = basedatos
||
||==IP(192.168.1.102 , 10.0.2.2)==Maquina 2
||      Netfilter:      10.0.4.1    -> 10.0.3.3    | 10.0.3.4    [round-robin]
||                      10.0.4.2:80 -> 10.0.3.1:80 | 10.0.3.2:80 [round-robin]
||                      10.0.4.4:80 -> 10.0.3.17:80 
||                      10.0.4.3:80 -> 10.0.3.5:80 
||                      192.168.1.102:30080 -> ingresscontroller:80
||-------10.0.3.3------ Pod1 BBDD
||-------10.0.3.4------ Pod2 BBDD
||
||==IP(192.168.1.103 , 10.0.2.3)==Maquina 3
||      Netfilter:      10.0.4.1    -> 10.0.3.3    | 10.0.3.4    [round-robin]
||                      10.0.4.2:80 -> 10.0.3.1:80 | 10.0.3.2:80 [round-robin]
||                      10.0.4.4:80 -> 10.0.3.17:80 
||                      10.0.4.3:80 -> 10.0.3.5:80 
||                      192.168.1.103:30080 -> ingresscontroller:80
||-------10.0.3.2:80----- Pod Apache App1 - 2
||
||==IP(192.168.1.104 , 10.0.2.4)==Maquina N
||      Netfilter:      10.0.4.1    -> 10.0.3.3    | 10.0.3.4    [round-robin]
||                      10.0.4.2:80 -> 10.0.3.1:80 | 10.0.3.2:80 [round-robin]
||                      10.0.4.4:80 -> 10.0.3.17:80 
||                      10.0.4.3:80 -> 10.0.3.5:80 
||                      192.168.1.104:30080 -> ingresscontroller:80
||-------10.0.3.5------ Pod1 IngressController [Proxy reverso] nginx
||                          usando como hostname: app1.prod.es --> apacheapp1   <<< INGRESS
||                          usando como hostname: app2.prod.es --> apacheapp2   <<< INGRESS
||
||- Servidor de DNS de Kubernetes... No tendremos solo una copia, sino varias
        basedatos = IP_BALANCEO_BBDD =  10.0.4.1
        apacheapp1 =                    10.0.4.2
        apacheapp2 =                    10.0.4.4
        ingresscontroller =             10.0.4.3

La red virtual: 10.0.0.0/16

# Cuando el cliente accede a app1.prod.es
1- Accede al balanceador externo (DNS externo)
2- El balanceador externo -> Maquina (i)
3- Maquina(i) (netfilter, DNS kubernetes) --> IngressController
4- IngressController (netfilter, DNS Kubernetes, Reglas INGRESS) -> Apache App1

## Cuando el Apache quiere acceder a la BBDD:

1- El usa la palabra: basedatos
2- Esa palabra es resuelta por el DNS -> 10.0.4.1
3- La comunicación del apache1 a 10.0.4.1 es interceptada por el netfilter de la maquina 1 --> 10.0.3.4

# SERVICE

Entrada en el DNS de kubernetes gestionada y mantenida por Kubernetes que apunta a la ~~IP de un pod~~

El servicio (la entrada en el DNS de kubernetes) realmente no apunta a la IP del pod, sino que apunta a una
nueva IP, la IP del servicio (IP balanceo de carga):
    IP_BALANCEO_BBDD = 10.0.4.1 -> IP Pod BBDD = 10.0.3.3

NETFILTER? componente del KERNEL DE LINUX. Es quién gestiona todas las comunicaciones de red.
   ^^
IPTABLES: Dar reglas de que comunicaciones son permitidas y cuales no.

## TIPOS DE SERVICIO 

- CLUSTERIP es: Entrada en DNS de Kubernetes + IP de balanceo                               Comunicaciones Internas
- NODEPORT  es: Servicio ClusterIP + Puerto que se expone en los hosts                      Comunicaciones Externas
    Pruebas
- LOADBALANCER: Servicio NodePort  + Gestión automatizada del balanceador de carga externo  Comunicaciones Externas
    ** Aquí hay truco: SE REQUIERE UN BALANCEADOR DE CARGA COMPATIBLE CON KUBERNETES
                        Si monto Kubernetes en un Cloud: AWS > AZURE > GOOGLE > ... > IBM Cloud
                                * El cloud ya me provee un balanceador compartible con Kubernetes (previo paso por caja!)
                        Si monto kubernetes on premisses, SOLO HAY 1 balanceador compatible: MetalLB

> Pregunta... ojo de buen cubero... en porcentajes:
  Cúantos servicios de cada tipo tendré en un cluster de Kubernetes?
                        % sobre total       Cualquier cluster REAL!
    ClusterIP               20%-80%             Todos menos 1
    NodePort                10%-20%                 0
    LoadBalancer            La mayoría              1   - Proxy reverso - IngressController

## Control plane de kubernetes

### kubeproxy

Hay un programa, que forma parte del núcleo de Kubernetes (CONTROL PLANE): kubeproxy... 
    curiosamente este programa se despliega mediante pods, dentro del propio cluster, del que tendremos una copia por máquina:
        DAEMONSET, cuya misión es estar continuamente actualizando las reglas de netfilter de todas las máquinas

### CoreDNS

El servidor de DNS de kubernetes es otro de esos programas que forman parte del CONTROL PLANE. 
    Y es instalado por kubernetes, aprovechando su infraestructura

### Base de datos. etcd > 5 instancias

Al menos tiene 3 maquinas para el control plane y luego las máquinas que sean para ejecutar procesos


## Proxy reverso: 

- nginx
- httpd
- haproxy
- envoy

### Qué hace el proxy reverso

                                    192.168.3.117
    Cliente -------------------->   Proxy reverso  ----- app1.miempresa.es      ---->   App1    https://app1.myserver
    app1.miempresa.es                              ----- miempresa.es           ---->   App2    https://app2.myserver
    miempresa.es                                   ----- miempresa.es/servicios ---->   App3    https://app3.myserver
                                    Balanceadores de carga
                                
    #### DNS:
    
        192.168.3.117 app1.miempresa.es
        192.168.3.117 miempresa.es
        
# Proxy normal

    Cliente  -------->  Proxy  ---------->    Web1
     Web1
     
# Kubernetes:

[WORKLOAD en Kubernetes]

## POD
## DEPLOYMENT
## STATEFULSET
## DAEMONSET

[RED en Kubernetes]

## SERVICE
### ClusterIP
Entrada en el DNS de Kubernetes + IP de balanceo
### NodePort
Entrada en el DNS de Kubernetes + IP de balanceo + Puerto expuesto en cada nodo
### LoadBalancer
Entrada en el DNS de Kubernetes + IP de balanceo + Puerto expuesto en cada nodo + Regla configuración en balanceador externo
## INGRESS 
Regla que damos sobre un INGRESS CONTROLLER (proxy reverso)
Los ingress son un concepto que ofrece Kubernetes. 
Openshift sobreescribe ese concepto con un nombre distinto ROUTE!
## ROUTE
Ingress + Configuración automatizada del DNS Externo

[ALMACENAMIENTO DE DATOS]

## VOLUMEN
## VOLUMEN PERSISTENTE
## PETICION DE VOLUMEN PERSISTENTE
## STORAGECLASS
## PROVISIONER

----

## Plantilla de pod:

- Contenedores
    Para cada uno: 
        - Imagen
        - Puertos
        - Variables de entorno
        - Punto de montaje de cada volumen
- Definición Volumenes

> Ejemplo: POD Apache y fluend(que es el programa que lee los datos del log del apache)
POD Apache
- Contenedores:
    - apache:
        - puerto: 80
        - variables de entorno... configuración
        - CarpetaDeLosLogs -> /var/apache/logs
    - fluentd                                                   ---->           ES (aquí se persistan y se auditen)
        - variables de entorno... configuración
        - CarpetaDeLosLogs -> /var/fluentd/inputFiles
- Volumenes:
    - CarpetaDeLosLogs:
        De qué petición de volumen sale el volumen que vamos a usar
                                        

## Usos de volumenes

- Compartir datos entre contenedores
- Inyectar ficheros/directorios/configuración a contenedores
- Persistencia de datos

## Tipos de volumenes
- Volumenes no persistentes     Cuando vaya a hacer otros usos del volumen.
    - emptyDir:     Crea una carpeta vacia en el host... que se borrará si se borra el POD.
    - configMap:    Permite inyectar un fichero al POD (a sus contenedores)
    - secret:       Igual... pero con datos sensibles
    - host:         Una carpeta que ya existe en el host y que inyecto en el POD (y sus contenedores). Se usa poco
- Volumenes persistentes:       Cuando vaya a usar el volumen para tener perstencia             PERSISTENTVOLUME
                                de datos que tienen que mantenerse si se elimina el pod
    - El clouds: AWS, AZURE; GCP, VMWare
    - En una cabina, en un nfs


## Quién escribe el fichero de una plantilla de POD?

El equipo de desarrollo!

## Quién detalla un volumen?

El equipo de almacenamiento... sysadmins... los que están con el cluster de kubernetes.

# Para resolver esta situación, en Kubernetes existe el concepto de:
PETICION DE VOLUMEN PERSISTENTE!                                                            PersistentVolumeClaim

Como desarrollo que pido? 
    Necesito un volumen con estas características:
        - Capacidad
        - Rendimiento: Lento, Rápido, Super-rápido, Super-lento (backups)
                                        ^ Cache
        - Encripción? SI
        - Nivel de redundancia! x3 RAID5
        - Concurrencia
                                                Lo hace kubernetes en autom.
                                                             v
|----------------- negocio / desarrollo ------------------|      |---- provisionador!!! ----|       |----- Administrador ------------------------|
PLANTILLA POD MARIAB <---> PETICION DE VOLUMEN (33)MARIADB <---> VOLUMEN PERSISTENTE MARIADB <----> STORAGE CLASS
Quiero un mariadb           Quiero un volumen                       Volumen en AWS                      Cuando pidan un volumen persistente de 
Que guarde datos            Rapidito                                Con id: 1928346423284               Rapidito y Redundante x 4
en el volumen asociado      Con 4 Gbs                                                                   Provisioner !!!! Crealo en AWS con estas credenciales
a la peticion 33                                                                                                          y esta configuración

Yo defino el POD MariaDB
- contenedores
    - mariadb
        - imagen: Mariadb 5.7.4
- volumen: se saca de la peticion 33

Ese pod le defino hoy....
Y dentro de un año:

POD MariaDB v2
- contenedores
    - mariadb
        - imagen: Mariadb 7.9
- volumen: se sigue sacando de la peticion 33

# Objetos que configuran los administradores de cluster para limitar lo que pueden pedir los desarrolladores/negocio

LIMIT RANGE
RESOURCE QUOTAS
Te voy a dejar usar: 16 cores, 20Gbs RAM, 4 PVC, 40 Gbs 

NAMESPACE (Kubernetes) / PROYECT (Openshift)
