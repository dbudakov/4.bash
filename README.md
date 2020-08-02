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
Vagrntfile, access.log, и script находятся [здесь](https://github.com/dbudakov/4.bash/tree/master/homework)  
настройка email [здесь](https://github.com/dbudakov/4.bash/blob/master/mail.md)  
### script
настройка cron:  
```shell
crontab -e
0 * * * * /bin/bash /root/script1  
```

```shell
#!/bin/bash

#time параметры времени
t=$(date +%d\\/%b\\/%G:$(date --date '-60 min' +%H)) # период анализа [минус 60 мин от локального времени]
date0=$(date +%d\ %b\ %G)                            # текущие дата и время
date1=$(date --date '-60 min' +%H\:00)               # дата и время 60 минут назад
date2=$(date +%H\:00)                                # вывод только текущего значения [часа] для отчёта
#file параметры файлов  
file=/root/access.log                                # значения файла в котором собирается лог
lockfile=/tmp/localfile                              # файл который создается для фикса мультистарта
#mail параметры почты 
mailto=budakov.web@gmail.com                         # получатель
mailfrom=bash_test@mail.ru                           # отправитель
pass_mailfrom=***                                    # пароль отправителя
smtp_serv=smtp.mail.ru:587                           # smtp сервер для отправки письма


ip_select() {                                               # используется для оформления, вешает шапку
 awk ' BEGIN {print "Requests:\tAdress:" }{print $1" "$2}'| # на уже готовый отчёт, а также 
 column -t                                                  # разбивает колонки в таблицу
              }
code_select(){                                      # используется для оформления, вешает шапку, но 
 awk 'BEGIN {print "sum:\tcode:"}{print $1" "$2}'|  # уже для кодов возврата на уже готовый отчёт, 
 column -t                                          # а также разбивает колонки в таблицу
       }
srt() {                                             # считает уникальные значения строк, а после
        sort|uniq -c|sort -nr                       # сортирует по убыванию суммы
       }                                                    
adr() {                                             # выборка кол-ва ip 
  echo -e "\nadr request"                           # шапка отчёта
  awk -v t=$t '/'$t'/{print $1}' $file 2>/dev/null| # выборка из файла 1-го поля, для строк 
  srt|                                              # с наличием значения $t , далее srt()
  head -20|                                         # вывод 20 первых строк
  ip_select                                         # вывод на оформление в ip_select()
       }
trg() {                                             # выборка адресов запросов    
 echo -e "\ntarget request"                         # шапка отчёта
 awk -v t=$t '/'$t'/ {print $0}' $file 2>/dev/null| # вывод всей строки содержащей $t
 awk -F\" '/https/ {print $4}'|                     # вывод 4 поля для строр содержищих
 srt|                                               # значение "https", вывод на srt()
 head -20|                                          # вывод 20 первых строк
 ip_select                                          # вывод на оформление в ip_select()   
        }

rtn(){                                              # вывод кодов возврата
 echo -e "\nreturn code:"                           # шапка отчёта        
 awk -v t=$t '/'$t'/ {print $9}' $file 2>/dev/null| # вывод 9 поля для строк содержащих $t
 srt|                                               # вывод на srt()
 code_select                                        # вывод на оформление в code_select
        }
err() {                                             # вывод кодов ошибок
 echo -e "\nerror_code:"                            # шапка отчёта
 awk -v t=$t '/'$t'/ {print $9}' $file 2>/dev/null| # вывод 9 поля для строк содержащих $t
 egrep "^4|^5"|                                     # выборка значений начинающихся с "4" и "5"   
 srt|                                               # вывод на srt()  
 code_select                                        # вывод на оформление в code_select     
        }
all(){                                              # формирования общего отчета
        echo -e "$file\n$date0 $date1 - $date2"     # шапка отчета с указанием даты и 
        adr;trg;rtn;err                             # анализируемого промежутка времени,
}                                                   # а также вывод отчётов
ml() {                                              # отправка письма, с вложенной all()
 all|mail -v -s "Test" -S smtp="$smtp_serv" \       # подробнее по отправке в ссылке перед скриптом
 -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$mailfrom" \
 -S smtp-auth-password="$pass_mailfrom" -S ssl-verify-ignore \
 -S nss-config-dir=/etc/pki/nssdb -S from=$mailfrom $mailto
}

if ( set -o noclobber; echo "$$" > "$lockfile") 1> /dev/null; 
then                                                # активная часть скрипта, вводится трап
  trap 'rm -f "$lockfile"; exit $?' INT  TERM EXIT  # nocloobber - параметр о запрете записи файла
  ml                                                # поэтому если файл есть то перезапись неполучится,
  sleep 30                                          # осн if - если запись не удалась вывести сообщение о том
  rm -f "$lockfile"                                 # что скрипт запущен, если удалась, то запустить ml(), 
  trap - INT TERM exit                              # обозначен таймер на 30сек для проверки мульти старта,  
else                                                # трап перехватывает сигналы INT(^C) TERM(15,kill) 
  echo "program running"                            # EXIT(выходной сигнал), получая их происходит удаление
fi                                                  # lockfile'a, закрытия оператора условия "if"
```     
#### Дополнительно:  
Подстановка переменных в awk  
```
for i in {1..30} ; do cat <file>|awk -v t=$i '{print $t}';done
uniq -c
```
#### source
Extracting substring using a regular expression with capture groups [hier](https://markhneedham.com/blog/2013/06/26/unixawk-extracting-substring-using-a-regular-expression-with-capture-groups/)  
Локальные переменные [здесь](https://www.opennet.ru/docs/RUS/bash_scripting_guide/x12644.html)  
Отправка почты из консоли [interserver](https://www.interserver.net/tips/kb/linux-mail-command-usage-examples/)  
#### code training
[Bash by Example](https://www.funtoo.org/Bash_by_Example,_Part_1)  
[The Bash Hackers Wiki](https://wiki-dev.bash-hackers.org/)  
[codewars](https://www.codewars.com/?language=shell)
