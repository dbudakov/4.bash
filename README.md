## ДЗ
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
