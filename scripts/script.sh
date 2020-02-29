#!/bin/bash
 
#time
t=$(date +%d\\/%b\\/%G:$(date --date '-60 min' +%H))
date0=$(date +%d\ %b\ %G)
date1=$(date --date '-60 min' +%H\:00)
date2=$(date +%H\:00)
#file
temp=/var/temp.log
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

   rtn() {
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
file=/root/access.log
        post(){
        echo -e "$file\n$date0 $date1 - $date2"
        echo -e "$(adr)\n$(trg)\n$(rtn)\n$(err)"
        }
        main() {
        if
        [ -e $temp ]
        then echo "script running"
        else touch $temp && mail && rm -f $temp
        fi
        }
```       
