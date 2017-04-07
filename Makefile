update:
	sed -e 's#dir="./"#dir="/tmp/"#' schat.sh > /tmp/.schat.sh
	chmod a+x /tmp/.schat.sh
	cp .commander /tmp/.commander
	cp .logreader /tmp/.logreader
	touch /tmp/.schat.log
	chmod a+wr /tmp/.schat.log

purify:
	rm /tmp/.schat.sh
	rm /tmp/.commander
	rm /tmp/.logreader
	rm /tmp/.top_pane_awilkers.sh
	rm /tmp/.bottom_pane_awilkers.sh
	rm /tmp/.schat.log
