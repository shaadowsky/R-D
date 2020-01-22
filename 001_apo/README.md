с нуля выполнить установку и настройку небольшой среды для разработки/отладки серверного ПО: Centos/Debian, Docker CE, в контейнерах разместить ldap, zabbix, настроить домен, выполнить начальное обнаружение устройств и проверку доступности домена.

### prerequisites
docker-ce docker-ce-cli containerd.io

### описание

выполнено на основе [инструкции](https://github.com/osixia/docker-phpLDAPadmin)

необходимо запустить скрипт [ldap+ldapadmin.sh](ldap+ldapadmin.sh), будет показан адрес, логин и пароль

проверено на убунту 18.04.3 LTS

на чистом сервере выполнить 
    # apt update && apt upgrade
    # apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    # curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    # add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    # apt update
    # apt install docker-ce docker-ce-cli containerd.io

    ### as in https://docs.docker.com/compose/install/

    # sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    # chmod +x /usr/local/bin/docker-compose
    # ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

при локальной установке в браузере

172.16.238.50 логин Admin, пароль zabbix

https://172.16.238.20 логин cn=admin,dc=example,dc=org, пароль admin

в продакшн варианте можно вывести вольюмы для БД, конфигов, логов на диск, чтобы смотреть из хостовой системы. Также надо порешать проблемы безопасности, ограничить потребление ресурсов контейнерами.
