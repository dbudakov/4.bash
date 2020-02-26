#!/bin/bash
trap mail 1 2 3 6

#time
t=$(date +%d\\/%b\\/%G:$(date --date '-60 min' +%H))
date0=$(date +%d\ %b\ %G)
date1=$(date --date '-60 min' +%H\:00)
date2=$(date +%H\:00)
#file
temp=temp_file
file=access.log
#mail
mailto=budakov.web@gmail.com
mailfrom=bash_test@mail.ru
pass_mailfrom=
smtp_serv=smtp.mail.ru:587


	
 	ip_select() {
		awk -v t=$t '/'$t'/ {print $1}' $file 2>/dev/null|
		sort|uniq -c|
		sort -nr|
		head -20
	}
	adr() {
		ip_select|
		awk 'BEGIN{print "Requests:\tAdress:"" }{print "\t"$1"\t"$2}'
	}

	trg() {
		awk -v t=$t '/'$t'/ {print $0}' $file 2>/dev/null|
		awk -F\" '/https/ BEGIN{print "Requests:\ttarget_addresses"}{print $4}'|
		sort|uniq -c|
		sort -nr|
		head -20|
		column -t
	}

	rtn(){
		awk -v t=$t '/'$t'/ {print $0}' $file 2>/dev/null|
		awk  'BEGIN{print "return code:"}{print  $9}'|
		sort|uniq -c|
		sort -nr
	}
	err() {
	awk -v t=$t '/'$t'/ {print $9}' $file 2>/dev/null|
	egrep "^4|^5"
	}

	post(){
	echo -e "$file\n$date0 $date1 - $date2"
	echo -e "$(adr)\n$(trg)\n$(rtn)\n$(err)"
	}
mail() {
	mail -v -s "Test" -S smtp="$smtp_serv" -S smtp-use-starttls -S smtp-auth=login\ 
	-S smtp-auth-user="$mailfrom" -S smtp-auth-password="$pass_mailfrom" \
	-S ssl-verify-ignore -S nss-config-dir=/etc/pki/nssdb -S \
	from=$mailfrom $mailto
}<post


main() {
	if
	[ -e $temp ]
	then echo "script running"
	else touch $temp && mail && rm -f $temp
	fi
	}
main
