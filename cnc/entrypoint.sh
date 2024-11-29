#!/bin/bash

# Pornire MariaDB
service mariadb start

# Așteaptă MariaDB să fie gata
while ! mysqladmin ping --silent; do
    sleep 1
done

# Inițializare baza de date dacă este prima pornire
if [ ! -f /app/sql-init ]; then
    mysql -u root < /app/db.sql
    touch /app/sql-init
fi

# Pornire CNC
echo "Starting CNC service..."
/app/cnc


