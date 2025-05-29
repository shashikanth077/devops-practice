@echo off

echo The following "npm" command builds your Node.js/React application for production...
echo This will generate the "build" folder with optimized static files.
npm run build

echo -----------------------------------------------------
echo The following "npm" command runs the app in development mode.
echo It starts the app and writes the process ID to ".pidfile".
start /B npm start
REM Wait briefly to allow process to start
ping -n 3 127.0.0.1 > nul

REM Find the PID of the npm process (this is a workaround for Windows)
for /f "tokens=2" %%a in ('tasklist ^| findstr "node.exe"') do (
    echo %%a > .pidfile
    goto done
)
:done

echo Visit http://localhost:3000 to view your React application in action.
