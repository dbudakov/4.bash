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
чистый скрипт лежит [здесь](https://github.com/dbudakov/4.bash/blob/master/script.sh):  
```shell
#!/bin/bash

#time параметры времени
t=$(date +%d\\/%b\\/%G:$(date --date '-60 min' +%H))      # вывод актуальной даты и даты час назад, в виде [день] [месяц] [час]
date0=$(date +%d\ %b\ %G)                                 # текущие дата и время
date1=$(date --date '-60 min' +%H\:00)                    # дата и время 60 минут назад
date2=$(date +%H\:00)                                     # вывод только текущего значения [часа] для отчёта
#file параметры файлов 
file=/root/access.log                                     # значения файла в котором собирается лог
lockfile=/tmp/localfile                                   # файл который создается для фикса мультистарта, а также в него падает PID
#mail параметры почты
mailto=budakov.web@gmail.com                              # получатель
mailfrom=bash_test@mail.ru                                # отправитель
pass_mailfrom=***                                         # пароль отправителя
smtp_serv=smtp.mail.ru:587                                # smtp сервер для отправки письма


ip_select() {                                               # данная функция вешает шапку на уже готовый отчёт,
 awk ' BEGIN {print "Requests:\tAdress:" }{print $1" "$2}'| # а также разбивает колонки в таблицу, используется
 column -t                                                  # для оформления
}
code_select(){                                     # аналогично предыдущей вешает шапку, но уже для кодов 
 awk 'BEGIN {print "sum:\tcode:"}{print $1" "$2}'| # возврата на уже готовый отчёт, а также разбивает колонки
 column -t                                         # в таблицу, используется для оформления
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
```
temp=/var/temp.log                                      
main() {
        if
        [ -e $temp ]
        then echo "script running"
        else touch $temp && mail && rm -f $temp
        fi
        }
```    
