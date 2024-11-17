## docker For Grass
### 说明
* 集成grass
* 在容器中运行grass，没有注册的可以用我的邀请码 ```HvC7SY9DIqWLTTz```
* 注册点击[这里](https://app.getgrass.io/register/?referralCode=HvC7SY9DIqWLTTz)
----------------
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
* 内置novnc，通过8099端口访问
* 通过```DIY_RUSN_SH```可以设置开机运行脚本
* 通过```/debian/scripts/env```文件可以重新设置环境变量
* 通过```RUN_RPO```可以设置/usr/bin/grass自动启动，为了方便自己设置的
* 所有以上变量均可通过```/debian/scripts/env```文件重新设置
