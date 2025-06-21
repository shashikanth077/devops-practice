 echo 'Starting React application in development mode and capturing PID...'
                bat '''
                    @echo off

                    echo -----------------------------------------------------
                    echo Starting the app in development mode and writing the process ID to ".pidfile".

                    :: First, clear any old .pidfile to ensure we write a new one
                    if exist ".pidfile" del ".pidfile"

                    :: Start npm start in a detached background process.
                    :: Redirect stdout and stderr to npm_start.log for debugging.
                    start /B npm start > "npm_start.log" 2>&1

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

                        echo --- Attempt %attempts% ---
                        echo Checking for any node.exe processes using tasklist...
                        tasklist | findstr "node.exe"
                        echo.

                        echo Attempting to find PID with WMIC (raw output before filter)...
                        :: Capture the raw output of WMIC process query for debugging
                        wmic process where "name='node.exe'" get processid,commandline /value
                        echo.

                        echo Attempting to find PID with WMIC (filtered by react-scripts start)...
                        :: This is the command that's supposed to find the PID
                        :: We'll temporarily store its output in a temp file to see what it contains
                        set "wmic_output_file=wmic_pid_check_temp.txt"
                        wmic process where "name='node.exe' AND commandline LIKE '%%react-scripts start%%'" get processid,commandline /value > "%wmic_output_file%"
                        type "%wmic_output_file%"
                        echo.

                        for /f "tokens=2,*" %%a in ('type "%wmic_output_file%" ^| findstr "ProcessId="') do (
                            if "%%a" == "" (
                                echo "No 'ProcessId=' found in filtered WMIC output for this attempt."
                            ) else (
                                for /f "delims== tokens=2" %%p in ("%%a") do (
                                    echo Found PID: %%p
                                    echo %%p > ".pidfile"
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
                            echo 1. Check "npm_start.log" in your Jenkins workspace for any errors when "npm start" tried to run.
                            echo 2. Examine the "tasklist" and "WMIC (raw output)" above to see the *exact* command line of node.exe.
                            echo    You might need to adjust "%%react-scripts start%%" in this script to match it.
                            echo 3. Ensure 'node_modules' is present and 'react-scripts' is installed in your React project.
                            echo ====================================================================
                            exit /b 1
                        )
                    goto FIND_PID_LOOP

                    :PID_FOUND
                    echo PID captured to .pidfile.
                    echo Visit http://localhost:3000 to view your React application in action.

                    :: Clean up the temporary WMIC output file
                    if exist "%wmic_output_file%" del "%wmic_output_file%"
                '''
                echo 'React application started in development mode.'
                echo 'You can now access it via http://localhost:3000 on the Jenkins server.'
                echo 'The process ID has been saved to ".pidfile" for future reference.'
                echo 'To stop the application, use the "kill.bat" script.'
                echo 'For more information, refer to the Jenkins job console output.'
                echo '-----------------------------------------------------'
                echo 'Note: If you encounter issues, check the "npm_start.log" file in your Jenkins workspace for details.'
                echo '-----------------------------------------------------'
                echo 'This script is designed to run in a Jenkins pipeline and may not work as expected outside of that environment.'
                echo '-----------------------------------------------------'
                echo 'If you need to run this script outside of Jenkins, please ensure you have the necessary environment set up.'
                echo '-----------------------------------------------------'
                echo 'For more information, refer to the Jenkins documentation or the script comments.'
                echo '-----------------------------------------------------'
                echo 'This script is part of the Jenkins pipeline for delivering the React application.'
                echo '-----------------------------------------------------'
                echo 'End of script.'
                echo '-----------------------------------------------------'
                echo 'This script is intended to be run in a Jenkins pipeline and may not function correctly outside of that context.'
                echo '-----------------------------------------------------'
                echo 'If you encounter issues, please check the Jenkins job console output for more information.'
                echo '-----------------------------------------------------'
                echo 'This script is designed to start a React application in development mode and capture its process ID.'
                echo '-----------------------------------------------------'
                echo 'It is intended to be used in a Jenkins pipeline and may not work as expected outside of that environment.'
                echo '-----------------------------------------------------'    