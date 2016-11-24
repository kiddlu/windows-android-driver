@echo off

:: Enable USBstor driver from registry 
reg add HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR /v Start /t REG_DWORD /d 3 /f

:: Enable USBstor READ / Write mode
reg add HKLM\SYSTEM\CurrentControlSet\Control\StorageDevicePolicies /v WriteProtect /t REG_DWORD /d 0 /f

REM :: Remove permissions of actual USBSTORAGE Files

:: Provide Access for Users from  files
cacls %SystemRoot%\inf\usbstor.inf /E /G users:F
cacls %SystemRoot%\inf\usbstor.PNF /E /G users:F
cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /G users:F
rem cacls %SystemRoot%\inf\usbstor.inf /E /D users
rem cacls %SystemRoot%\inf\usbstor.PNF /E /D users

:: Provide Access for System
cacls %SystemRoot%\inf\usbstor.inf /E /G system:F
cacls %SystemRoot%\inf\usbstor.PNF /E /G system:F
cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /G system:F
rem cacls %SystemRoot%\inf\usbstor.inf /E /D system
rem cacls %SystemRoot%\inf\usbstor.PNF /E /D system

:: Provide Access for ower Users
cacls %SystemRoot%\inf\usbstor.inf /E /G "Power Users":F
cacls %SystemRoot%\inf\usbstor.PNF /E /G "Power Users":F
cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /G "Power Users":F
rem cacls %SystemRoot%\inf\usbstor.inf /E /D "Power Users"
rem cacls %SystemRoot%\inf\usbstor.PNF /E /D "Power Users"

:: Provide Access for Administrators
cacls %SystemRoot%\inf\usbstor.inf /E /G Administrators:F
cacls %SystemRoot%\inf\usbstor.PNF /E /G Administrators:F
cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /G Administrators:F
rem cacls %SystemRoot%\inf\usbstor.inf /E /D Administrators
rem cacls %SystemRoot%\inf\usbstor.PNF /E /D Administrators



:: Provide Access for EveryOne
cacls %SystemRoot%\inf\usbstor.inf /E /G Everyone:F
cacls %SystemRoot%\inf\usbstor.PNF /E /G Everyone:F
cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /F Everyone:F
rem cacls %SystemRoot%\inf\usbstor.inf /E /D Everyone
rem cacls %SystemRoot%\inf\usbstor.PNF /E /D Everyone
rem cacls %SystemRoot%\system32\drivers\USBSTOR.SYS /E /D Everyone


REM ::USB_REG_PERMISSION_changes

:: If parameter recover then undo all this
IF [%1]==[enable] GOTO Enable
:: Create a temporary .REG file - DISABLE USB
> "%Temp%.\u1.ini" ECHO HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR [1 5 8 11 17]
regini "%Temp%.\u1.ini"
DEL "%Temp%.\u1.ini"

:Exit
pause