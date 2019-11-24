#!/bin/bash
path=$3 #取原始路径，我的环境下如果是单文件则为/data/demo.png,如果是文件夹则该值为文件夹内某个文件比如/data/a/b/c/d.jpg
downloadpath='/home'  #修改成Aria2下载文件夹

if [ $2 -eq 0 ]
    then
    exit 0
fi

while true; do  #提取下载文件根路径，如把/data/a/b/c/d.jpg变成/data/a
filepath=$path
path=${path%/*}; 
if [ "$path" = "$downloadpath" ] && [ $2 -eq 1 ]  #如果下载的是单个文件
    then
    php /var/www/html/oneindex/one.php upload:file $filepath /$folder/
    rm -rf $filepath
    php /var/www/html/oneindex/one.php cache:refresh
    exit 0
elif [ "$path" = "$downloadpath" ]
    then
    php /var/www/html/oneindex/one.php upload:folder $filepath /$folder/
    rm -rf "$filepath/"
    php /var/www/html/oneindex/one.php cache:refresh
    exit 0
fi
done
