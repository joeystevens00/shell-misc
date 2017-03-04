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
	sshpass -p "$password" ssh -N -4 -v "$user"@"$server" -D "$port" &
}

checkStatus() {
	proxyStatus=`curl --connect-timeout 5 -Is --socks5 $sshproxybindhost:$sshproxybindport google.com`
}

checkStatus
if [ "$proxyStatus" ]; then 
	exit 0
else
	retry=0
	until [ "$proxyStatus" ]  || ((retry>=3)); do
		echo "$proxyStatus"
		currentServicePid=` ps aux | grep ssh | grep "$sshproxybindport" | grep "$sshproxy" | awk {'print $2'}`
		kill -9 $currentServicePid
		sleep 1
		proxySet $password $sshproxybindport $sshproxyuser@$sshproxy
		sleep 19
		checkStatus
		((retry++))
	done
fi

