#!/bin/bash

###### -- schat.sh -- ######
# Written by Alex Wilkerson
# School chat for UNO
# Usage: ./schat.sh
############################

# get username
userid=$(whoami)
# change this to /tmp/ if updating
dir="./"

# script for bottom pane
cat > /tmp/.bottom_pane_$userid.sh << EOF
#!$(which bash)
function cleanup {
    rm /tmp/.bottom_pane_$userid.sh
    tmux kill-session -t schat
}

echo -e "[\$(TZ=UTC+5 date '+%F %H:%M')] \e[1m\e[35m$userid enters the room.\e[0m" >> \\
    /tmp/.schat.log

while true; do
    echo -en "\r\e[1m\e[35mmessage: \e[0m"
    read -e messg
    if [ "\$messg" == '!exit' ]
    then
        echo -e "[\$(TZ=UTC+5 date '+%F %H:%M')] \e[1m\e[35m$userid leaves the room.\e[0m" >> \\
        /tmp/.schat.log
        break
    elif [ "\$messg" == '!deletelog' ]
    then
        rm /tmp/.schat.log
        touch /tmp/.schat.log
        chmod a+w /tmp/.schat.log
        echo -e "[\$(TZ=UTC+5 date '+%F %H:%M')] \e[1m\e[35m$userid deleted chat log.\e[0m" >> \\
        /tmp/.schat.log
        clear
    elif [ "\$messg" == 'Shrek' ]
    then
        while read -e line; do
            sleep 1
            echo -e "[\$(TZ=UTC+5 date '+%F %H:%M')] \e[1m\e[34m$userid:\e[0m \$line" >> \\
            /tmp/.schat.log && \\
            clear
        done < /tmp/.allstar.txt
    elif [[ \$messg =~ ^! ]]
    then
        clear
        setterm -cursor off
        $dir.commander $userid "\$messg"
        setterm -cursor on
        clear #comment out this line to error check
    else
        echo -e "[\$(TZ=UTC+5 date '+%F %H:%M')] \e[1m\e[34m$userid:\e[0m \$messg" >> \\
        /tmp/.schat.log && \\
        clear
    fi
done
cleanup
EOF

chmod +x /tmp/.bottom_pane_$userid.sh
chmod +x /tmp/.eater
chmod a+w /tmp/.schat.log

# set up tmux session
tmux new-session -d -s "schattr" "/tmp/.eater"
tmux split-window -v "/tmp/.bottom_pane_$userid.sh"
tmux resize-pane -D 20
tmux attach-session 
