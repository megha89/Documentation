import csv
i=0
csv_out = "/Users/meghagupta/Downloads/all-data/test/Delay/New.csv"
fin = open("/Users/meghagupta/Downloads/all-data/test/6.csv", "rb")
fin.readline()
fout = csv.writer(open(csv_out, 'wb'))
fout.writerow(('timestamp','dttm_utc','value','estimated','anomaly'))
while i < 6:
    i += 1
    str_from = fin.readline()
    newTime = str_from.replace(':00,',':01,')
    fout.writerow([newTime])
    print newTime
#fout.write(newTime)
fin.close()
