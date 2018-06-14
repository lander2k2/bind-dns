#!/bin/bash

sudo yum clean all
sudo yum update -y
sudo yum clean all
sudo sudo yum install -y bind bind-utils

sudo systemctl disable firewalld

# disable SELinux
sudo mv /tmp/selinux_config /etc/selinux/config

# reset any existing iptables rules
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X

