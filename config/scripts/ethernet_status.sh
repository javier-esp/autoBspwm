#!/bin/sh

echo "%{F#8bcc6a} %{F#FFFFFF}$(/usr/sbin/ifconfig | grep "inet " | awk '{print $2}')%{u-}"
