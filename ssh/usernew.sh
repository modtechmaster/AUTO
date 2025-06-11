#!/bin/bash
MYIP=$(wget -qO- ipv4.icanhazip.com);
echo "Checking VPS"
clear
cekray=`grep -ow "XRAY" /root/log-install.txt | sort | uniq`
if [ "$cekray" = "XRAY" ]; then
  domen=`cat /etc/xray/domain`
else
  domen=`cat /etc/v2ray/domain`
fi
portsshws=`grep -w "SSH Websocket" ~/log-install.txt | cut -d: -f2 | awk '{print $1}'`
wsssl=`grep -w "SSH SSL Websocket" /root/log-install.txt | cut -d: -f2 | awk '{print $1}'`

echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;41;36m          SENSI SSH Account            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (day): " masaaktif

IP=$(curl -sS ifconfig.me)
ossl=`grep -w "OpenVPN" /root/log-install.txt | cut -f2 -d: | awk '{print $6}'`
opensh=`grep -w "OpenSSH" /root/log-install.txt | cut -f2 -d: | awk '{print $1}'`
db=`grep -w "Dropbear" /root/log-install.txt | cut -f2 -d: | awk '{print $1,$2}'`
ssl=`grep -w "Stunnel4" ~/log-install.txt | cut -d: -f2`
sqd=`grep -w "Squid" ~/log-install.txt | cut -d: -f2`

OhpSSH=`grep -w "OHP SSH" /root/log-install.txt | cut -d: -f2 | awk '{print $1}'`
OhpDB=`grep -w "OHP DBear" /root/log-install.txt | cut -d: -f2 | awk '{print $1}'`
OhpOVPN=`grep -w "OHP OpenVPN" /root/log-install.txt | cut -d: -f2 | awk '{print $1}'`

sleep 1
clear
useradd -e "$(date -d "$masaaktif days" +"%Y-%m-%d")" -s /bin/false -M "$Login"
exp="$(chage -l "$Login" | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass" | passwd "$Login" &> /dev/null
PID=$(pgrep -f sshws)

echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "\E[0;41;36m          SENSI SSH Account            \E[0m" | tee -a /etc/log-create-ssh.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "Username    : $Login" | tee -a /etc/log-create-ssh.log
echo -e "Password    : $Pass" | tee -a /etc/log-create-ssh.log
echo -e "Expired On  : $exp" | tee -a /etc/log-create-ssh.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "IP          : $IP" | tee -a /etc/log-create-ssh.log
echo -e "Host        : $domen" | tee -a /etc/log-create-ssh.log
echo -e "OpenSSH     : $opensh" | tee -a /etc/log-create-ssh.log
echo -e "SSH WS      : $portsshws" | tee -a /etc/log-create-ssh.log
echo -e "SSH SSL WS  : $wsssl" | tee -a /etc/log-create-ssh.log
echo -e "SSL/TLS     : $ssl" | tee -a /etc/log-create-ssh.log
echo -e "UDPGW       : 7100-7900" | tee -a /etc/log-create-ssh.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "Payload WSS" | tee -a /etc/log-create-ssh.log

cat <<EOF | tee -a /etc/log-create-ssh.log
GET wss://isi_bug_disini HTTP/1.1\r\nHost: $domen\r\nUpgrade: websocket\r\n\r\n
EOF

echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "Payload WS" | tee -a /etc/log-create-ssh.log

cat <<EOF | tee -a /etc/log-create-ssh.log
GET / HTTP/1.1\r\nHost: $domen\r\nUpgrade: websocket\r\n\r\n
EOF

echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo "" | tee -a /etc/log-create-ssh.log

read -n 1 -s -r -p "Press any key to back on menu"
m-sshovpn
