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


    yum -y upgrade 
    yum -y install docker docker-compose git
    systemctl start docker && \
        systemctl enable docker
    #вытягиваем репу с проектом
    git clone https://github.com/shaadowsky/R-D.git

    (из каталога с фриипой) 
    docker build -t freeipa-server .

    (разрешаем селинуху конейнеры) setsebool -P container_manage_cgroup 1

    #Create directory which will hold the server data:
    mkdir /var/lib/ipa-data
    
    #для систем, которые умеют в  oci-systemd-hook (центоос 8 должен уметь)
    docker run --name freeipa-server-container -ti \
        -h ipa.example.test \
        --read-only \
        -v /var/lib/ipa-data:/data:Z freeipa-server [ opts ]

    #для систем, которые не умеют в oci-systemd-hook надо пробросить /run, /tmp, and /sys/fs/cgroup
    docker run --name freeipa-server-container -ti \
        -h ipa.example.test \
        -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        --tmpfs /run --tmpfs /tmp \
        -v /var/lib/ipa-data:/data:Z freeipa-server [ opts ]

    cp ipa-server-install-options /var/lib/ipa-data/ipa-server-install-options

    #после запуска этой команды заработает _ipa-server-install_ и отконфигурирует себя по файлу в _/var/lib/ipa-data/ipa-server-install-options_
    docker run --rm -e PASSWORD=Secret123 -h ipa.example.test --read-only \
    freeipa-server exit-on-finished -U



        # установка gnome-desktop
        yum -y groupinstall 'GNOME Desktop'
        systemctl enable graphical.target --force
        rm -f /etc/systemd/system/default.target
        ln -s /usr/lib/systemd/system/graphical.target /etc/systemd/system/default.target