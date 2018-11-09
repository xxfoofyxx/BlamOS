@echo off
echo %*>in
:iwait
if not exist out goto iwait
set /p output=out
del out