# Openshift Compute

En openshift se separa el concepto de Node del concepto Machine:

- Machine es una maquina física (HOST) 
- Node es un proceso de Kubernetes levantado en un host

Lo que puedo tener es MAQUINAS que no tengoan levantado el proceso de Kubernetes.
Esto se hace para poder ESCALAR el cluster!

# 

Tengo mi código de un programa -> Imagen de contenedor
Montar unos archivos de despliegue en kubernetes -> Cluster en un determinado NS
