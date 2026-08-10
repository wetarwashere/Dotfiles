#!/bin/sh

awww-daemon --no-cache &

while ! awww query >/dev/null 2>&1; do
    sleep 0.1
done

awww img $HOME/Pictures/Wallpapers/Frontier.png --transition-fps 60 --transition-type grow --transition-pos center --transition-duration 1
