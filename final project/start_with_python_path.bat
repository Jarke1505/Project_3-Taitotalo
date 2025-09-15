@echo off
echo ========================================
echo RESTAURANT APP - WITH PYTHON PATH
echo ========================================
echo.

rem Try different Python paths
set "PYTHON_PATH="
set "PYTHON_FOUND=0"

rem Check common Python installation paths
if exist "C:\Users\jariv\AppData\Local\Programs\Python\Python313\python.exe" (
    set "PYTHON_PATH=C:\Users\jariv\AppData\Local\Programs\Python\Python313\python.exe"
    set "PYTHON_FOUND=1"
) else if exist "C:\Python313\python.exe" (
    set "PYTHON_PATH=C:\Python313\python.exe"
    set "PYTHON_FOUND=1"
) else if exist "C:\Program Files\Python313\python.exe" (
    set "PYTHON_PATH=C:\Program Files\Python313\python.exe"
    set "PYTHON_FOUND=1"
) else if exist "C:\Users\jariv\AppData\Local\Programs\Python\Python312\python.exe" (
    set "PYTHON_PATH=C:\Users\jariv\AppData\Local\Programs\Python\Python312\python.exe"
    set "PYTHON_FOUND=1"
) else if exist "C:\Python312\python.exe" (
    set "PYTHON_PATH=C:\Python312\python.exe"
    set "PYTHON_FOUND=1"
) else if exist "C:\Program Files\Python312\python.exe" (
    set "PYTHON_PATH=C:\Program Files\Python312\python.exe"
    set "PYTHON_FOUND=1"
)

if %PYTHON_FOUND% equ 0 (
    echo Python not found in common locations.
    echo Please run the Python installer and make sure to check:
    echo "Add Python to PATH" during installation.
    echo.
    echo For now, using Node.js alternative...
    goto :use_nodejs
)

echo Found Python at: %PYTHON_PATH%
echo Testing Python...
"%PYTHON_PATH%" --version
if %errorlevel% neq 0 (
    echo Python test failed, using Node.js alternative...
    goto :use_nodejs
)

echo Python is working! Starting servers...

rem Kill any existing processes
taskkill /f /im python.exe 2>nul
taskkill /f /im node.exe 2>nul
timeout /t 1 /nobreak >nul

rem Start backend
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

rem Start frontend with Python
echo Starting frontend server on port 8080...
start "Frontend Server" cmd /k "cd /d %~dp0 && \"%PYTHON_PATH%\" -m http.server 8080"

rem Wait for servers to start
timeout /t 3 /nobreak >nul

rem Open browser
echo Opening browser...
start "" "http://localhost:8080"

echo.
echo ========================================
echo SERVERS STARTED SUCCESSFULLY
echo ========================================
echo Frontend: http://localhost:8080
echo Backend: http://localhost:4000
echo.
echo If localhost refuses to connect:
echo 1. Wait 10-15 seconds for servers to fully start
echo 2. Check the server windows for error messages
echo 3. Try refreshing the browser
echo.
pause
goto :eof

:use_nodejs
echo.
echo Using Node.js alternative instead...
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

rem Start frontend using Node.js
echo Starting frontend server using Node.js...
start "Frontend Server" cmd /k "cd /d %~dp0 && npx http-server -p 8080 -o"

rem Wait for servers to start
timeout /t 3 /nobreak >nul

echo.
echo ========================================
echo SERVERS STARTED (NODE.JS VERSION)
echo ========================================
echo Frontend: http://localhost:8080
echo Backend: http://localhost:4000
echo.
pause
