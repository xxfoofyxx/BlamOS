@echo off

::CONFIG

set secure=true
set keylength=2048
set method=SHA256


log [kernel] [INFO] The BlamOS Kernel is starting up...
if NOT %secure%==true goto skipsecure
log [kernel] [INFO] Secure Mode is on.
log [kernel] [INFO] Beginning key generation. Using keylength of %keylength%, and method %method%
cd System
fastlng %length% >secure.tmp
certutil -hashfile secure.tmp %method% | findstr /V ":" >secure.tmp
timeout /t 1 >nul
set /p secure=<secure.tmp
del secure.tmp
cd ..
log [kernel] [INFO] Key generation completed. Only authorized applications will be allowed to retrieve it.
:skipsecure
log [kernel] [INFO] Starting BlamOS and awaiting bootup signal.
start /b BlamOS.bat
System\iwait ping
log [kernel] Successfully connected to BlamOS.

log [kernel] [INFO] Startup complete. Awaiting signal from BlamOS.

log [kernel] [ERROR] Unexpected escape from main loop, killing BlamOS
echo exit>kernel
exi

:icl
for /f "tokens=1,* delims=:" %%i in (%data%) do (
  if /i "%text%"=="%%i" ( 
  echo %%j>output.icl
  )
)
goto :eof