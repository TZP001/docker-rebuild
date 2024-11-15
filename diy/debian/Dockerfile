FROM debian:bullseye
COPY ../entrypoint.sh /debian/entrypoint.sh
# 添加执行权限
RUN chmod +x /entrypoint.sh

WORKDIR /debian/
VOLUME ["/debian/scripts/"]
ENTRYPOINT ["/debian/entrypoint.sh"]
