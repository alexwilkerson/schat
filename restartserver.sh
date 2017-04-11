#!/bin/bash
tmux kill-session -t "srv"
tmux new-session -d -s "srv" "python3 srv.py"
