#!/bin/sh

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

ANNOUNCES="/root/var/BGP/ANNOUNCES"
VAR="/root/var/BGP/"
DIFF="/tmp/diff"
NEED_UPDATE="/root/var/BGP/need_update"
EMAIL=noc@isp
FROM=bgp@isp
ASSET="AS-SET"
ASN="AS12345"
LC_ALL=C

rm ${NEED_UPDATE} >/dev/null 2>&1

whois -r ${ASSET} | grep members | awk '{print $2}' | grep -v ${ASN} > $ANNOUNCES

if [ ! -s $ANNOUNCES ]; then
                echo "Cannot create list of AS-SET's :-("
                exit
fi


for AS in $( cat ${ANNOUNCES} ); do
        { bgpq3 -R 24 ${AS} | awk '{print $5}' | sort > ${VAR}${AS}_TMP; diff -q ${VAR}${AS}_TMP ${VAR}${AS}_PREFIXES > $DIFF 2>&1; KEY=`cat /tmp/diff | grep -o "differ"`; }
                        if [ x$KEY = x"differ" ]; then
                                echo "${AS}" >> ${NEED_UPDATE}
                        else
                        fi
done

for AS in $( cat ${ANNOUNCES} ); do
        { mv ${VAR}${AS}_TMP ${VAR}${AS}_PREFIXES; }
done

if [ ! -f $NEED_UPDATE ]; then
                echo "No prefixes changed!"
                exit
fi


MESSAGE="BGP prefixes was changed, please update prefix-lists:\n`cat $NEED_UPDATE`"

echo -e $MESSAGE | mail -s "[BGP PREFIXES]: `date`" $EMAIL -f $FROM
