#!/bin/sh
. /etc/profile
kcp_ver=$(wget -qO- --no-check-certificate https://api.github.com/repos/xtaci/kcptun/releases/latest | grep 'tag_name' | cut -d\" -f4 | sed s/v//g)
udp_ver=$(wget -qO- --no-check-certificate https://api.github.com/repos/wangyu-/udp2raw-tunnel/releases/latest | grep 'tag_name' | cut -d\" -f4)
brook_ver=$(wget -qO- --no-check-certificate https://api.github.com/repos/txthinking/brook/releases/latest | grep 'tag_name' | cut -d\" -f4 | sed s/v//g)
speeder_ver=$(wget -qO- --no-check-certificate https://api.github.com/repos/wangyu-/UDPspeeder/releases/latest | grep 'tag_name' | cut -d\" -f4 | sed s/v2@//g)
file_ver=$(wget -qO- --no-check-certificate https://api.github.com/repos/filebrowser/filebrowser/releases/latest | grep 'tag_name' | cut -d\" -f4 | sed s/v//g)
rclone_ver=$(wget -qO- --no-check-certificate https://api.github.com/repos/ncw/rclone/releases/latest | grep 'tag_name' | cut -d\" -f4 | sed s/v//g)

long_bit=$(getconf LONG_BIT)
        if [ "$long_bit" = 32 ]; then
        kcp_bit=386
        udp_bit=x86
        brook_bit=brook_linux_386
        speeder_bit=x86
        file_bit=386
        rclone_bit=386

else
        kcp_bit=amd64
        udp_bit=amd64
        brook_bit=brook
        speeder_bit=amd64
        file_bit=amd64
        rclone_bit=amd64
fi

date_date()
    {
date "+%Y-%m-%d %H:%M:%S"
}

download_rclone()
    {
        r_url="https://github.com/ncw/rclone/releases/download/v${rclone_ver}/rclone-v${rclone_ver}-linux-${rclone_bit}.deb"
        wget --no-check-certificate -qO- ${r_url} -O '/usr/local/sh/rclone.deb'
}

install_rclone()
    {
        download_rclone >/dev/null 2>&1
        dpkg -i /usr/local/sh/rclone.deb
        rm  /usr/local/sh/rclone.deb
}

update_rclone()
    {
        l_rclone_ver="$(/usr/bin/rclone -V | grep rclone | awk '{print$2}'| sed s/v//g)"
        if [ -n "$rclone_ver" ] && [ "$rclone_ver" != "$l_rclone_ver" ]; then
        echo 发现 Rclone 新版本 ${rclone_ver}
        dpkg -r rclone
sleep 1
        install_rclone
else
        echo 未发现 Rclone 更新...
fi
}

check_rclone()
    {
        ins_rclone=$(find /usr/bin -iname 'rclone')
        if [ ! -n "$ins_rclone" ]; then
           echo "Rclone未安装，正在全新安装..."       
           install_rclone
else
         update_rclone
fi
}


download_kcp()
    {
        k_url="https://github.com/xtaci/kcptun/releases/download/v${kcp_ver}/kcptun-linux-${kcp_bit}-${kcp_ver}.tar.gz"
        wget --no-check-certificate -qO- ${k_url} -O '/usr/local/sh/kcptun.tar.gz'
        mkdir /tmp/kcptun/
        tar -xzvf /usr/local/sh/kcptun.tar.gz -C /tmp/kcptun/
}

install_kcp()
    {
        download_kcp >/dev/null 2>&1
        mv /tmp/kcptun/server_linux_${kcp_bit} /usr/local/bin/kcptun
        chmod 755 /usr/local/bin/kcptun
        /usr/local/sh/dog.sh start_kcp
        rm /usr/local/sh/kcptun.tar.gz
        rm -r /tmp/kcptun
}

update_kcp()
    {
        l_kcp_ver="$(/usr/local/bin/kcptun -v| awk '{print$3}')"
        if [ -n "$kcp_ver" ] && [ "$kcp_ver" != "$l_kcp_ver" ]; then
        echo 发现 Kcptun 新版本 ${kcp_ver}
        download_kcp >/dev/null 2>&1
         /usr/local/sh/dog.sh stop_kcp
        mv /tmp/kcptun/server_linux_${kcp_bit} /usr/local/bin/kcptun
        chmod 755 /usr/local/bin/kcptun
        /usr/local/sh/dog.sh start_kcp
        rm /usr/local/sh/kcptun.tar.gz
        rm -r /tmp/kcptun
else
        echo 未发现 Kcptun 更新...
fi
}

check_kcp()
    {
        ins_kcp=$(find /usr/local/bin -iname 'kcptun')
        if [ ! -n "$ins_kcp" ]; then
           echo "Kcptun未安装，正在全新安装..."       
           install_kcp
else
         update_kcp
fi
}

download_udp()
    {
        u_url="https://github.com/wangyu-/udp2raw-tunnel/releases/download/${udp_ver}/udp2raw_binaries.tar.gz"
        wget --no-check-certificate -qO- ${u_url} -O '/usr/local/sh/udp.tar.gz'
        mkdir /tmp/udp2raw/
        tar -xzvf /usr/local/sh/udp.tar.gz -C /tmp/udp2raw/
}

install_udp()
    {
        download_udp >/dev/null 2>&1
        cp /tmp/udp2raw/udp2raw_${udp_bit} /usr/local/bin/udp2raw
        cp /tmp/udp2raw/udp2raw_${udp_bit} /usr/local/bin/spe2raw
        touch /usr/local/bin/udp2raw.version
        echo "$udp_ver" > /usr/local/bin/udp2raw.version
        chmod 755 /usr/local/bin/udp2raw
        chmod 755 /usr/local/bin/spe2raw
        /usr/local/sh/dog.sh start_udp
        /usr/local/sh/dog.sh start_spe
        rm /usr/local/sh/udp.tar.gz
        rm -r /tmp/udp2raw
}        

update_udp()
    {
        l_udp_ver=$(cat /usr/local/bin/udp2raw.version)
        if [ -n "$udp_ver" ] && [ "$udp_ver" != "$l_udp_ver" ]; then
        echo 发现 Udp2raw 新版本 ${udp_ver}
        echo 发现 Sdp2raw 新版本 ${udp_ver}
        download_udp >/dev/null 2>&1
        /usr/local/sh/dog.sh stop_udp
        /usr/local/sh/dog.sh stop_spe
        cp /tmp/udp2raw/udp2raw_${udp_bit} /usr/local/bin/udp2raw
        cp /tmp/udp2raw/udp2raw_${udp_bit} /usr/local/bin/spe2raw
        chmod 755 /usr/local/bin/udp2raw
        chmod 755 /usr/local/bin/spe2raw
        /usr/local/sh/dog.sh start_udp
        /usr/local/sh/dog.sh start_spe
        echo "$udp_ver" > /usr/local/bin/udp2raw.version
        rm /usr/local/sh/udp.tar.gz
        rm -r /tmp/udp2raw
else
        echo 未发现 Udp2raw 更新...
        echo 未发现 Sdp2raw 更新...
fi
}

check_udp()
    {
        ins_udp=$(find /usr/local/bin -iname 'udp2raw')
        if [ ! -n "$ins_udp" ]; then
        echo "Udp2raw未安装，正在全新安装..."
        install_udp
else        
         update_udp
fi
        ins_spe=$(find /usr/local/bin -iname 'spe2raw')
        if [ ! -n "$ins_spe" ]; then
        echo "Spe2raw未安装，正在全新安装..."
        install_udp >/dev/null 2>&1
else        
         update_udp >/dev/null 2>&1
fi
}

download_brook()
    {
        b_url="https://github.com/txthinking/brook/releases/download/v${brook_ver}/${brook_bit}"
        wget --no-check-certificate -qO- ${b_url} -O '/usr/local/brook/brook'
}

install_brook()
    {
        download_brook >/dev/null 2>&1
        chmod 755 /usr/local/brook/brook
        /etc/init.d/brook stop >/dev/null 2>&1
}

update_brook()
    {
        l_brook_ver="$(/usr/local/brook/brook -v| awk '{print$3}')"
        if [ -n "$brook_ver" ] && [ "$brook_ver" != "$l_brook_ver" ]; then
        echo 发现 Brook 新版本 ${brook_ver}
        download_brook >/dev/null 2>&1
         /etc/init.d/brook stop >/dev/null 2>&1
        chmod 755 /usr/local/brook/brook
        /etc/init.d/brook start >/dev/null 2>&1
else
        echo 未发现 Brook 更新...
fi
}

check_brook()
    {
        ins_kcp=$(find /usr/local/brook -iname 'brook')
        if [ ! -n "$ins_brook" ]; then
           echo "Brook未安装，正在全新安装..."       
           install_brook
else
         update_brook
fi
}

download_speeder()
    {       
        s_url="https://github.com/wangyu-/UDPspeeder/releases/download/v2@${speeder_ver}/speederv2_binaries.tar.gz"        
        wget --no-check-certificate -qO- ${s_url} -O '/usr/local/sh/speeder.tar.gz'
        mkdir /tmp/speeder/
        tar -xzvf /usr/local/sh/speeder.tar.gz -C /tmp/speeder/
}

install_speeder()
    {
        download_speeder >/dev/null 2>&1
        mv /tmp/speeder/speederv2_${speeder_bit} /usr/local/bin/speeder
        touch /usr/local/bin/speeder.version
        echo "$speeder_ver" > /usr/local/bin/speeder.version
        chmod 755 /usr/local/bin/speeder
        /usr/local/sh/dog.sh start_speeder
        rm /usr/local/sh/speeder.tar.gz
        rm -r /tmp/speeder
}

update_speeder()
    {
        l_speeder_ver=$(cat /usr/local/bin/speeder.version)
        if [ -n "$speeder_ver" ] && [ "$speeder_ver" != "$l_speeder_ver" ]; then
        echo 发现 Speeder 新版本 ${speeder_ver}
        download_speeder >/dev/null 2>&1
        /usr/local/sh/dog.sh stop_speeder
        mv /tmp/udp2raw/speederv2_${speeder_bit} /usr/local/bin/speeder
        chmod 755 /usr/local/bin/speeder
        /usr/local/sh/dog.sh start_speeder
        echo "$speeder_ver" > /usr/local/bin/speeder.version
        rm /usr/local/sh/speeder.tar.gz
        rm -r /tmp/speeder
else
        echo 未发现 Speeder 更新...
fi
}

check_speeder()
    {
        ins_speeder=$(find /usr/local/bin -iname 'speeder')
        if [ ! -n "$ins_speeder" ]; then
           echo "Speeder未安装，正在全新安装..."       
           install_speeder
else
         update_speeder
fi
}

download_file()
    {              
        f_url="https://github.com/filebrowser/filebrowser/releases/download/v${file_ver}/linux-${file_bit}-filebrowser.tar.gz"
        wget --no-check-certificate -qO- ${f_url} -O '/usr/local/sh/filemanager.tar.gz'
        mkdir /tmp/filemanager/
        tar -xzvf /usr/local/sh/filemanager.tar.gz -C /tmp/filemanager/
}

install_file()
    {
        download_file >/dev/null 2>&1
        mv /tmp/filemanager/filebrowser /usr/local/bin/filemanager
        /usr/local/sh/dog.sh start_filemanager
        rm /usr/local/sh/filemanager.tar.gz
        rm -r /tmp/filemanager
}

update_file()
    {
        l_file_ver=$(/usr/local/bin/filemanager -v| awk '{print $3}')
        if [ -n "$file_ver" ] && [ "$file_ver" != "$l_file_ver" ]; then
        echo 发现 Filemanager 新版本 ${file_ver}
        download_file >/dev/null 2>&1
        /usr/local/sh/dog.sh stop_filemanager
        mv /tmp/filemanager/filebrowser /usr/local/bin/filemanager
        chmod 755 /usr/local/bin/filemanager
        /usr/local/sh/dog.sh start_filemanager
        rm /usr/local/sh/filemanager.tar.gz
        rm -r /tmp/filemanager
else
        echo 未发现 Filemanager 更新...
fi
}

check_file()
    {
        ins_file=$(find /usr/local/bin -iname 'filemanager')
        if [ ! -n "$ins_file" ]; then
           echo "Filemanager未安装，正在全新安装..."       
           install_file
else
         update_file
fi
}

check_all()
    {
        date_date
        check_udp
        check_kcp
#        check_brook
        check_speeder
        check_file
#        check_rclone
}

INPUT=$1  
if [ -z "$1" ]
then    
check_all
else       
case "$INPUT" in
check_udp) check_udp;;
check_kcp) check_kcp;;
check_brook) check_brook;;
check_speeder) check_speeder;;
check_file) check_file;;
check_rclone) check_rclone;;        
esac
fi