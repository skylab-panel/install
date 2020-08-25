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
cur.execute("CREATE DATABASE IF NOT EXISTS skylabpanel")
cur.execute("USE skylabpanel")

cur.execute("""CREATE TABLE IF NOT EXISTS tbl_users (
    id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(30) NOT NULL,
    lastname VARCHAR(30) NOT NULL,
    username VARCHAR(30) NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(50),
    account_type VARCHAR(50))
""")

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
email = email.strip("""!"#$%&'()*+,_/[\]^`{|}~ """) # pylint: disable=anomalous-backslash-in-string
email = email.lower()

cur.execute("INSERT INTO tbl_users (id, firstname, lastname, username, password, email, account_type) VALUES (?, ?, ?, ?, ?, ?, ?)", ("1", firstname, lastname, username, enpassword, email, "admin"))

cur.execute("CREATE USER " + username + " @'localhost' IDENTIFIED BY " + password)
cur.execute("GRANT USAGE ON *.* TO " + username + " @'localhost' IDENTIFIED BY ''")
#
main_config.close