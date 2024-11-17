#!/bin/bash

deb_file="$1"

# 查询依赖
dependencies=$(dpkg -I "$deb_file" | grep "Depends:" | awk -F ':' '{print $2}' | tr ',' '\n')

# 输出依赖项
echo "依赖项：${dependencies[@]}"

echo "开始安装依赖"

for dependency in $dependencies; do
    apt-get install -y "$dependency"
done

echo "开始安装主程序"
dpkg -i "$deb_file"
