Pseudo dynamic dns - constantly updates a remote file with your current ip address
   
#### Install    
On the machine that's IP will be logged    

Set the following env variables   
$REMOTE_IP  - ip addr or domain of the remote server     
$REMOTE_USER - username to ssh into     
$REMOTE_PASSWORD - password of user    
$REMOTE_WWW_DIR - location that the ip file will reside in   

Add pseudodynamicdns.sh as a cronjob
` sudo crontab -e `    
` * * * * * pseudodynamicdns.sh `    

Then whenver you need the ip address of that machine you can    
`curl -s $REMOTE_IP/ip`
