@set defenderremoverver=12.8
@setlocal DisableDelayedExpansion
@echo off
pushd "%CD%"
CD /D "%~dp0"

:: Skip the choice section and go straight to disabling all security mitigations
goto disablemitigations

:--------------------------------------

:disablemitigations
CLS
bcdedit /set hypervisorlaunchtype off

CLS
echo Disabling Security Mitigations...
:: Registry Remove of Windows Defender
FOR /R %%f IN (Remove_SecurityComp\*.reg) DO PowerRun.exe regedit.exe /s "%%f"
CLS
echo Your PC will reboot in 10 seconds..
timeout 10
shutdown /r /f /t 0
exit
:--------------------------------------
