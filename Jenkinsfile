// Jenkinsfile
pipeline {
    // Defines where the pipeline will run.
    // 'any' means it can run on any available agent.
    // For specific Windows agents, you might use: agent { label 'my-windows-agent-label' }
    agent any

    // Environment variables (optional)
    environment {
        // You can define paths or other variables here if needed
        // For example: CI = 'true' // Tells react-scripts it's a CI environment
    }

    // Stages define the different phases of your pipeline
    stages {
        // Stage 1: Checkout Source Code
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                // Replace 'YOUR_GIT_REPOSITORY_URL' with your actual Git repository URL
                // Replace 'main' with your target branch (e.g., 'master', 'develop')
                git branch: 'master', url: 'https://github.com/shashikanth077/devops-practice.git'
                echo 'Source code checked out.'
            }
        }

        // Stage 2: Install Node.js Dependencies
        stage('Install Dependencies') {
            steps {
                echo 'Installing Node.js dependencies...'
                // This command installs packages listed in package.json
                // Assumes package.json is at the root of the repository
                bat 'npm install'
                echo 'Node.js dependencies installed.'
            }
        }

        // Stage 3: Build React Application for Production
        stage('Build React App') {
            steps {
                echo 'Building React application for production...'
                // This creates the 'build' folder with optimized static assets
                bat 'npm run build'
                echo 'React application built.'
            }
        }

        // Stage 4: Run React App in Development Mode (and Capture PID)
        // This stage will start the React development server in the background
        // and attempt to capture its Process ID (PID) for later termination.
        // The PID is stored in a '.pidfile' in the Jenkins workspace root.
        stage('Start React App (Development Mode)') {
            steps {
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
                echo 'You can now access it via http://localhost:3000 on the Jenkins agent machine (if firewall allows).'
            }
        }

        // Stage 5: Run Tests (Optional, but highly recommended)
        stage('Run Tests') {
            steps {
                echo 'Running React application tests...'
                // Make sure you have test files (e.g., src/App.test.js)
                // or configure "test" script in package.json to use --passWithNoTests
                bat 'npm test'
                echo 'Tests completed.'
            }
        }

        // Stage 6: Deployment (Placeholder - This is where you'd add your actual deployment logic)
        stage('Deploy') {
            steps {
                echo 'This stage would contain your actual deployment steps.'
                echo 'For example, pushing a Docker image to a registry, or deploying to Kubernetes/VMs.'
                // Example of a Minikube deployment step (assuming minikube is running with Docker driver):
                // bat 'eval $(minikube docker-env)' // Set Docker CLI to use Minikube's daemon
                // bat 'docker build -t my-react-app:latest .' // Build image within Minikube
                // bat 'kubectl apply -f kubernetes/deployment.yaml' // Apply Kubernetes deployment
                // bat 'kubectl apply -f kubernetes/service.yaml' // Apply Kubernetes service
            }
        }
    }

    // Post-build actions: These steps run after all stages, regardless of success or failure
    post {
        // 'always' ensures this block runs even if a stage fails
        always {
            echo 'Running post-build cleanup to ensure Node.js process is terminated...'
            bat '''
                @echo off
                if exist ".pidfile" (
                   set /p PID=<".pidfile"
                   echo Post-build cleanup: Terminating Node.js/React process with PID: %PID%
                   taskkill /PID %PID% /F
                   del ".pidfile"
                ) else (
                   echo Post-build cleanup: .pidfile not found. No Node.js process to terminate.
                )
            '''
            echo 'Cleanup complete.'
        }
        // 'success' block runs only if the pipeline completes successfully
        success {
            echo 'Pipeline finished successfully! 🎉'
        }
        // 'failure' block runs only if the pipeline fails
        failure {
            echo 'Pipeline failed. Please check the logs for errors. ❌'
        }
    }
}
