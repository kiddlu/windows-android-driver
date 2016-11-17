:::::::::::::::::::::::::::::::::: get Admin ::::::::::::::::::::::::::::::::::::::::::::::::::
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
set DIR_PATH=%~dp0
set ERASEDRV_EXE=%DIR_PATH%\apps\erasedrv.exe


%ERASEDRV_EXE% /g %~dp0\driver\google\android_winusb.inf
%ERASEDRV_EXE% /r %~dp0\driver\google\android_winusb.inf

%ERASEDRV_EXE% /g %~dp0\driver\qcom\qcser.inf
%ERASEDRV_EXE% /r %~dp0\driver\qcom\qcser.inf

%ERASEDRV_EXE% /g %~dp0\driver\qcom\qcmdm.inf
%ERASEDRV_EXE% /r %~dp0\driver\qcom\qcmdm.inf

%ERASEDRV_EXE% /g %~dp0\driver\qcom\qcwwan.inf
%ERASEDRV_EXE% /r %~dp0\driver\qcom\qcwwan.inf
echo.

pause