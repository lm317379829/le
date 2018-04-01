#!/bin/bash
. /etc/profile

RXnow=$(cat /proc/net/dev|grep eth0|awk '{print $2}')
TXnow=$(cat /proc/net/dev|grep eth0|awk '{print $10}')

ins_net=$(find /tmp/ -iname 'net')
        if [ ! -n "$ins_net" ]; then     
           line=$(cat /usr/local/sh/net/net1)
           echo $line > /usr/local/sh/net/net0
           RXpre=$(cat /usr/local/sh/net/net0 | awk '{print $1}')
           TXpre=$(cat /usr/local/sh/net/net0 | awk '{print $2}')
           let "rx = RXnow + RXpre"
           let "tx = TXnow + TXpre"
           echo $rx $tx > /usr/local/sh/net/net1
           let "Total = rx + tx"
else
           RXpre=$(cat /usr/local/sh/net/net0 | awk '{print $1}')
           TXpre=$(cat /usr/local/sh/net/net0 | awk '{print $2}')
           let "rx = RXnow + RXpre"
           let "tx = TXnow + TXpre"
           echo $rx $tx > /usr/local/sh/net/net1
           let "Total = rx + tx"
fi

if [[ $Total -lt 1024 ]];then
      echo $Total B >/tmp/net
  else
      if [[ $Total -lt 1048576 ]];then
       KB=$(echo $Total | awk '{printf("%.2f\n", $1/1024)}')
echo $KB KB >/tmp/net
    else
         if [[ $Total -lt 1073741824 ]];then
          MB=$(echo $Total | awk '{printf("%.2f\n", $1/1048576)}')
echo $MB MB >/tmp/net
        else
            GB=$(echo $Total | awk '{printf("%.2f\n", $1/1073741824)}') 
echo $GB GB >/tmp/net
         fi
      fi
fi

time=$(ping -c 3 -n leop.tk |grep rtt |cut -d '/' -f 5|awk '{printf("%.2f\n", $1)}')
echo $time > /tmp/time
