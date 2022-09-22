

Prerequisites to run the notification tool (case_monitor.py):

1). Install/upgrade Python3 and mpg321 packages.

        Install:   apt-get install python3 python3-dev python3-venv mpg321
        Upgrade:   apt-get install --upgrade python3 python3-dev python3-venv mpg321

2).  Install required packages and Python modules for this project:

        pip3 install imapclient    (IMAP Client to read/check email from account)
        pip3 install gTTS              (Google Text-to-Speech module for Python)
        pip3 install pyzmail
        pip3 install pipreqs



Addional notes: 

Make changes in "config.ini" file to add desired email-account and login details.  

Example: 
------------------------------------------------------
[login_details]
# Login details of Email account:
HOSTNAME = mail.example.com
USERNAME = myemail-id@example.com
PASSWORD = mypassword 

[folder_details]
# Folder name which we will monitor for incoming emails.
MAILBOX = Inbox

##  Example to check email in a sub folder.
##MAILBOX = 'Inbox/TestFolder'

[subject_details] 
#  Change subject according to your requirement.  
sev_sub = Severity-1

[check_freq]
# Check email in every 30 seconds
MAIL_CHECK_FREQ = 30

[email_offset]
# Set offset, if unread messages never goes to zero
OFFSET_NEWMAIL = 0
------------------------------------------------------ 



