FROM debian:trixie-backports
LABEL maintainer="tzp001"
LABEL name="grass-slim"

ENV TZ="Asia/Shanghai"

RUN mkdir -p /debian && \
    mkdir -p /debian/scripts
    
COPY debian/grass-slim/entrypoint.sh /debian/entrypoint.sh
COPY debian/grass-slim//install_deb.sh /debian/install_deb.sh
COPY debian/grass/grass*deb /debian/grass.deb

# 添加执行权限
RUN chmod 777 /debian/entrypoint.sh
RUN chmod 777 /debian/install_deb.sh

# 安装ssl支持
RUN apt-get update
RUN apt install -y ca-certificates figlet

# 换清华源
RUN cp -rp /etc/apt/sources.list.d /etc/apt/sources.list.d.bak 
RUN for file in /etc/apt/sources.list.d/*; do \ 
        sed -i "s/http:\/\/deb.debian.org/https:\/\/mirrors.tuna.tsinghua.edu.cn/g" "$file"; \
    done
    
EXPOSE 5800

VOLUME ["/debian/scripts/"]

ENTRYPOINT ["/debian/entrypoint.sh"]
