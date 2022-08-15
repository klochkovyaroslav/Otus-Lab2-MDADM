#!/bin/bash
sudo su
# Устанавливаем утилиты parted и mdadm
yum install -y parted mdadm
#Зануляем суперблоки на дисках
 mdadm --zero-superblock --force /dev/sd{b,c,d,e,f,g,h,i,j}
#Создаем raid1 на 2 диска 
 mdadm --create --verbose /dev/md/raid1 --level =1 --raid-devices=2 /dev/sd{b,c};
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
#Создаем raid5 на 4 диска 
 mdadm --create --verbose /dev/md/raid5 -l 5 -n 4 /dev/sd{f,g,h,i};
# Смотрим что получилось
cat /proc/mdstat
 mdadm --detail /dev/md/raid5
#Создать каталог mdadm
 mkdir /etc/mdadm
#Создать файл mdadm.conf
 echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
 mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
 # Создаем GPT
 parted /dev/md/raid5 mklabel gpt
  # Смотрим что получилось
 print
 #Создаем разделы
 parted /dev/md/raid5 mkpart hdd1 ext4 0% 25%
 parted /dev/md/raid5 mkpart hdd2 ext4 25% 50%
 parted /dev/md/raid5 mkpart hdd3 ext4 50% 75%
 parted /dev/md/raid5 mkpart hdd4 ext4 75% 100%
 #Создаем партишины
 for i in $(seq 1 4); do sudo mkfs.ext4 /dev/md/raid5p$i; done

