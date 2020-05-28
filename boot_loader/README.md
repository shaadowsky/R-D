# Linux-06-hw

## Работа с загрузчиком

1. Попасть в систему без пароля несколькими способами
2. Установить систему с LVM, после чего переименовать VG
3. Добавить модуль в initrd

### 1 Попасть в систему без пароля несколькими способами

В VirtualBox установлена ВМ с Centos-7-minimal

```
[root@otus-hw4-1 vagrant]# cat /etc/redhat-release
CentOS Linux release 7.8.2003 (Core)
```

* В меню загрузчика выбираем `e` и дописываем к параметрам загрузки:
`init=/bin/sh`
Продолжаем загрузку, нажав Ctrl+x
При этом корневая файловая система смотирована в `/` режиме readonly
Для возможности записи в файлы ОС перемонтируем ФС в режиме read-write:
`mount -o remount,rw /`

* 2й способ: в меню загрузчика выбираем `e` и дописываем к параметрам загрузки:
`rd.break`
При этом корневая ФС будет смонтирована в каталог `/sysroot` так же в режиме ro
Перемонтируем корневую ФС `mount -o remount,rw /`
Делаем chroot `chroot /sysroot`
Далее можно сбросить пароль root `passwd root`
Сбрасываем метки безопасности файлов, если включен selinux `touch /.autorelabel`

* 3й способ: монтируем корневую ФС сразу в режиме read-write:
в меню загрузчика выбираем `e` и в параметрах загрузки меняем `ro` на
`rw init=/sysroot/bin/sh`
При этом корневая ФС будет смонтирована в каталог `/sysroot` в режиме read-write

* 4й способ: загрузка с LiveCD и смонтировать ФС

### 2 Установить систему с LVM, после чего переименовать VG

В той же ВМ, переименовываем группу томом centos в OtusRoot
Правим `/etc/fstab` и параметры grub, пересоздаем initramfs
После перезагрузки видим, что ВМ нормально грузится с ФС на LVM, новым названием VG
```
[root@otus-hw4-1 ~]# cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-3.10.0-1127.el7.x86_64 root=/dev/mapper/OtusRoot-root ro crashkernel=auto
spectre_v2=retpoline rd.lvm.lv=OtusRoot/root rd.lvm.lv=OtusRoot/swap rhgb quiet LANG=en_US.UTF-8
```

### 3 Mодуль в initrd

Создаем каталог в `/usr/lib/dracut/modules.d/`, помещаем туда сам и скрипт, который его устанавливает и вызывает
Пересобираем образ initramfs
В опциях загрузчика убираем `rghb quiet` и делаем новый конфиг
После перезагрузки видим, что модуль запускается

```
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
lsinitrd -m /boot/initramfs-3.10.0-1127.el7.x86_64.img
vi /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
``` 

### 4 Сконфигурировать систему без отдельного раздела /boot

В гаталоге `/move-boot` находится стенд для переноса раздела /boot на lvm.
Скрипт `scripts/pretask.sh` добавляет репозиторий с пропатченным grub и апдейтит его
Скрипт `scripts/move.sh` создает lvm на дополнительном диске(захардкожено на /dev/sdb),
переносит туда файлы системы с текущего lvm + boot раздел, далее в chroot на новом разделе
апдейтит fstab, устанавливает grub на новый диск, меняет конфиг grub и пересобирает initramfs.
После выключаем ВМ и отцепляем начальный диск.
