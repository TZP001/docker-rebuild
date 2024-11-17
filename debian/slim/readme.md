## slim版本
### 说明
* 相关软件通过开启容器时自动下载安装，故镜像本身较小
------------
### 使用方法
```
docker run -it \
	--name="debian" \
	-p 8099:5800 \
	-v <你的本地目录>/debian/scripts:/debian/scripts \
	-e VNC_USERNAME="VNCC" \
	-e VNC_PASSWPRD="123456" \
	-e NOVNCPort="5800" \
	-e DIY_RUSN_SH="/debian/scripts/run.sh" \
	-e RUN_RPO=true \
	-e TZ="Asia/Shanghai" \
	--dns 223.5.5.5 \
	tzp001/tzp001:diy-debian-slim
```
* 内置novnc，通过8099端口访问
* 通过```DIY_RUSN_SH```可以设置开机运行脚本
* 通过```/debian/scripts/env```文件可以重新设置环境变量
* 通过```RUN_RPO```可以设置/usr/bin/grass自动启动，为了方便自己设置的
* 所有以上变量均可通过```/debian/scripts/env```文件重新设置
