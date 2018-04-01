#!/bin/bash

path="$3" 
downloadpath='/home'

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
            onedrivecmd put "$1/$file" od:"${1#*"$downloadpath"}"
        fi
    done
}

while true; do
filepath=$path 
path=${path%/*};
if [ "$path" = "$downloadpath" ] && [ $2 -eq 1 ]
    then
      onedrivecmd put "${filepath}" od:/
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
