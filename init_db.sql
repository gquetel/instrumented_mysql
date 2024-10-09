ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
create database users;
use users;
CREATE USER 'toto'@'localhost' IDENTIFIED BY 'toto';
GRANT SELECT ON *.* TO 'toto'@'localhost' WITH GRANT OPTION;
flush privileges; 