#!/bin/bash

# 1.1
if [[ $(id -u) -ne 0 ]]; then
  echo "Please run script as root"
  exit 1	
fi

name='nginx'
which $name &> /dev/null

if [[ $? -ne 0 ]]; then
  echo "${name} is not installed"
else
  echo "${name} is installed"
  echo "Uninstalling ${name} ..."
  nginx -v
  printf "\n"
  apt remove -y $name
  apt -y autoremove  
  apt purge -y $name
fi

# 2.2
# prerequisites
apt update
apt install -y curl gnupg2 ca-certificates lsb-release
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

# import and verify nginx key
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -

apt update
apt install -y nginx=1.14.2*

nginx -v
echo "Nginx conf file path: "
nginx -t
printf "\n"

cd /etc/nginx/ && mv nginx.conf backup_nginx.conf
mkdir -p sites-available/ sites-enabled/
awk '1;/include.*conf/{print "include /etc/nginx/sites-enabled/*;"}' backup_nginx.conf > nginx.conf

#2.2
mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/
service nginx restart

#2.3
curl -X GET 127.0.0.1 | grep -o "Welcome to nginx" | head -1
if [[ $? -ne 0 ]]; then
  echo "${name} not working"
fi  


#3
printf "\n"
ps -lfC nginx | grep 'nginx.*master' | awk '{print "Nginx main process have a PID: " $4}'
#3.1
printf "\n"
ps -lfC nginx | grep -c 'nginx.*worker'| awk '{print "Number of nginx worker processes: \033[01;31m" $1 "\033[0m"}'
