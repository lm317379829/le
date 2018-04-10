#!/bin/bash

path="$3" 
downloadpath='/home' #下载目录

if [ $2 -eq 0 ]
    then
      exit 0
fi

function getdir(){
IFS=$'\n';for file in `ls "$1"`
    do
        if [ -d "$1/$file" ]  
        then
            getdir "$1/$file"
        else
            onedrive -u "$downloadpath" "$1/$file"
        fi
    done
}

while true; do
filepath=$path 
path=${path%/*};
if [ "$path" = "$downloadpath" ] && [ $2 -eq 1 ]
    then
      onedrive "${filepath}"
      rm "${filepath}"
      echo 3 > /proc/sys/vm/drop_caches
      swapoff -a && swapon -a
      exit 0    
elif [ "$path" = "$downloadpath" ] 
    then  
      getdir "${filepath}"
      rm -r "${filepath}"
      echo 3 > /proc/sys/vm/drop_caches
      swapoff -a && swapon -a
      exit 0
fi
done
