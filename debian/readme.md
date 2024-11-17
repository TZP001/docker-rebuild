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
	tzp001/tzp001:diy-debian-full
```
* 内置novnc，通过8099端口访问，可通过```DIY_RUSN_SH```设置开机运行脚本，可通过```/debian/scripts/env```重新设置环境变量
