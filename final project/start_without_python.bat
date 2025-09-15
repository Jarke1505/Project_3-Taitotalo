@echo off
echo ========================================
echo RESTAURANT APP - NO PYTHON REQUIRED
echo ========================================
echo.

rem Check if Node.js is available
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js not found!
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

echo Node.js found. Starting servers...

rem Kill any existing processes
taskkill /f /im node.exe 2>nul
timeout /t 1 /nobreak >nul

rem Start backend first
echo Starting backend server...
cd server

rem Try to build if needed
if not exist "dist\index.js" (
    echo Building backend...
    call npm run build 2>nul || call npx tsc -p tsconfig.json 2>nul
)

if exist "dist\index.js" (
    echo Backend starting on port 4000...
    start "Backend Server" cmd /k "cd /d %~dp0\server && node dist/index.js"
) else (
    echo Backend build failed, trying ts-node...
    start "Backend Server" cmd /k "cd /d %~dp0\server && node node_modules\.bin\ts-node.cmd src/index.ts"
)

cd ..

rem Wait for backend to start
timeout /t 3 /nobreak >nul

rem Start frontend using Node.js instead of Python
echo Starting frontend server using Node.js...
start "Frontend Server" cmd /k "cd /d %~dp0 && npx http-server -p 8080 -o"

rem Wait a moment
timeout /t 2 /nobreak >nul

echo.
echo ========================================
echo SERVERS STARTED
echo ========================================
echo Frontend: http://localhost:8080
echo Backend: http://localhost:4000
echo.
echo The browser should open automatically.
echo If not, manually open: http://localhost:8080
echo.
echo Check the server windows for any error messages.
echo.
pause
