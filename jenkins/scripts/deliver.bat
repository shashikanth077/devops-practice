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
:: This ensures any output from npm start goes to the log file for debugging
start /B npm start > "..\npm_start.log" 2>&1

echo Waiting for Node.js/React app to start and capture PID...
set "pid_found="
set /a "attempts=0"
:FIND_PID_LOOP
    :: Wait for 5 seconds before checking again.
    timeout /t 5 /nobreak > nul
    if errorlevel 1 (
        echo Timeout command failed or interrupted. Exiting.
        exit /b 1
    )

    echo --- Attempt %attempts% ---
    echo Checking for any node.exe processes using tasklist...
    tasklist | findstr "node.exe"
    echo.

    echo Attempting to find PID with WMIC (raw output before findstr)...
    :: Capture the raw output of WMIC process query for debugging
    wmic process where "name='node.exe'" get processid,commandline /value
    echo.

    echo Attempting to find PID with WMIC (filtered by react-scripts start)...
    :: This is the command that's supposed to find the PID
    :: We'll temporarily store its output in a temp file to see what it contains
    set "wmic_output_file=..\wmic_pid_check_temp.txt"
    wmic process where "name='node.exe' AND commandline LIKE '%%react-scripts start%%'" get processid,commandline /value > "%wmic_output_file%"
    type "%wmic_output_file%"
    echo.

    for /f "tokens=2,*" %%a in ('type "%wmic_output_file%" ^| findstr "ProcessId="') do (
        :: Double-check if the file is empty after filtering
        if "%%a" == "" (
            echo "No 'ProcessId=' found in filtered WMIC output for this attempt."
        ) else (
            for /f "delims== tokens=2" %%p in ("%%a") do (
                echo Found PID: %%p
                echo %%p > ..\.pidfile
                set "pid_found=true"
                goto PID_FOUND
            )
        )
    )

    set /a "attempts+=1"
    if %attempts% geq 10 (
        echo Failed to find the npm start process PID after multiple attempts (waited up to 50 seconds).
        echo ====================================================================
        echo DIAGNOSTIC HINTS:
        echo 1. Check "..\npm_start.log" for any errors when "npm start" tried to run.
        echo 2. Examine the "tasklist" and "WMIC (raw output)" above to see the *exact* command line of node.exe.
        echo    You might need to adjust "%%react-scripts start%%" to match it.
        echo 3. Ensure 'node_modules' is present and 'react-scripts' is installed.
        echo ====================================================================
        exit /b 1
    )
goto FIND_PID_LOOP

:PID_FOUND
echo PID captured to ..\.pidfile.
echo Visit http://localhost:3000 to view your React application in action.

:: Clean up the temporary WMIC output file
if exist "%wmic_output_file%" del "%wmic_output_file%"

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
