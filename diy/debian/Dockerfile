# 使用Debian Bullseye (最新版本) 作为基础镜像
FROM debian:bullseye-slim
 
# 安装curl、gnupg2和iputils-ping
RUN apt-get update && \
    apt-get install -y curl gnupg2 iputils-ping && \
    rm -rf /var/lib/apt/lists/*
 
# 设置环境变量
ENV LANG C.UTF-8
 
# 设置工作目录
WORKDIR /app
 
# 将/app目录设为卷
VOLUME /app
 
# 设置容器启动时执行的命令
CMD ["bash"]
