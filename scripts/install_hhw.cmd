@echo off
setlocal

set URL=https://download.microsoft.com/download/0/A/9/0A939EF6-E31C-430F-A3DF-DFAE7960D564/htmlhelp.exe
set CHECKSUM=b2b3140d42a818870c1ab13c1c7b8d4536f22bd994fa90aade89729a6009a3ae

net session >nul 2>&1 || goto :error-elevation
%ComSpec% /c "pushd "%TEMP%" && curl -fLOJ "%URL%"" || goto :error-download
for /f %%a in ('certutil -hashfile "%TEMP%\htmlhelp.exe" SHA256 ^| find /v " "') do set SHA256=%%a
if not "%SHA256%"=="%CHECKSUM%" goto :error-checksum

"%TEMP%\htmlhelp.exe" /Q /T:"%TEMP%\htmlhelp" /C
> "%TEMP%\htmlhelp\htmlhelp_noupdate.inf" findstr /v /b """hhupd.exe "%TEMP%\htmlhelp\htmlhelp.inf"
%SYSTEMROOT%\SysWOW64\rundll32.exe advpack.dll,LaunchINFSection "%TEMP%\htmlhelp\htmlhelp_noupdate.inf",,3,N
goto :end

:error-elevation
echo Elevated privileges are required for installation 1>&2
goto :end

:error-download
echo Download failed 1>&2
goto :end

:error-checksum
echo Checksum mismatch 1>&2
goto :end

:end
endlocal
