#!/bin/bash

#####################################################
### Generate BIND Configuration Using This Script ###
#####################################################


#http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm

### grep IP
##### ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'
## URL: http://www.cyberciti.biz/tips/read-unixlinux-system-ip-address-in-a-shell-script.html


# Define userfull variables:
IP=`ip r | grep 'proto kernel' | awk '{print $9}'`
Network=`ip r | grep 'proto kernel' | awk '{print $1}'`
DomainName=`hostname | awk -F'.' '{print $2"."$3}'`
RevAdd=`ip r | grep 'proto kernel' | awk '{print $9}' | awk -F'.' '{print $3"."$2"."$1}'`


# Install Bind Chroot DNS server:
#yum install bind bind-chroot bind-utils -y
yum install bind bind-chroot bind-utils bind-libs -y

# Configure Bind auto start at boot:
chkconfig named on


# Stop Bind service, if service is already running:
service named stop


# Copy all bind related files to prepare bind chrooted environments:
## cp -pr /usr/share/doc/bind-`rpm -qa | grep bind-[0123456789] | awk -F'-' '{print $2}'`/sample/etc/* /var/named/chroot/etc/
## cp -pr /usr/share/doc/bind-`rpm -qa | grep bind-[0123456789] | awk -F'-' '{print $2}'`/sample/var/named/* /var/named/chroot/var/named/
cp -R /usr/share/doc/bind-*/sample/var/named/* /var/named/chroot/var/named/
cp -R /usr/share/doc/bind-*/sample/etc/* /var/named/chroot/etc/


# Create bind related files and directory into chrooted directory:
touch /var/named/chroot/var/named/data/cache_dump.db
touch /var/named/chroot/var/named/data/named_stats.txt
touch /var/named/chroot/var/named/data/named_mem_stats.txt
touch /var/named/chroot/var/named/data/named.run
mkdir -p /var/named/chroot/var/named/dynamic
touch /var/named/chroot/var/named/dynamic/managed-keys.bind


# Bind lock file should be writeable, therefore set the permission to make it writable as below:
chmod -R 777 /var/named/chroot/var/named/{data,dynamic}


# Set if you do not use IPv6:
echo 'OPTIONS="-4"' >> /etc/sysconfig/named


# Configure main bind configuration in chrooted config folder:
mv /var/named/chroot/etc/named.conf /var/named/chroot/etc/named.conf_`date +%F`
cat > /var/named/chroot/etc/named.conf <<EOF
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//

options {
	listen-on port 53 { 127.0.0.1; $IP; };
	listen-on-v6 port 53 { ::1; };
	directory 	"/var/named";
	dump-file 	"/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
	allow-query     { localhost; $Network; };
	#### transfer range ( set it if you have secondary DNS )
	# allow-transfer { localhost; $Network; };
	recursion yes;

	dnssec-enable yes;
	dnssec-validation yes;
	dnssec-lookaside auto;

	/* Path to ISC DLV key */
	bindkeys-file "/etc/named.iscdlv.key";

	managed-keys-directory "/var/named/dynamic";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

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
include "/etc/named.root.key";

EOF


# Bind lock file should be writeable, therefore set the permission to make it writable as below:
chown root.named /var/named/chroot/etc/named.conf
chmod 640 /var/named/chroot/etc/named.conf


# Create Forward Zone:
cat > /var/named/chroot/var/named/$DomainName.zone << EOF
`echo '$TTL'` 86400
@       IN      SOA     `hostname`. root.$DomainName. (
                               `date +%Y%m%d01`	; Serial
                               3600		; Refresh
                               1800		; Retry
                               604800		; Expire
                               86400 )		; Minimum TTL

;       Define the nameserver 
			IN      NS      ns.$DomainName.
;	Internal IP address of name server
			IN      A       $IP
;	Define Mail exchanger
			IN      MX      10 `hostname`.

;	Define IP address and hostname
`hostname | awk -F'.' '{print $1}'`			IN      A       $IP
ns			IN      A       $IP
;	Define CNAME
mail				CNAME	$IP
;	Define SPF record
$DomainName.	IN	TXT	"v=spf1 mx mx:`hostname` -all"
;	Define DKIM Key
;dkim._domainkey.mailsandyou.com.        IN TXT       "v=DKIM1; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDfOJ9tc08SNE9ZnHvSX1xnDX5JwJTAKMadxEodFIh07VconxAPsCBcSoj9ym6ihYly+96R5Kd/w1vkvzaflNl2F5CAcRYw07dHegp6vhoEgLUTb51dyfLpz6hRGRYzIGEj+AAeG8OaV5Rnhtihf+IZN7+Ya49vlS1NHOAGwwTrmwIDAQAB"

EOF


# Create Reverse Zone:
cat > /var/named/chroot/var/named/$DomainName.rev << EOF
`echo '$TTL'` 86400
@       IN      SOA     `hostname`. root.$DomainName. (
                               `date +%Y%m%d01`	; Serial
                               43200		; Refresh
                               3600		; Retry
                               3600000		; Expire
                               86400 )		; Minimum TTL

;       Define the nameservers and the mail servers
@	IN	NS	ns.$DomainName.
`hostname | awk -F'.' '{print $1}'`	IN	A	$IP

`ip r | grep 'proto kernel' | awk '{print $9}' | awk -F'.' '{print $4}'`	IN	PTR	`hostname`.
`ip r | grep 'proto kernel' | awk '{print $9}' | awk -F'.' '{print $4}'`	IN	PTR	mail.$DomainName.
`ip r | grep 'proto kernel' | awk '{print $9}' | awk -F'.' '{print $4}'`	IN	PTR	ns.$DomainName.

EOF


# Start Bind service:
service named restart

# Final Message:
echo '';
echo '';
echo '';
echo 'Your BIND Server is Configured and BIND Service Stated.';
echo '';
echo '';
echo '';
echo '##########################################################';
echo '##	    Test and Verify Bind DNS Setup		##';
echo '##########################################################';
echo '##	a. Test and verify using host command :		##';
echo '##	host -t ns example.com				##';
echo '##	host -t mx example.com				##';
echo '##							##';
echo '##	b. Test and verify using nslookup command :	##';
echo '##	nslookup					##';
echo '##	> set type=any					##';
echo '##	> example.com					##';
echo '##	> exit						##';
echo '##							##';
echo '##	c. Test and verify using dig command :		##';
echo '##	dig example.com					##';
echo '##########################################################';
echo '';
echo '';


