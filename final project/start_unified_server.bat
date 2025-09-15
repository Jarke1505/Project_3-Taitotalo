@echo off
echo ========================================
echo AMBER & THYME UNIFIED SERVER
echo ========================================
echo.

echo Starting unified server with all pages...
echo.

rem Kill any existing processes
taskkill /f /im node.exe 2>nul
timeout /t 2 /nobreak >nul

echo Starting backend server on port 4000...
echo This will serve all pages from the same server.
start "Unified Server" cmd /k "echo Backend server starting... && cd /d %~dp0 && node simple_backend.js"

echo.
echo Waiting for server to start...
timeout /t 3 /nobreak >nul

echo Opening all pages...
echo.
echo 🌐 Website: http://localhost:4000/
echo 📧 Contact: http://localhost:4000/contact
echo 🍽️ Menu: http://localhost:4000/menu
echo 🔐 Admin: http://localhost:4000/admin
echo.

start "" "http://localhost:4000/"
start "" "http://localhost:4000/admin"

echo.
echo ========================================
echo UNIFIED SERVER STARTED
echo ========================================
echo.
echo All pages are now served from the same server!
echo.
echo Available URLs:
echo • Website: http://localhost:4000/
echo • Contact: http://localhost:4000/contact
echo • Menu: http://localhost:4000/menu
echo • Admin: http://localhost:4000/admin
echo.
echo Admin login: admin / admin123
echo.
echo All pages will now work together seamlessly!
echo.
pause
