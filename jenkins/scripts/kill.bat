@echo off

echo The following command terminates the "npm start" (Node.js) process...
echo This uses the PID stored in the "..\.pidfile" created by "deliver.bat".

REM Check if ..\.pidfile exists
if not exist ..\.pidfile (
    echo ERROR: ..\.pidfile not found. The process may not have started correctly or PID was not captured.
    exit /b 1
)

REM Read the PID from ..\.pidfile
set /p PID=<..\.pidfile

echo Terminating Node.js/React process with PID: %PID%
taskkill /PID %PID% /F

del ..\.pidfile
