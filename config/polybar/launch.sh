#!/bin/bash

# Terminate any running polybar instances
# killall -q polybar

# Using ipc if it's enabled to kill all the bars
polybar-msg cmd quit

# Launch Polybar using the config located at ~/.config/polybar/config.ini
polybar vmbar 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."
