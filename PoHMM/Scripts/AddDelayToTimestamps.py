__author__ = 'meghagupta'

import time
import csv
import os
import sys
import string

delay_csv = "/Users/meghagupta/Downloads/all-data/Delay/"
i = 0
j = -1
while j < 59:
    root_dir = '/Users/meghagupta/Downloads/all-data/test/'
    for root, subFolders, files in os.walk(root_dir):
        for filename in files:
            j += 1
            filePath = os.path.join(root, filename)
            fout = csv.writer(open(delay_csv + filename, 'wb'))
            with open(filePath, "rb") as f:
                old_str = f.readline()
                fout.writerow(('timestamp', 'dttm_utc', 'value', 'estimated', 'anomaly'))
                while i < 105385:
                    i += 1
                    old_str = f.readline()
                    newTime = old_str.replace(':00,', ':{0},'.format(j))
                    fout.writerow([newTime])
                i = 0
    print "FILE ENDS HERE !"
    print i,j
    f.close()
# fin = open("/Users/meghagupta/Downloads/all-data/csv/6.csv", "rb")
# fout = csv.writer(open(csv_file, 'wb'))
# # fout.writerow(('Phone no', 'SMS Sent time', 'SMS Reception Time', 'SMS Content'))
# #
# str_from = fin.readline()
# print str_from
# fin.readline()
# str_sent = fin.readline()
# str_rec = fin.readline()
# fin.readline()
# fin.readline()
# fin.readline()
# fin.readline()
# str_sms = fin.readline()
# index = str_from.find(":")
# str_from = str_from[index+2:-2]
# str_from.lstrip()
# print str_from
# index = str_sent.find(":")
# str_sent = str_sent[index+2:-2]
# str_sent.lstrip
# print str_sent
# index = str_rec.find(":")
# str_rec = str_rec[index+2:-2]
# str_rec.lstrip
# print str_rec
# index = str_sms.find(":")
# str_sms = str_sms[index+2:-2]
# str_sms.lstrip
# print str_sms
#
# fout.writerow((str_from, str_sent, str_rec, str_sms))



##time.sleep(60)
