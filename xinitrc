#!/bin/bash
# Enforce locales from the beginning
unset LC_COLLATE
export LC_CTYPE=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_MESSAGES=C
export LC_PAPER=en_US.UTF-8
export LC_NAME=en_US.UTF-8
export LC_ADDRESS=en_US.UTF-8
export LC_TELEPHONE=en_US.UTF-8
export LC_MEASUREMENT=en_US.UTF-8
export LC_IDENTIFICATION=en_US.UTF-8

# Start i3 and log to file
echo "Starting at $(date)" >> ~/.config/i3/logfile
exec /usr/bin/i3 -c ~/.config/i3/config -V -d all >> ~/.config/i3/logfile
