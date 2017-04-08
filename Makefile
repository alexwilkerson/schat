update:
	sed -e 's#dir="./"#dir="/tmp/"#' schat.sh > /tmp/.schat.sh
	chmod a+x /tmp/.schat.sh
	cp feeder /tmp/.feeder
	chmod a+x /tmp/.feeder
	cp eater /tmp/.eater
	chmod a+x /tmp/.eater
	touch /tmp/.schat.log
	chmod a+rw /tmp/.schat.log
	cp termcolors.py /tmp/termcolors.py
	chmod a+rw /tmp/termcolors.py

purify:
	rm /tmp/.schat.sh
	rm /tmp/.eater
	rm /tmp/.feeder
	rm /tmp/termcolors.py
	rm /tmp/.schat.log
