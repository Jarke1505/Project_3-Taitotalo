@echo off
echo ========================================
echo SERVER FIXING SCRIPT
echo ========================================
echo.

echo This script will try to fix the server issues step by step.
echo.

echo Step 1: Checking Windows Firewall...
echo If Windows Firewall is blocking the connection, you might see a popup.
echo If you see a Windows Firewall popup, click "Allow access"

echo.
echo Step 2: Testing basic connectivity...
ping localhost
if %errorlevel% neq 0 (
    echo ERROR: Cannot ping localhost - network issue!
    pause
    exit /b 1
) else (
    echo Localhost connectivity works
)

echo.
echo Step 3: Testing if we can start a simple server...
echo Starting a test server on port 8080...

rem Try Python first
set "PYTHON_CMD="
if exist "C:\Users\jariv\AppData\Local\Programs\Python\Python313\python.exe" (
    set "PYTHON_CMD=C:\Users\jariv\AppData\Local\Programs\Python\Python313\python.exe"
) else if exist "C:\Python313\python.exe" (
    set "PYTHON_CMD=C:\Python313\python.exe"
) else if exist "C:\Program Files\Python313\python.exe" (
    set "PYTHON_CMD=C:\Program Files\Python313\python.exe"
)

if not "%PYTHON_CMD%"=="" (
    echo Testing Python server...
    start "Python Test Server" cmd /k "echo Python server test - if you see this, Python works && cd /d %~dp0 && \"%PYTHON_CMD%\" -m http.server 8080"
    timeout /t 5 /nobreak >nul
    
    echo Checking if Python server started...
    netstat -an | findstr ":8080" >nul
    if %errorlevel% equ 0 (
        echo SUCCESS: Python server is running!
        echo Opening browser...
        start "" "http://localhost:8080"
        echo.
        echo The server is working! Check the browser.
        echo If you can see the page, Python works fine.
        pause
        goto :eof
    ) else (
        echo Python server failed to start
        taskkill /f /im python.exe 2>nul
    )
)

echo.
echo Step 4: Testing Node.js server...
echo Testing Node.js server...
start "Node Test Server" cmd /k "echo Node.js server test - if you see this, Node.js works && cd /d %~dp0 && npx http-server -p 8080"
timeout /t 5 /nobreak >nul

echo Checking if Node.js server started...
netstat -an | findstr ":8080" >nul
if %errorlevel% equ 0 (
    echo SUCCESS: Node.js server is running!
    echo Opening browser...
    start "" "http://localhost:8080"
    echo.
    echo The server is working! Check the browser.
    echo If you can see the page, Node.js works fine.
    pause
    goto :eof
) else (
    echo Node.js server also failed
    taskkill /f /im node.exe 2>nul
)

echo.
echo ========================================
echo ALL SERVERS FAILED
echo ========================================
echo.
echo Neither Python nor Node.js servers are working.
echo This could be due to:
echo 1. Windows Firewall blocking the connection
echo 2. Antivirus software blocking the servers
echo 3. Port 8080 being reserved by Windows
echo 4. Network configuration issues
echo.
echo SOLUTIONS:
echo 1. Try running as Administrator
echo 2. Check Windows Firewall settings
echo 3. Check antivirus settings
echo 4. Use the direct_open.bat instead
echo.
echo For now, use direct_open.bat to see the app without servers.
echo.
pause
