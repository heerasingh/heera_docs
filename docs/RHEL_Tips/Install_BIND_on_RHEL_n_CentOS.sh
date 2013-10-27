#!/bin/bash

#####################################################
### Generate BIND Configuration Using This Script ###
#####################################################

echo ""
echo ''
echo ""
echo '****************************************************************************************'
echo 'Note: Before BIND DNS Installation, set correct Hostname look like "MAIL.EXAMPLE.COM"'
echo "If server's Hostname is not like example then DNS server will not work properly"
echo '****************************************************************************************'
echo ""
echo ''
echo ""
echo "=========================================================="
echo "Current Hostname: `hostname`"
echo "=========================================================="
echo ''

#http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm

### grep IP
##### ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'
## URL: http://www.cyberciti.biz/tips/read-unixlinux-system-ip-address-in-a-shell-script.html


# Define usefull variables:
IP=`ip r | grep 'proto kernel' | awk '{print $9}'`
Network=`ip r | grep 'proto kernel' | awk '{print $1}'`
DomainName=`hostname | awk -F'.' '{print $2"."$3}'`
RevAdd=`ip r | grep 'proto kernel' | awk '{print $9}' | awk -F'.' '{print $3"."$2"."$1}'`

epel_repo ()
{
echo ''
echo -ne 'Installing EPEL Repository ..... '
echo ''
echo ''
}

################ RHEL 6 Repository Start Here #####################
RHEL6 ()
{
cat > /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6 << EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.5 (GNU/Linux)

mQINBEvSKUIBEADLGnUj24ZVKW7liFN/JA5CgtzlNnKs7sBg7fVbNWryiE3URbn1
JXvrdwHtkKyY96/ifZ1Ld3lE2gOF61bGZ2CWwJNee76Sp9Z+isP8RQXbG5jwj/4B
M9HK7phktqFVJ8VbY2jfTjcfxRvGM8YBwXF8hx0CDZURAjvf1xRSQJ7iAo58qcHn
XtxOAvQmAbR9z6Q/h/D+Y/PhoIJp1OV4VNHCbCs9M7HUVBpgC53PDcTUQuwcgeY6
pQgo9eT1eLNSZVrJ5Bctivl1UcD6P6CIGkkeT2gNhqindRPngUXGXW7Qzoefe+fV
QqJSm7Tq2q9oqVZ46J964waCRItRySpuW5dxZO34WM6wsw2BP2MlACbH4l3luqtp
Xo3Bvfnk+HAFH3HcMuwdaulxv7zYKXCfNoSfgrpEfo2Ex4Im/I3WdtwME/Gbnwdq
3VJzgAxLVFhczDHwNkjmIdPAlNJ9/ixRjip4dgZtW8VcBCrNoL+LhDrIfjvnLdRu
vBHy9P3sCF7FZycaHlMWP6RiLtHnEMGcbZ8QpQHi2dReU1wyr9QgguGU+jqSXYar
1yEcsdRGasppNIZ8+Qawbm/a4doT10TEtPArhSoHlwbvqTDYjtfV92lC/2iwgO6g
YgG9XrO4V8dV39Ffm7oLFfvTbg5mv4Q/E6AWo/gkjmtxkculbyAvjFtYAQARAQAB
tCFFUEVMICg2KSA8ZXBlbEBmZWRvcmFwcm9qZWN0Lm9yZz6JAjYEEwECACAFAkvS
KUICGw8GCwkIBwMCBBUCCAMEFgIDAQIeAQIXgAAKCRA7Sd8qBgi4lR/GD/wLGPv9
qO39eyb9NlrwfKdUEo1tHxKdrhNz+XYrO4yVDTBZRPSuvL2yaoeSIhQOKhNPfEgT
9mdsbsgcfmoHxmGVcn+lbheWsSvcgrXuz0gLt8TGGKGGROAoLXpuUsb1HNtKEOwP
Q4z1uQ2nOz5hLRyDOV0I2LwYV8BjGIjBKUMFEUxFTsL7XOZkrAg/WbTH2PW3hrfS
WtcRA7EYonI3B80d39ffws7SmyKbS5PmZjqOPuTvV2F0tMhKIhncBwoojWZPExft
HpKhzKVh8fdDO/3P1y1Fk3Cin8UbCO9MWMFNR27fVzCANlEPljsHA+3Ez4F7uboF
p0OOEov4Yyi4BEbgqZnthTG4ub9nyiupIZ3ckPHr3nVcDUGcL6lQD/nkmNVIeLYP
x1uHPOSlWfuojAYgzRH6LL7Idg4FHHBA0to7FW8dQXFIOyNiJFAOT2j8P5+tVdq8
wB0PDSH8yRpn4HdJ9RYquau4OkjluxOWf0uRaS//SUcCZh+1/KBEOmcvBHYRZA5J
l/nakCgxGb2paQOzqqpOcHKvlyLuzO5uybMXaipLExTGJXBlXrbbASfXa/yGYSAG
iVrGz9CE6676dMlm8F+s3XXE13QZrXmjloc6jwOljnfAkjTGXjiB7OULESed96MR
XtfLk0W5Ab9pd7tKDR6QHI7rgHXfCopRnZ2VVQ==
=V/6I
-----END PGP PUBLIC KEY BLOCK-----
EOF


cat > /etc/yum.repos.d/epel.repo << EOF
[epel]
name=Extra Packages for Enterprise Linux 6 - `echo '$basearch'`
#baseurl=http://download.fedoraproject.org/pub/epel/6/`echo '$basearch'`
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=`echo '$basearch'`
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

[epel-debuginfo]
name=Extra Packages for Enterprise Linux 6 - `echo '$basearch'` - Debug
#baseurl=http://download.fedoraproject.org/pub/epel/6/`echo '$basearch'`/debug
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-debug-6&arch=`echo '$basearch'`
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
gpgcheck=1

[epel-source]
name=Extra Packages for Enterprise Linux 6 - `echo '$basearch'` - Source
#baseurl=http://download.fedoraproject.org/pub/epel/6/SRPMS
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-source-6&arch=`echo '$basearch'`
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
gpgcheck=1

EOF
}
################# RHEL 6 Repository End Here ######################


