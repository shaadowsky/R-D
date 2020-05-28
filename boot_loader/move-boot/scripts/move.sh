#!/bin/bash
echo "start"

#new lvm create
echo "new lvm create"
pvcreate /dev/sdb --bootloaderareasize 1m 
vgcreate otus /dev/sdb
lvcreate -L 1G -n swap otus
lvcreate -l+100%FREE -n root otus

#fs create & copy /
echo "fs create"
mkfs.xfs /dev/otus/root
mkswap /dev/otus/swap
mount /dev/otus/root /mnt

yum install -y xfsdump
xfsdump -J - /dev/VolGroup00/LogVol00 | xfsrestore -J - /mnt
cp -aR /boot/* /mnt/boot/ 

#chroot
echo "chroot!"
#from archwiki

mount -t proc /proc/ /mnt/proc/
mount --rbind /dev/ /mnt/dev/
mount --rbind /sys/ /mnt/sys/

chroot /mnt/ /bin/bash <<"EOT"

#rewrite fstab

echo "/dev/mapper/otus-root / xfs  defaults 0 0" > /etc/fstab
echo "/dev/mapper/otsu-swap swap swap defaults 0 0" >> /etc/fstab

#install grub & edit boot params
#GRUB_CMDLINE_LINUX="no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 elevator=noop crashkernel=auto rd.lvm.lv=VolGroup00/LogVol00 rd.lvm.lv=VolGroup00/LogVol01 rhgb quiet"

grub2-install /dev/sdb
sed -i 's|VolGroup00/LogVol00|otus/root|g' /etc/default/grub
sed -i 's|VolGroup00/LogVol01|otus/swap|g' /etc/default/grub

#update grub cfg
grub2-mkconfig -o /boot/grub2/grub.cfg

#rebuild initrd
dracut -f
EOT