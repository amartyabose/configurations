#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polyexample.log
polybar example >>/tmp/polyexample.log 2>&1 & disown

echo "Bars launched..."
