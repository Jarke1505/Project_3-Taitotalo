@echo off
setlocal enabledelayedexpansion

rem Resolve project root (folder of this script)
set "ROOT=%~dp0"

rem Select Node/npm/npx commands
set "NPM=npm"
set "NPX=npx"
set "NODE=node"
where npm >nul 2>&1 || set "NPM=%ProgramFiles%\nodejs\npm.cmd"
where npx >nul 2>&1 || set "NPX=%ProgramFiles%\nodejs\npx.cmd"
where node >nul 2>&1 || set "NODE=%ProgramFiles%\nodejs\node.exe"

rem 1) Backend env setup
pushd "%ROOT%server"
if not exist ".env" (
  echo PORT=4000> .env
  echo MONGO_URI=mongodb://localhost:27017/restaurant_app>> .env
  echo JWT_SECRET=super_secret_change_me>> .env
)

rem 2) Install deps (including dev) and build TypeScript
call "%NPM%" install --include=dev || goto :npm_fail
call "%NPM%" run build || call "%NPX%" tsc -p tsconfig.json || goto :npm_fail

rem 3) Start backend API in a new window
start "Restaurant API" cmd /k "%NODE%" "%ROOT%server\dist\index.js"
popd

rem 4) Start static frontend server in a new window on port 8080
start "Restaurant Frontend" cmd /k python -m http.server 8080

rem 5) Open browser to the site
start "" "http://localhost:8080/index.html"

echo.
echo Started backend on http://localhost:4000 and frontend on http://localhost:8080
echo If MongoDB is not running locally, set MONGO_URI in server\.env to your Atlas URL and re-run.
goto :eof

:npm_fail
echo.
echo Failed to run npm. Make sure Node.js is installed and try again.
pause
exit /b 1