################ RHEL 5 Repository Start Here #####################
RHEL5 ()
{
cat > /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL << EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.2.6 (GNU/Linux)

mQGiBEXopTIRBACZDBMOoFOakAjaxw1LXjeSvh/kmE35fU1rXfM7T0AV31NATCLF
l5CQiNDA4oWreDThg2Bf6+LIVTsGQb1V+XXuLak4Em5yTYwMTVB//4/nMxQEbpl/
QB2XwlJ7EQ0vW+kiPDz/7pHJz1p1jADzd9sQQicMtzysS4qT2i5A23j0VwCg1PB/
lpYqo0ZhWTrevxKMa1n34FcD/REavj0hSLQFTaKNLHRotRTF8V0BajjSaTkUT4uk
/RTaZ8Kr1mTosVtosqmdIAA2XHxi8ZLiVPPSezJjfElsSqOAxEKPL0djfpp2wrTm
l/1iVnX+PZH5DRKCbjdCMLDJhYap7YUhcPsMGSeUKrwmBCBJUPc6DhjFvyhA9IMl
1T0+A/9SKTv94ToP/JYoCTHTgnG5MoVNafisfe0wojP2mWU4gRk8X4dNGKMj6lic
vM6gne3hESyjcqZSmr7yELPPGhI9MNauJ6Ob8cTR2T12Fmv9w03DD3MnBstR6vhP
QcqZKhc5SJYYY7oVfxlSOfF4xfwcHQKoD5TOKwIAQ6T8jyFpKbQkRmVkb3JhIEVQ
RUwgPGVwZWxAZmVkb3JhcHJvamVjdC5vcmc+iGQEExECACQFAkXopTICGwMFCRLM
AwAGCwkIBwMCAxUCAwMWAgECHgECF4AACgkQEZzANiF1IfabmQCgzvE60MnHSOBa
ZXXF7uU2Vzu8EOkAoKg9h+j0NuNom6WUYZyJQt4zc5seuQINBEXopTYQCADapnR/
blrJ8FhlgNPl0X9S3JE/kygPbNXIqne4XBVYisVp0uzNCRUxNZq30MpY027JCs2J
nL2fMpwvx33f0phU029vrIZKA3CmnnwVsjcWfMJOVPBmVN7m5bGU68F+PdRIcDsl
PMOWRLkTBZOGolLgIbM4719fqA8etewILrX6uPvRDwywV7/sPCFpRcfNNBUY+Zx3
5bf4fnkaCKxgXgQS3AT+hGYhlzIqQVTkGNveHTnt4SSzgAqR9sSwQwqvEfVtYNeS
w5rDguLG41HQm1Hojv59HNYjH6F/S1rClZi21bLgZbKpCFX76qPt8CTw+iQLBPPd
yoOGHfzyp7nsfhUrAAMFB/9/H9Gpk822ZpBexQW4y3LGFo9ZSnmu+ueOZPU3SqDA
DW1ovZdYzGuJTGGM9oMl6bL8eZrcUBBOFaWge5wZczIE3hx2exEOkDdvq+MUDVD1
axmN45q/7h1NYRp5GQL2ZsoV4g9U2gMdzHOFtZCER6PP9ErVlfJpgBUCdSL93V4H
Sgpkk7znmTOklbCM6l/G/A6q4sCRqfzHwVSTiruyTBiU9lfROsAl8fjIq2OzWJ2T
P9sadBe1llUYaow7txYSUxssW+89avct35gIyrBbof5M+CBXyAOUaSWmpM2eub24
0qbqiSr/Y6Om0t6vSzR8gRk7g+1H6IE0Tt1IJCvCAMimiE8EGBECAA8FAkXopTYC
GwwFCRLMAwAACgkQEZzANiF1IfZQYgCgiZHCv4xb+sTHCn/otc1Ovvi/OgMAnRXY
bbsLFWOfmzAnNIGvFRWy+YHi
=MMNL
-----END PGP PUBLIC KEY BLOCK-----

EOF


cat > /etc/yum.repos.d/epel.repo << EOF
[epel]
name=Extra Packages for Enterprise Linux 5 - `echo '$basearch'`
#baseurl=http://download.fedoraproject.org/pub/epel/5/`echo '$basearch'`
mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=`echo '$basearch'`
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL

[epel-debuginfo]
name=Extra Packages for Enterprise Linux 5 - `echo '$basearch'` - Debug
#baseurl=http://download.fedoraproject.org/pub/epel/5/`echo '$basearch'`/debug
mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=epel-debug-5&arch=`echo '$basearch'`
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL
gpgcheck=1

[epel-source]
name=Extra Packages for Enterprise Linux 5 - `echo '$basearch'` - Source
#baseurl=http://download.fedoraproject.org/pub/epel/5/SRPMS
mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=epel-source-5&arch=`echo '$basearch'`
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL
gpgcheck=1

EOF
}
################# RHEL 5 Repository End Here ######################


