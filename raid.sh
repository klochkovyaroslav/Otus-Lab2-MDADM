#!/bin/bash
sudo su
# Устанавливаем утилиты parted и mdadm
yum install -y parted mdadm;
#Зануляем суперблоки на дисках
 mdadm --zero-superblock /dev/sd{b,c,d,e,f,g,h,i,j};
#Создаем raid1 на 2 диска 
 mdadm --create --verbose --metadata=1.2 /dev/md/raid1 -l 1 -n 2 /dev/sd{b,c};
# Смотрим что получилось
cat /proc/mdstat
#Добавляем диск в массив raid1
 mdadm --add /dev/md/raid1 /dev/sdd 
# Смотрим что получилось
 mdadm --detail /dev/md/raid1
# Имитируем падение диска /dev/sdb
 mdadm /dev/md/raid1 --fail /dev/sdb
# Смотрим что получилось
 mdadm --detail /dev/md/raid1
#Добавляем диск в массив raid1 sde
 mdadm --add /dev/md/raid1 /dev/sde
# Смотрим что получилось
 mdadm --detail /dev/md/raid1
 #Удаляем диск из массива raid1 sdb
 mdadm --remove /dev/md/raid1 /dev/sdb;
#Создаем raid5 на 4 диска 
lsblk
 mdadm --create --verbose /dev/md/raid5 -l 5 -n 4 /dev/sd{f,g,h,i};
# Смотрим что получилось
 cat /proc/mdstat
 mdadm --detail /dev/md/raid5
#Создать каталог mdadm
 mkdir /etc/mdadm;
#Создать файл mdadm.conf
 echo "DEVICE partitions" > /etc/mdadm/mdadm.conf;
 mdadm --detail --scan | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
 update-initramfs -u
 # Создаем GPT
 parted --script /dev/md/raid5 mklabel gpt;
 #Создаем разделы
 parted /dev/md/raid5 mkpart primary ext4 0% 20%;
 parted /dev/md/raid5 mkpart primary ext4 20% 40%;
 parted /dev/md/raid5 mkpart primary ext4 40% 60%;
 parted /dev/md/raid5 mkpart primary ext4 60% 80%;
 parted /dev/md/raid5 mkpart primary ext4 80% 100%;
 # Смотрим что получилось
 parted /dev/md/raid5 print
 #Создаем файловую систему
 for i in $(seq 1 5); do mkfs.ext4 /dev/md/raid5p$i; done;
 mkdir -p /raid5/part{1,2,3,4,5}
 #Монтируем партишины
 for i in $(seq 1 5); do mount /dev/md/raid5p$i /raid5/part$i; done;
