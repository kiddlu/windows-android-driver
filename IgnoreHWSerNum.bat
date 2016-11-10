::Windows Registry Editor Version 5.00

::[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\UsbFlags]
::"IgnoreHWSerNum05C69025"=hex:01
::"GlobalDisableSerNumGen"=hex:01
::"GenericUSBDeviceString"="USB Device"
::"GenericCompositeUSBDeviceString"="Composite USB Device"

:: get Admin
::-------------------------------------
:: Check for permissions
@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: If error flag set, we do not have admin.
if '%ERRORLEVEL%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( 
	goto gotAdmin
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%TMP%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%TMP%\getadmin.vbs"

    "%TMP%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%TMP%\getadmin.vbs" ( del "%TMP%\getadmin.vbs" )
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
echo "add IgnoreHWSerNum list"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v IgnoreHWSerNum05C69025 /t REG_BINARY /d 01 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v IgnoreHWSerNum05C69091 /t REG_BINARY /d 01 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v IgnoreHWSerNum29A9701B /t REG_BINARY /d 01 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v GlobalDisableSerNumGen /t REG_BINARY /d 01 /f
pause

::@echo off
::echo "delete IgnoreHWSerNum registry"
::reg delete "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v IgnoreHWSerNum05C69025 /f
::pause