#!/usr/bin/env python3

# Import required modules 
import time
import os
import sys
import email
import signal
import io
#import configparser
 
from gtts import gTTS
from imapclient import IMAPClient
from configparser import ConfigParser 


parser = ConfigParser()
parser.read('config.ini')

HOSTNAME = parser.get('login_details', 'HOSTNAME')
USERNAME = parser.get('login_details', 'USERNAME')
PASSWORD = parser.get('login_details', 'PASSWORD')
MAILBOX = parser.get('folder_details', 'MAILBOX')
SUBJECT_KEYWORD = parser.get('subject_details', 'SUBJECT_KEYWORD')
MAIL_CHECK_FREQ = parser.get('mail_check_freq', 'MAIL_CHECK_FREQ')
OFFSET_NEWMAIL = parser.get('email_offset', 'OFFSET_NEWMAIL')


# CTRL+C error handling 
def keyboardInterruptHandler(signal, frame):
    print("KeyboardInterrupt (ID: {}) has been caught. Cleaning up...".format(signal))
    exit(0)

signal.signal(signal.SIGINT, keyboardInterruptHandler)


def mailcheck_func():
    # Login credentials
    server = IMAPClient(HOSTNAME, use_uid=True, ssl=True)
    server.login(USERNAME, PASSWORD)
    b'[CAPABILITY IMAP4rev1 LITERAL+ SAL-IR [...] LIST-STATUS QUOTA] Logged in'

    # Select folder and search for the unread messages
    select_info = server.select_folder(MAILBOX, readonly=True)
    unread = server.folder_status(MAILBOX, ['UNSEEN'])
    messages = server.search('UNSEEN')

    for uid, message_data in server.fetch(messages, 'RFC822').items():
        #print('enter here')
        email_message = email.message_from_bytes(message_data[b'RFC822']) 
        #print('this is email message %s' % (email_message))
        ##print('this is email message %s' % (email_message))
        if (not email_message):
          print('No new message in the Inbox')
          continue
        else:
            mail_sub = email_message.get('Subject') 
#            print('New email')  

####  adding new lines
#           Print total count of unread messages
            newmail_count = (unread[b'UNSEEN'])
            print('%d unread messages in the Inbox' % newmail_count)
####
            if (mail_sub):
              if (SUBJECT_KEYWORD in mail_sub):
                print('There is a Severity-1 case in Queue.')  
####
                speech=gTTS("Hello Heera..., Please check there is a Severity-1 case in the queue.")
                speech.save("Hello.mp3")
                os.system("mpg321 -q Hello.mp3")
####
              else:
                #print('There is no Sev-1')
                print(' ')
            else:
              print('There is no mail')

            print('')

time.sleep(5)
#print('Done.')

'''
    # Print total count of unread messages
    newmail_count = (unread[b'UNSEEN'])
    print('%d unread messages' % newmail_count)

    if newmail_count > OFFSET_NEWMAIL:
         print('New Email')
         speech=gTTS("Hello Heera..., Please check New Email in the Inbox")
         speech.save("Hello.mp3")
         os.system("mpg321 -q Hello.mp3")
    else:
          time.sleep(MAIL_CHECK_FREQ)
'''


while True:
# Calling main mailcheck function 
    mailcheck_func()


while True:
    pass



