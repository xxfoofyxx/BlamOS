@echo off
:wait
if not exist secure.tmp goto wait
set /p key=<secure.tmp
echo KEY FOUND: %key%
pause