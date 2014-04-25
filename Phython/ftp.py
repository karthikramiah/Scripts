#!/usr/bin/pyhton
import ftplib
import os
import sys
import traceback

print "Logging in..."
ftp = ftplib.FTP()
ftp.connect('192.168.8.203')
print ftp.getwelcome()
try:
    try:
        ftp.login('ftpuser', 'we1c@me')
        ftp.cwd('/home/ftpuser')
        # move to the desired upload directory
        print "Currently in:", ftp.pwd()

        print "Uploading...",
        fullname = '/home/karthikr/pyhtonscripts/ftp.py'
        name = os.path.split(fullname)[1]
        f = open(fullname, "rb")
        ftp.storbinary('STOR ' + name, f)
        f.close()
        print "OK"
        
        print "Files:"
        print ftp.retrlines('LIST')
    finally:
        print "Quitting..."
        ftp.quit()
except:
      traceback.print_exc()  