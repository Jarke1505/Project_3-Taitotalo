@echo off
setlocal enabledelayedexpansion

rem Resolve project root (folder of this script)
set "ROOT=%~dp0"

echo ========================================
echo RESTAURANT APP - NPM WORKAROUND VERSION
echo ========================================
echo.

rem Check if Node.js is available
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js not found in PATH
    echo Please install Node.js from https://nodejs.org/
    echo Or add Node.js to your system PATH
    pause
    exit /b 1
)

rem Check if we have a pre-built dist folder
if exist "%ROOT%server\dist\index.js" (
    echo Found pre-built backend, using existing build...
    goto :start_servers
)

echo No pre-built backend found. Attempting to build...

rem Try different approaches to get dependencies and build
echo.
echo Method 1: Trying direct node execution...
if exist "%ROOT%server\node_modules" (
    echo Dependencies found, attempting TypeScript compilation...
    pushd "%ROOT%server"
    
    rem Try using npx tsc directly
    where npx >nul 2>&1
    if %errorlevel% equ 0 (
        echo Using npx tsc...
        call npx tsc -p tsconfig.json
        if %errorlevel% equ 0 (
            echo TypeScript compilation successful!
            popd
            goto :start_servers
        )
    )
    
    rem Try using node with typescript directly
    echo Trying node with typescript...
    call node node_modules/typescript/bin/tsc -p tsconfig.json
    if %errorlevel% equ 0 (
        echo TypeScript compilation successful!
        popd
        goto :start_servers
    )
    
    rem Try using ts-node to run directly
    echo Trying ts-node for direct execution...
    where ts-node >nul 2>&1
    if %errorlevel% equ 0 (
        echo Using ts-node...
        popd
        goto :start_with_tsnode
    )
    
    rem Check if ts-node is in node_modules
    if exist "%ROOT%server\node_modules\.bin\ts-node.cmd" (
        echo Using local ts-node...
        popd
        goto :start_with_tsnode
    )
    
    popd
)

echo.
echo Method 2: Manual dependency check...
pushd "%ROOT%server"

rem Check if we have the essential files
if not exist "src\index.ts" (
    echo ERROR: Source files not found!
    popd
    goto :manual_setup
)

rem Try to run with minimal setup
echo Attempting to run with existing setup...
call node -e "console.log('Node.js is working')"
if %errorlevel% neq 0 (
    echo ERROR: Node.js execution failed
    popd
    goto :manual_setup
)

popd

:manual_setup
echo.
echo Method 3: Manual setup required...
echo.
echo Since npm is not working, you have a few options:
echo.
echo OPTION A - Install Node.js properly:
echo 1. Download Node.js from https://nodejs.org/
echo 2. Install it and make sure it's added to PATH
echo 3. Run: npm install in the server folder
echo 4. Run: npm run build in the server folder
echo.
echo OPTION B - Use a different approach:
echo 1. Use yarn instead: yarn install && yarn build
echo 2. Use pnpm instead: pnpm install && pnpm build
echo 3. Use a different package manager
echo.
echo OPTION C - Manual compilation:
echo 1. Install TypeScript globally: npm install -g typescript
echo 2. Run: tsc in the server folder
echo.
echo For now, let's try to start the frontend only...
goto :start_frontend_only

:start_with_tsnode
echo Starting backend with ts-node (development mode)...
pushd "%ROOT%server"
start "Restaurant API (ts-node)" cmd /k "node node_modules\.bin\ts-node.cmd src/index.ts"
popd
goto :start_frontend

:start_servers
echo Starting backend server...
pushd "%ROOT%server"
start "Restaurant API" cmd /k "node dist/index.js"
popd

:start_frontend
echo Starting frontend server...

:start_frontend_only
rem Start static frontend server
start "Restaurant Frontend" cmd /k python -m http.server 8080

rem Wait a moment for servers to start
timeout /t 2 /nobreak >nul

rem Open browser
start "" "http://localhost:8080/index.html"

echo.
echo ========================================
echo SERVERS STARTED
echo ========================================
echo Frontend: http://localhost:8080
if exist "%ROOT%server\dist\index.js" (
    echo Backend: http://localhost:4000 (compiled)
) else if exist "%ROOT%server\node_modules\.bin\ts-node.cmd" (
    echo Backend: http://localhost:4000 (ts-node)
) else (
    echo Backend: Not started (npm issues)
)
echo.
echo If you see errors, check the server windows for details.
echo.
pause
goto :eof
