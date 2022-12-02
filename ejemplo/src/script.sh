#!/bin/bash

export directorio=/tmp/datos/$(date +%d%m%y-%H:%M)
mkdir -p $directorio

echo Soy el script de la bash
echo genero unas cosas en un archivo:
echo dato1 > $directorio/archivo.txt

echo Llamo a un script de python y capturo su salida y genero con esa salida más datos
echo dato2: $(python3 script.py) >> $directorio/archivo.txt

