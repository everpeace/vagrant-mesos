#! /bin/bash
PUBLIC_DNS=`wget -q -O - http://169.254.169.254/latest/meta-data/public-hostname`
hostname $PUBLIC_DNS
echo $PUBLIC_DNS > /etc/hostname
HOSTNAME=$PUBLIC_DNS  # Fix the bash built-in hostname variable too
