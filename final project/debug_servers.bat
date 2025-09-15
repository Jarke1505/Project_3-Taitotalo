@echo off
echo ========================================
echo SERVER DEBUGGING SCRIPT
echo ========================================
echo.

echo Step 1: Checking if ports are free...
netstat -an | findstr ":8080" >nul
if %errorlevel% equ 0 (
    echo ERROR: Port 8080 is already in use!
    echo Killing processes on port 8080...
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8080"') do taskkill /f /pid %%a 2>nul
    timeout /t 2 /nobreak >nul
) else (
    echo Port 8080 is free
)

netstat -an | findstr ":4000" >nul
if %errorlevel% equ 0 (
    echo ERROR: Port 4000 is already in use!
    echo Killing processes on port 4000...
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":4000"') do taskkill /f /pid %%a 2>nul
    timeout /t 2 /nobreak >nul
) else (
    echo Port 4000 is free
)

echo.
echo Step 2: Testing Python...
set "PYTHON_CMD="
if exist "C:\Users\jariv\AppData\Local\Programs\Python\Python313\python.exe" (
    set "PYTHON_CMD=C:\Users\jariv\AppData\Local\Programs\Python\Python313\python.exe"
) else if exist "C:\Python313\python.exe" (
    set "PYTHON_CMD=C:\Python313\python.exe"
) else if exist "C:\Program Files\Python313\python.exe" (
    set "PYTHON_CMD=C:\Program Files\Python313\python.exe"
) else if exist "C:\Users\jariv\AppData\Local\Programs\Python\Python312\python.exe" (
    set "PYTHON_CMD=C:\Users\jariv\AppData\Local\Programs\Python\Python312\python.exe"
) else if exist "C:\Python312\python.exe" (
    set "PYTHON_CMD=C:\Python312\python.exe"
) else if exist "C:\Program Files\Python312\python.exe" (
    set "PYTHON_CMD=C:\Program Files\Python312\python.exe"
)

if "%PYTHON_CMD%"=="" (
    echo Python not found in common locations
    echo Will use Node.js for frontend
) else (
    echo Found Python: %PYTHON_CMD%
    "%PYTHON_CMD%" --version
    if %errorlevel% neq 0 (
        echo Python test failed
        set "PYTHON_CMD="
    ) else (
        echo Python is working
    )
)

echo.
echo Step 3: Testing Node.js...
node --version
if %errorlevel% neq 0 (
    echo ERROR: Node.js not working!
    pause
    exit /b 1
) else (
    echo Node.js is working
)

echo.
echo Step 4: Testing backend build...
cd server
if exist "dist\index.js" (
    echo Backend already built
) else (
    echo Building backend...
    call npm run build
    if %errorlevel% neq 0 (
        echo npm build failed, trying npx...
        call npx tsc -p tsconfig.json
        if %errorlevel% neq 0 (
            echo Backend build failed
        ) else (
            echo Backend built with npx
        )
    ) else (
        echo Backend built with npm
    )
)

if exist "dist\index.js" (
    echo Backend build exists
) else (
    echo Backend build missing - will try ts-node
)

cd ..

echo.
echo Step 5: Starting servers with detailed output...

rem Start backend
echo Starting backend...
cd server
if exist "dist\index.js" (
    echo Using compiled backend...
    start "Backend Server" cmd /k "echo Backend starting... && cd /d %~dp0 && node dist/index.js && echo Backend stopped. Press any key to close."
) else (
    echo Using ts-node...
    start "Backend Server" cmd /k "echo Backend starting with ts-node... && cd /d %~dp0 && node node_modules\.bin\ts-node.cmd src/index.ts && echo Backend stopped. Press any key to close."
)
cd ..

rem Wait a moment
timeout /t 2 /nobreak >nul

rem Start frontend
echo Starting frontend...
if "%PYTHON_CMD%"=="" (
    echo Using Node.js http-server...
    start "Frontend Server" cmd /k "echo Frontend starting... && cd /d %~dp0 && npx http-server -p 8080 && echo Frontend stopped. Press any key to close."
) else (
    echo Using Python http.server...
    start "Frontend Server" cmd /k "echo Frontend starting... && cd /d %~dp0 && \"%PYTHON_CMD%\" -m http.server 8080 && echo Frontend stopped. Press any key to close."
)

echo.
echo ========================================
echo SERVERS STARTING
echo ========================================
echo.
echo Two new windows should have opened:
echo 1. Backend Server window
echo 2. Frontend Server window
echo.
echo Wait 10 seconds, then check:
echo - Do you see any error messages in the server windows?
echo - Are the servers actually running?
echo.
echo After 10 seconds, I'll open the browser...
timeout /t 10 /nobreak >nul

echo Opening browser...
start "" "http://localhost:8080"

echo.
echo ========================================
echo DEBUGGING COMPLETE
echo ========================================
echo.
echo If you still can't reach the page:
echo 1. Check the server windows for error messages
echo 2. Look for any red error text
echo 3. Tell me what errors you see
echo.
pause
