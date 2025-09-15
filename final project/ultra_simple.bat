@echo off
echo ========================================
echo ULTRA SIMPLE RESTAURANT APP
echo ========================================
echo.

rem Just open the HTML file directly in browser
echo Opening restaurant app directly in browser...
start "" "%~dp0index.html"

echo.
echo ========================================
echo APP OPENED
echo ========================================
echo.
echo The restaurant app is now open in your browser.
echo.
echo NOTE: This version runs without any server.
echo Some features may not work (like user login),
echo but you can see the restaurant interface.
echo.
echo To get full functionality:
echo 1. Install Python from https://python.org
echo 2. Or install Node.js from https://nodejs.org
echo 3. Then use the other startup scripts
echo.
pause
