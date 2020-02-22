Перваначально в Vagrantfile предустановлены mailx и wget, они понадобятся  
```
yum install mailx wget  
```
для отправки через сторонний smtp сервис нужно установить сертификат, этого ресурса  
проверяем установленный  
```
certutil -L -d /etc/pki/nssdb  
# здесь -L посмотреть список сертификатов  
```  
смотрим отрытый сертификат smtp сервера  
```  
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
```
wget https://dl.cacerts.digicert.com/GeoTrustRSACA2018.crt    
```
и устанавливаем его для в нашу систему  
```
certutil -A -d /etc/pki/nssdb -t "TCu,Cu,Tuw" -i ./GeoTrustRSACA2018.crt -n GeoTrustRSACA2018.crt    
#  здесь -A -добавить сертификат  
#        -d -директория сертификатов  
#        -t -указывает на trust в кавычках его значение "аргумента"  
#        -i -путь к сертификату  
#        -n наименование, будет отображаться в списке сертификитов  
```
Проверяем наличие сертификата  
```
certutil -L -d /etc/pki/nssdb  
```
Далее, можно отправлять сообщения, [example](https://www.dmosk.ru/miniinstruktions.php?mini=mail-shell)  
```
df -h | mail -v -s "Test" -S smtp="smtp.mail.ru:587" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="bash_test@mail.ru" -S smtp-auth-password="gcy2yRVFV5" -S ssl-verify-ignore -S nss-config-dir=/etc/pki/nssdb -S from=bash_test@mail.ru budakov.web@gmail.com  
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
