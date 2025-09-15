# NPM Workarounds for Restaurant App

Since you're experiencing npm issues, I've created several workaround solutions to get your restaurant app running.

## Available Workaround Scripts

### 1. `start_app_workaround.bat` (Recommended)
- **What it does**: Tries multiple methods to build and run the app
- **Features**:
  - Attempts npm, npx, and direct node execution
  - Falls back to ts-node if compilation fails
  - Provides clear error messages and solutions
  - Starts both frontend and backend

**Usage**: Double-click `start_app_workaround.bat`

### 2. `start_app.ps1` (PowerShell Version)
- **What it does**: PowerShell version with better error handling
- **Features**:
  - More detailed status messages
  - Better error reporting
  - Interactive troubleshooting
  - Keeps running to monitor servers

**Usage**: Right-click → "Run with PowerShell" or run `powershell -ExecutionPolicy Bypass -File start_app.ps1`

### 3. `manual_build.bat`
- **What it does**: Attempts to build the TypeScript backend only
- **Features**:
  - Tries global TypeScript, local TypeScript, and npx
  - Provides specific installation instructions if it fails
  - Only builds, doesn't start servers

**Usage**: Run this first if you want to build manually, then use other scripts

### 4. `start_frontend_only.bat`
- **What it does**: Starts only the frontend (no backend)
- **Features**:
  - Works even if backend can't be built
  - Good for testing frontend functionality
  - Minimal dependencies

**Usage**: Use this if backend continues to fail

## Step-by-Step Troubleshooting

### If npm is completely broken:

1. **Try the workaround scripts first**:
   ```
   start_app_workaround.bat
   ```

2. **If that fails, try manual build**:
   ```
   manual_build.bat
   ```

3. **If build succeeds, run the app**:
   ```
   start_app_workaround.bat
   ```

4. **If everything fails, use frontend only**:
   ```
   start_frontend_only.bat
   ```

### Alternative Package Managers

If npm is broken, try these alternatives:

#### Option A: Use Yarn
```bash
# Install yarn globally
npm install -g yarn

# In the server folder
yarn install
yarn build
```

#### Option B: Use pnpm
```bash
# Install pnpm globally
npm install -g pnpm

# In the server folder
pnpm install
pnpm build
```

#### Option C: Manual TypeScript Installation
```bash
# Install TypeScript globally
npm install -g typescript

# Build manually
cd server
tsc -p tsconfig.json
```

### If Node.js itself is broken:

1. **Reinstall Node.js**:
   - Download from https://nodejs.org/
   - Choose LTS version
   - Make sure to check "Add to PATH" during installation

2. **Verify installation**:
   ```bash
   node --version
   npm --version
   ```

3. **Try the workaround scripts again**

## What Each Script Does

### Backend Building Process:
1. Checks for pre-built `dist` folder
2. If not found, tries to compile TypeScript using:
   - `npx tsc` (if npx works)
   - `node node_modules/typescript/bin/tsc` (direct execution)
   - `ts-node` for direct TypeScript execution
3. Falls back to frontend-only mode if all methods fail

### Frontend Serving:
- Uses Python's built-in HTTP server on port 8080
- Serves static files from the project root
- Opens browser automatically

### Backend Serving:
- Runs compiled JavaScript from `dist/index.js`
- Or runs TypeScript directly with `ts-node`
- Listens on port 4000
- Connects to MongoDB (local or Atlas)

## Expected Results

### Success:
- Frontend: http://localhost:8080
- Backend: http://localhost:4000
- Browser opens automatically
- Two command windows stay open (one for each server)

### Partial Success (Frontend Only):
- Frontend: http://localhost:8080
- Backend: Not running
- Some features may not work (user authentication, data persistence)

### Failure:
- Clear error messages explaining what went wrong
- Specific instructions for fixing the issues
- Fallback options provided

## Common Issues and Solutions

### "Node.js not found"
- Install Node.js from https://nodejs.org/
- Make sure it's added to system PATH

### "TypeScript not found"
- Run: `npm install -g typescript`
- Or use one of the alternative package managers

### "Dependencies not found"
- Run: `npm install` in the server folder
- Or use yarn/pnpm instead

### "Port already in use"
- Close other applications using ports 8080 or 4000
- Or modify the scripts to use different ports

## File Structure After Successful Build

```
final project/
├── server/
│   ├── dist/           # Compiled JavaScript (created by build)
│   │   └── index.js
│   ├── src/            # TypeScript source files
│   ├── node_modules/   # Dependencies
│   └── package.json
├── start_app_workaround.bat
├── start_app.ps1
├── manual_build.bat
├── start_frontend_only.bat
└── index.html          # Frontend files
```

## Need More Help?

If none of these workarounds solve your npm issues, the problem might be:
1. Corrupted Node.js installation
2. System PATH issues
3. Antivirus blocking npm
4. Corporate firewall/proxy issues
5. Windows permissions problems

In that case, consider:
- Reinstalling Node.js completely
- Running as administrator
- Checking antivirus settings
- Using a different development environment (like VS Code with integrated terminal)
