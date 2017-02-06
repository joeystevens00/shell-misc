#!/bin/bash
function isIp() {
	echo "$1" | grep -E "[0-9]+\.[0-9]+\.+[0-9]+\.[0-9]+" 
} 

IP_ADDR_SERVICES="
http://whatismyip.akamai.com/
http://icanhazip.com/
https://ident.me/
https://tnx.nl/ip
http://ipecho.net/plain
http://wgetip.com/
http://ip.tyk.nu/
http://curlmyip.com/
https://corz.org/ip
http://bot.whatismyipaddress.com/
https://ifcfg.me/
http://ipof.in/txt
http://l2.io/ip
http://eth0.me/
https://curlmyip.com/
"
for ipservice in $(echo $IP_ADDR_SERVICES); do
	echo "Trying: $ipservice"
	ip=$(curl -s --connect-timeout 10 $ipservice)
	isTheResposeAnIp=$(isIp "$ip")
	if [ -n "$isTheResposeAnIp" ]; then 
		echo "$ip"
		foundIp="$ip"
		break
	fi
done

if [ -n "$foundIp" ]; then 
	bash send-command.sh "echo "$foundIp" > $REMOTE_WWW_DIR/ip"
else
	echo "ERROR: cound not get IP"
fi
