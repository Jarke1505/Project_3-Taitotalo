@echo off
echo ========================================
echo RESTAURANT FRONTEND ONLY
echo ========================================
echo.
echo Starting frontend server (backend disabled due to npm issues)...
echo.

rem Start static frontend server
start "Restaurant Frontend" cmd /k python -m http.server 8080

rem Wait a moment for server to start
timeout /t 2 /nobreak >nul

rem Open browser
start "" "http://localhost:8080/index.html"

echo.
echo ========================================
echo FRONTEND STARTED
echo ========================================
echo Frontend: http://localhost:8080
echo Backend: DISABLED (npm issues)
echo.
echo Note: Some features may not work without the backend.
echo To fix the backend, resolve the npm issues first.
echo.
pause
