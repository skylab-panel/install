#!/bin/bash

YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

if [ "$EUID" -ne 0 ]
  then printf "${RED}Please run as root!S${NC}\n"
  exit
fi
cd /tmp/
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
# Installing Lamp #
printf "${BLUE}Installing LAMP${NC}\n"
sleep 2
apt-get install apache2 mariadb-server php libapache2-mod-php php-mysql -y
# Other Services #
printf "${BLUE}Installing Php my Admin, Email Dns and others${NC}\n"
sleep 2
apt-get install phpmyadmin letseNCrypt -y
# Database #
printf "${BLUE}Installing some Stuff for the Database${NC}\n"
sleep  2
apt install libmariadb3 libmariadb-dev -y
# Python #
printf "${BLUE}Installing Python${NC}\n"
sleep 2
apt-get install python3 python3-pip python3-dev -y
printf "${BLUE}Installing Python Modules${NC}\n"
sleep 2
pip3 install flask
pip3 install bcrypt
pip3 install mariadb
printf "${BLUE}Everything is installed.Now SkyLab Panel needs to update some configuration files. ${NC}\n"
cd / 
mkdir skylabpanel 
cd /tmp/
sleep 2
printf "[mysqld]\ndefault_authentication_plugin=mysql_native_password\n" | tee -a /etc/mysql/my.cnf
sleep 2
printf "${BLUE}For Security you need to set a Database password.${NC}\n"
sleep 2
printf "Enter Root MySql Password"
read mypassword
mysqladmin -u password $mypassword
wget https://raw.githubusercontent.com/skylab-panel/install/master/install.py
python3 install.py $mypassword