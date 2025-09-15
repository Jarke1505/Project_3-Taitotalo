@echo off
echo ========================================
echo WINDOWS FIREWALL FIX
echo ========================================
echo.

echo This script will help fix Windows Firewall issues.
echo.

echo Step 1: Checking if Windows Firewall is running...
netsh advfirewall show allprofiles state
echo.

echo Step 2: Adding firewall rules for our ports...
echo Adding rule for port 3000...
netsh advfirewall firewall add rule name="Restaurant App Frontend" dir=in action=allow protocol=TCP localport=3000
echo Adding rule for port 4000...
netsh advfirewall firewall add rule name="Restaurant App Backend" dir=in action=allow protocol=TCP localport=4000
echo Adding rule for port 8080...
netsh advfirewall firewall add rule name="Restaurant App Alt" dir=in action=allow protocol=TCP localport=8080

echo.
echo Step 3: Checking if rules were added...
netsh advfirewall firewall show rule name="Restaurant App Frontend"
echo.

echo ========================================
echo FIREWALL RULES ADDED
echo ========================================
echo.
echo Firewall rules have been added for ports 3000, 4000, and 8080.
echo.
echo Now try running: start_with_different_port.bat
echo.
echo If you still have issues:
echo 1. Check Windows Defender settings
echo 2. Check if you have other antivirus software
echo 3. Try running as Administrator
echo.
pause