if [ -f /etc/redhat-release ]; then

	i=`uname -i`
	if [ "x$i" = "xx86_64" ]; then
		i="_x86_64"
	else 
		i="_i386"
	fi

	grep "Red Hat Enterprise Linux.*release 6" /etc/redhat-release > /dev/null 2>&1
	if [ $? = 0 ]; then
		echo "Operating System:  RHEL6${i}"
		sleep 1
		echo ""
		RHEL6
	fi
	grep "Red Hat Enterprise Linux.*release 5" /etc/redhat-release > /dev/null 2>&1
	if [ $? = 0 ]; then
		echo "Operating System:  RHEL5${i}"
		sleep 1
		echo ""
		RHEL5
	fi
	grep "CentOS release 6" /etc/redhat-release > /dev/null 2>&1
	# Treat CentOS as RHEL
	if [ $? = 0 ]; then
		echo "Operating System:  CentOS6${i}"
		sleep 1
		echo ""
		RHEL6
	fi
	grep "CentOS release 5" /etc/redhat-release > /dev/null 2>&1
	if [ $? = 0 ]; then
		echo "Operating System:  CentOS5${i}"
		sleep 1
		echo ""
		RHEL5
	fi
	
fi


bind_installation ()
{
echo ''
echo -ne 'Starting BIND DNS Installation .............................. '
sleep 1
echo ''

##### ******************************************************************* #####
echo ''
echo -ne 'Installing BIND Chroot Packages .............................. '
sleep 2
echo -ne 'Done. \n'
sleep 1
echo ''
echo -ne 'Configuration Is On Progress .............................. \n'
sleep 1
echo -ne 'Please Wait .......... \n'
sleep 1

#echo -ne '\n'
#exit 0

#yum install bind bind-chroot bind-utils -y
yum install bind bind-chroot bind-utils bind-libs -y   > /dev/null 2>&1

# Configure Bind auto start at boot:
chkconfig named on

# Stop Bind service, if service is already running:
service named stop	> /dev/null 2>&1


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
mv /var/named/chroot/etc/named.conf /var/named/chroot/etc/named.conf_`date +%F__%H-%M-%S`
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
	allow-query-cache     { localhost; $Network; };
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
mail			IN	CNAME	`hostname | awk -F'.' '{print $1}'`
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
service named restart	> /dev/null 2>&1


# Set New DNS Entry In "/etc/resolv.conf": 
cp -p /etc/resolv.conf /etc/resolv.conf_`date +%F__%H-%M-%S`
cat > /etc/resolv.conf << EOF 
nameserver 127.0.0.1
nameserver 8.8.8.8
EOF

# Final Message:
echo '';
echo 'Your BIND Server is Configured and BIND Service Stated.';
echo '';
sleep 1
echo 'Note: Before DNS Testing Make Changes In "/etc/resolv.conf"';
sleep 1
echo '############################################################';
echo '##            Test and Verify Bind DNS Setup              ##';
echo '############################################################';
echo '##        a. Test and verify using host command :         ##';
echo '##        host -t ns example.com                          ##';
echo '##        host -t mx example.com                          ##';
echo '##                                                        ##';
echo '##        b. Test and verify using nslookup command :     ##';
echo '##        nslookup                                        ##';
echo '##        > set type=any                                  ##';
echo '##        > example.com                                   ##';
echo '##        > exit                                          ##';
echo '##                                                        ##';
echo '##        c. Test and verify using dig command :          ##';
echo '##        dig example.com                                 ##';
echo '############################################################';
echo '';
echo 'If You Have Any Doubt Then Contact Me at "heerakoranga@gmail.com"';
echo '';
echo '';
sleep 2
exit ;
}

while true; 
        do
                read -p "Do You Want To Continue? [y/N]" yn
                case $yn in
                [Yy]* ) bind_installation;;
                [Nn]* ) echo "Installation Cancelled. " && exit ;;
                * ) echo "Please answer yes or no.";;
                esac
	done



