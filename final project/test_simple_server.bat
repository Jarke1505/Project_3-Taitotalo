@echo off
echo ========================================
echo SIMPLE SERVER TEST
echo ========================================
echo.

echo This will test if we can start ANY server on port 8080
echo.

rem Kill any existing processes
taskkill /f /im python.exe 2>nul
taskkill /f /im node.exe 2>nul
timeout /t 1 /nobreak >nul

echo Testing Python first...
set "PYTHON_CMD="
if exist "C:\Users\jariv\AppData\Local\Programs\Python\Python313\python.exe" (
    set "PYTHON_CMD=C:\Users\jariv\AppData\Local\Programs\Python\Python313\python.exe"
) else if exist "C:\Python313\python.exe" (
    set "PYTHON_CMD=C:\Python313\python.exe"
) else if exist "C:\Program Files\Python313\python.exe" (
    set "PYTHON_CMD=C:\Program Files\Python313\python.exe"
)

if not "%PYTHON_CMD%"=="" (
    echo Found Python, testing...
    "%PYTHON_CMD%" --version
    if %errorlevel% equ 0 (
        echo Python works! Starting simple server...
        start "Test Server" cmd /k "echo Python server starting on port 8080... && cd /d %~dp0 && \"%PYTHON_CMD%\" -m http.server 8080"
        timeout /t 3 /nobreak >nul
        echo Opening browser...
        start "" "http://localhost:8080"
        echo.
        echo If you can see the page now, Python works!
        echo If not, there might be a firewall or other issue.
        pause
        goto :eof
    )
)

echo Python didn't work, trying Node.js...
echo Testing Node.js...
node --version
if %errorlevel% neq 0 (
    echo ERROR: Neither Python nor Node.js working!
    echo Please check your installations.
    pause
    exit /b 1
)

echo Node.js works! Starting simple server...
start "Test Server" cmd /k "echo Node.js server starting on port 8080... && cd /d %~dp0 && npx http-server -p 8080"
timeout /t 3 /nobreak >nul
echo Opening browser...
start "" "http://localhost:8080"

echo.
echo If you can see the page now, Node.js works!
echo If not, there might be a firewall or other issue.
echo.
pause
