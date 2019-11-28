#!/bin/bash

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo useradd -G docker -s /bin/bash -d /home/sailor sailor
cat /etc/passwd |grep sailor
mkdir /home/sailor
chown -R sailor /home/sailor
cp script2.sh /home/sailor/script2.sh
su - sailor -c "docker run -td --name shevchenko ubuntu:16.04 && docker cp script2.sh shevchenko:/script2.sh && docker exec -it shevchenko ./script2.sh"
