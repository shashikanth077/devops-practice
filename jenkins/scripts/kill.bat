@echo off

echo The following command terminates the "npm start" (Node.js) process...
echo This uses the PID stored in the ".pidfile" created by "deliver.bat".

REM Read the PID from .pidfile
set /p PID=<.pidfil
