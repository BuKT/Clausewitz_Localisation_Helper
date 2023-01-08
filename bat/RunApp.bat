@echo off

:: Set working dir
cd %~dp0 & cd ..

set PAUSE_ERRORS=1

mkdir bin\externals
copy lib\externals\ bin\externals\
call bat\SetupSDK.bat
call bat\SetupApp.bat

echo.
echo Starting AIR Debug Launcher...
echo.

adl "%APP_XML%" "%APP_DIR%" -profile extendedDesktop
if errorlevel 1 goto error
goto end

:error
pause

:end
