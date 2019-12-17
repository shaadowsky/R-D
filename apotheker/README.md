с нуля выполнить установку и настройку небольшой среды для разработки/отладки серверного ПО: Centos/Debian, Docker CE, в контейнерах разместить ldap, zabbix, настроить домен, выполнить начальное обнаружение устройств и проверку доступности домена.

### prerequisites
docker
docker-compose

### описание

выполнено на основе базового образа centos:centos7. В production среде смотрел бы в сторону ,базового образа alpine. Дело в том, что alpine 5.5M, а centos7 203M

freeipa взята отсюда https://github.com/Tiboris/freeipa-container
заббикс взят отсюда https://github.com/zabbix/zabbix-docker/tree/4.4/zabbix-appliance/centos

много времени убил на freeipa. Вспомнил, что ldap'ом может рулить webmin

на данный момент не написан докер-композ и крашится при установке freeipa

вагрант ап
подставить костыль sudo chown vagrant:docker /var/run/docker.sock
потом докер-композ

docker run --sysctl net.ipv6.conf.lo.disable_ipv6=0 --rm  --name freeipa -ti  -e IPA_SERVER_IP=10.12.0.98 -p 53:53/udp -p 53:53 -p 80:80 -p 443:443 -p 389:389 -p 636:636 -p 88:88 -p 464:464 -p 88:88/udp -p 464:464/udp -p 123:123/udp  -h ipa.example.test    -v /sys/fs/cgroup:/sys/fs/cgroup:ro    --tmpfs /run --tmpfs /tmp  -v /var/lib/ipa-data:/data:Z   freeipa-server exit-on-finished