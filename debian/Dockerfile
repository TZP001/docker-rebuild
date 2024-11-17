FROM debian:trixie-backports
LABEL maintainer="tzp001"
LABEL name="debianDiy"

ENV TZ="Asia/Shanghai"

RUN mkdir -p /debian && \
    mkdir -p /debian/scripts
    
RUN apt-get update
RUN apt-get install -y "procps" "net-tools" "inetutils-ping" "xfce4" "xfce4-goodies" "xorg" "dbus-x11" "x11-xserver-utils" "tightvncserver" "novnc" "expect" "figlet"

# 换清华源
RUN cp -rp /etc/apt/sources.list.d /etc/apt/sources.list.d.bak 
RUN for file in /etc/apt/sources.list.d/*; do \ 
        sed -i "s/http:\/\/deb.debian.org/https:\/\/mirrors.tuna.tsinghua.edu.cn/g" "$file" \
    done

COPY debian/entrypoint.sh /debian/entrypoint.sh
COPY debian/install_deb.sh /debian/install_deb.sh

# 添加执行权限
RUN chmod 777 /debian/entrypoint.sh
RUN chmod 777 /debian/install_deb.sh

WORKDIR /debian/

EXPOSE 5800

VOLUME ["/debian/scripts/"]

ENTRYPOINT ["/debian/entrypoint.sh"]
