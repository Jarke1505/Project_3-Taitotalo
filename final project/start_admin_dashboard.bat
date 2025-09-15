@echo off
echo ========================================
echo AMBER & THYME ADMIN DASHBOARD
echo ========================================
echo.

echo Starting admin dashboard for restaurant management...
echo.

rem Check if backend is running
echo Checking if backend server is running...
curl -s http://localhost:4000/api/health >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Backend server is running
) else (
    echo ⚠️  Backend server is not running
    echo.
    echo To get full functionality, please start the backend first:
    echo 1. Run start_backend_only.bat
    echo 2. Or run start_amber_thyme.bat
    echo.
    echo The admin dashboard will still open, but won't show data.
    echo.
    pause
)

echo.
echo Opening admin dashboard...
start "" "admin_dashboard.html"

echo.
echo ========================================
echo ADMIN DASHBOARD STARTED
echo ========================================
echo.
echo Admin Dashboard: admin_dashboard.html (opened in browser)
echo.
echo Login credentials:
echo Username: admin
echo Password: admin123
echo.
echo Features:
echo ✅ View contact form submissions
echo ✅ View restaurant orders
echo ✅ Real-time statistics
echo ✅ Backend status monitoring
echo.
echo If backend is running, you'll see live data.
echo If backend is not running, you'll see connection errors.
echo.
pause
