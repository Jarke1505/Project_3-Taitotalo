@echo off
echo ========================================
echo AMBER & THYME BACKEND SERVER
echo ========================================
echo.

echo Starting backend server on port 4000...
echo Backend will be available at: http://localhost:4000
echo.
echo API endpoints:
echo - GET  /api/health     - Health check
echo - GET  /api/menu       - Get menu items
echo - POST /api/login      - User login
echo - POST /api/register   - User registration
echo - POST /api/orders     - Create order
echo - GET  /api/orders     - Get orders
echo - POST /api/contact    - Submit contact message
echo - GET  /api/contact    - Get contact messages
echo.
echo Press Ctrl+C to stop the server
echo.

cd /d %~dp0
node simple_backend.js