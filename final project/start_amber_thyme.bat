@echo off
echo ========================================
echo AMBER & THYME RESTAURANT
echo ========================================
echo.

echo Starting your beautiful Amber & Thyme restaurant with backend!
echo.

rem Kill any existing processes
taskkill /f /im node.exe 2>nul
timeout /t 2 /nobreak >nul

echo Step 1: Starting backend server...
echo Backend will run on port 4000
start "Amber & Thyme Backend" cmd /k "echo Backend server starting... && cd /d %~dp0 && node simple_backend.js"

echo.
echo Step 2: Waiting for backend to start...
timeout /t 3 /nobreak >nul

echo Step 3: Opening your Amber & Thyme website...
echo The site will automatically connect to the backend
start "" "index.html"

echo.
echo ========================================
echo AMBER & THYME STARTED
echo ========================================
echo.
echo Your beautiful restaurant website is now running with backend!
echo.
echo Features:
echo ✅ Beautiful Amber & Thyme design
echo ✅ Full menu with cart functionality
echo ✅ Checkout system with payment options
echo ✅ Contact form with backend integration
echo ✅ Orders saved to backend
echo ✅ Real-time order processing
echo.
echo Backend: http://localhost:4000
echo Website: index.html (opened in browser)
echo.
echo To access admin dashboard:
echo Run: start_admin_dashboard.bat
echo.
echo The cart and contact form will save data to the backend!
echo Check the backend window to see data coming in.
echo.
pause
