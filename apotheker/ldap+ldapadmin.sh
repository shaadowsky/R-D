#!/bin/bash -e
docker run --name ldap --hostname ldap \
    --detach osixia/openldap:1.1.8
docker run --name phpldapadmin --hostname phpldapadmin \
    --link ldap:ldap-host --env PHPLDAPADMIN_LDAP_HOSTS=ldap-host \
    --detach osixia/phpldapadmin:0.9.0

PHPLDAP_IP=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" phpldapadmin)

echo "Go to: https://$PHPLDAP_IP"
echo "Login DN: cn=admin,dc=example,dc=org"
echo "Password: admin"

