FROM debian:bullseye
LABEL maintainer="tzp001"
LABEL name="debianDiy"

ENV TZ="Asia/Shanghai"

RUN mkdir -p /debian && \
    mkdir -p /debian/scripts
    
COPY diy/debian/entrypoint.sh /debian/entrypoint.sh

# 添加执行权限
RUN chmod 777 /debian/entrypoint.sh

WORKDIR /debian/

VOLUME ["/debian/scripts/"]
ENTRYPOINT ["/debian/entrypoint.sh"]
