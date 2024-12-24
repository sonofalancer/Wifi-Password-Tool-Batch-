@echo off

setlocal enabledelayedexpansion
title Wifi Password Tool
mode 85,25

cd %systemroot%\system32
call :IsAdmin

echo Welcome to the password finder!
echo Please note we can only find passwords of Wifi networks you have connected to before.

pause
cls

:question

set /p name=What is the name of the Wifi you want to get the password from? 
cls

netsh wlan show profiles name=%name% >nul || (
    cls
	echo Could not find Wifi name. Make sure you have connected to it before.
    goto question
)

set name="%name%"
for /f "usebackq tokens=1,2 delims=:" %%v in (`cmd /c "netsh wlan show profiles name=%name% key=clear"`) do (
set "pw=%%w"
echo %%v | findstr /r "Key Content" >nul && goto result
)

msg * Error... Could not find password.
exit

:IsAdmin

Reg.exe query "HKU\S-1-5-19\Environment"
If Not %ERRORLEVEL% EQU 0 (
 msg * Please open this file as administrator, otherwise it will not work
 exit
)

cls
goto:eof

:result

cd %userprofile%\Downloads

if exist Wifi_Passwords.txt (
	goto writefile
) else (
	goto createfile
)

:createfile

@echo>"C:\%userprofile%\Downloads\Wifi_Passwords.txt"
echo Password %name% = %pw%> Wifi_Passwords.txt
goto end

:writefile

echo Password %name% = %pw%>> Wifi_Passwords.txt

:end

cls
:end2
echo Password saved in "Wifi_Passwords.txt" in your downloads folder.
echo What do you want to do now?
echo 	1. Choose a new Wifi
echo 	2. Open "Wifi_Passwords.txt"
echo		3. Exit
set /p choice=Choose 1, 2 or 3: 
if %choice% EQU 1 (
	cls
	goto question
)
if %choice% EQU 2 (
	start "" "Wifi_Passwords.txt"
	exit
)
if %choice% EQU 3 (
	exit
)

cls
echo Did not detect 1, 2 or 3
goto end2