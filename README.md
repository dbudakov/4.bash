### Домашнее задание
Пишем скрипт  
Цель: В результате выполнения ДЗ студент напишет скрипт.   
написать скрипт для крона    
который раз в час присылает на заданную почту   
- X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта  
- Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта  
- все ошибки c момента последнего запуска  
- список всех кодов возврата с указанием их кол-ва с момента последнего запуска 
в письме должно быть прописан обрабатываемый временной диапазон должна быть реализована защита от мультизапуска  
Критерии оценки: 5 - трапы и функции, а также sed и find +1 балл  
### Решение  

настройка cron:  
```shell
crontab -e
0 * * * * /bin/bash /root/script1  
```
сам скрипт:
```shell
#!/bin/bash
#trap ml 1 2 3 6

#time
t=$(date +%d\\/%b\\/%G:$(date --date '-60 min' +%H))
date0=$(date +%d\ %b\ %G)
date1=$(date --date '-60 min' +%H\:00)
date2=$(date +%H\:00)
#file
temp=/var/temp.log
file=/root/access.log
lockfile=/tmp/localfile
#mail
mailto=budakov.web@gmail.com
mailfrom=bash_test@mail.ru
pass_mailfrom=***
smtp_serv=smtp.mail.ru:587


ip_select() {
                awk ' BEGIN {print "Requests:\tAdress:" }{print $1" "$2}'|
                column -t
        }
code_select(){
                awk 'BEGIN {print "sum:\tcode:"}{print $1" "$2}'|
                column -t
        }
srt() {
        sort|uniq -c|sort -nr
}
        adr() {
                echo -e "\nadr request"
                awk -v t=$t '/'$t'/{print $1}' $file 2>/dev/null|
                srt|
                head -20|
                ip_select
        }

        trg() {
                echo -e "\ntarget request"
                awk -v t=$t '/'$t'/ {print $0}' $file 2>/dev/null|
                awk -F\" '/https/ {print $4}'|
                srt|
                head -20|
                ip_select
        }

        rtn(){
                echo -e "\nreturn code:"
                awk -v t=$t '/'$t'/ {print $9}' $file 2>/dev/null|
                srt|
                code_select
        }
        err() {
                echo -e "\nerror_code:"
                awk -v t=$t '/'$t'/ {print $9}' $file 2>/dev/null|
                egrep "^4|^5"|
                srt|
                code_select
        }

        post(){
        echo -e "$file\n$date0 $date1 - $date2"
        echo -e "$(adr)\n$(trg)\n$(rtn)\n$(err)"
        }

all(){
        echo -e "$file\n$date0 $date1 - $date2"
        adr;trg;rtn;err
}
main() {
        if
        [ -e $temp ]
        then echo "script running"
        else touch $temp && mail && rm -f $temp
        fi
        }
ml() {
         all|mail -v -s "Test" -S smtp="$smtp_serv" \
        -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$mailfrom" \
        -S smtp-auth-password="$pass_mailfrom" -S ssl-verify-ignore \
        -S nss-config-dir=/etc/pki/nssdb -S from=$mailfrom $mailto
}

if ( set -o noclobber; echo "$$" > "$lockfile") 1> /dev/null;
then
  trap 'rm -f "$lockfile"; exit $?' INT  TERM EXIT
  ml
  sleep 30
  rm -f "$lockfile"
  trap - INT TERM exit
else
  echo "program running"
fi
```
