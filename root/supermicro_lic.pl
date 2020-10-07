#!/usr/local/bin/perl
use strict;
use Digest::HMAC_SHA1 'hmac_sha1';
my $key  = "\x85\x44\xe3\xb4\x7e\xca\x58\xf9\x58\x30\x43\xf8";
my $mac  = shift || die 'args: mac-addr (i.e.00:25:90:cd:26:da)';
my $data = join '', map { chr hex $_ } split ':', $mac;
my $raw  = hmac_sha1($data, $key);
printf "%02lX%02lX-%02lX%02lX-%02lX%02lX-%02lX%02lX-%02lX%02lX-%02lX%02lX\n", (map { ord $_ } split '', $raw);
