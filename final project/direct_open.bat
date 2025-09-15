@echo off
echo ========================================
echo DIRECT RESTAURANT APP LAUNCHER
echo ========================================
echo.

echo Opening restaurant app directly in browser...
echo This bypasses all server issues.

rem Get the full path to the HTML file
set "HTML_FILE=%~dp0index.html"

echo HTML file location: %HTML_FILE%

rem Check if the HTML file exists
if not exist "%HTML_FILE%" (
    echo ERROR: index.html not found!
    echo Make sure you're running this from the project folder.
    pause
    exit /b 1
)

echo Opening %HTML_FILE% in your default browser...
start "" "%HTML_FILE%"

echo.
echo ========================================
echo APP OPENED DIRECTLY
echo ========================================
echo.
echo The restaurant app should now be open in your browser.
echo.
echo NOTE: This version runs without any server.
echo - The interface will work
echo - Some features may not work (like user login)
echo - But you can see and interact with the restaurant
echo.
echo If you want full functionality with backend:
echo 1. Fix the server issues first
echo 2. Then use the other startup scripts
echo.
pause
