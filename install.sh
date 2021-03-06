#!/bin/bash

PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if the Script is being run a root
if [ "$EUID" -ne 0 ]
  then printf "${RED}Please run as root!${NC}\n"
  exit
fi
cd / 
mkdir skylabpanel 
cd /root/skylabpanel-install/

printf "${YELLOW}"
printf '
 .d8888b.  888               888               888           8888888b.                            888 
d88P  Y88b 888               888               888           888   Y88b                           888 
Y88b.      888               888               888           888    888                           888 
 "Y888b.   888  888 888  888 888       8888b.  88888b.       888   d88P 8888b.  88888b.   .d88b.  888 
    "Y88b. 888 .88P 888  888 888          "88b 888 "88b      8888888P"     "88b 888 "88b d8P  Y8b 888 
      "888 888888K  888  888 888      .d888888 888  888      888       .d888888 888  888 88888888 888 
Y88b  d88P 888 "88b Y88b 888 888      888  888 888 d88P      888       888  888 888  888 Y8b.     888 
 "Y8888P"  888  888  "Y88888 88888888 "Y888888 88888P"       888       "Y888888 888  888  "Y8888  888 
                         888                                                                          
                    Y8b d88P                                                                          
                     "Y88P"                                                                                                                    
'
printf "${BLUE}SkyLab Panel Requires some packages to run. Its going to install then now!${NC}\n"
sleep 2

# Update System #
printf "${BLUE}Updating your System.${NC}\n"
sleep 3
apt-get update -y
apt-get upgrade -y

# Installing LEMP #
printf "${BLUE}Installing LEMP Stack${NC}\n"
sleep 2
apt-get install nginx mariadb-server php libapache2-mod-php php-mysql php-fpm unzip -y

# C Comlier and Modules #
printf "${BLUE}Installing C modules for Python Maria Database Connector & iRedMail!${NC}\n"
sleep  2
apt install gcc libmariadb3 libmariadb-dev -y

# PHPmyAdmin #
printf "${BLUE}Installing and Seting up PHPmyAdmin!${NC}\n"
sleep 2
apt-get install php-mbstring -y
a2enmod mbstring
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-english.tar.gz
tar -xf phpMyAdmin-5.0.4-english.tar.gz -C /var/www/html
mv /var/www/html/phpMyAdmin /var/www/html/phpmyadmin

# SQL #
sleep 2
python3 update_files.py
phpmyadmin_password=$(cat /skylabpanel/info.conf | head -3 | tail -1)
mysql < phpmyadmin-setup.sql
mysql -u pma -p$phpmyadmin_password  < /var/www/html/phpmyadmin/sql/create_tables.sql

# Tiny File Manager #
printf "${BLUE}Installing and Setting up TinyFileManager!${NC}\n"
sleep 2
wget https://github.com/prasathmani/tinyfilemanager/archive/master.zip
unzip -q master.zip -d /var/www/html
mv /var/www/html/tinyfilemanager-master /var/www/html/tinyfilemanager

# Email #
printf "${BLUE} Installing and Seting up Email${NC}\n"
apt-get install postfix postfix-mysql dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd dovecot-mysql -y

# Setup Nginx for Tiny File Manger and PHPmyAdmin #
cp config-templates/00-default-ssl.conf /etc/nginx/sites-available 
sudo chmod -R 755 /var/www

# Extra Scripts #
sleep 2
printf "${BLUE}Downloading some Scripts for Later${NC}\n"

# Python Stuff#
printf "${BLUE}Installing Python${NC}\n"
sleep 2
apt-get install python3 python3-pip python3-dev -y
printf "${BLUE}Installing Python Modules${NC}\n"
sleep 2
pip3 install flask
pip3 install bcrypt
pip3 install mariadb
pip3 install WTForms
pip3 install wtforms.validators
pip3 install flask_wtf
pip3 install fqdn
pip3 install nslookup

printf "${BLUE}Everything is installed.Now SkyLab Panel needs to update some configuration files. ${NC}\n"

sleep 2

#SQL Stuff
mysql -u root < skylabpanel.sql
mysql -u root -e "INSTALL SONAME 'auth_ed25519';"
printf "${BLUE}For Security you need to set a Database password.${NC}\n"
sleep 2
printf "${PURPLE}Enter Root MySql Password: "
read mypassword
printf "${NC}"
printf "[mariadb]\nplugin_load_add = auth_ed25519\ndefault_authentication_plugin=auth_ed25519\n" | tee -a /etc/mysql/my.cnf
mysqladmin --user=root password $mypassword

python3 install.py $mypassword
