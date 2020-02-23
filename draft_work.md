
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
