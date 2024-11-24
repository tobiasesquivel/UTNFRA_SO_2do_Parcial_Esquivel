#!/bin/bash

sudo fdisk /dev/sdc << EOF
n
p


+1G
n
p



w
EOF

sudo fdisk /dev/sdd << EOF
n
p


+1.5G
n



t
1
82
w
EOF

sudo wipefs -a /dev/sdc1 /dev/sdd1 /dev/sdd2

sudo pvcreate /dev/sdc1 /dev/sdd1

sudo vgcreate vg_datos /dev/sdc1
sudo vgcreate vg_temp /dev/sdd1

sudo lvcreate -L 5M vg_datos -n lv_docker
sudo lvcreate -L 1.5G vg_datos -n lv_workareas
sudo lvcreate -L 512M vg_temp -n lv_swap

sudo mkfs -t ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs -t ext4 /dev/mapper/vg_datos-lv_workareas

sudo mkswap /dev/vg_temp/lv_swap
sudo swapon /dev/vg_temp/lv_swap

sudo mkdir -p /var/lib/docker
sudo mkdir -p /work
sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker
sudo mount /dev/mapper/vg_datos-lv_workareas /work

sudo lvextend -L +110M /dev/vg_datos/lv_docker
sudo resize2fs /dev/vg_datos/lv_docker

echo "/dev/mapper/vg_datos-lv_docker /var/lib/docker ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/mapper/vg_datos-lv_workareas /work ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/vg_temp/lv_swap none swap sw 0 0" | sudo tee -a /etc/fstab
