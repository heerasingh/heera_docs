#!/bin/bash
while IFS=',' read  u1 p1 u2 p2;
do

imapsync --host1 imap.gmail.com --port1 993 --user1 "$u1" --password1 "$p1" --ssl1 --host2 imap.gmail.com --port2 993 --user2 "$u2" --password2 "$p2" --ssl2 --syncinternaldates --noauthmd5 --exclude "Monit" --exclude "\[Gmail\]" --useheader Message-ID --skipsize --allowsizemismatch

#imapsync --host1 imap.gmail.com --port1 993 --user1 "$u1" --password1 "$p1" --ssl1 --host2 imap.gmail.com --port2 993 --user2 "$u2" --password2 "$p2" --ssl2 --syncinternaldates --noauthmd5 --exclude "Monit" --exclude "\[Gmail\]" --useheader Message-ID --skipsize --allowsizemismatch

#imapsync --host1 imap.gmail.com --port1 993 --user1 "$u1" --password1 "$p1" --ssl1 --host2 imap.gmail.com --port2 993 --user2 "$u2" --password2 "$p2" --ssl2 --syncinternaldates --noauthmd5 --folder "[Gmail]/Sent Mail"

#imapsync --host1 imap.gmail.com --port1 993 --user1 "$u1" --password1 "$p1" --ssl1 --host2 imap.gmail.com --port2 993 --user2 "$u2" --password2 "$p2" --ssl2 --syncinternaldates --split1 100 --split2 100 --authmech1 LOGIN --authmech2 LOGIN --allowsizemismatch --useheader Message-ID --include "INBOX.Softlink_Check"

#imapsync --host1 209.59.210.98 --user1 $u1 --password1 $p1 --host2 imap.gmail.com --user2 $u2 --password2 $p1 --ssl2 --noauthmd5 --include "INBOX.Sent" --skipsize --allowsizemismatch
#imapsync --host1 mail.tetrain.com --user1 $u1 --password1 $p1 --host2 imap.gmail.com --user2 $u2 --password2 $p1 --ssl2 --noauthmd5 --skipsize --allowsizemismatch

#imapsync --host1 imap.gmail.com --port1 993 --user1 you@gmail.com --password1 ****** --ssl1 --host2 imap.gmail.com --port2 993 --user2 you@domain.com --password2 ****** --ssl2 --syncinternaldates --split1 100 --split2 100 --authmech1 LOGIN --authmech2 LOGIN --allowsizemismatch --useheader Message-ID

done  < myaccount.csv

