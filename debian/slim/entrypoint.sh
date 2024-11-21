#!/bin/bash

UPDATE=true
dpkg -s "figlet" >/dev/null 2>&1 && figlet Diy Debian && UPDATE=false
echo -e "======================1. 安装novnc远程桌面========================\n"
# 安装必要软件
packages=("procps" "net-tools" "inetutils-ping" "wget" "xfce4" "xfce4-goodies" "xorg" "dbus-x11" "x11-xserver-utils" "tightvncserver" "novnc" "expect" "figlet")

if $UPDATE; then
    apt-get update
    for package in "${packages[@]}"; do
        if ! dpkg -s "$package" >/dev/null 2>&1; then
            apt-get install -y "$package"
        fi
    done
fi
echo -e "======================2. 检测自定义环境变量文件========================\n"

DIY_ENV_FILE="/debian/scripts/env"
echo  -e "NOVNCPort、VNC_USERNAME、VNC_PASSWPRD、RUN_RPO可以在“$DIY_ENV_FILE”中重新设置，使用export AA=""设置"
if [ -f "$DIY_ENV_FILE" ]; then
  echo -e "检测到$DIY_ENV_FILE 文件，重新设置相应环境变量\n"
  bash "$DIY_ENV_FILE"
elif [ ! -f "$DIY_ENV_FILE" ]; then
  echo -e "自定义环境变量文件$DIY_ENV_FILE 不存在\n"
fi

echo -e "======================3. 设置远程桌面账号和密码========================\n"

NOVNCPort="${NOVNCPort:-5800}"
# 自动设置VNC密码
export USER="${VNC_USERNAME:-VNCC}"
vncpwd="${VNC_PASSWPRD:-123456}"
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

pgrep -f tightvnc > /dev/null && pgrep -f tightvnc | xargs kill -9
pgrep -f websockify > /dev/null && pgrep -f websockify | xargs kill -9
rm -rf /tmp/.X*lock
rm -rf /tmp/.X*unix
tightvncserver -geometry 1024x768 -depth 24 -port 5901
echo "" > '/usr/share/novnc/Click 【vnc.html】!!! NOT ME!!!'
websockify -D --web=/usr/share/novnc $NOVNCPort localhost:5901

echo -e "======================4. 检测自定义脚本是否存在========================\n"

DIY_RUSN_SH="${DIY_RUSN_SH}"
if [ "$DIY_RUSN_SH" != "" ] && [ -f "$DIY_RUSN_SH" ]; then
  echo -e "执行自定义脚本$DIY_RUSN_SH，后台运行 \n"
  "$DIY_RUSN_SH" &
elif [ ! -f "$DIY_RUSN_SH" ]; then
  echo -e "自定义脚本$DIY_RUSN_SH 不存在\n"
else
  echo -e "未定义自定义脚本\n"
fi

echo -e "======================5. 运行镜像内部自定义程序========================\n"

program="/usr/bin/grass"
RUN_RPO="${RUN_RPO}"

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

if ! ps -p 1 -o pid= | grep -v "$$" > /dev/null; then
    bash   #这个不能取消，否则脚本运行完，容器将重启
fi

