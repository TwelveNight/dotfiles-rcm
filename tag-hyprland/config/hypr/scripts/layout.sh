#!/usr/bin/env bash

# Define the text to be linked
files=(
	"$HOME/.config/hypr/custom/monitors/multi.conf"
	"$HOME/.config/hypr/custom/monitors/single_external.conf"
	"$HOME/.config/hypr/custom/monitors/single_internal.conf"
	"$HOME/.config/hypr/custom/monitors/mirror.conf"
)

# Get the parameters entered by the user
if [ $# -eq 0 ]; then
	echo "请选择显示器布局："
	echo "1. 扩展布局"
	echo "2. 外接显示屏"
	echo "3. 内置屏幕"
	echo "4. 镜像布局"
	read -r num
else
	num=$1
fi

# Determine whether user input exists
if [ -z "$num" ] || [ "$num" -lt 1 ] || [ "$num" -gt ${#files[@]} ]; then
	echo "无效的输入，请重新输入！"
	exit 1
fi

# Select the file to link to
selected_file="${files[$((num - 1))]}"

# Cover soft chain
ln -sf "$selected_file" "$HOME/.config/hypr/custom/monitors.conf"

# if layout is mirror, reload swww
if [ "$num" -eq 4 ]; then
	bash "$HOME/.config/hypr/scripts/swwwreload.sh"
fi

hyprctl reload

killall ags ydotool
nohup ags >/dev/null 2>&1 &

sleep 1

if [ $? -eq 0 ]; then
	echo "布局已切换为：$selected_file"
else
	echo "布局切换失败！"
fi
