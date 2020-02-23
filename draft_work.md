
скрипт для выборки AWK из file
```
#echo -n "укажите путь к файлу: "; read file ;
while [ 1 -eq 1  ];do echo -n "введите столбец: "; read yesno ;  awk -v i="$yesno" '{print $i}' $file |head -10 ;done ;  
```
выборка по дате:  
```   
date +%d\\/%b\\/%G:$(( $(date +%H)-1 ))

awk '/15\/Aug\/2019:00/ {print $1}'
```
установка времени:  
```
sudo date 081410002019  
timedatectl  
date MMDDhhmmYYYY  
```


рабочие наброски  
```shell
t=$(date +%d\\/%b\\/%G:$(date --date '-60 min' +%H))
#awk -v t=$t '/t/ {print $1}'
awk -v t=$t '/'$t'/ {print $1}' access.log 2>/dev/null|uniq -c|sort -gr
```
script выбора кол-ва IP за последний час  
```shell
#!/bin/bash
t=$(date +%d\\/%b\\/%G:$(date --date '-60 min' +%H))
echo -e "access.log file\n$(date +%d\ %b\ %G) $(date --date '-60 min' +%H\:00) - $(date +%H\:00)\nRequests:\tAdress:"
awk -v t=$t '/'$t'/ {print $1}' access.log 2>/dev/null|uniq -c|sort -nr|awk '{print "\t"$1"\t"$2}'
```
скрипт выбора запрашиваемых адресов  
```
#!/bin/bash
t=$(date +%d\\/%b\\/%G:$(date --date '-60 min' +%H))
echo -e "access.log file\n$(date +%d\ %b\ %G) $(date --date '-60 min' +%H\:00) - $(date +%H\:00)\n"
awk -v t=$t -v i=$i '/'$t'/ {print $0}' access.log 2>/dev/null |awk -F\" '/https/{print $4}'|uniq -c|sort -nr|column -t
```  
