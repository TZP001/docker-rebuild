FROM debian:trixie-backports
LABEL maintainer="tzp001"
LABEL name="debianDiy"

ENV TZ="Asia/Shanghai"

RUN mkdir -p /debian && \
    mkdir -p /debian/scripts
    
RUN apt-get update
RUN apt-get install -y "procps" "net-tools" "inetutils-ping" "xfce4" "xfce4-goodies" "xorg" "dbus-x11" "x11-xserver-utils" "tightvncserver" "novnc" "expect" "figlet"

COPY diy/debian/entrypoint.sh /debian/entrypoint.sh

# 添加执行权限
RUN chmod 777 /debian/entrypoint.sh

WORKDIR /debian/

EXPOSE 5800

VOLUME ["/debian/scripts/"]

ENTRYPOINT ["/debian/entrypoint.sh"]
