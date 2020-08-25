import mariadb
import subprocess
import time
import os, sys
import bcrypt

os.chdir("/")
main_config = open("/skylabpanel/main.conf", "w")

# Create skylabpanel Database #
try:
    conn = mariadb.connect(
        user="root",
        password=sys.argv[1],
        host="localhost",
        port=3306,
    )
except mariadb.Error as e:
    print(f"Error connecting to MariaDB Platform: {e}")
    sys.exit(1)
else:
    print("Successful Conection to the Database")
cur = conn.cursor()
cur.execute("CREATE DATABASE skylabpanel")
cur.execute("USE skylabpanel")

cur.execute("""CREATE TABLE tbl_users (
    id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(30) NOT NULL,
    lastname VARCHAR(30) NOT NULL,
    username VARCHAR(30) NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(50),
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)
""")

print("The Following Infomation Will be Used for Logging into SkyLab Panel(Username and Password are Case Sestive!)")
firstname = input("Please Enter your Firstname: ")
lastname = input("Please enter your Lastname: ")
username = input("Please Enter a Username(admin and root are not recommended!): ")
password = input("Please Enter a Password: ")
email = input("Please Enter an Email Adress: ")

main_config.write(username+"\n")
main_config.write(password+"\n")

password = password.encode('utf-8')
password = bcrypt.hashpw(password, bcrypt.gensalt())
email = email.strip("""!"#$%&'()*+,_/[\]^`{|}~ """) # pylint: disable=anomalous-backslash-in-string
email = email.lower()

cur.excute("INSERT INTO tbl_users (firstname, lastname, username, password, email) VALUES (?, ?)", (firstname, lastname, username, password, email))

cur.excute("CREATE USER " + username + " @'localhost' IDENTIFIED BY " + password)
main_config.close