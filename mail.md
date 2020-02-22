### Настройка отправки сообщений
[script](https://github.com/dbudakov/4.bash/blob/master/mail.md#script)  
Перваначально в Vagrantfile предустановлены mailx и wget, они понадобятся  
```shell
yum install mailx wget -y 
```
для отправки через сторонний smtp сервис нужно установить сертификат, этого ресурса  
проверяем установленный  
```shell
certutil -L -d /etc/pki/nssdb  
# здесь -L посмотреть список сертификатов  
```  
смотрим отрытый сертификат smtp сервера  
```shell
openssl s_client -showcerts -connect smtp.mail.ru:465 </dev/null|less  
```  
здесь основные поля в которых указан нужный сертификат и сервер сертификата это    
```  
Certificate chain    
 0 s:/C=RU/L=Moscow/O=LLC Mail.Ru/OU=IT/CN=*.mail.ru    
   i:/C=US/O=DigiCert Inc/OU=www.digicert.com/CN=GeoTrust RSA CA 2018    
```  
или   
```  
Server certificate    
subject=/C=RU/L=Moscow/O=LLC Mail.Ru/OU=IT/CN=*.mail.ru  
issuer=/C=US/O=DigiCert Inc/OU=www.digicert.com/CN=GeoTrust RSA CA 2018  
```  
качаем требуемый сертификат  
```shell
wget https://dl.cacerts.digicert.com/GeoTrustRSACA2018.crt    
```
и устанавливаем его для в нашу систему  
```shell
certutil -A -d /etc/pki/nssdb -t "TCu,Cu,Tuw" -i ./GeoTrustRSACA2018.crt -n GeoTrustRSACA2018.crt    
#  здесь -A -добавить сертификат  
#        -d -директория сертификатов  
#        -t -указывает на trust в кавычках его значение "аргумента"  
#        -i -путь к сертификату  
#        -n наименование, будет отображаться в списке сертификитов  
```
Проверяем наличие сертификата  
```shell
certutil -L -d /etc/pki/nssdb  
```
Далее, можно отправлять сообщения, [example](https://www.dmosk.ru/miniinstruktions.php?mini=mail-shell)  
```shell
df -h | mail -v -s "Test" -S smtp="smtp.mail.ru:587" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="bash_test@mail.ru" -S smtp-auth-password="***" -S ssl-verify-ignore -S nss-config-dir=/etc/pki/nssdb -S from=bash_test@mail.ru budakov.web@gmail.com  
# Здесь smtp="smtp.mail.ru":587 - сервер smtp:порт  
#       smtp-use-starttls       - указывает на использование шифрования TLS  
#       smtp-auth=login         - задает аутентификацию с использованием логина пароля  
#       smtp-auth-user          - имя пользователя  
#       smtp-auth-password      - пароль пользователя  
#       ssl-verify-ignore       - отключает проверку подлинности сертификата безопасности  
#       nss-config-dir=/etc/pki/nssdb - указывает на каталог с базами nss  
#       from=[from@mail.ru]     - задает поле FROM  
#       [to_mail]@gmail.com     - получатель  
```
##### script
```
#!/bin/bash
yum install mailx wget -y
# certutil -L -d /etc/pki/nssdb
# openssl s_client -showcerts -connect smtp.mail.ru:465 </dev/null|less
wget https://dl.cacerts.digicert.com/GeoTrustRSACA2018.crt
certutil -A -d /etc/pki/nssdb -t "TCu,Cu,Tuw" -i ./GeoTrustRSACA2018.crt -n GeoTrustRSACA2018.crt
# certutil -L -d /etc/pki/nssdb
# df -h | mail -v -s "Test" -S smtp="smtp.mail.ru:587" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="bash_test@mail.ru" -S smtp-auth-password="***" -S ssl-verify-ignore -S nss-config-dir=/etc/pki/nssdb -S from=bash_test@mail.ru budakov.web@gmail.com
```
