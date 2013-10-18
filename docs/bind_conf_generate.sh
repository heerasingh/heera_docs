#!/bin/bash
#http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm


## cp -pvr /usr/share/doc/bind-*/sample/etc/* /var/named/chroot/etc/
## cp -pvr /usr/share/doc/bind-*/sample/var/named/named.* /var/named/chroot/var/named/


### grep IP
##### ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'
## URL: http://www.cyberciti.biz/tips/read-unixlinux-system-ip-address-in-a-shell-script.html

IP=`ip r | grep 'proto kernel' | awk '{print $9}'`
Network=`ip r | grep 'proto kernel' | awk '{print $1}'`
DomainName=`hostname | awk -F'.' '{print $2"."$3}'`
RevAdd=`ip r | grep 'proto kernel' | awk '{print $9}' | awk -F'.' '{print $3"."$2"."$1}'`

## Temp directory to generate configuration and zone files
mkdir /tmp/named_

##cat > /var/named/chroot/etc/named.conf <<EOF
cat > /tmp/named_/named.conf <<EOF
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//

options {
	# make it comment ( listen all interfaces on the server )
	listen-on port 53 { 127.0.0.1; $IP; };
	# change ( if not use IPv6 )
//	listen-on-v6 { none; };
	directory		"/var/named";
	dump-file		"/var/named/data/cache_dump.db";
	statistics-file		"/var/named/data/named_stats.txt";
	memstatistics-file	"/var/named/data/named_mem_stats.txt";
	# query range ( set internal server and so on )
	allow-query	{ localhost; $Network; };
	# transfer range ( set it if you have secondary DNS )
	allow-transfer { localhost; $Network; };
	recursion yes;
	dnssec-enable yes;
	dnssec-validation yes;
	dnssec-lookaside auto;
	/* Path to ISC DLV key */
	bindkeys-file "/etc/named.iscdlv.key";
};
logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

# change all from here

        zone "." IN {
                type hint;
                file "named.ca";
        };
	zone "0.0.127.in-addr.arpa" IN {
                type master;
                file "named.localhost";
                allow-update { none; };
        };
        zone "$DomainName" IN {
                type master;
                file "$DomainName.zone";
                allow-update { none; };
        };
        zone "$RevAdd.in-addr.arpa" IN {
                type master;
                file "$DomainName.rev";
                allow-update { none; };
        };
include "/etc/named.rfc1912.zones";

EOF



##cat > /var/named/chroot/var/named/$DomainName.zone << EOF
cat > /tmp/named_/$DomainName.zone << EOF
`echo '$TTL'` 86400
@	IN	SOA	`hostname`. root.$DomainName. (
			`date +%Y%m%d01`  ;Serial
			3600        ;Refresh
	        	1800        ;Retry
	        	604800      ;Expire
	        	86400       ;Minimum TTL
)
; define name serve
	IN	NS      `hostname`.
; internal IP address of name server
	IN	A       $IP
; define Mail exchanger
	IN	MX 10   `hostname`.
; define IP address and hostname
`hostname | awk -F'.' '{print $1}'`            IN  A       $IP

; define CNAME 
mailserver	CNAME	`hostname | awk -F'.' '{print $1}'`

; define SPF record
$DomainName.	IN TXT	"v=spf1 mx mx:`hostname` -all"

;dkim._domainkey.mailsandyou.com.        IN TXT       "v=DKIM1; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDfOJ9tc08SNE9ZnHvSX1xnDX5JwJTAKMadxEodFIh07VconxAPsCBcSoj9ym6ihYly+96R5Kd/w1vkvzaflNl2F5CAcRYw07dHegp6vhoEgLUTb51dyfLpz6hRGRYzIGEj+AAeG8OaV5Rnhtihf+IZN7+Ya49vlS1NHOAGwwTrmwIDAQAB"


EOF



cat > /tmp/named_/$DomainName.rev << EOF
`echo '$TTL'` 86400
;
;       Addresses and other host information.
;
@	IN	SOA	`hostname`. root.$DomainName. (
                        `date +%Y%m%d01`		; Serial
			43200      ; Refresh
			3600       ; Retry
			3600000    ; Expire
			86400     ; Minimum TTL
)

;       Define the nameservers and the mail servers

	IN	NS	`hostname`.
	IN	PTR     $DomainName.
	IN      A       255.255.255.0
`ip r | grep 'proto kernel' | awk '{print $9}' | awk -F'.' '{print $4}'`	IN      PTR     `hostname`.

EOF


echo '';
echo 'Your BIND configuration generated in "/tmp/named_"';
echo '';
echo '';



