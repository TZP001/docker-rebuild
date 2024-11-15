FROM debian:bullseye as debian-diy
LABEL previous-stage=debian-diy

COPY diy/debian/entrypoint.sh /debian/entrypoint.sh

COPY --from=debian-diy /debian/entrypoint.sh /debian/entrypoint.sh

# 添加执行权限
RUN chmod 777 /debian/entrypoint.sh

WORKDIR /debian/
VOLUME ["/debian/scripts/"]
ENTRYPOINT ["/debian/entrypoint.sh"]
