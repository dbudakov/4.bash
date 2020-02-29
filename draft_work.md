
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
awk -v t=$t '/'$t'/ {print $1}' access.log 2>/dev/null|sort|uniq -c|sort -nr|awk '{print "\t"$1"\t"$2}'
```
скрипт выбора запрашиваемых адресов  
```shell  
#!/bin/bash
t=$(date +%d\\/%b\\/%G:$(date --date '-60 min' +%H))
awk -v t=$t '/'$t'/ {print $0}' access.log 2>/dev/null| awk -F\" '/https/ {print $4}'|sort|uniq -c|sort -nr|column -t
```  
коды возврата  
```
awk -v t=$t '/'$t'/ {print $0}' access.log 2>/dev/null| awk  '{print  $9}'|sort|uniq -c
```

выборка ошибок за 1 час
```
awk -v t=$t '/'$t'/ {print $9}' access.log 2>/dev/null|egrep '^4|^5
```

```вывод времени в секундах
#!/bin/bash
utime=$(awk '{print $14}' /proc/2832/stat)
stime=$(awk '{print $15}' /proc/2832/stat)
cutime=$(awk '{print $16}' /proc/2832/stat)
cstime=$(awk '{print $17}' /proc/2832/stat)
HZ=$(getconf CLK_TCK)
a=$(echo "scale=10;($utime+$stime+$cutime+$cstime)/$HZ/6"|bc)
#вывод минут и секунд
m=$(echo "$(echo "$(echo "scale=10;$a/10"|bc) - $(echo "$a/10")"|bc)*60"|bc|cut -d. -f 1)
s=$(echo "$a/10"|bc)
echo "$m:$s"
```
