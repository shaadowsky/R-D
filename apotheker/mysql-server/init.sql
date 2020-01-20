DELETE FROM mysql.user WHERE user = 'zabbix';
FLUSH PRIVILEGES;
CREATE USER 'zabbix'@'%' IDENTIFIED WITH mysql_native_password BY 'zabbix';
GRANT ALL PRIVILEGES ON *.* TO 'zabbix'@'%';
ALTER USER 'root' IDENTIFIED WITH mysql_native_password BY 'root';