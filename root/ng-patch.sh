#!/bin/sh
/usr/sbin/ngctl -f- <<-SEQ
mkpeer ipfw: patch 200 in
name ipfw:200 ttl_add
msg ttl_add: setconfig { count=1 csum_flags=1 ops=[     \
{ mode=1 value=1 length=1 offset=8 } ] }
SEQ
