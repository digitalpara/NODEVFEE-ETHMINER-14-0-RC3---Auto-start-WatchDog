rem ========== PreStart ==========

rem Don't echo to standard output
@echo off
rem Set Localisation of Environment Variables
setlocal
rem Set version info
set V=1.8.0
rem Switch to the batch file's directory
cd /d %~dp0
rem Set title
title ETHminer WatchDog Version %V% by: SIMSEK - KAYNAS.TK

rem ========== Start ==========

cls
echo ###############################################################################
echo #                                                                             #
echo #  ETHminerWatchDogDmW Version %V%                                          #
echo #                                                                             #
echo #  AUTHOR: SIMSEK - KAYNAS.TK  (SIMSEK - KAYNAS.TK)                           #
echo #                                                                             #
echo ###############################################################################
echo.
echo ETHminerWatchDogDmW
echo 1. Run ethminer.
echo 2. Restart ethminer up to 4 times.
echo 3. Reboot the system.
echo.

rem Skip RunEthMinerCommand section at start
goto Initializing

rem ========== Run EthMiner Command ==========

:RunEthMinerCommand

rem ==================== Your Code Start Here ====================

setx GPU_FORCE_64BIT_PTR 0
setx GPU_MAX_HEAP_SIZE 100
setx GPU_USE_SYNC_OBJECTS 1
setx GPU_MAX_ALLOC_PERCENT 100
setx GPU_SINGLE_ALLOC_PERCENT 100
ethminer.exe -RH -U -P stratum+ssl://0x7F5BB53c415334235a9E42eA03695F11b6553C0D.rig4@eu1.ethermine.org:5555 -P stratum+ssl://0x7F5BB53c415334235a9E42eA03695F11b6553C0D.rig4@us1.ethermine.org:5555 --work-timeout 180

rem ==================== Your Code End Here ====================

exit /b

rem ========== Initializing ==========

:Initializing
rem Auto Fix #385 issue of Ethminer
chcp 437
rem set loop to zero
set /A loopnum=0

rem ========== Run Program ==========

:runProgram
echo run

rem ========== Calc ==========

rem loop inc by one
set /A loopnum=loopnum+1

rem Calc Date & Time
:DateTime
rem Check WMIC is available
WMIC.EXE Alias /? >nul 2>&1 || goto wmicError
rem Use WMIC to retrieve date and time
for /F "skip=1 tokens=1-6" %%G in ('WMIC Path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') do (
   IF "%%~L"=="" goto wmicDone
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
set pISOdate= %pdate% %ptime%

:DateTimeOK

rem ========== Output ==========

rem ========== Screen Output ==========

echo.
echo ###############################################################################
echo %pISOdate%
echo ETHminerWatchDogDmW has run %loopnum% times.
echo ###############################################################################
echo.

rem ========== File Output ==========

echo %pISOdate% >> RunTimes.log
echo ETHminerWatchDogDmW has run %loopnum% times. >> RunTimes.log
echo. >> RunTimes.log

rem ========== Execution Code ==========

call :RunEthMinerCommand

rem Wait 5s
timeout 5 > NUL

rem Check 4 loops
if %loopnum% gtr 9 goto ErrorHandling

rem loop
goto runProgram

rem ========== Error Handling ==========

:ErrorHandling

rem ========== Error Screen Output ==========

echo.
echo ###############################################################################
echo %pISOdate%
echo ETHminerWatchDogDmW has run %loopnum% times.
echo System Restart Required.
echo.
echo.
echo.
echo Reboot Now (%pISOdate%).
echo ###############################################################################
echo.

rem ========== Error File Output ==========

echo %pISOdate% >> RunTimes.log
echo ETHminerWatchDogDmW has run %loopnum% times. >> RunTimes.log
echo System Restart Required. >> RunTimes.log
echo. >> RunTimes.log
echo. >> RunTimes.log
echo. >> RunTimes.log
echo Reboot Now (%pISOdate%). >> RunTimes.log
echo. >> RunTimes.log

rem ========== System Reboot ==========

shutdown -r -f -t 0

rem ========== END ==========

endlocal

rem ========== EOF ==========
