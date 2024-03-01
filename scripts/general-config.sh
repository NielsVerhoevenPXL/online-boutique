#!/bin/bash
yum install git -y
git clone https://github.com/ResearchProject-SNB-PXLDigital/online-boutique.git

yum install docker -y
service docker start
usermod -a -G docker ec2-user
logout