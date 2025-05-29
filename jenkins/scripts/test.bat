@echo off
echo The following "npm" command (if executed) installs the "cross-env"
echo dependency into the local "node_modules" directory.

REM Optional: Uncomment to install cross-env
REM npm install --save-dev cross-env

echo Running tests using Jest...
npm test
