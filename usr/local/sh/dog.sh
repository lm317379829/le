#!/bin/sh
. /etc/profile

date "+%Y-%m-%d %H:%M:%S"
kcp_pid=$(ps -ef|grep /usr/local/bin/kcptun|grep -v grep|awk '{print $2}')
udp_pid=$(ps -ef|grep /usr/local/bin/udp2raw|grep -v grep|awk '{print $2}')
spe_pid=$(ps -ef|grep /usr/local/bin/spe2raw|grep -v grep|awk '{print $2}')
brook_pid=$(ps -ef|grep /usr/local/bin/brook|grep -v grep|awk '{print $2}')
speeder_pid=$(ps -ef|grep /usr/local/bin/speeder|grep -v grep|awk '{print $2}')
shadowsocksr_pid=$(ps -ef|grep /usr/local/shadowsocksr/server.py|grep -v grep|awk '{print $2}')
aria2_pid=$(ps -ef|grep /usr/bin/aria2c|grep -v grep|awk '{print $2}')
filemanager_pid=$(ps -ef|grep /usr/local/bin/filemanager|grep -v grep|awk '{print $2}')
rcloned_pid=$(ps -ef|grep /usr/bin/rclone|grep -v grep|awk '{print $2}')

start_rcloned()
    {
        /usr/bin/rclone mount Onedrive: /home/OneDrive --copy-links --no-gzip-encoding --no-check-certificate --allow-other --allow-non-empty --umask 000 >/dev/null 2>&1 &
}
stop_rcloned()       
    {           
        kill "$rcloned_pid_pid"
}

start_kcp()
    {
        /usr/local/bin/kcptun -l :kport1 -t 127.0.0.1:kport2 -key password -mtu 1300 -sndwnd 2048 -rcvwnd 2048 -mode fast2 >/dev/null 2>&1 &
}
stop_kcp()       
    {           
        kill "$kcp_pid"
}

start_udp()
    {
        /usr/local/bin/udp2raw -s -l 0.0.0.0:uport1 -r 127.0.0.1:uport2 -k password --raw-mode faketcp -a >/dev/null 2>&1 &
}
stop_udp()      
    {             
       kill "$udp_pid"
}

start_spe()
    {
        /usr/local/bin/spe2raw -s -l 0.0.0.0:sport1 -r 127.0.0.1:sport2 -k password --raw-mode faketcp -a >/dev/null 2>&1 &
}
stop_spe()      
    {             
       kill "$spe_pid"

}

start_speeder()
    {
        /usr/local/bin/speeder -s -l 0.0.0.0:spport1 -r 127.0.0.1:spport2  -f 20:10 -k password --mode 0 >/dev/null 2>&1 &
}
stop_speeder()      
    {             
       kill "$speeder_pid"

}

start_aria2()
    {
       /usr/bin/aria2c --conf-path=/etc/aria2.conf -D
}
stop_aria2()      
    {              
       kill $aria2_pid
}

start_filemanager()
    {
       /usr/local/bin/filemanager --port 8989 --database  /etc/fm.db  --scope  /home >/dev/null 2>&1 &
}
stop_filemanager()      
    {              
       kill $filemanager_pid
}

check_rcloned()
    {  

       if [ ! -n "$rcloned_pid" ]; then
        /usr/local/sh/dog.sh start_rcloned
        rcloned_pid_new=$(ps -ef|grep /usr/bin/rclone|grep -v grep|awk '{print $2}')
        echo Starting Rcloned ...
        echo "$rcloned_pid_new" Rcloned
else
        echo "$rcloned_pid" Rcloned
fi
}

check_kcp()
    {  
       if [ ! -n "$kcp_pid" ]; then
        /usr/local/sh/dog.sh start_kcp
        kcp_pid_new=$(ps -ef|grep /usr/local/bin/kcptun|grep -v grep|awk '{print $2}')
        echo Starting Kcptun ...
        echo "$kcp_pid_new" Kcptun
else
        echo "$kcp_pid" Kcptun
fi
}

