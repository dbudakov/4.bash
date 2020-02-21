# 4.draft

Оболочки: bash,zsh,fish  
Справка:  type,help,man,apropos,whatis,info  

#### Hot keys:  
![alt-текст](https://github.com/dbudakov/4.bash/blob/master/image/moving_bash.png)  
#### move and copy/past
Ctrl+a Ctrl+e - home,end  
Alt+f Alt+b - forward, back  
Ctrl+w - cut to cursor  
Ctrl+y - paste  
Ctrl+u - del string to cursor  
Ctrl+k - del string after cursor  
#### function
Tab или Ctrl+1 - tabulation  
Ctrl+j - Enter  
Ctrl+l - clear  
Ctrl + r - поиск по строке, повторный Ctrl + r - цикличный поиск по истории  
Ctrl + r дважды - поиск по последней поисковой строке  
  Во время поиска:  
  Ctrl + j - закончить поиск по истории  
  Ctrl + g - закончить поиск и вернуть строку к прежнему состоянию  
Crtl + /  
Сtrl + e  


#### Перенаправления
1 [file]<< EOF / EOF    
2 cat << EOF > myscript.sh  
3 read first second <<< "hello world"   
### Scripts
#### варианты запуска  
1 ./script.sh (необходим chmod +x)  
2 bash script.sh  
3 source script.sh  
### Переменные  
1 env  
2 printenv  
3 export  
4 declare  
##### Специальные переменные:
 $@ — параметры скрипта (столбик)  
 $* - все параметры скрипта (строка)  
 $0 — имя скрипта  
 $# — количество параметров  
 $? — статус выхода последней вýполненной командý  
 $$ — PID оболочки  
 $! — PID последней вýполненной в фоновом режиме командý  
##### примеры:  
export var=value  
declare var=value  
var=$(expr 3 + 7)  
var1="${var1:-default value}"  




скрипт киди
mandb - update db
сочетание клавиш
  
  bash-completion
  ctrl /

/ - в конце строки дополнение строки
&& - выполнить первую команду И выпонить вторую команду
|| - выполнить первую команду ИЛИ вторую

команды trur/false - вывод 1 или 0
echo $? - указывает кол-во ошибок

google > bash error code

ls -l /dev/std* - потоки

echo $TERM
 alias |grep color 
 
mkfifo

<<EOF - end of file


bash ./script
bash -x   для отладки
ещё pipestatus[i] полезно знать 

evn - много инфы, переменные
printenv
записть в .bash_profile, экспортных переменных

IFS - array знак переноса

https://devhints.io/bash#conditionals - шпора

while: exit 0 - не кашерный выход?
## ДЗ
while [ -f $pid_file ]
    do
      echo "Идет фоновой процесс ждем 300 секунд"
      sleep 300
  done
  вот защита от повторного запуска
  ### lock file во временное хранилище - tmp,var
  
   https://regex101.com/
  
  awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
  sed '/ *#/d; /^ *$/d'
  egrep "^#|^$"
  
 классы
 
tr --help - замена 
echo "hello \thonny" \t - табуляция 
awk -F":" -f ./test.awk /etc/passwd

sed - steam editior, замена данных на ходу
secoban на sed - игра  http://sed.sourceforge.net/local/games/sokoban.sed.html