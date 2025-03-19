#!/bin/bash

MYSQL_ROOT_USER="root"
MYSQL_ROOT_PASSWORD="1" # Change!
MYSQL_EXPORTER_PASSWORD="123" # Change

mysql -u "${MYSQL_ROOT_USER}" -p"${MYSQL_ROOT_PASSWORD}" <<EOF
CREATE USER 'mysqld_exporter'@'localhost' IDENTIFIED BY '${MYSQL_EXPORTER_PASSWORD}';
GRANT PROCESS, SELECT ON *.* TO 'mysqld_exporter'@'localhost';

CREATE USER 'mysqld_exporter'@'%' IDENTIFIED BY '${MYSQL_EXPORTER_PASSWORD}';
GRANT PROCESS, SELECT ON *.* TO 'mysqld_exporter'@'%';
FLUSH PRIVILEGES;
EOF

if [[ $? -eq 0 ]]; then
    echo "Пользователь mysqld_exporter успешно создан и привилегии предоставлены."
else
    echo "Произошла ошибка при создании пользователя mysqld_exporter."
fi
