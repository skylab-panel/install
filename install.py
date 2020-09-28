import mariadb
import subprocess
import time
import os, sys
import bcrypt
from pprint import pformat

os.chdir("/")
main_config = open("/skylabpanel/main.conf", "w")

# Create skylabpanel Database #
try:
    conn = mariadb.connect(
        user="root",
        password=sys.argv[1],
        host="localhost",
        port=3306,
        database='skylabpanel'
    )
except mariadb.Error as e:
    print(f"Error connecting to MariaDB Platform: {e}")
    sys.exit(1)
else:
    print("Successful Conection to the Database")
cur = conn.cursor()


print("The Following Infomation Will be Used for Logging into SkyLab Panel(Username and Password are Case Sestive!)")
firstname = input("Please Enter your Firstname: ")
lastname = input("Please enter your Lastname: ")
username = input("Please Enter a Username(admin and root are not recommended!): ")
password = input("Please Enter a Password: ")
email = input("Please Enter an Email Adress: ")

main_config.write(username+"\n")
main_config.write(password+"\n")

enpassword = password.encode('utf-8')
enpassword = bcrypt.hashpw(enpassword, bcrypt.gensalt())
password = pformat(password)
email = email.strip("""!"#$%&'()*+,_/[\]^`{|}~ """) # pylint: disable=anomalous-backslash-in-string
email = email.lower()

cur.execute("INSERT INTO tbl_users (firstname, lastname, username, password, email, account_type) VALUES (?, ?, ?, ?, ?, ?)", (firstname, lastname, username, enpassword, email, 'admin'))

print ("CREATE USER IF NOT EXISTS " + username + "@'localhost' IDENTIFIED BY " + password) # This line should be removed but makes the program work so I am keep it for now!
cur.execute("CREATE USER IF NOT EXISTS " + username + "@'localhost' IDENTIFIED BY " + password)
cur.execute("GRANT ALL PRIVILEGES ON * TO " + username +"@'localhost' WITH GRANT OPTION")
cur.execute("FLUSH PRIVILEGES")
#
main_config.close()

#
tinyfilemanger = open("/var/www/html/tinyfilemanager/tinyfilemanager.php", "rt")
tinyfilemanger_data = tinyfilemanger.read()
tinyfilemanger_data  = tinyfilemanger_data.replace("'admin' => '$2y$10$/K.hjNr84lLNDt8fTXjoI.DBp6PpeyoJ.mGwrrLuCZfAwfSAGqhOW', //admin@123", "'"+password+"' => password_hash('"+username+"', PASSWORD_DEFAULT) ")
tinyfilemanger.close()

tinyfilemanger = open("/var/www/html/tinyfilemanager/tinyfilemanager.php", "wt")
tinyfilemanger.write(tinyfilemanger_data)
tinyfilemanger.close()
