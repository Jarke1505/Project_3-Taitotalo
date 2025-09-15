@echo off
echo ========================================
echo SIMPLE RESTAURANT APP STARTER
echo ========================================
echo.

rem Kill any existing processes on our ports
echo Cleaning up any existing servers...
taskkill /f /im python.exe 2>nul
taskkill /f /im node.exe 2>nul
timeout /t 1 /nobreak >nul

rem Start frontend server
echo Starting frontend server on port 8080...
start "Frontend Server" cmd /c "cd /d %~dp0 && python -m http.server 8080 && pause"

rem Wait a moment
timeout /t 3 /nobreak >nul

rem Check if we can build the backend
echo Checking backend...
cd server

rem Try to build if dist doesn't exist
if not exist "dist\index.js" (
    echo Building backend...
    call npm run build 2>nul || call npx tsc -p tsconfig.json 2>nul || echo Backend build failed, continuing with frontend only...
)

rem Start backend if build exists
if exist "dist\index.js" (
    echo Starting backend server on port 4000...
    start "Backend Server" cmd /c "cd /d %~dp0\server && node dist/index.js && pause"
) else (
    echo Backend not available, running frontend only...
)

cd ..

rem Wait a moment for servers to start
timeout /t 2 /nobreak >nul

rem Open browser
echo Opening browser...
start "" "http://localhost:8080"

echo.
echo ========================================
echo SERVERS STARTED
echo ========================================
echo Frontend: http://localhost:8080
if exist "server\dist\index.js" (
    echo Backend: http://localhost:4000
) else (
    echo Backend: Not available
)
echo.
echo If localhost refuses to connect:
echo 1. Wait 10-15 seconds for servers to fully start
echo 2. Check the server windows for error messages
echo 3. Try refreshing the browser
echo.
pause
