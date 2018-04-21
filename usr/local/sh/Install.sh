#!/bin/sh
. /etc/profile
LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")
aria2_ver=$(wget -qO- --no-check-certificate https://api.github.com/repos/aria2/aria2/releases/latest | grep 'tag_name' |  cut -d\" -f4 | sed s/release-//g)
v2ray_ver=$(wget -qO- --no-check-certificate https://api.github.com/repos/v2ray/v2ray-core/releases/latest | grep 'tag_name' | cut -d\" -f4 | sed s/v//g)
caddy_ver=$(wget -qO- --no-check-certificate https://api.github.com/repos/mholt/caddy/releases/latest | grep 'tag_name' | cut -d\" -f4 | sed s/v//g)

long_bit=$(getconf LONG_BIT)
        if [ "$long_bit" = 32 ]; then
        aria2_bit=32bit
        v2ray_bit=32
		caddy_bit=386
else
        aria2_bit=64bit
        v2ray_bit=64
		caddy_bit=amd64
fi

install_aria2()
    {
        echo [$LOGTIME] 正在安装Aria2 v${aria2_ver}...
        apt-get update
        apt-get install build-essential make -y
        wget --no-check-certificate -qO- "https://github.com/q3aql/aria2-static-builds/releases/download/v${aria2_ver}/aria2-${aria2_ver}-linux-gnu-${aria2_bit}-build1.tar.bz2" -O '/usr/local/sh/aria2.tar.bz2'
        mkdir /tmp/aria2/
        tar -xjvf  /usr/local/sh/aria2.tar.bz2 -C /tmp/aria2/
        cd /tmp/aria2/aria2-${aria2_ver}-linux-gnu-${aria2_bit}-build1
        make install
        chmod +x /usr/bin/aria2c
        rm /usr/local/sh/aria2.tar.bz2
        rm -r /tmp/aria2
        mkdir -p /root/.aria2
        wget --no-check-certificate -q -O /root/.aria2/aria2.session "https://raw.githubusercontent.com/lm317379829/le/master/root/.aria2/aria2.session"
        wget --no-check-certificate -q -O /root/.aria2/autoupload.sh "https://raw.githubusercontent.com/lm317379829/le/master/root/.aria2/autoupload.sh"
        wget --no-check-certificate -q -O /root/.aria2/dht.dat "https://raw.githubusercontent.com/lm317379829/le/master/root/.aria2/dht.dat"
        chmod +x /root/.aria2/autoupload.sh
        apt-get autoremove --purge build-essential make -y
}

install_onedrive()
    {
        echo [$LOGTIME] 正在安装OneDrive...
        apt-get update
        apt-get install curl -y
        mkdir -p /usr/local/etc/OneDrive
        wget --no-check-certificate -q -O /usr/local/etc/OneDrive/json-parser "https://raw.githubusercontent.com/lm317379829/OneDrive/master/Business/json-parser"
        wget --no-check-certificate -q -O /usr/local/etc/OneDrive/onedrive "https://raw.githubusercontent.com/lm317379829/OneDrive/master/Business/onedrive"
        wget --no-check-certificate -q -O /usr/local/etc/OneDrive/onedrive-d "https://raw.githubusercontent.com/lm317379829/OneDrive/master/Business/onedrive-d"
        wget --no-check-certificate -q -O /usr/local/etc/OneDrive/onedrive-authorize "https://raw.githubusercontent.com/lm317379829/OneDrive/master/Business/onedrive-authorize"
        wget --no-check-certificate -q -O /usr/local/etc/OneDrive/onedrive-base "https://raw.githubusercontent.com/lm317379829/OneDrive/master/Business/onedrive-base"
        wget --no-check-certificate -q -O /usr/local/etc/OneDrive/onedrive.cfg "https://raw.githubusercontent.com/lm317379829/OneDrive/master/Business/onedrive.cfg"
        chmod -R a+x /usr/local/etc/OneDrive
        ln -sf /usr/local/etc/OneDrive/onedrive /usr/local/bin/
        ln -sf /usr/local/etc/OneDrive/onedrive-d /usr/local/bin/
        sed -i 's/api_client_id=""/api_client_id="8303dde6-6e8a-41b7-ad44-cb6fb989fa2d"/g' /usr/local/etc/OneDrive/onedrive.cfg
        sed -i 's/api_client_secret=""/api_client_secret="jn96ng5oYgLpQicAyvudoB0lKriPMLkZhbG7ATaVQf4="/g' /usr/local/etc/OneDrive/onedrive.cfg
}

install_v2ray()
    {
        echo [$LOGTIME] 正在安装V2ray v${v2ray_ver}...
        apt-get update
        apt-get install unzip curl -y
        wget --no-check-certificate -qO- "https://github.com/v2ray/v2ray-core/releases/download/v${v2ray_ver}/v2ray-linux-${v2ray_bit}.zip" -O '/usr/local/sh/v2ray.zip'
        mkdir -p /tmp/v2ray/
        unzip /usr/local/sh/v2ray.zip -d /tmp/v2ray/
        mkdir -p /usr/local/bin/v2ray
        mkdir -p /var/log/v2ray
        mv /tmp/v2ray/v2ray-v${v2ray_ver}-linux-${v2ray_bit}/v2ctl /usr/local/bin/v2ray/v2ctl
        mv /tmp/v2ray/v2ray-v${v2ray_ver}-linux-${v2ray_bit}/v2ray /usr/local/bin/v2ray/v2ray
        mv /tmp/v2ray/v2ray-v${v2ray_ver}-linux-${v2ray_bit}/geoip.dat /usr/local/bin/v2ray/geoip.dat
        mv /tmp/v2ray/v2ray-v${v2ray_ver}-linux-${v2ray_bit}/geosite.dat /usr/local/bin/v2ray/geosite.dat
        chmod -R 755 /usr/local/bin/v2ray
        rm /usr/local/sh/v2ray.zip
        rm -r /tmp/v2ray
}

install_caddy()
    {
        echo [$LOGTIME] 正在安装Caddy v{caddy_ver}...
        apt-get update
        apt-get install curl -y
		wget --no-check-certificate -qO- "https://caddyserver.com/download/linux/${caddy_bit}?license=personal&plugins=http.filemanager&access_codes=" -O '/usr/local/sh/caddy.tar.gz'
		mkdir -p /tmp/caddy/
		tar -xzvf /tmp/caddy.tar.gz -C /tmp/caddy/  >/dev/null 2>&1
		mkdir -p /usr/local/bin/caddy
		mv /tmp/caddy/caddy /usr/local/bin/caddy/caddy
		chmod -R 755 /usr/local/bin/caddy   
        mkdir -p /var/www/html
        mkdir -p /var/log/caddy
        apt-get install php7.0 php7.0-fpm -y
        sed -i '$a listen = 9000' /etc/php/7.0/fpm/php-fpm.conf
        apt-get autoremove --purge apache2 -y  
		rm /usr/local/sh/caddy.tar.gz
        rm -r /tmp/caddy/
}

install_all()
    {
        install_aria2
        install_onedrive
        install_v2ray
        install_caddy  
}
        
remove_aria2()
    {
         echo [$LOGTIME] 正在卸载Aria2...
         /usr/local/sh/dog.sh stop_aria2
         rm -r /root/.aria2
         rm /etc/aria2.conf
         rm /usr/bin/aria2c  
}

remove_onedrive()
    {
         echo [$LOGTIME] 正在卸载OneDrive...
         apt-get autoremove --purge curl -y
         rm -r /usr/local/etc/OneDrive  
}

remove_v2ray()
    {
         echo [$LOGTIME] 正在卸载V2ray...
         /usr/local/sh/dog.sh stop_v2ray
         ins_onedrive=$(find /usr/local/etc -name onedrive)
         if [ ! -n "$ins_onedrive" ]; then
             apt-get autoremove --purge unzip curl -y
         else
             apt-get autoremove --purge unzip -y
         rm -r /usr/local/bin/v2ray  
         fi
}

remove_caddy()
    {
         echo [$LOGTIME] 正在卸载Caddy...
         /usr/local/sh/dog.sh stop_caddy
         rm -r /usr/local/bin/caddy
         apt-get autoremove --purge php7.0 php7.0-fpm -y
} 

remove_all()
    {
         remove_aria2
         remove_onedrive
         remove_v2ray
         remove_caddy
}        
  
update_aria2()
    {
        l_aria2_ver=$(/usr/bin/aria2c -v | head -n 1 | cut -d " " -f3 )
        if [ -n "$aria2_ver" ] && [ "$aria2_ver" != "$l_aria2_ver" ]; then
        echo [$LOGTIME] 发现 Aria2 新版本 ${aria2_ver}
         /usr/local/sh/dog.sh stop_aria2
         install_aria2
sleep 1
         /usr/local/sh/dog.sh start_aria2
else
        echo [$LOGTIME] 未发现 Aria2 更新...
fi
}

update_v2ray()
    {
        l_v2ray_ver=$(/usr/local/bin/v2ray/v2ray -version | head -n 1 | cut -d " " -f2 | sed s/v//g)
        if [ -n "$v2ray_ver" ] && [ "$v2ray_ver" != "$l_v2ray_ver" ]; then
        echo [$LOGTIME] 发现 V2ray 新版本 ${v2ray_ver}
         /usr/local/sh/dog.sh stop_v2ray
         install_v2ray
sleep 1
         /usr/local/sh/dog.sh start_v2ray
else
        echo [$LOGTIME] 未发现 V2ray 更新...
fi
}

update_caddy()
    {
        l_caddy_ver=$(/usr/local/bin/caddy/caddy -version | awk '{print$2}')
        if [ -n "$caddy_ver" ] && [ "$caddy_ver" != "$l_caddy_ver" ]; then
        echo [$LOGTIME] 发现 Caddy 新版本 ${caddy_ver}
         /usr/local/sh/dog.sh stop_caddy
         echo [$LOGTIME] 正在安装Caddy v{caddy_ver}...
		 wget --no-check-certificate -qO- "https://caddyserver.com/download/linux/${caddy_bit}?license=personal&plugins=http.filemanager&access_codes=" -O '/usr/local/sh/caddy.tar.gz'
		 mkdir -p /tmp/caddy/
		 tar -xzvf /tmp/caddy.tar.gz -C /tmp/caddy/  >/dev/null 2>&1
		 mv /tmp/caddy/caddy /usr/local/bin/caddy/caddy
		 rm /usr/local/sh/caddy.tar.gz
		 rm -r /tmp/caddy/
sleep 1
         /usr/local/sh/dog.sh start_caddy
else
        echo [$LOGTIME] 未发现 Caddy 更新...
fi
}

update_all()
    {
        update_aria2
        update_v2ray
        update_caddy  
}

start_bbr()
    {
        echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
        echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
        sysctl -p
}

if [ $# -ge 1 ];
then
while [ $# -ge 1 ]; do
    case $1 in
        0|install_all) 
            install_all
            shift
            ;;
        1|install_aria2) 
            install_aria2
            shift
            ;;
        2|install_onedrive) 
            install_onedrive
            shift
            ;;
        3|install_v2ray) 
            install_v2ray
            shift
            ;;
        4|install_caddy) 
            install_caddy
            shift
            ;;
        5|remove_all) 
            remove_all
            shift
            ;;
        6|remove_aria2) 
            remove_aria2
            shift
            ;;
        7|remove_onedrive) 
            remove_onedrive
            shift
            ;;
        8|remove_v2ray) 
            remove_v2ray
            shift
            ;;
        9|remove_caddy) 
            remove_caddy
            shift
            ;;
        10|update_all) 
            update_all
            shift
            ;;
        11|update_aria2) 
            update_aria2
            shift
            ;;
        12|update_v2ray) 
            update_v2ray
            shift
            ;;
        13|update_caddy) 
            update_caddy
            shift
            ;;
        14|start_bbr) 
            start_bbr
            shift
            ;;
        *)
            break;
            ;;                    
    esac
