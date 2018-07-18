#!/bin/sh
/usr/sbin/ngctl -f- <<-SEQ
mkpeer ipfw: patch 33 in
name ipfw:33 time_plus_33
msg time_plus_33: setconfig { count=2 csum_flags=1 ops=[   \
{ mode=2 value=0x00000000547AE148 length=8 offset=60 }  \
{ mode=2 value=0x00000000547AE148 length=8 offset=68 } ] }

mkpeer ipfw: patch 66 in
name ipfw:66 time_plus_66
msg time_plus_66: setconfig { count=2 csum_flags=1 ops=[   \
{ mode=2 value=0x00000000A8F5C28F length=8 offset=60 }  \
{ mode=2 value=0x00000000A8F5C28F length=8 offset=68 } ] }

SEQ

