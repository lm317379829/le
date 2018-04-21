#!/bin/sh
. /etc/profile
LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")
aria2_pid=$(ps -ef|grep /usr/bin/aria2c|grep -v grep|awk '{print $2}')
v2ray_pid=$(ps -ef|grep /usr/local/bin/v2ray|grep -v grep|awk '{print $2}')
caddy_pid=$(ps -ef|grep  /usr/local/bin/caddy|grep -v grep|awk '{print $2}')

start_aria2()
    {
       /usr/bin/aria2c --conf-path=/etc/aria2.conf -D
}
stop_aria2()      
    {              
       kill $aria2_pid
}

start_v2ray()
    {
       /usr/local/bin/v2ray/v2ray -config /usr/local/bin/v2ray/v2ray.json >/dev/null 2>&1 &
}
stop_v2ray()      
    {              
       kill $v2ray_pid
}

start_caddy()
    {
        ulimit -n 8192
        /usr/local/bin/caddy/caddy -conf /usr/local/bin/caddy/caddy.conf >/dev/null 2>&1 &
}
stop_caddy()       
    {           
        kill "$caddy_pid"
}

check_aria2()
    { 
           if [ ! -n "$aria2_pid" ]; then
           /usr/local/sh/dog.sh start_aria2
           aria2_pid_new=$(ps -ef|grep /usr/bin/aria2c|grep -v grep|awk '{print $2}')
           echo [$LOGTIME] Starting Aria2 ...
           echo [$LOGTIME] $aria2_pid_new Aria2
else
        echo [$LOGTIME] $aria2_pid Aria2
fi
}

check_v2ray()
    { 
           if [ ! -n "$v2ray_pid" ]; then
           /usr/local/sh/dog.sh start_v2ray
           v2ray_pid_new=$(ps -ef|grep /usr/local/bin/v2ray|grep -v grep|awk '{print $2}')
           echo [$LOGTIME] Starting V2ray ...
           echo [$LOGTIME] $v2ray_pid_new V2ray
else
        echo [$LOGTIME] $v2ray_pid V2ray
fi
}

check_caddy()
    {  

       if [ ! -n "$caddy_pid" ]; then
        /usr/local/sh/dog.sh start_caddy
        caddy_pid_new=$(ps -ef|grep  /usr/local/bin/caddy|grep -v grep|awk '{print $2}')
        echo [$LOGTIME] Starting Caddy ...
        echo [$LOGTIME] $caddy_pid_new Caddy
else
        echo [$LOGTIME] $caddy_pid Caddy
fi
}

check()
    {
        check_aria2
        check_v2ray
        check_caddy
}

INPUT=$1
if [ -z "$1" ]
then    
check
else     
case "$INPUT" in
start_aria2) start_aria2;;
stop_aria2) stop_aria2;;
start_v2ray) start_v2ray;;
stop_v2ray) stop_v2ray;;
start_caddy) start_caddy;;
stop_caddy) stop_caddy;;
check_aria2) check_aria2;;
check_v2ray) check_v2ray;;
check_caddy) check_caddy;;
esac
fi