import requests
phpmyadmin_password = requests.get('https://www.passwordrandom.com/query?command=password')
phpmyadmin_setup_file = open("phpmyadmin-setup.sql", "rt")
phpmyadmin_setup_file_data = phpmyadmin_setup_file.read()
phpmyadmin_setup_file_data  = phpmyadmin_setup_file_data.replace('password_here', str(phpmyadmin_password.text))
phpmyadmin_setup_file.close

phpmyadmin_setup_file = open("phpmyadmin-setup.sql", "wt")
phpmyadmin_setup_file.write(phpmyadmin_setup_file_data)
phpmyadmin_setup_file.close