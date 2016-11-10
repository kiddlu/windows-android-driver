::more info https://msdn.microsoft.com/en-us/windows/hardware/drivers/install/test-signing

::inspired by https://github.com/koush/UniversalAdbDriver

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

set SEED=%RANDOM%

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

set CERT_FILE=%DIR_PATH%\Oh-My-Cert.%SEED%.cer

%MAKECERT_EXE% -r -pe -ss PrivateCertStore -n "CN=Oh-My-Cert.%SEED%" -b 09/29/1962 -e 09/29/2062 %CERT_FILE%

%CERTUTIL_EXE% -addstore root %CERT_FILE%
%CERTUTIL_EXE% -addstore TrustedPublisher %CERT_FILE%

%CERTMGR_EXE% /add %CERT_FILE% /s /r localMachine root
%CERTMGR_EXE% /add %CERT_FILE% /s /r localMachine trustedpublisher

%INF2CAT_EXE%  /v  /driver:%~dp0\driver\google\ /os:7_x64,7_x86
%INF2CAT_EXE%  /v  /driver:%~dp0\driver\qcom\ /os:7_x64,7_x86

%SIGNTOOL_EXE% sign /v /s PrivateCertStore /n Oh-My-Cert.%SEED% /t http://timestamp.verisign.com/scripts/timstamp.dll %~dp0\driver\google\androidwinusb86.cat
%SIGNTOOL_EXE% sign /v /s PrivateCertStore /n Oh-My-Cert.%SEED% /t http://timestamp.verisign.com/scripts/timstamp.dll %~dp0\driver\google\androidwinusba64.cat

%SIGNTOOL_EXE% sign /v /s PrivateCertStore /n Oh-My-Cert.%SEED% /t http://timestamp.verisign.com/scripts/timstamp.dll %~dp0\driver\qcom\qcser.cat
%SIGNTOOL_EXE% sign /v /s PrivateCertStore /n Oh-My-Cert.%SEED% /t http://timestamp.verisign.com/scripts/timstamp.dll %~dp0\driver\qcom\qcmdm.cat
%SIGNTOOL_EXE% sign /v /s PrivateCertStore /n Oh-My-Cert.%SEED% /t http://timestamp.verisign.com/scripts/timstamp.dll %~dp0\driver\qcom\qcwwan.cat

%PREINST_EXE% %~dp0\driver\google\android_winusb.inf
%PREINST_EXE% %~dp0\driver\qcom\qcser.inf
%PREINST_EXE% %~dp0\driver\qcom\qcmdm.inf
%PREINST_EXE% %~dp0\driver\qcom\qcwwan.inf

pause