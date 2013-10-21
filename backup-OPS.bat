@echo off
rem description	: This script makes backups of your OPS files frol Alcatel-Lucent PBX
rem		  More info - http://dontforgetitplz.blogspot.com/2013/10/alcatel-licent-oxe-cpu.html
rem author	: Dmitry Myasnikov <saver_is_not@bk.ru>
rem version	: 1.0.0

rem i - имя станции, j - IP-адрес, k - имя, l - пароль, m - путь
FOR /F "eol=; skip=1 tokens=1-5* delims=|" %%i in (ats_config.txt) do (

  if not exist %%m\%DATE%\%%i\OPS mkdir %%m\%DATE%\%%i\OPS
  if exist %%i.dat del %%i.dat

  echo user %%k>> %%i.dat
  echo %%l>> %%i.dat
  echo bin>> %%i.dat
  echo lcd %%m\%DATE%\%%i\OPS>> %%i.dat
  echo mget /usr4/BACKUP/OPS/*.*>> %%i.dat
  echo y>> %%i.dat
  echo y>> %%i.dat
  echo y>> %%i.dat
  echo y>> %%i.dat
  echo y>> %%i.dat
  echo y>> %%i.dat
rem  echo cd /usr4/BACKUP/OPS>> %%i.dat
rem  echo get mao-dat %%m\%DATE%\%%i\DAY\mao-dat>> %%i.dat
rem  echo get cho-dat %%m\%DATE%\%%i\DAY\cho-dat>> %%i.dat
  echo quit>> %%i.dat

rem ===== Создание TELNET-скрипта для каждой станции
  echo %%j 23>> backup-ops-%%i.tst
  echo WAIT "login:">> backup-ops-%%i.tst
  echo SEND "%%k\m">> backup-ops-%%i.tst
  echo WAIT "Password:">> backup-ops-%%i.tst
  echo SEND "%%l\m">> backup-ops-%%i.tst
  echo WAIT ">">> backup-ops-%%i.tst
  echo SEND "swinst\m">> backup-ops-%%i.tst
  echo WAIT "Password:">> backup-ops-%%i.tst
  echo SEND "SoftInst\m">> backup-ops-%%i.tst
  echo WAIT "Your choice [1..2, Q] ?">> backup-ops-%%i.tst
  echo SEND "1\m">> backup-ops-%%i.tst
  echo WAIT "Your choice [1..10, Q] ?">> backup-ops-%%i.tst
  echo SEND "5\m">> backup-ops-%%i.tst
  echo WAIT "(y/n, default y):">> backup-ops-%%i.tst
  echo SEND "y\m">> backup-ops-%%i.tst
  echo WAIT "Press return">> backup-ops-%%i.tst
  echo SEND "\m">> backup-ops-%%i.tst
  echo WAIT "Your choice [1..10, Q] ?">> backup-ops-%%i.tst
  echo SEND "q\m">> backup-ops-%%i.tst
  echo WAIT "Your choice [1..2, Q] ?">> backup-ops-%%i.tst
  echo SEND "q\m">> backup-ops-%%i.tst
  echo WAIT ">">> backup-ops-%%i.tst
  echo SEND "exit\m">> backup-ops-%%i.tst
rem ===== Скрипт создан!

  tst10 /r:backup-ops-%%i.tst /o:backup-ops-%%i.log
  ftp -n -s:%%i.dat %%j

del %%i.dat
del backup-ops-%%i.tst

rar a -r %%m\%DATE%.rar %DATE%\
del /S /Q %%m\%DATE%
rmdir /S /Q %%m\%DATE%

)



