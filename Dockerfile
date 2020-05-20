FROM debian:buster
WORKDIR /root/
ENV DEBIAN_FRONTEND noninteractive
COPY install.sh build_settings Bela/ ./
RUN ./install.sh