check_udp()
    { 
       if [ ! -n "$udp_pid" ]; then
        /usr/local/sh/dog.sh start_udp >/dev/null 2>&1
        udp_pid_new=$(ps -ef|grep /usr/local/bin/udp2raw|grep -v grep|awk '{print $2}')
        echo Starting Udp2raw ...
        echo "$udp_pid_new" Udp2raw
else
        echo "$udp_pid" Udp2raw
fi
}

check_spe()
    { 
       if [ ! -n "$spe_pid" ]; then
        /usr/local/sh/dog.sh start_spe >/dev/null 2>&1
        spe_pid_new=$(ps -ef|grep /usr/local/bin/spe2raw|grep -v grep|awk '{print $2}')
        echo Starting Spe2raw ...
        echo "$spe_pid_new" Spe2raw
else
        echo "$spe_pid" Spe2raw
fi
}

check_brook()
    { 
       if [ ! -n "$brook_pid" ]; then
        /etc/init.d/brook start >/dev/null 2>&1
        brook_pid_new=$(ps -ef|grep /usr/local/bin/brook|grep -v grep|awk '{print $2}')
        echo Starting Brook ...
        echo "$brook_pid_new" Brook
else
        echo "$brook_pid" Brook
fi
}

check_speeder()
    { 
       if [ ! -n "$speeder_pid" ]; then
        /usr/local/sh/dog.sh start_speeder >/dev/null 2>&1
        speeder_pid_new=$(ps -ef|grep /usr/local/bin/speeder|grep -v grep|awk '{print $2}')
        echo Starting Speeder ...
        echo "$speeder_pid_new" Speeder
else
        echo "$speeder_pid" Speeder
fi
}

check_shadowsocksr()
    {
       if [ ! -n "$shadowsocksr_pid" ]; then
        /etc/init.d/ssrmu start >/dev/null 2>&1
        shadowsocksr_pid_new=$(ps -ef|grep /usr/local/shadowsocks/server.py|grep -v grep|awk '{print $2}')
        echo Starting ShadowsocksR ...
        echo "$shadowsocksr_pid_new" ShadowsocksR
else
        echo "$shadowsocksr_pid" ShadowsocksR
fi
}

check_aria2()
    { 
           if [ ! -n "$aria2_pid" ]; then
           /usr/local/sh/dog.sh start_aria2
           aria2_pid_new=$(ps -ef|grep /usr/bin/aria2c|grep -v grep|awk '{print $2}')
           echo Starting Aria2 ...
           echo "$aria2_pid_new" Aria2
else
        echo "$aria2_pid" Aria2
fi
}

check_filemanager()
    { 
           if [ ! -n "$filemanager_pid" ]; then
           /usr/local/sh/dog.sh start_filemanager
           filemanager_pid_new=$(ps -ef|grep /usr/local/bin/filemanager|grep -v grep|awk '{print $2}')
           echo Starting FileManager ...
           echo "$filemanager_pid_new" FileManager
else
        echo "$filemanager_pid" FileManager
fi
}

check()
    {
        check_kcp
        check_udp
        check_spe
#        check_brook
        check_speeder
        check_shadowsocksr
        check_aria2
#        check_rcloned
        check_filemanager
}

INPUT=$1
if [ -z "$1" ]
then    
check
else     
case "$INPUT" in
start_kcp) start_kcp;;
stop_kcp) stop_kcp;;
start_udp) start_udp;;
stop_udp) stop_udp;;
start_spe) start_spe;;
stop_spe) stop_spe;;
start_brook) start_brook;;
stop_brook) stop_brook;;
start_speeder) start_speeder;;
stop_speeder) stop_speeder;;
start_aria2) start_aria2;;
stop_aria2) stop_aria2;;
start_rcloned) start_rcloned;;
stop_rcloned) stop_rcloned;;
start_filemanager) start_filemanager;;
stop_filemanager) stop_filemanager;;
check_kcp) check_kcp;;
check_udp) check_udp;;
check_spe) check_spe;;
check_brook) check_brook;;
check_speeder) check_speeder;;
check_shadowsocksr) check_shadowsocksr;;
check_aria2) check_aria2;;
check_rcloned) check_rcloned;;
check_filemanager) check_filemanager;;
esac
fi