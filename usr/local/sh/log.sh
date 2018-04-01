#!/bin/bash 
. /etc/profile
echo `date +%Y-%m-%d` 
find /var/log/apache2 -mtime +1 -name "*.log.*" -exec rm {} \;
find /var/log/apt -mtime +1 -name "*.log.*" -exec rm {} \;
find /var/log -mtime +1 -name "messages.*" -exec rm {} \;
find /var/log -mtime +1 -name "*.log.*" -exec rm {} \;
find /var/log -mtime +1 -name "debug.*" -exec rm {} \;
find /var/log -mtime +1 -name "syslog.*" -exec rm {} \;
find /var/log -mtime +1 -name "btmp.*" -exec rm {} \;
find /var/log -mtime +1 -name "wtmp.*" -exec rm {} \;

logrow=$(grep -c "" /var/log/apache2/access.log)
if [ $logrow -ge 1000 ];then
    > /var/log/apache2/access.log
fi

logrow=$(grep -c "" /var/log/apache2/error.log)
if [ $logrow -ge 1000 ];then
    > /var/log/apache2/error.log
fi

logrow=$(grep -c "" /var/log/apache2/other_vhosts_access.log)
if [ $logrow -ge 1000 ];then
    > /var/log/apache2/other_vhosts_access.log
fi

logrow=$(grep -c "" /var/log/alternatives.log)
if [ $logrow -ge 1000 ];then
    > /var/log/alternatives.log
fi

logrow=$(grep -c "" /var/log/auth.log)
if [ $logrow -ge 5000 ];then
    > /var/log/auth.log
fi

logrow=$(grep -c "" /var/log/btmp)
if [ $logrow -ge 1000 ];then
    > /var/log/btmp
fi

logrow=$(grep -c "" /var/log/daemon.log)
if [ $logrow -ge 1000 ];then
    > /var/log/daemon.log
fi

logrow=$(grep -c "" /var/log/debug)
if [ $logrow -ge 1000 ];then
    > /var/log/debug
fi

logrow=$(grep -c "" /var/log/faillog)
if [ $logrow -ge 1000 ];then
    > /var/log/faillog
fi

logrow=$(grep -c "" /var/log/fontconfig.log)
if [ $logrow -ge 1000 ];then
    > /var/log/fontconfig.log
fi

logrow=$(grep -c "" /var/log/dpkg.log)
if [ $logrow -ge 1000 ];then
    > /var/log/dpkg.log
fi

logrow=$(grep -c "" /var/log/kern.log)
if [ $logrow -ge 1000 ];then
    > /var/log/kern.log
fi

logrow=$(grep -c "" /var/log/lastlog)
if [ $logrow -ge 1000 ];then
    > /var/log/lastlog
fi

logrow=$(grep -c "" /var/log/messages)
if [ $logrow -ge 1000 ];then
    > /var/log/messages
fi

logrow=$(grep -c "" /var/log/syslog)
if [ $logrow -ge 1000 ];then
    > /var/log/syslog
fi

logrow=$(grep -c "" /var/log/user.log)
if [ $logrow -ge 1000 ];then
    > /var/log/user.log
fi

logrow=$(grep -c "" /var/log/wtmp)
if [ $logrow -ge 1000 ];then
    > /var/log/wtmp
fi

logrow=$(grep -c "" /var/log/apt/history.log)
if [ $logrow -ge 1000 ];then
    > /var/log/apt/history.log
fi

logrow=$(grep -c "" /var/log/apt/term.log)
if [ $logrow -ge 1000 ];then
    > /var/log/apt/term.log
fi

logrow=$(grep -c "" /usr/local/shadowsocksr/ssserver.log)
if [ $logrow -ge 1000 ];then
    > /usr/local/shadowsocksr/ssserver.log
fi

list=`wget  --no-check-certificate -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_ip.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`
if [ -z "`grep "bt-tracker" /etc/aria2.conf`" ]; then
    /usr/local/sh/dog.sh stop_aria2
    sed -i '$a bt-tracker='${list} /etc/aria2.conf
    echo add......
else
    /usr/local/sh/dog.sh stop_aria2
    sed -i "s@bt-tracker.*@bt-tracker=$list@g" /etc/aria2.conf
    echo update......
sleep 1
    /usr/local/sh/dog.sh start_aria2
fi

echo 3 > /proc/sys/vm/drop_caches
swapoff -a && swapon -a


