@echo off
setlocal enabledelayedexpansion

echo ========================================
echo MANUAL BUILD SCRIPT - NPM WORKAROUND
echo ========================================
echo.

rem Resolve project root
set "ROOT=%~dp0"

rem Check if Node.js is available
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js not found in PATH
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

echo Node.js found. Checking for TypeScript...

rem Check if TypeScript is available globally
where tsc >nul 2>&1
if %errorlevel% equ 0 (
    echo TypeScript found globally. Building...
    pushd "%ROOT%server"
    call tsc -p tsconfig.json
    if %errorlevel% equ 0 (
        echo Build successful!
        popd
        goto :success
    ) else (
        echo Build failed with global TypeScript
        popd
    )
)

rem Check if TypeScript is in node_modules
if exist "%ROOT%server\node_modules\typescript\bin\tsc" (
    echo TypeScript found in node_modules. Building...
    pushd "%ROOT%server"
    call node node_modules\typescript\bin\tsc -p tsconfig.json
    if %errorlevel% equ 0 (
        echo Build successful!
        popd
        goto :success
    ) else (
        echo Build failed with local TypeScript
        popd
    )
)

rem Try using npx
where npx >nul 2>&1
if %errorlevel% equ 0 (
    echo Trying npx tsc...
    pushd "%ROOT%server"
    call npx tsc -p tsconfig.json
    if %errorlevel% equ 0 (
        echo Build successful with npx!
        popd
        goto :success
    ) else (
        echo Build failed with npx
        popd
    )
)

echo.
echo ========================================
echo BUILD FAILED - MANUAL INSTALLATION NEEDED
echo ========================================
echo.
echo To fix this, try one of these methods:
echo.
echo METHOD 1 - Install TypeScript globally:
echo   npm install -g typescript
echo   Then run this script again
echo.
echo METHOD 2 - Use yarn instead of npm:
echo   npm install -g yarn
echo   yarn install
echo   yarn build
echo.
echo METHOD 3 - Use pnpm instead of npm:
echo   npm install -g pnpm
echo   pnpm install
echo   pnpm build
echo.
echo METHOD 4 - Manual compilation:
echo   Go to server folder and run: node node_modules\typescript\bin\tsc
echo.
pause
exit /b 1

:success
echo.
echo ========================================
echo BUILD COMPLETED SUCCESSFULLY!
echo ========================================
echo.
echo You can now run the main application using:
echo   start_app_workaround.bat
echo   or
echo   start_app.ps1
echo.
pause
