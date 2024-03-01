#!/bin/bash
yum install git -y
git clone https://github.com/NielsVerhoevenPXL/online-boutique.git

#install docker
yum install docker -y
service docker start
usermod -a -G docker ec2-user
