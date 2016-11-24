@echo off

:: Disable USBstor driver
reg add HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR /v Start /t REG_DWORD /d 4 /f

:: USB Read Only Mode
reg add HKLM\SYSTEM\CurrentControlSet\Control\StorageDevicePolicies /v WriteProtect /t REG_DWORD /d 1 /f

:: USB Disable startup

reg add HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR /v Boot /t REG_DWORD /d 0 /f

rem reg add HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR /v System /t REG_DWORD /d 1 /f

reg add HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR /v Auto Load /t REG_DWORD /d 0 /f

:: Disable read permissions on USBstor driver

:: Remove Access for Users from  files

cacls %SystemRoot%\inf\usbstor.inf /E /R users
cacls %SystemRoot%\inf\usbstor.PNF /E /R users
cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /R users
cacls %SystemRoot%\inf\usbstor.inf /E /D users
cacls %SystemRoot%\inf\usbstor.PNF /E /D users
cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /D users

:: Remove Access for System
cacls %SystemRoot%\inf\usbstor.inf /E /R system
cacls %SystemRoot%\inf\usbstor.PNF /E /R system
cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /R system
cacls %SystemRoot%\inf\usbstor.inf /E /D system
cacls %SystemRoot%\inf\usbstor.PNF /E /D system
cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /D system

:: Remove Access for ower Users
cacls %SystemRoot%\inf\usbstor.inf /E /R "Power Users"
cacls %SystemRoot%\inf\usbstor.PNF /E /R "Power Users"
cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /R "Power Users"
cacls %SystemRoot%\inf\usbstor.inf /E /D "Power Users"
cacls %SystemRoot%\inf\usbstor.PNF /E /D "Power Users"
cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /D "Power Users"

:: Remove Access for Administrators
cacls %SystemRoot%\inf\usbstor.inf /E /R Administrators
cacls %SystemRoot%\inf\usbstor.PNF /E /R Administrators
cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /R Administrators
cacls %SystemRoot%\inf\usbstor.inf /E /D Administrators
cacls %SystemRoot%\inf\usbstor.PNF /E /D Administrators
cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /D Administrators

:: Remove Access for EveryOne
cacls %SystemRoot%\inf\usbstor.inf /E /R Everyone
cacls %SystemRoot%\inf\usbstor.PNF /E /R Everyone
cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /R Everyone
cacls %SystemRoot%\inf\usbstor.inf /E /D Everyone
cacls %SystemRoot%\inf\usbstor.PNF /E /D Everyone
cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /D Everyone


REM ::USB_REG_PERMISSION_changes

:: If parameter recover then undo all this
IF [%1]==[enable] GOTO Enable
:: Create a temporary .REG file - DISABLE USB
> "%Temp%.\u1.ini" ECHO HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR [0 0 0 0]
regini "%Temp%.\u1.ini"
DEL "%Temp%.\u1.ini"

:Exit
pause
:: Leave state