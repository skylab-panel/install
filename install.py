import mariadb
import subprocess
import time
import os, sys
import bcrypt


# This script must be run as root!
if not os.geteuid()==0:
    sys.exit('This script must be run as root!')

os.chdir("/")



# Config File #
subprocess.run(['bash','-c', 'cd / & mkdir skylabpanel'])
main_config = open("/skylabpanel/main.txt", "w")

# Create skylabpanel Database #
print ("\nSkyLab Panel needs to set its configration file. Follow on Screen Instructions! \n")
time.sleep(2)
mysqlrootusername = input("Enter MySQL Root Username: ")
mysqlrootpassword = input("Enter MySQL Root Password: ")
mydb = mysql.connector.connect(
    host="localhost",
    user=mysqlrootusername,
    password=mysqlrootpassword,
    auth_plugin='mysql_native_password',
)
mycursor = mydb.cursor()


mycursor.execute("CREATE DATABASE skylabpanel")

# Conect to Database and add User #
mydb = mysql.connector.connect(
    host="localhost",
    user=mysqlrootusername,
    password=mysqlrootpassword,
    database="skylabpanel",
    auth_plugin='mysql_native_password',
)
mycursor.execute("""CREATE TABLE tbl_users (
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

sql = "INSERT INTO tbl_users (firstname, lastname, username, password, email) VALUES (%s, %s, %s, %s, %s)"
val = (firstname, lastname, username, password, email)
mycursor.execute(sql, val)

mycursor.execute("CREATE USER " + username + " @'localhost' IDENTIFIED BY " + password)
mydb.commit()
