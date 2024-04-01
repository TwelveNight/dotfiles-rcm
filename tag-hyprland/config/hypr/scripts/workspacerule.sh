#!/usr/bin/env bash
MULTI=$HOME/.config/hypr/custom/monitors/multi.conf
SINGLE=$HOME/.config/hypr/custom/monitors/single_internal.conf
hyprctl monitors | rg '\b(HDMI|DP)' >/dev/null
if [[ $? -eq 0 ]]; then
	ln -sf "$MULTI" "$HOME/.config/hypr/custom/monitors.conf"
	# bash $HOME/.config/hypr/scripts/moveworkspace.sh
else
	ln -sf "$SINGLE" "$HOME/.config/hypr/custom/monitors.conf"
fi

hyprctl reload
