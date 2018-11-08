@echo off

:: A NOTE TO DEVELOPERS:

:: First of all, thank you for choosing to contribute to BlamOS.
:: Second, the memory map has changed since 1.0.
:: We now use the format address:value.
:: If you have created plugins / mods that interface with the memory directly in 1.0, they will need to be updated.

:: P.S.: 2.1 is coming out soon and will have a "kernel" that interfaces the main OS with plugins / outside programs. :^)


:: P.P.S.: Follow the development of BlamOS and help contribute over at https://github.com/xxfoofyxx/BlamOS


setlocal enabledelayedexpansion

echo Performing write-protection test...
echo %random% >>wtest.blam
if %ERRORLEVEL%==1 goto wptfail
goto wptsuccess
:wptfail
cls
echo ERROR - Either the disk is full, or it is write-protected.
echo.
echo Press any key to quit...
pause >nul
exit
:wptsuccess
del wtest.blam
echo Done

echo Resetting Vars
set DRIVELETTERS=
set DRIVELETTERSUSED=
set bsodcode=
set ld=
set sf=
set ed=
set ooe=
set toe=

echo Done

echo Clearing VRAM
del memory.sysblam
echo. >>memory.sysblam
echo Done


echo Mapping drives...
set "DRIVELETTERSFREE=Z Y X W V U T S R Q P O N M L K J I H G F E D C B A "
for /f "skip=1 tokens=1,2 delims=: " %%a in ('wmic logicaldisk get deviceid^,volumename') do (
   set "DRIVELETTERSUSED=!DRIVELETTERSUSED!%%a,%%b@" 
   set "DRIVELETTERSFREE=!DRIVELETTERSFREE:%%a =!"
)
echo ^[DRIVES^] >>memory.sysblam
set DRIVELETTERSUSED=%DRIVELETTERSUSED:~0,-2% >>memory.sysblam
set DRIVELETTERSUSED=%DRIVELETTERSUSED:,@=, @% >>memory.sysblam
set DRIVELETTERS >>memory.sysblam
echo Done!


echo Logging succesful bootup...

:: This log function was preventing BlamOS from booting up, so we are currently not logging startups.

goto bootuplogged

set ed=The system started up successfully on %date% at %time%
set ld=bootuplogged
set ooe=BLAMOS
set toe=info
goto logevent
:bootuplogged
echo Done!
timeout /t 3 >nul


set ld=startupsoundplayed
set sf=startup.mp3
goto sound
:startupsoundplayed
if "%1"=="-i" goto :EOF



cls
echo ~~~~~~~~~~
echo BlamOS 2.0
echo ~~~~~~~~~~
:loop
set /p input=^[BlamOS^] ^- %CD%^>
%input%
if %ERRORLEVEL%==1 goto logerror
goto loop






:logerror
set ld=loop
set ed=commandError
set ooe=KERNEL_HANDLER
set toe=error
goto logevent










:crash
cls
if [%bsodcode%] == [] goto bcodeud
set report=%random%
color 4f
                                                                      
