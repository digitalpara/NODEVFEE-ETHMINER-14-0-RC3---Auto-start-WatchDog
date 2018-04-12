rem Skip RunEthMinerCommand section at start
goto PreStart

rem ========== Run EthMiner Command ==========

:RunEthMinerCommand

rem ==================== Your Code Starts Here ====================
rem ==================== Your Code Starts Here ====================
rem ==================== Your Code Starts Here ====================

setx GPU_FORCE_64BIT_PTR 0
setx GPU_MAX_HEAP_SIZE 100
setx GPU_USE_SYNC_OBJECTS 1
setx GPU_MAX_ALLOC_PERCENT 100
setx GPU_SINGLE_ALLOC_PERCENT 100

rem set NO_COLOR=Yes
 

ethminer.exe -RH -X --exit -U -P stratum+ssl://0x7F5BB53c415334235a9E42eA03695F11b6553C0D.rig4@eu1.ethermine.org:5555 -P stratum+ssl://0x7F5BB53c415334235a9E42eA03695F11b6553C0D.rig4@us1.ethermine.org:5555

rem ==================== Your Code Ends Here ====================
rem ==================== Your Code Ends Here ====================
rem ==================== Your Code Ends Here ====================

exit /b

rem ========== PreStart ==========

:PreStart

rem Don't echo to standard output
@echo off
rem Make script variables local
setlocal
rem Set version info
set V=1.9.4
rem Switch to the batch file's directory
cd /d %~dp0
rem Set codepage
chcp 437 >nul
rem Set title
title ETHminer WatchDog Version %V% by SiMSEK

rem ========== Start ==========

cls
echo ###############################################################################
echo.
echo   ETHminerWatchDog Version %V%
echo.
echo   AUTHOR: SiMSeK  (DiGiTaLPaRa - TO-GitHub)
echo.
echo ###############################################################################
echo.
echo ETHminerWatchDogDmW
echo 1. Run ethminer.
echo 2. Restart ethminer up to 5 times.
echo 3. Reboot the system.
echo.
echo Additional:
echo - AutoFix #385 issue of Ethminer
echo - AutoFix #189 issue of Ethminer
echo - Log file RunTimes.log
echo - Auto Turn off the Error Dialog
echo.

rem ========== Initializing ==========

:Initializing
rem set loop to zero
set /A loopnum=0
set FileOut=RunTimes.log
echo ETHminerWatchDogDmW Version %V% >> %FileOut%
reg add "HKCU\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "DontShowUI" /t REG_DWORD /d 1 /f > nul 2>&1

rem ========== Run Program ==========

:runProgram

rem ========== Calc ==========

rem Increment loop by one
set /A loopnum=loopnum+1

rem Calculate Date & Time
:DateTime
rem Check if WMIC is available
WMIC.EXE Alias /? >nul 2>&1 || goto wmicError
rem Use WMIC to retrieve date and time
for /F "skip=1 tokens=1-6" %%G in ('WMIC Path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') do (
   if "%%~L"=="" goto wmicDone
      set _yyyy=%%L
      set _mm=00%%J
      set _dd=00%%G
      set _hour=00%%H
      set _minute=00%%I
)
:wmicDone

rem Pad digits with leading zeros
      set _mm=%_mm:~-2%
      set _dd=%_dd:~-2%
      set _hour=%_hour:~-2%
      set _minute=%_minute:~-2%

rem Date/time in ISO 8601 format:
set pISOdate=%_yyyy%-%_mm%-%_dd% %_hour%:%_minute%

goto DateTimeOK

:wmicError
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set pdate=%%c-%%a-%%b)
for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set ptime=%%a:%%b)
set pISOdate=%pdate% %ptime%

:DateTimeOK

rem ========== Output ==========

rem ========== Screen Output ==========

echo.
echo ===============================================================================
echo %pISOdate%
echo ETHminerWatchDogSMSK has run %loopnum% times.
echo ===============================================================================
echo.

rem ========== File Output ==========

echo %pISOdate% ETHminerWatchDogSMSK has run %loopnum% times.>>%FileOut%

rem ========== Execution Code ==========

call :RunEthMinerCommand

rem Wait 5s
timeout /T 5 /NOBREAK>NUL

rem Check 5 loops
if %loopnum% gtr 4 goto ErrorHandling

rem Loop
goto runProgram

rem ========== Error Handling ==========

:ErrorHandling

rem ========== Error Screen Output ==========

echo.
echo ===============================================================================
echo %pISOdate%
echo ETHminerWatchDogSMSK has run %loopnum% times.
echo System restart required.
echo.
echo.
echo.
echo Rebooting now (%pISOdate%).
echo ###############################################################################
echo.

rem ========== Error File Output ==========

echo %pISOdate% ETHminerWatchDogSMSK has run %loopnum% times.>>%FileOut%
echo System restart required. Rebooting now (%pISOdate%).>>%FileOut%
echo. >>%FileOut%
echo. >>%FileOut%

rem ========== System Reboot ==========

shutdown -r -f -t 0

rem ========== End ==========

endlocal

rem ========== EoF ==========