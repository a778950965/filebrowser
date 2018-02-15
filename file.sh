#!/bin/bash
screen -dmS A
sleep 1s
screen -x A -p 0 -X stuff $'/home/filebrowser > /home/file.log & \n'
sleep 1s
port=`cat /home/file.log | awk '{split($0,a,":");print a[4]}'`
echo $port
iptables -t nat -A PREROUTING -d 198.13.42.194 -p tcp --dport 1024 -j DNAT --to-destination 198.13.42.194:$port
number=`awk 'END{print NR}' /home/file.log `
echo number $number
echo now ok
screen -ls
while true
do
	echo 1
	sleep 5s
	if [ "$number"x != "1x" ]; then
		iptables -t nat -D PREROUTING -d 198.13.42.194 -p tcp --dport 1024 -j DNAT --to-destination 198.13.42.194:$port
		screen -x A -p 0 -X stuff $'kill %1 \n'
		screen -x A -p 0 -X stuff $'jobs \n'
		echo kill
		screen -ls
		screen -x A -p 0 -X stuff $'exit \n'
		echo after kill
		sleep 1s
		screen -ls
		screen -dmS A
		screen -x A -p 0 -X stuff $'/home/filebrowser > /home/file.log & \n'
		sleep 1s
		echo now
		screen -ls
		sleep 1s
		port=`cat /home/file.log | awk '{split($0,a,":");print a[4]}'`
		iptables -t nat -A PREROUTING -d 198.13.42.194 -p tcp --dport 1024 -j DNAT --to-destination 198.13.42.194:$port
		sleep 5s
		number=`awk 'END{print NR}' /home/file.log `
	fi
done
