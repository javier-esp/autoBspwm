#!/bin/sh

ip_target=$(cat ~/.config/scripts/target | awk '{print $1}')
name_target=$(cat ~/.config/scripts/target | awk '{print $2}')

if [ $ip_target ] && [ $name_target ]; then
	echo "%{F#8bcc6a}什%{F#FFFFFF} $ip_target - $name_target"
elif [ $(cat ~/.config/scripts/target | wc -w) -eq 1 ]; then
	echo "%{F#8bcc6a}什%{F#FFFFFF} $ip_target"
else
	echo "%{F#8bcc6a}ﲅ %{u-}%{F#FFFFFF} No target"
fi