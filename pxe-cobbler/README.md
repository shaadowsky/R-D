стенд поднят на centos7  и cobbler 2.8.5

требуется выполнить установку плагина для вагранта

    # vagrant plugin install vagrant-reload
    
pxe-сервер доступен тут (_login cobbler, pass cobbler_):

    https://192.168.20.10/cobbler_web/
    

в продакшн случае нужно закрыть возможность обращаться в браузере куда-либо, кроме  cobbler_web

можно настроить так, чтобы dhcp и dns рулились не на cobbler-хосте.

_/etc/dhcp/dhcpd.conf_ подкидывается, чтобы стартанул dhcp.service, далее он перезапишется при выполнении _cobbler sync_ из шаблона _/etc/cobbler/dhcp.template_

DHCP и DNS рулятся _/etc/cobbler/dhcp.template_ и _/etc/cobbler/dnsmasq.template_

