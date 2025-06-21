@echo off

echo The following "npm" command builds your Node.js/React application for production...
echo This will generate the "build" folder with optimized static files.
npm run build

echo -----------------------------------------------------
echo The following "npm" command runs the app in development mode.
echo It starts the app and writes the process ID to "..\.pidfile".

:: First, clear any old ..\.pidfile to ensure we write a new one
if exist ..\.pidfile del ..\.pidfile

:: Start npm start in a detached background process and log output
start /B npm start > ..\npm_start.log 2>&1

echo Waiting for Node.js/React app to start and capture PID...
set "pid_found="
set /a "attempts=0"
:FIND_PID_LOOP
    :: Wait for 5 seconds before checking again. This gives the Node.js process time to start.
    timeout /t 5 /nobreak > nul
    if errorlevel 1 (
        echo Timeout command failed or interrupted. Exiting.
        exit /b 1
    )

    echo Checking for node.exe processes...
    tasklist | findstr node.exe

    echo Attempting to find PID with WMIC...
    for /f "tokens=2,*" %%a in ('wmic process where "name='node.exe' AND commandline LIKE '%%react-scripts start%%'" get processid,commandline /value ^| findstr "ProcessId="') do (
        for /f "delims== tokens=2" %%p in ("%%a") do (
            echo %%p > ..\.pidfile
            set "pid_found=true"
            goto PID_FOUND
        )
    )

    set /a "attempts+=1"
    if %attempts% geq 10 (
        echo Failed to find the npm start process PID after multiple attempts (waited up to 50 seconds).
        echo Please check if the 'npm start' command is actually launching 'node.exe' with 'react-scripts start'.
        echo Verify that 'react-scripts' is correctly installed in node_modules.
        echo See ..\npm_start.log for npm start output.
        exit /b 1
    )
goto FIND_PID_LOOP

:PID_FOUND
echo PID captured to ..\.pidfile.
echo Visit http://localhost:3000 to view your React application in action.

:: IMPORTANT: The command to terminate the process is not in this script block.
:: It would be in a separate step later in your Jenkins pipeline,
:: or in a `post` section to ensure cleanup. Example for termination:
:: if exist ..\.pidfile (
::    set /p PID=<..\.pidfile
::    echo Terminating Node.js/React process with PID: %PID%
::    taskkill /PID %PID% /F
::    del ..\.pidfile
:: ) else (
::    echo ..\.pidfile not found. Cannot terminate process.
:: )