#!/bin/bash

#Verion del Servidor Wildfly
WILDFLY_VERSION=18.0.1.Final
#Tamaño de memoria a asignar
MEMORY_RAM=512m
MEMORY_WSP=256m

#Actualizamos
sudo apt-get update

#Instalamos unzip para descomprimir
sudo apt-get install -y default-jdk

#Instalamos unzip para descomprimir
sudo apt-get install -y unzip

#Navegamos a la ruta de instalación
cd /opt/

#Descargamos el archivo zip
wget https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.zip

#Extraemos el contenido del zip
unzip wildfly-$WILDFLY_VERSION.zip

#Cambiamos de nombre la carpera extraida
mv wildfly-$WILDFLY_VERSION wildfly

#Eliminamos el archivo zip
rm wildfly-$WILDFLY_VERSION.zip

#Damos todos los permisos a la carpeta -- Esto es opcional
chmod 777 -R wildfly/

# Seteamos la zona horaria en el servidor
echo 'JAVA_OPTS="$JAVA_OPTS -Duser.timezone=GMT-5"' >> wildfly/bin/standalone.conf

# Damos mayor memoria al servidor
sed -i "s/-Xmx512m/-Xmx$MEMORY_RAM/g" wildfly/bin/standalone.conf
sed -i "s/-XX:MaxMetaspaceSize=256m/-XX:MaxMetaspaceSize=$MEMORY_WSP/g" wildfly/bin/standalone.conf

# Seteamos valor
export LAUNCH_JBOSS_IN_BACKGROUND=true

#creamos usuarios
./wildfly/bin/add-user.sh admin admin --silent

#Extra - Configuraciones por si acaso - la mayor parte del tiempo no se usaran
sed -i 's/jboss.http.port:8080/jboss.http.port:80/g' wildfly/standalone/configuration/standalone.xml
sed -i 's/inet-address value="${jboss.bind.address.management:127.0.0.1}"/any-address/g' wildfly/standalone/configuration/standalone.xml
sed -i 's/inet-address value="${jboss.bind.address:127.0.0.1}"/any-address/g' wildfly/standalone/configuration/standalone.xml
sed -i 's/jboss.http.port:8080/jboss.http.port:80/g' wildfly/standalone/configuration/standalone-ha.xml
sed -i 's/inet-address value="${jboss.bind.address.management:127.0.0.1}"/any-address/g' wildfly/standalone/configuration/standalone-ha.xml
sed -i 's/inet-address value="${jboss.bind.address.private:127.0.0.1}"/any-address/g' wildfly/standalone/configuration/standalone-ha.xml
sed -i 's/inet-address value="${jboss.bind.address:127.0.0.1}"/any-address/g' wildfly/standalone/configuration/standalone-ha.xml
sed -i 's/jboss.http.port:8080/jboss.http.port:80/g' wildfly/standalone/configuration/standalone-full.xml
sed -i 's/inet-address value="${jboss.bind.address.management:127.0.0.1}"/any-address/g' wildfly/standalone/configuration/standalone-full.xml
sed -i 's/inet-address value="${jboss.bind.address.unsecure:127.0.0.1}"/any-address/g' wildfly/standalone/configuration/standalone-full.xml
sed -i 's/inet-address value="${jboss.bind.address:127.0.0.1}"/any-address/g' wildfly/standalone/configuration/standalone-full.xml
sed -i 's/jboss.http.port:8080/jboss.http.port:80/g' wildfly/standalone/configuration/standalone-full-ha.xml
sed -i 's/inet-address value="${jboss.bind.address.management:127.0.0.1}"/any-address/g' wildfly/standalone/configuration/standalone-full-ha.xml
sed -i 's/inet-address value="${jboss.bind.address.private:127.0.0.1}"/any-address/g' wildfly/standalone/configuration/standalone-full-ha.xml
sed -i 's/inet-address value="${jboss.bind.address:127.0.0.1}"/any-address/g' wildfly/standalone/configuration/standalone-full-ha.xml
sed -i 's/inet-address value="${jboss.bind.address.unsecure:127.0.0.1}"/any-address/g' wildfly/standalone/configuration/standalone-full-ha.xml
sed -i 's/jboss.http.port:8080/jboss.http.port:80/g' wildfly/standalone/configuration/standalone-load-balancer.xml
sed -i 's/inet-address value="${jboss.bind.address.management:127.0.0.1}"/any-address/g' wildfly/standalone/configuration/standalone-load-balancer.xml
sed -i 's/inet-address value="${jboss.bind.address.private:127.0.0.1}"/any-address/g' wildfly/standalone/configuration/standalone-load-balancer.xml
sed -i 's/inet-address value="${jboss.bind.address:127.0.0.1}"/any-address/g' wildfly/standalone/configuration/standalone-load-balancer.xml

#Ejecutamos el servidor en segundo plano -- Ya no se puede detener :V
#CMD ["/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
./wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -c standalone.xml &
