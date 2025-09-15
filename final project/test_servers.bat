@echo off
echo ========================================
echo SERVER TESTING SCRIPT
echo ========================================
echo.

echo Testing if ports are available...
netstat -an | findstr ":8080" >nul
if %errorlevel% equ 0 (
    echo ERROR: Port 8080 is already in use!
    echo Please close any applications using port 8080
    pause
    exit /b 1
) else (
    echo Port 8080 is available
)

netstat -an | findstr ":4000" >nul
if %errorlevel% equ 0 (
    echo ERROR: Port 4000 is already in use!
    echo Please close any applications using port 4000
    pause
    exit /b 1
) else (
    echo Port 4000 is available
)

echo.
echo Testing Python HTTP server...
python -c "import http.server; print('Python HTTP server module available')" 2>nul
if %errorlevel% neq 0 (
    echo ERROR: Python not found or HTTP server module not available
    echo Please install Python from https://python.org
    pause
    exit /b 1
) else (
    echo Python HTTP server is ready
)

echo.
echo Testing Node.js...
node --version 2>nul
if %errorlevel% neq 0 (
    echo WARNING: Node.js not found - backend will not work
    echo Frontend will still work
) else (
    echo Node.js is available
)

echo.
echo ========================================
echo ALL TESTS PASSED - READY TO START
echo ========================================
echo.
echo You can now run: simple_start.bat
echo.
pause
