FROM ubuntu:latest

RUN apt update && apt install -y sudo openbsd-inetd telnetd
RUN useradd -rm -d /home/admin -s /bin/bash -g root -G sudo -u 1001 admin -p "$(openssl passwd -1 admin)"
RUN echo "telnet stream tcp nowait root /usr/sbin/telnetd telnetd" >> /etc/inetd.conf

EXPOSE 23

ENTRYPOINT service openbsd-inetd start && sleep infinity

















