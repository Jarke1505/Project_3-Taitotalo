# Restaurant App - PowerShell Workaround
# This script provides multiple fallback methods when npm fails

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "RESTAURANT APP - POWERSHELL WORKAROUND" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get project root
$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path

# Check if Node.js is available
try {
    $nodeVersion = node --version 2>$null
    Write-Host "Node.js found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Node.js not found!" -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Check for pre-built backend
if (Test-Path "$ROOT\server\dist\index.js") {
    Write-Host "Found pre-built backend, using existing build..." -ForegroundColor Green
    $usePreBuilt = $true
} else {
    Write-Host "No pre-built backend found. Attempting to build..." -ForegroundColor Yellow
    $usePreBuilt = $false
}

# Function to try building the backend
function Build-Backend {
    Push-Location "$ROOT\server"
    
    try {
        # Method 1: Try npx tsc
        Write-Host "Trying npx tsc..." -ForegroundColor Yellow
        npx tsc -p tsconfig.json
        if ($LASTEXITCODE -eq 0) {
            Write-Host "TypeScript compilation successful with npx!" -ForegroundColor Green
            Pop-Location
            return $true
        }
    } catch {
        Write-Host "npx tsc failed" -ForegroundColor Red
    }
    
    try {
        # Method 2: Try node with typescript directly
        Write-Host "Trying node with typescript..." -ForegroundColor Yellow
        node node_modules/typescript/bin/tsc -p tsconfig.json
        if ($LASTEXITCODE -eq 0) {
            Write-Host "TypeScript compilation successful with node!" -ForegroundColor Green
            Pop-Location
            return $true
        }
    } catch {
        Write-Host "node typescript failed" -ForegroundColor Red
    }
    
    try {
        # Method 3: Try ts-node for direct execution
        Write-Host "Trying ts-node..." -ForegroundColor Yellow
        if (Test-Path "node_modules\.bin\ts-node.cmd") {
            Write-Host "Found ts-node, will use for direct execution" -ForegroundColor Green
            Pop-Location
            return "ts-node"
        }
    } catch {
        Write-Host "ts-node not found" -ForegroundColor Red
    }
    
    Pop-Location
    return $false
}

# Function to start backend
function Start-Backend {
    param($method)
    
    Push-Location "$ROOT\server"
    
    if ($method -eq "ts-node") {
        Write-Host "Starting backend with ts-node (development mode)..." -ForegroundColor Green
        Start-Process cmd -ArgumentList "/k", "node node_modules\.bin\ts-node.cmd src/index.ts" -WindowStyle Normal
    } else {
        Write-Host "Starting backend with compiled JavaScript..." -ForegroundColor Green
        Start-Process cmd -ArgumentList "/k", "node dist/index.js" -WindowStyle Normal
    }
    
    Pop-Location
}

# Function to start frontend
function Start-Frontend {
    Write-Host "Starting frontend server..." -ForegroundColor Green
    Start-Process cmd -ArgumentList "/k", "python -m http.server 8080" -WindowStyle Normal
}

# Main execution
if (-not $usePreBuilt) {
    $buildResult = Build-Backend
    
    if ($buildResult -eq $false) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Red
        Write-Host "BUILD FAILED - MANUAL SETUP REQUIRED" -ForegroundColor Red
        Write-Host "========================================" -ForegroundColor Red
        Write-Host ""
        Write-Host "Since npm is not working, you have these options:" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "OPTION A - Fix npm/Node.js:" -ForegroundColor Cyan
        Write-Host "1. Reinstall Node.js from https://nodejs.org/" -ForegroundColor White
        Write-Host "2. Make sure it's added to system PATH" -ForegroundColor White
        Write-Host "3. Run: npm install in server folder" -ForegroundColor White
        Write-Host "4. Run: npm run build in server folder" -ForegroundColor White
        Write-Host ""
        Write-Host "OPTION B - Use alternative package manager:" -ForegroundColor Cyan
        Write-Host "1. Install yarn: npm install -g yarn" -ForegroundColor White
        Write-Host "2. Run: yarn install && yarn build" -ForegroundColor White
        Write-Host ""
        Write-Host "OPTION C - Manual TypeScript compilation:" -ForegroundColor Cyan
        Write-Host "1. Install TypeScript globally: npm install -g typescript" -ForegroundColor White
        Write-Host "2. Run: tsc in the server folder" -ForegroundColor White
        Write-Host ""
        Write-Host "For now, starting frontend only..." -ForegroundColor Yellow
        Start-Frontend
        Start-Sleep 2
        Start-Process "http://localhost:8080/index.html"
        Read-Host "Press Enter to exit"
        exit 0
    } else {
        Start-Backend $buildResult
    }
} else {
    Start-Backend "compiled"
}

# Start frontend
Start-Frontend

# Wait a moment for servers to start
Start-Sleep 3

# Open browser
Write-Host "Opening browser..." -ForegroundColor Green
Start-Process "http://localhost:8080/index.html"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "SERVERS STARTED SUCCESSFULLY" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Frontend: http://localhost:8080" -ForegroundColor White
Write-Host "Backend: http://localhost:4000" -ForegroundColor White
Write-Host ""
Write-Host "Check the server windows for any error messages." -ForegroundColor Yellow
Write-Host "Press Ctrl+C in this window to stop the servers." -ForegroundColor Yellow

# Keep the script running
try {
    while ($true) {
        Start-Sleep 1
    }
} catch {
    Write-Host "Script stopped." -ForegroundColor Yellow
}
