#!/bin/bash

###### -- schat.sh -- ######
# Written by Alex Wilkerson
# School chat for UNO
# Usage: ./schat.sh
############################

# get username
userid=$(whoami)

# script for top pane
cat > /tmp/.top_pane_$userid.sh << EOF
#!$(which bash)
touch /tmp/.schat.log
echo -e "\e[1m\e[31m*** \e[35mwelcome to schat school chat \e[31m***\e[0m"
echo -e "\e[1m\e[31mtype !exit to exit\e[0m"
echo ""
tail -f /tmp/.schat.log | sed \\
     -e "s/\($userid:\)/\o033[31m\o033[1m\1\o033[0m/" \\
     -e "s/\*\(.*\)\*/\o033[1m\\1\o033[0m/"
EOF

# script for bottom pan
cat > /tmp/.bottom_pane_$userid.sh << EOF
#!$(which bash)
function cleanup {
    rm /tmp/.top_pane_$userid.sh
    rm /tmp/.bottom_pane_$userid.sh
    tmux kill-session -t schat
}

while true; do
    echo -en "\rmessage: "
    read messg
    [ "\$messg" == '!exit' ] && break

    echo "[\$(TZ=UTC-7 date '+%F %H:%M')] $userid: \$messg" >> \\
        /tmp/.schat.log && \\
        clear
done
cleanup
EOF

chmod +x /tmp/.top_pane_$userid.sh
chmod +x /tmp/.bottom_pane_$userid.sh
chmod a+w /tmp/.schat.log

# set up tmux session
tmux new-session -d -s "schat" "/tmp/.top_pane_$userid.sh"
tmux split-window -v "/tmp/.bottom_pane_$userid.sh"
tmux resize-pane -D 20
tmux attach-session 

