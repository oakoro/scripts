Adding Users to Your SQL Azure Database
Connect to Master
CREATE LOGIN readonlylogin WITH password='1231!#ASDF!a';

Connect to User Database
CREATE USER readonlyuser FROM LOGIN readonlylogin;