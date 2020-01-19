#!/bin/bash -e
docker run --name ldap --hostname ldap \
    --ip 172.17.0.10 --detach osixia/openldap:1.1.8
docker run --name ldapadmin --hostname ldapadmin \
    --ip 172.17.0.20 --link ldap:ldap-host \
    --env PHPLDAPADMIN_LDAP_HOSTS=ldap-host \
    --detach osixia/phpldapadmin:0.9.0
docker run --name mysql-server -t \
    --host-name mysql-server \
    --ip 172.17.0.30 -e MYSQL_DATABASE="zabbix" \
    -e MYSQL_USER="zabbix" \
    -e MYSQL_PASSWORD="zabbix" \
    -e MYSQL_ROOT_PASSWORD="root" \
        -d mysql:latest
на mysql-server выполнить:
    # mysql -u root -p
    # ALTER USER 'zabbix' IDENTIFIED WITH mysql_native_password BY 'zabbix';
docker run --name zabbix-server -t -p 10051:10051 \
    --ip 172.17.0.40 \
    -e DB_SERVER_HOST="172.17.0.30" -e MYSQL_DATABASE="zabbix" \
    -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="zabbix" \
    -e MYSQL_ROOT_PASSWORD="root" \
    --link mysql-server:mysql \
    -d zabbix/zabbix-server-mysql:alpine-4.4.4
docker run --name zabbix-web -t -p 80:80 \
    --ip 172.17.0.50 \
    -e DB_SERVER_HOST="172.17.0.30" \
    -e MYSQL_USER="zabbix" \
    -e MYSQL_PASSWORD="zabbix" \
    -e ZBX_SERVER_HOST="172.17.0.40" \
    -e ZBX_SERVER_NAME="MyZabbix" \
    -e PHP_TZ="Asia/Irkutsk" \
    -d zabbix/zabbix-web-apache-mysql:latest

PHPLDAP_IP=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" phpldapadmin)

echo "LDAPadmin"
echo "Go to: https://$PHPLDAP_IP"
echo "Login DN: cn=admin,dc=example,dc=org"
echo "Password: admin"

ZABBIX_WEB=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" zabbix-web)
