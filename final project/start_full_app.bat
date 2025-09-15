@echo off
echo ========================================
echo RESTAURANT APP - FULL BACKEND VERSION
echo ========================================
echo.

echo This will start the complete restaurant app with backend functionality.
echo.

rem Kill any existing processes
taskkill /f /im node.exe 2>nul
timeout /t 2 /nobreak >nul

echo Step 1: Starting backend server...
echo Backend will run on port 4000
start "Restaurant Backend" cmd /k "echo Backend server starting... && cd /d %~dp0 && node simple_backend.js"

echo.
echo Step 2: Waiting for backend to start...
timeout /t 3 /nobreak >nul

echo Step 3: Opening frontend...
echo Frontend will connect to the backend automatically
start "" "restaurant_with_backend.html"

echo.
echo ========================================
echo FULL APP STARTED
echo ========================================
echo.
echo Backend: http://localhost:4000
echo Frontend: restaurant_with_backend.html
echo.
echo Features available:
echo ✅ User registration and login
echo ✅ Menu browsing
echo ✅ Shopping cart
echo ✅ Order placement
echo ✅ Order history
echo ✅ Real-time data storage
echo.
echo Default login credentials:
echo Username: admin
echo Password: admin123
echo.
echo Or register a new account!
echo.
echo Check the backend window for server logs.
echo.
pause
