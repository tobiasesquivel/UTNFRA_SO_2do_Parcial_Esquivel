#!/bin/bash

# Crear particiones en /dev/sdc (disco de 1GB)
sudo fdisk /dev/sdc << EOF
n
p


+1.5G
n
p


+200M
n
p


+10M
n



t
1
8E
t
2
8E
t
3
8E
w
EOF

# Crear partición en /dev/sdd (disco de 2GB)
sudo fdisk /dev/sdd << EOF
n
p


+700M
n
e



t
1
82
w
EOF

sudo wipefs -a /dev/sdc1 /dev/sdc2 /dev/sdc3
sudo wipefs -a /dev/sdd1

sudo pvcreate /dev/sdc1 /dev/sdc2 /dev/sdc3
sudo pvcreate /dev/sdd1

sudo vgcreate vg_datos /dev/sdc1 /dev/sdc2 /dev/sdc3
sudo vgcreate vg_temp /dev/sdd1

sudo lvcreate -L 5M vg_datos -n lv_docker
sudo lvcreate -L 1.5G vg_datos -n lv_workareas
sudo lvcreate -L 512M vg_temp -n lv_swap

sudo mkfs -t ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs -t ext4 /dev/mapper/vg_datos-lv_workareas

sudo mkswap /dev/vg_temp/lv_swap
sudo swapon /dev/vg_temp/lv_swap

sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker/
sudo mount /dev/mapper/vg_datos-lv_workareas /work/

sudo lvextend -L +110M /dev/vg_datos/lv_docker
sudo resize2fs /dev/vg_datos/lv_docker

