# kubectl 

$ kubectl [VERBO] [TIPO_OBJETO] <args>
            describe
            get
            delete
            apply
            create
            
            
            
            logs
            exec
                                -n --namespace NOMBRE_NAMESPACE
                                --all-namespaces
                                
                                
                    Red virtual del cluster de kubernetes
-------------------------------------------------------------------------------
|               |               |
.19             .44             .85
|               |               |
PodIvan         PodSilvia       PodDavid
|               |               |
C1              C2              C3


# Imagen contenedor CentOS

Fichero comprimido que tiene :

bin/
    mkdir
    ls
    rmdir
    sh
    bash
    yum -> 30 Mbs
tmp/
var/
usr/
root/
home/
sbin/

# Imagen contenedor Ubuntu

Fichero comprimido que tiene :

bin/
    mkdir
    ls
    rmdir
    sh
    bash
    apt
tmp/
var/
usr/
root/
home/
sbin/

# Imagen contenedor Alpine 3M 

Fichero comprimido que tiene :

bin/
    mkdir
    ls
    rmdir
    sh
    wget
tmp/
var/
usr/
root/
home/
sbin/
    
# Queremos acceder alos nginx desde casa.

Opciones:
2- Montar un servicio NodePort

1- Montar un servicio de tipo load balancer
3- Usar un IngressController

### Ejecutar  Job

Un JOB es como un POD, en el que los contenedores que se definan ejecutan tareas que acaban en un determinado periodo de tiempo:
- Scripts
- Comandos

Ejecutar backup de la BBDD

Cuantos Jobs configuramos en Kubernetes? NINGUNO

Qué es lo que configuramos Plantiollas de Jobs, que querremos que se ejecuten con una periodicidad: CRONJOB

# Capacidad de almacenamiento

1 Gibibyte = 1024 x Mebibytes = 1024 x Kibibytes = 1024 bytes
1 Gigabyte = 1000 x Megabytes = 1000 x Kilobytes = 1000 bytes


----

 PVC   <<<<>>>>  PV