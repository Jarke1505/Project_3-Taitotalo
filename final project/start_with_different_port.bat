@echo off
echo ========================================
echo RESTAURANT APP - DIFFERENT PORT
echo ========================================
echo.

echo Trying port 3000 instead of 8080 (sometimes 8080 is blocked)...

rem Kill any existing processes
taskkill /f /im python.exe 2>nul
taskkill /f /im node.exe 2>nul
timeout /t 1 /nobreak >nul

rem Find Python
set "PYTHON_CMD="
if exist "C:\Users\jariv\AppData\Local\Programs\Python\Python313\python.exe" (
    set "PYTHON_CMD=C:\Users\jariv\AppData\Local\Programs\Python\Python313\python.exe"
) else if exist "C:\Python313\python.exe" (
    set "PYTHON_CMD=C:\Python313\python.exe"
) else if exist "C:\Program Files\Python313\python.exe" (
    set "PYTHON_CMD=C:\Program Files\Python313\python.exe"
)

if not "%PYTHON_CMD%"=="" (
    echo Starting Python server on port 3000...
    start "Frontend Server" cmd /k "echo Frontend server on port 3000... && cd /d %~dp0 && \"%PYTHON_CMD%\" -m http.server 3000"
) else (
    echo Starting Node.js server on port 3000...
    start "Frontend Server" cmd /k "echo Frontend server on port 3000... && cd /d %~dp0 && npx http-server -p 3000"
)

rem Wait for server to start
timeout /t 3 /nobreak >nul

rem Start backend on port 4000
echo Starting backend server...
cd server
if exist "dist\index.js" (
    start "Backend Server" cmd /k "echo Backend server on port 4000... && cd /d %~dp0\server && node dist/index.js"
) else (
    start "Backend Server" cmd /k "echo Backend server on port 4000... && cd /d %~dp0\server && node node_modules\.bin\ts-node.cmd src/index.ts"
)
cd ..

rem Wait a moment
timeout /t 2 /nobreak >nul

echo.
echo ========================================
echo SERVERS STARTED
echo ========================================
echo Frontend: http://localhost:3000
echo Backend: http://localhost:4000
echo.
echo Try opening: http://localhost:3000
echo.
echo If that doesn't work, try these URLs:
echo - http://127.0.0.1:3000
echo - http://0.0.0.0:3000
echo.
start "" "http://localhost:3000"

echo.
echo If you still can't reach the page:
echo 1. Check Windows Firewall settings
echo 2. Try running as Administrator
echo 3. Check if antivirus is blocking connections
echo.
pause
