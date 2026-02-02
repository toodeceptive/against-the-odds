# Desktop Automation Guide

## Overview

This guide covers the desktop automation system that enables full PC control through screen viewing, mouse/keyboard automation, window management, and automated issue detection and resolution.

## Core Components

### Screen Capture

Capture screen content in various ways:

```javascript
import {
  captureScreen,
  captureRegion,
  captureWindow,
} from './src/desktop-automation/screen-capture.js';

// Capture full screen
const screenshot = await captureScreen();

// Capture specific region
const region = await captureRegion({ x: 0, y: 0, width: 1920, height: 1080 });

// Capture specific window
const window = await captureWindow('Cursor');
```

### OCR Text Extraction

Extract and read text from screens:

```javascript
import { extractText, findTextOnScreen } from './src/desktop-automation/ocr-reader.js';

// Extract all text
const ocrResult = await extractText(screenshot);

// Find specific text
const matches = await findTextOnScreen(screenshot, 'Error');
```

### Mouse Control

Control mouse operations:

```javascript
import { moveMouse, clickMouse, dragAndDrop } from './src/desktop-automation/mouse-control.js';

// Move mouse
await moveMouse(100, 100);

// Click
await clickMouse('left', { x: 100, y: 100 });

// Drag and drop
await dragAndDrop(100, 100, 200, 200);
```

### Keyboard Control

Control keyboard input:

```javascript
import { typeText, pressKey, Shortcuts } from './src/desktop-automation/keyboard-control.js';

// Type text
await typeText('Hello World');

// Press key combination
await pressKey(['control', 's']);

// Use shortcuts
await Shortcuts.save();
```

### Window Management

Manage application windows:

```javascript
import {
  findWindow,
  activateWindow,
  getAllWindows,
} from './src/desktop-automation/window-manager.js';

// Find window
const window = await findWindow('Cursor');

// Activate window
await activateWindow(window);

// Get all windows
const windows = await getAllWindows();
```

## Issue Detection

### Automatic Detection

```javascript
import { detectIssues } from './src/desktop-automation/issue-detector.js';

// Detect all issues
const issues = await detectIssues();

// Detect issues for specific application
const cursorIssues = await detectIssues({ application: 'cursor' });
```

### Continuous Monitoring

```javascript
import { monitorIssues } from './src/desktop-automation/issue-detector.js';

// Monitor continuously
const stopMonitoring = await monitorIssues({
  interval: 5000,
  onIssue: (issue) => {
    console.log('New issue detected:', issue);
  },
});

// Stop monitoring later
stopMonitoring();
```

## Debugging and Fixing

### Debug Issue

```javascript
import { debugIssue } from './src/desktop-automation/debugger.js';

// Debug an issue
const debug = await debugIssue(issue);
console.log('Root cause:', debug.rootCause);
console.log('Fix strategy:', debug.fixStrategy);
```

### Generate Solution

```javascript
import { generateSolution } from './src/desktop-automation/solution-engine.js';

// Generate solution
const solution = await generateSolution(issue, {
  autoApply: false,
  requireConfirmation: true,
});
```

### Apply Fix

```javascript
import { applyFix } from './src/desktop-automation/fix-applier.js';

// Apply fix
const result = await applyFix(issue, fixStrategy, {
  requireConfirmation: true,
  verifyAfter: true,
});
```

## Application Automation

### Cursor IDE

```javascript
import {
  openFile,
  executeCommand,
  saveFile,
} from './src/desktop-automation/apps/cursor-automation.js';

// Open file
await openFile('package.json');

// Execute command
await executeCommand('Git: Pull');

// Save file
await saveFile();
```

### Browser

```javascript
import {
  activateBrowser,
  navigateToURL,
} from './src/desktop-automation/apps/browser-automation.js';

// Activate Chrome
await activateBrowser('chrome');

// Navigate to URL
await navigateToURL('https://aodrop.com/admin');
```

### System Apps

```javascript
import { openFileExplorer, openPowerShell } from './src/desktop-automation/apps/system-apps.js';

// Open File Explorer
await openFileExplorer('C:\\Users\\LegiT\\against-the-odds');

// Open PowerShell
await openPowerShell();
```

## Safety and Confirmation

### Check if Confirmation Required

```javascript
import { requiresConfirmation } from './src/desktop-automation/safety-manager.js';

if (requiresConfirmation('delete file')) {
  // Request confirmation
}
```

### Request Confirmation

```javascript
import { requestConfirmation } from './src/desktop-automation/confirmation-system.js';

const confirmed = await requestConfirmation('Delete file', {
  description: 'This will permanently delete the file',
});
```

## Orchestration

### Use Orchestrator

```javascript
import { createOrchestrator } from './src/desktop-automation/orchestrator.js';

// Create orchestrator
const orchestrator = createOrchestrator({
  autoDetect: true,
  autoFix: true,
  requireConfirmation: true,
  monitoring: true,
});

// Start orchestrator
await orchestrator.start();

// Stop later
orchestrator.stop();
```

## Workflows

### Predefined Workflows

```javascript
import { executeWorkflow } from './src/desktop-automation/workflow-manager.js';

// Execute health check workflow
await executeWorkflow('healthCheck');

// Execute detect and fix workflow
await executeWorkflow('detectAndFix');
```

## Best Practices

1. **Always capture screen** before analysis
2. **Verify issues** before fixing
3. **Require confirmation** for sensitive operations
4. **Log all actions** for audit
5. **Support rollback** for fixes
6. **Use existing scripts** when available
7. **Handle errors gracefully**
8. **Report clearly** all results

## Troubleshooting

### Screen Capture Fails

- Check permissions
- Verify display is accessible
- Try alternative capture method

### OCR Inaccurate

- Improve screen quality
- Adjust OCR settings
- Use region capture for better accuracy

### Mouse/Keyboard Not Working

- Check RobotJS installation
- Verify permissions
- Use PowerShell fallback

### Window Not Found

- Check window title variations
- Try partial matches
- List all windows first

## References

- [Agent System](AGENT_SYSTEM.md)
- [Agent Prompts](AGENT_PROMPTS.md)
- [Head Guru Orchestrator](../prompts/head-guru-orchestrator.md)
