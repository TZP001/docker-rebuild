#!/bin/bash

figlet Diy Debian

echo -e "======================1. 检测自定义环境变量文件========================\n"

DIY_ENV_FILE="/debian/scripts/env"
echo  -e "NOVNCPort、VNC_USERNAME、VNC_PASSWPRD、RUN_RPO可以在“$DIY_ENV_FILE”中重新设置，使用export AA="" 设置"
if [ -f "$DIY_ENV_FILE" ]; then
    echo -e "检测到$DIY_ENV_FILE 文件，重新设置相应环境变量\n"
    # 读取 env 文件
    while IFS= read -r line; do
        # 提取变量名和值
        var=$(echo "$line" | cut -d'=' -f1 | cut -d' ' -f2)
        value=$(echo "$line" | cut -d'=' -f2)
    
        # 判断变量是否存在且值是否相等
        if [ -z "${!var}" ] || [ "${!var}"!= "$value" ]; then
            sed -i "/export $var=/d"  ~/.bashrc
            echo "export $var=$value" >> ~/.bashrc
    	fi
    done < "$DIY_ENV_FILE"
elif [ ! -f "$DIY_ENV_FILE" ]; then
    echo -e "自定义环境变量文件$DIY_ENV_FILE 不存在\n"
fi

# 设置屏幕
echo 'export DISPLAY=$(hostname)":1"' >>  ~/.bashrc
# 设置用户名
sed -i "/export USER=/d"  ~/.bashrc
echo "export USER=${VNC_USERNAME:-VNCC}" >> ~/.bashrc

# 环境变量立即生效
source ~/.bashrc

# 获取环境变量
NOVNCPort="${NOVNCPort:-5800}"
vncpwd="${VNC_PASSWPRD:-123456}"
DIY_RUSN_SH="${DIY_RUSN_SH}"
RUN_RPO="${RUN_RPO}"

echo -e "======================2. 设置远程桌面账号和密码========================\n"

# 自动设置VNC密码
echo -e "设置vnc密码\n"
expect << EOF
	spawn vncpasswd
	expect "Password"
	send "${vncpwd}\r"
	expect "Verify"
	send "${vncpwd}\r"
	expect "Would you like to enter a view-only password (y/n)?"
	send "n\r"
	expect eof
EOF

pgrep -f tightvnc > /dev/null && pgrep -f tightvnc | xargs -n 1 kill -9
pgrep -f websockify > /dev/null && pgrep -f websockify | xargs -n 1 kill -9
rm -rf /tmp/.X*lock
rm -rf /tmp/.X*unix
tightvncserver :1 -geometry 1600x900 -depth 24 -port 5901
echo "" > '/usr/share/novnc/Click 【vnc.html】!!! NOT ME!!!'
websockify -D --web=/usr/share/novnc $NOVNCPort localhost:5901

echo -e "======================3. 检测自定义脚本是否存在========================\n"


if [ "$DIY_RUSN_SH" != "" ] && [ -f "$DIY_RUSN_SH" ]; then
  echo -e "执行自定义脚本$DIY_RUSN_SH，后台运行 \n"
  "$DIY_RUSN_SH" &
elif [ ! -f "$DIY_RUSN_SH" ]; then
  echo -e "自定义脚本$DIY_RUSN_SH 不存在\n"
else
  echo -e "未定义自定义脚本\n"
fi

echo -e "======================4. 运行镜像内部自定义程序========================\n"

program="/usr/bin/grass"

if [ -f "$program" ] && [ "$RUN_RPO" = "true" ]; then
  # 文件存在，执行文件
  nohub "$program" > /dev/null 2>&1 &
elif [ "$RUN_RPO" != "true" ]; then
  echo -e "未定义RUN_PRO,不执行$program \n"
else
  echo -e "$program 不存在\n"
fi

echo -e "安装本地deb包失败，可以用/debian/install_deb.sh脚本安装"
echo -e "使用方法：/debian/install_deb.sh xx.deb"

# 检查是否存在PID为1的进程，但排除当前进程
if ! ps -p 1 -o pid= | grep -v "$$" > /dev/null; then
    bash   #这个不能取消，否则脚本运行完，容器将重启
fi