echo                      `h+                                             
echo                -M    /M:                                             
echo                  M:  hN    hh                                        
echo                  /`       My                                         
echo            /MN                                                       
echo                `             .:s                                     
echo                      :      y+/`                                     
echo            `/ys     .+                                               
echo                      -yN-m/`N.  oMMNyo::::sdMMM:                     
echo                 -      `MMMM`NMMm     +yhmhys..MM+                   
echo               hMh     -MMMMMMMm   +MMMMMMMMMMMMMdMMm                 
echo              y     M+   mMMM   hMMMMMMMMMMMMMMMMMMMMMd               
echo                    M-    oN. `mMMMMMMMMMMMMMMMMMMMMMMM:              
echo                    N    yM  sMMMMMMMMMMMMMMMMMMMMMMMMMMo             
echo                         M/ oMMMMMMMMMMMMMMMMMMMMMMMMMMMM             
echo                        sh +MMMMMMMMMMMMMMMMMMMMMMMMMMMMM+            
echo                        M: MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo                       :M  MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:           
echo                       :M  MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:           
echo                       .M `MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM            
echo                        N/ MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd            
echo                        .M-MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM             
echo                         MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM             
echo                         oMsMMMMMMMMMMMMMMMMMMMMMMMMMMMM-             
echo                           MMMMMMMMMMMMMMMMMMMMMMMMMMMM               
echo                           `NMMMMMMMMMMMMMMMMMMMMMMMMs                
echo                             mMMMMMMMMMMMMMMMMMMMMMMo                 
echo                                hMMMMMMMMMMMMMMMN+                    
echo                                 .oMMMMMMMMMN:                       
echo.
echo The system has encountered a critical error, and must now restart. Details of the error can be found below, or in the crash report.
echo.
echo %bsodcode%
echo.
echo.
echo Logging event...

set ed="SYSTEM_CRASH"
set ld=crashlogged
set ooe=BLAMOS
set toe=critical
goto logevent
:crashlogged

echo Creating report...
echo == BlamOS Crash Report ==>>crashReport_%report%.crashdump
echo.>>crashReport_%report%.crashdump
echo Error Code: %bsodcode%>>crashReport_%report%.crashdump
echo.>>crashReport_%report%.crashdump
echo.>>crashReport_%report%.crashdump
echo Time and date of crash: %time%, %date%>>crashReport_%report%.crashdump
echo.>>crashReport_%report%.crashdump
echo A full copy of the system's memory:>>crashReport_%report%.crashdump
echo.>>crashReport_%report%.crashdump
type memory.sysblam>>crashReport_%report%.crashdump
echo Name of crash report^: crashReport_%report%.crashdump
echo Press any key to reboot.
pause >nul
cls
color 0f
%0





:defrag
cls
echo Choose an option:
echo 1) Clean up crashdumps 2) Undefined 3) Undefined
set /p dfop=^>
if %dfop%==1 goto crashdumpdefrag
set bsodcode=UNDEFINED_INPUT_EXCEPTION
goto crash

:crashdumpdefrag
cls
set /p cddfc=Are you sure^? ^[Y^/N^]
if %cddfc%==N goto loop
if %cddfc%==n goto loop
del *.crashdump
echo Done!
goto loop



:bcodeud
set bsodcode=UNKNOWN_CRASH_EXEPTION
goto crash



:logevent
call log [%ooe%] [%toe%] %ed%
goto %ld%



:applauncher

::log the startup of an app for diagnostic purposes.
::it needs to be up here so it writes to the main 
::log instead of making a new one in the apps folder.
set ld=appstartlogged
set toe=info
set ooe=applauncher
set ed=Application Started
goto logevent
:appstartlogged

cd Apps
dir /b /s *.blamapp
echo Enter the name of the app you want to launch.
set /p atl=^>
echo Compiling Code... This may take a while
del CurrRuntimeEnviro /y
mkdir CurrRuntimeEnviro
copy %atl%.blamapp CurrRuntimeEnviro\APPLICATION.BAT >nul
cd CurrRuntimeEnviro
echo Starting App...
cls 
APPLICATION


:netcheck
findstr NET1 memory.sysblam >>RESERVED1.TEMP
findstr NET0 memory.sysblam >>RESERVED1.TEMP
set /p netcheckresult=<RESERVED1.TEMP
del RESERVED1.TEMP
if [%netcheckresult%]==[] goto loop
if %netcheckresult%==NET1 goto outgoing
if %netcheckresult%==NET0 goto incoming

:outgoing
findstr /v "NET1" memory.sysblam >RESERVED2.TEMP
copy /y RESERVED2.TEMP memory.sysblam
del RESERVED2.TEMP
set /p netinput=NET - %CD%^> 
echo %netinput% >>outgoing.txt
goto netcheck

:incoming
findstr /v "NET0" memory.sysblam >RESERVED2.TEMP
copy /y RESERVED2.TEMP memory.sysblam
del RESERVED2.TEMP
if not exist incoming.txt goto netcheck
set /p netcommand=<incoming.txt >nul
%netcommand%
goto netcheck


:426c616d

echo noice, you found an easter egg.
echo gg m8!
echo.
echo ^:^)
goto loop

:sound
echo Feature not yet implemented.
goto %ld%
cd System
cd TEMP
echo %sf% >RESERVED3.TEMP
cd..
cmd /c SOUND.BAT
cd..
goto %ld%


:ooo
set bsodcode=i_hate_coding
goto crash


::If there is no more code to run, then crash.
:nocode
set bsodcode=END_OF_CODE
goto crash
