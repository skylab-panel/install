import requests
import os
phpmyadmin_password = requests.get('https://www.passwordrandom.com/query?command=password')
phpmyadmin_setup_file = open("phpmyadmin-setup.sql", "rt")
phpmyadmin_setup_file_data = phpmyadmin_setup_file.read()
phpmyadmin_setup_file_data  = phpmyadmin_setup_file_data.replace('password_here', str(phpmyadmin_password.text))
phpmyadmin_setup_file.close

phpmyadmin_setup_file = open("phpmyadmin-setup.sql", "wt")
phpmyadmin_setup_file.write(phpmyadmin_setup_file_data)
phpmyadmin_setup_file.close

os.chdir("/")
main_config = open("/skylabpanel/info.conf", "w+")
main_config.write("PHPmyAdmin")
main_config.write("pma")
main_config.write(phpmyadmin_password)
main_config.close