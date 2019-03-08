#!/bin/bash
# iptables -nvL

echo "do you want to add or remove port ?"
echo "type n for new, r for remove, c for custom list"
read in

if [[ $in=="n" ]]
then
echo "what port ?"
read in

echo "enter sudo password" 
#/etc/systemd/scripts/firewall.sh
sudo iptables -A INPUT -p tcp -m tcp --dport $in -j ACCEPT
sudo iptables -A OUTPUT -p tcp -m tcp --dport $in -j ACCEPT


elif [[ $in=="r" ]]
then
echo "what port ?"
read in

sudo iptables -A INPUT -p tcp -m tcp --dport $in -j ACCEPT
sudo iptables -A OUTPUT -p tcp -m tcp --dport $in -j ACCEPT


elif [[ $in=="c" ]]
then
    echo "custom rules"  
###sudo iptables -A INPUT -p tcp -m tcp --dport $in -j ACCEPT
##sudo iptables -A OUTPUT -p tcp -m tcp --dport $in -j ACCEPT


elif [[ $in=='l' ]]
then
echo "list iptables"
iptables -nvL
fi


