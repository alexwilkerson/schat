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
tail -F /tmp/.schat.log | sed \\
     -e "s/\($userid:\)/\o033[31m\o033[1m\1\o033[0m/" \\
     -e "s/\*\(.*\)\*/\o033[1m\\1\o033[0m/"
EOF

# script for bottom pane
cat > /tmp/.bottom_pane_$userid.sh << EOF
#!$(which bash)
function cleanup {
    rm /tmp/.top_pane_$userid.sh
    rm /tmp/.bottom_pane_$userid.sh
    tmux kill-session -t schat
}

echo -e "[\$(TZ=UTC+5 date '+%F %H:%M')] \e[1m\e[35m$userid enters the room.\e[0m" >> \\
    /tmp/.schat.log

while true; do
    echo -en "\r\e[1m\e[35mmessage: \e[0m"
    read -e messg
    $firstchar = ${messg:0:1}
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
        ./.commander $userid "\$messg"
        setterm -cursor on
        clear #comment out this line to error check
    elif [ "\${messg/%\ */}" == '!roll' ]
    then
        # lastarg=("\${messg/#*\ /}")
        local lastarg="test"
        echo \$lastarg >> /tmp/.schat.log
        echo -e "[\$(TZ=UTC+5 date '+%F %H:%M')] \e[1m\e[34m$userid's d20 landed on \$((1 + RANDOM % 20)).\e[0m" >> \\
        /tmp/.schat.log && \\
        clear
    else
        echo -e "[\$(TZ=UTC+5 date '+%F %H:%M')] \e[1m\e[34m$userid:\e[0m \$messg" >> \\
        /tmp/.schat.log && \\
        clear
    fi
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
