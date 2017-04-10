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
# tmux kill-session -t "schattr"
tmux new-session -d -s "schattr" "/tmp/.eater"
tmux split-window -h "/tmp/.dxbdxb7"
tmux resize-pane -t 1 -x 15
tmux split-window -t 0 -v "/tmp/.feeder"
tmux resize-pane -t 2 -y 2
tmux attach-session
