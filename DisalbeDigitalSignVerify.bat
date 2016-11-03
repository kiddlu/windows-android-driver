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
bcdedit.exe /set loadoptions DISABLE_INTEGRITY_CHECKS
bcdedit.exe /set testsigning on
echo "Press Enter to Reboot"
pause
%~dp0\apps\nircmd.exe  exitwin reboot