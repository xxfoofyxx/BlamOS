@echo off
setlocal enabledelayedexpansion
for /L %%A in (1,1,%1) do (
    set /a output=(!random! %% 6^)+1
    set /p "=!output!" <nul    
)