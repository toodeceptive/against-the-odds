# Installation Instructions - Fixing 142 Problems

## Current Issue

`robotjs` requires Visual Studio Build Tools for native compilation. This is blocking the full install, but we can work around it.

## Quick Fix - Install Without robotjs

Run these commands in PowerShell:

```powershell
cd C:\Users\LegiT\against-the-odds

# Option 1: Install ignoring build scripts (robotjs will fail but others install)
npm install --ignore-scripts

# Option 2: If Option 1 doesn't work, remove robotjs temporarily
# Edit package.json and remove the "robotjs" line from dependencies
# Then run: npm install
```

## After Install Completes

Once npm install works (even if robotjs fails), run:

```powershell
npm run lint
```

This will show the **142 ESLint problems** that need fixing.

## robotjs Alternative

The code already has PowerShell fallbacks for mouse/keyboard control, so `robotjs` is optional. You can:

1. **Skip robotjs for now** - The system will use PowerShell fallbacks
2. **Install Visual Studio Build Tools later** if you want native mouse/keyboard control
3. **Focus on fixing the 142 linting problems first**

## Next Steps

1. Get `npm install` to complete (even if robotjs fails)
2. Run `npm run lint` to see the 142 problems
3. Paste the lint output here so I can fix all 142 issues
