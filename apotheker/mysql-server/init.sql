DELETE FROM mysql.user WHERE user = 'zabbix';
FLUSH PRIVILEGES;
CREATE USER 'zabbix' IDENTIFIED WITH mysql_native_password BY 'zabbix';
