@echo off
cd /d "%~dp0.."
if errorlevel 1 exit /b 1
if not exist composer.json exit /b 1
if not exist ralph\runs\tmp mkdir ralph\runs\tmp
if errorlevel 1 exit /b 1
set "TEMP=%CD%\ralph\runs\tmp"
set "TMP=%TEMP%"
call php --version
if errorlevel 1 exit /b 1
call composer --version
if errorlevel 1 exit /b 1
node --version
if errorlevel 1 exit /b 1
call npm --version
if errorlevel 1 exit /b 1
git status --porcelain >nul
if errorlevel 1 exit /b 1
call php -r "$source = tempnam(sys_get_temp_dir(), 'ralph'); $target = $source . '.renamed'; if (!rename($source, $target)) { exit(1); } unlink($target);"
if errorlevel 1 exit /b 1
echo Sandbox development tools are available.
