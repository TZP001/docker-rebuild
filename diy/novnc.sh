#!/bin/bash

# 安装必要软件
packages=("procps" "net-tools" "inetutils-ping" "xfce4" "xfce4-goodies" "xorg" "dbus-x11" "x11-xserver-utils" "tightvncserver" "novnc" )

for package in "${packages[@]}"; do
    if! dpkg -s "$package" >/dev/null 2>&1; then
        apt-get update
        apt-get install -y "$package"
    fi
done

NOVNCPort="${VNC_PASSWPRD:-5800}"
# 自动设置VNC密码
USER="${VNC_USERNAME:-VNCC}"
vncpwd="${VNC_PASSWPRD:-123456}"
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

pgrep -f novnc | xargs kill || true
pgrep -f novnc | xargs kill || true
rm -rf /tmp/.X*lock
rm -rf /tmp/.X*unix
tightvncserver -geometry 1024x768 -depth 24 -port 5901
websockify -D --web=/usr/share/novnc/ $NOVNCPort localhost:5901

program="/usr/bin/grass"
 
if [ -f "$program" ]; then
    # 文件存在，执行文件
    "$program"
else
    echo "文件不存在，请先确保文件路径正确。"
fi
