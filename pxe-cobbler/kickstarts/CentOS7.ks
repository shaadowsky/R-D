 настройка фаервола(выключаем)
firewall --disabled
# Режим, установка или обновление
install
# Путь к образу установки
url --url="http://192.168.20.10/cblr/links/CentOS7-x86_64/"# cobbler
# Пароль root
rootpw --iscrypted $1$tGzwsFH9$35gG/LKDF5Ckn75B0xQDC.

# Настройка сети
network --bootproto=dhcp --device=eth0 --onboot=on

# Перезагрузка после установки
reboot

# Информация об авторизации системы
auth useshadow passalgo=sha512
# Использовать графический интерфейс во время установки
graphical
firstboot disable
# Настройка клавиатуры
keyboard us
# Язык системы
lang en_US
# Конфигурация Selinux
selinux disabled
# Installation logging level
logging level=info
# Временная зона
timezone Europe/Moscow
# Настройка файловой системы
bootloader location=mbr
clearpart --all --initlabel
part swap --asprimary --fstype="swap" --size=1024
part /boot --fstype xfs --size=500
part pv.01 --size=1 --grow
volgroup root_vg01 pv.01
logvol / --fstype xfs --name=lv_01 --vgname=root_vg01 --size=1 --grow
%packages
@^minimal
@core
%end
%addon com_redhat_kdump --disable --reserve-mb='auto'
%end
