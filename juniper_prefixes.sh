#!/bin/sh

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

AS=$1
POLICY=$2

if [ $# -eq 0 ]; then
        echo "Usage: juniper_prefixes.sh as-set/asn policy-statement"
        echo "Example: juniper_prefixes.sh AS-SET AS1234-AS-SET-in"
        exit 1
fi


echo "delete policy-options policy-statement $2 term 1"
#bgpq -R 32 -l ${POLICY} -APq ${AS} | grep "^ip prefix-list" | awk '{print "set policy-options policy-statement "$3" term 1 from route-filter "$5" upto /"$7}'
bgpq3 -JAER 32 -l ${POLICY} ${AS} | grep "route-filter" | awk '{print "set policy-options policy-statement '$POLICY' term 1 from route-filter "$2" "$3" "$4}' | sed 's/;//'
echo "set policy-options policy-statement $2 term 1 then next policy"
echo "set policy-options policy-statement $2 then reject"
