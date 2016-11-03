@echo on
set DIR_PATH=%~dp0

set INF2CAT_EXE=%DIR_PATH%\apps\Inf2Cat.exe
set MAKECERT_EXE=%DIR_PATH%\apps\MakeCert.exe
set SIGNTOOL_EXE=%DIR_PATH%\apps\SignTool.exe
set PREINST_EXE=%DIR_PATH%\apps\preinst.exe
set CERTUTIL_EXE=certutil.exe
set CER_FILE=%DIR_PATH%\Oh-My-CA.cer

%MAKECERT_EXE% -r -pe -n "cn=Oh-My-CA" -a sha1 -b 09/29/1962 -e 09/29/2062 -cy authority -ss PrivateCertStore %CER_FILE%

%CERTUTIL_EXE% -addstore root %CER_FILE%
%CERTUTIL_EXE% -addstore TrustedPublisher %CER_FILE%

%SIGNTOOL_EXE% sign /a /v /s PrivateCertStore /n Oh-My-CA /t http://timestamp.verisign.com/scripts/timstamp.dll %~dp0\driver\androidwinusb86.cat
%SIGNTOOL_EXE% sign /a /v /s PrivateCertStore /n Oh-My-CA /t http://timestamp.verisign.com/scripts/timstamp.dll %~dp0\driver\androidwinusba64.cat

%PREINST_EXE% %~dp0\driver\android_winusb.inf