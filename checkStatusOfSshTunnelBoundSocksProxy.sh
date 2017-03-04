#!/bin/bash
# Checks that an SSH tunnel that is bound to a local port (effectively making a SOCKS proxy) is still up
# If it finds the tunnel is dead it will kill the ssh processes and restart the tunnel
# Best useds as a cronjob ran every few minutes  (5 seems OK)
# */5 * * * * /root/bin/checkStatusOfSshTunnelBoundSocksProxy.sh > /root/checkStatus.log 2> /root/checkStatuserror.log
sshproxybindhost="localhost"
sshproxybindport="9999"
sshproxy=""
sshproxyuser=""
password=""

proxySet() {
	password="$1"
	user="$2"
	server="$3"
	port="$4"
	sshpass -p "$password" ssh -N -4 "$user"@"$server" -D "$port" &
}

checkStatus() {
	# Returns 0 if success
	# Returns 1 if failure
	tryNc=`printf "HEAD / HTTP/1.0\r\n\r\n" | nc -X 5 -x $sshproxybindhost:$sshproxybindport google.com 80`
	if [ "$tryNc" ]; then
		return 0
	else 
		tryCurl=`curl --connect-timeout 5 -Is --socks5 $sshproxybindhost:$sshproxybindport google.com`
		if [ "$tryCurl" ]; then
			return 0
		else 
			return 1
		fi
	return 1
	fi
}

checkStatus ; proxyStatus=$?
if (($proxyStatus == 0)); then 
	exit 0
else
	retry=0
	until (( "$proxyStatus" == 0 ))  || ((retry>=3)); do
		currentServicePid=` ps aux | grep ssh | grep "$sshproxybindport" | grep "$sshproxy" | awk {'print $2'}`
		kill -9 $currentServicePid
		for pid in `echo -e "$currentServicePid"`; do kill -9 $pid; done
		proxySet $password $sshproxyuser $sshproxy $sshproxybindport 
		sleep 15
		checkStatus ; proxyStatus=$?
		((retry++))
	done
fi

