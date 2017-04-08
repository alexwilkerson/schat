#!/bin/bash

###### -- schat.sh -- ######
# Written by Alex Wilkerson
# School chat for UNO
# Usage: ./schat.sh
############################

chmod a+x /tmp/.eater
chmod a+x /tmp/.feeder
chmod a+r /tmp/termcolors.py
chmod a+rw /tmp/.schat.log

# set up tmux session
tmux new-session -d -s "schattr" "/tmp/.eater"
tmux split-window -v "/tmp/.feeder"
tmux resize-pane -D 20
tmux attach-session 
