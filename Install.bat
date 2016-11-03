::more info https://msdn.microsoft.com/en-us/windows/hardware/drivers/install/test-signing

::inspired by https://github.com/kiddlu/UniversalAdbDriver


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

:::::::::::::::::::::::::::::::::: get Pid ::::::::::::::::::::::::::::::::::::::::::::::::::
rem Note: Session Name for privileged Administrative consoles is sometimes blank.
if not defined SESSIONNAME set SESSIONNAME=Console

setlocal

rem Instance Set
set instance=%DATE% %TIME% %RANDOM%
echo Instance: "%instance%"
title %instance%

rem PID Find
for /f "usebackq tokens=2" %%a in (`tasklist /FO list /FI "SESSIONNAME eq %SESSIONNAME%" /FI "USERNAME eq %USERNAME%" /FI "WINDOWTITLE eq %instance%" ^| find /i "PID:"`) do set PID=%%a
if not defined PID for /f "usebackq tokens=2" %%a in (`tasklist /FO list /FI "SESSIONNAME eq %SESSIONNAME%" /FI "USERNAME eq %USERNAME%" /FI "WINDOWTITLE eq Administrator:  %instance%" ^| find /i "PID:"`) do set PID=%%a
if not defined PID echo !Error: Could not determine the Process ID of the current script.  Exiting.& exit /b 1

rem Current Task Show
echo PID: "%PID%"
tasklist /v /FO list /FI "PID eq %PID%"

rem Title Reset to Image Name (Image Name can contain spaces and will not be tokenized through usage of * token and %%b variable to access the remaining line without tokenization.)
for /f "usebackq tokens=2*" %%a in (`tasklist /V /FO list /FI "PID eq %PID%" ^| find /i "Image Name:"`) do title %%b
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set DIR_PATH=%~dp0

::from wdk
set INF2CAT_EXE=%DIR_PATH%\apps\Inf2Cat.exe
set MAKECERT_EXE=%DIR_PATH%\apps\MakeCert.exe
set SIGNTOOL_EXE=%DIR_PATH%\apps\SignTool.exe
set CERTMGR_EXE=%DIR_PATH%\apps\CertMgr.exe

::from https://github.com/oboroc/misc/blob/f073a415b3cf22d5f6df1f4633436870076dd03e/preinst/preinst.c
set PREINST_EXE=%DIR_PATH%\apps\preinst.exe

::windows build-in
set CERTUTIL_EXE=certutil.exe

set CERT_FILE=%DIR_PATH%\Oh-My-Cert.%PID%.cer

del /f %~dp0\driver\google\androidwinusb86.cat
del /f %~dp0\driver\google\androidwinusba64.cat

%MAKECERT_EXE% -r -pe -ss PrivateCertStore -n "CN=Oh-My-Cert.%PID%" -b 09/29/1962 -e 09/29/2062 %CERT_FILE%

%CERTUTIL_EXE% -addstore root %CERT_FILE%
%CERTUTIL_EXE% -addstore TrustedPublisher %CERT_FILE%

%CERTMGR_EXE% /add %CERT_FILE% /s /r localMachine root
%CERTMGR_EXE% /add %CERT_FILE% /s /r localMachine trustedpublisher

%INF2CAT_EXE%  /v  /driver:%~dp0\driver\google\ /os:7_x64,7_x86

%SIGNTOOL_EXE% sign /v /s PrivateCertStore /n Oh-My-Cert.%PID% /t http://timestamp.verisign.com/scripts/timstamp.dll %~dp0\driver\google\androidwinusb86.cat
%SIGNTOOL_EXE% sign /v /s PrivateCertStore /n Oh-My-Cert.%PID% /t http://timestamp.verisign.com/scripts/timstamp.dll %~dp0\driver\google\androidwinusba64.cat
%PREINST_EXE% %~dp0\driver\google\android_winusb.inf

pause