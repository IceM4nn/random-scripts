@echo off
setlocal

set help=false
if ["%1"]==[""] set help=true
if ["%1"]==["-h"] set help=true
if ["%1"]==["--help"] set help=true
if ["%help%"]==["true"] (
	goto :usage
)

IF ["%1"]==["-f"] (
  SET file=%~f2
  SHIFT
  goto :ip_list
)

set ip=%1
for /F "tokens=1,2,3,4 delims=." %%a in ("%ip%") do (
	set ipaddr=%%a.%%b.%%c
  set range=%%d
)
for /F "tokens=1,2 delims=-" %%a in ("%range%") do (
	set startaddr=%%a
  set endaddr=%%b
)

:: echo [*] start address:  %startaddr%
:: echo [*] end address:  %endaddr%

for /L %%i IN (%startaddr%,1,%endaddr%) do (
	echo [+] pinging address %ipaddr%.%%i && ping -n 1 %ipaddr%.%%i | FIND /i "Reply from %ipaddr%.%%i" >nul && echo     - Host is up
)
exit /B 0

:: Ping sweep from IP list file.

:ip_list
for /F "tokens=*" %%A in (%file%) do (
	echo [+] pinging address %%A && ping -n 1 %%A | FIND /i "Reply from %%A" >nul && echo     - Host is up 
)
exit /B 0
goto :eof

:: Help section

:usage
echo Usage: ping-sweep.bat ^<ip-address-range^>^|^<-f file_name.txt^>
echo Perform ping sweep on windows internal network.
echo.
echo   ip-address-range	            IP address in range. For example: 192.168.1.1-10
echo   -f file_name.txt	            IP address list in a file.
echo   -h, --help                   display this help and exit
goto :eof
