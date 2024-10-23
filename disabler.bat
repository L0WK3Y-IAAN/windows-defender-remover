@echo off
:: Elevate privileges if not already running as admin
:: Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires administrative privileges.
    pause
    exit /b
)

echo.
echo ---- Disabling Windows Defender ----
echo.

:: Disable Windows Defender Antivirus Service
sc stop WinDefend
sc config WinDefend start= disabled
echo Windows Defender service stopped and disabled.

:: Disable SecurityHealthService
sc stop SecurityHealthService
sc config SecurityHealthService start= disabled
echo SecurityHealthService stopped and disabled.

:: Disable Windows Defender scheduled tasks
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Disable
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Disable
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Disable
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /Disable
echo Windows Defender tasks disabled.

:: Disable Windows Defender real-time protection using Registry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
echo Disabled real-time protection in registry.

:: Disable Tamper Protection (only on newer Windows versions, not always effective)
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v TamperProtection /t REG_DWORD /d 0 /f
echo Disabled Tamper Protection.

echo.
echo ---- Windows Defender should now be disabled. ----
echo A reboot may be required for all changes to take effect.
echo.
pause
exit
