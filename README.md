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
ecли год равен году, месяц равен месяцу и часы равны часам то запустить анализ, взять время с сервера, или использовать локальное  
отправить на майл: использовать переменную $USER, задублировать

выборка по IP: выборка по времени и запросу, подсчёт кол-ва  
выборка по запросу: выборка по времени и запрашиваемому сайту, подсчёт  
все ошибки c момента последнего запуска: выборка по времени, выборка по столбцу, подсчёт кол-ва каждой ошибки  
список всех кодов возврата с указанием их кол-ва с момента последнего запуска: выборка по времени,выборка по столбцу, подсчет   

в письме должно быть прописан обрабатываемый временной диапазон: вывод date  
должна быть реализована защита от мультизапуска: trap,создания файла и чек файла   

while [ -f $pid_file ]
    do
      echo "Идет фоновой процесс ждем 300 секунд"
      sleep 300
  done
  вот защита от повторного запуска
  ### lock file во временное хранилище - tmp,var
  
[if in for](https://gitlab.com/otus_linux/stands-05-bash/-/blob/master/loop5.sh)    
[do in while](https://gitlab.com/otus_linux/stands-05-bash/-/blob/master/loop6.sh)   
[expect ?](https://gitlab.com/otus_linux/stands-05-bash/-/blob/master/script.exp)  
[trap](https://gitlab.com/otus_linux/stands-05-bash/-/blob/master/trap.sh)  
declare




