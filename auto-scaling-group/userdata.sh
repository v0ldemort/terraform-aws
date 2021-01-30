#!/bin/bash -v
yum -y update
mkfs.ext4 /dev/xvdz
mkdir /var/log/nginx
chmod ec2user:ec2user /var/log/nginx
mount /dev/xvdz /var/log/nginx
amazon-linux-extras install -y nginx1
systemctl start nginx