done
else
echo && echo " 
————————————————————————
0 全部安装
1 安装 Aria2
2 安装 OneDrive
3 安装 V2ray
4 安装 Caddy
————————————————————————
5 全部卸载
6 卸载 Aria2
7 卸载 OneDrive
8 卸载 V2ray
9 卸载 Caddy
————————————————————————
10 全部更新
11 更新 Aria2
12 更新 V2ray
13 更新 Caddy
————————————————————————
14 开启 BBR
————————————————————————" && echo

read -p "请输入数字 [0-14]:" num     
    case $num in
        0|install_all) 
            install_all
            ;;
        1|install_aria2) 
            install_aria2
            ;;
        2|install_onedrive) 
            install_onedrive
            ;;
        3|install_v2ray) 
            install_v2ray
            ;;
        4|install_caddy) 
            install_caddy
            ;;
        5|remove_all) 
            remove_all
            ;;
        6|remove_aria2) 
            remove_aria2
            ;;
        7|remove_onedrive) 
            remove_onedrive
            ;;
        8|remove_v2ray) 
            remove_v2ray
            ;;
        9|remove_caddy) 
            remove_caddy
            ;;
        10|update_all) 
            update_all
            ;;
        11|update_aria2) 
            update_aria2
            ;;
        12|update_v2ray) 
            update_v2ray
            ;;
        13|update_caddy) 
            update_caddy
            ;;
        14|start_bbr) 
            start_bbr
            ;;                    
    esac
fi