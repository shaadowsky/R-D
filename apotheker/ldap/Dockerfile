### https://github.com/Tiboris/freeipa-container/blob/master/Dockerfile.centos-7

FROM centos:centos7

LABEL maintainer="pvandreev@gmail.com"

#################
### добавлено из-за особенностей докера. связанных с идеологией
### systemd, видите ли ему не нравится. Философия, myass

## показываем systemd, что мы в контейнере
ENV container=docker  

COPY container.target /etc/systemd/system/container.target

RUN ln -sf /etc/systemd/system/container.target /etc/systemd/system/default.target

ENTRYPOINT ["/sbin/init"]

CMD ["--log-level=info"]

### Docker обычно посылает процессу, запущенному внутри контейнера, SIGTERM
### при вызове команды "docker stop". 
### Systemd же для этих целей использует SIGTMIN+3 и не реагирует на SIGTERM
STOPSIGNAL SIGRTMIN+3
##############

RUN yum -y update && \
    yum -y install chrony

CMD cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    systemctl enable chronyd && \
    systemctl start chronyd && \
    hostnamectl set-hostname ldap.test.local && \
    setenforce 0 && \
    sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config && \
    firewall-cmd --permanent --add-port=53/{tcp,udp} \
    --add-port=80/tcp --add-port=88/{tcp,udp} --add-port=123/udp \
    --add-port=389/tcp --add-port=443/tcp --add-port=464/{tcp,udp} \
    --add-port=636/tcp && \
    firewall-cmd --reload 

RUN yum -y install ipa-server ipa-server-dns 

#CMD ipa-server-install

