# Desktop Automation Patterns

## Common Patterns

### Pattern 1: Detect and Fix Issue

```javascript
// 1. Detect issues
const issues = await detectIssues();

// 2. For each issue, debug and fix
for (const issue of issues) {
  const debug = await debugIssue(issue);
  const solution = await generateSolution(issue);
  if (solution.solution.automated && solution.solution.confidence > 70) {
    await applyFix(issue, solution.solution);
  }
}
```

### Pattern 2: Screen Analysis Workflow

```javascript
// 1. Capture screen
const screenshot = await captureScreen();

// 2. Extract text
const text = await extractText(screenshot);

// 3. Analyze for issues
const analysis = await analyzeScreen();

// 4. Act on findings
if (analysis.issues.length > 0) {
  // Handle issues
}
```

### Pattern 3: Application Navigation

```javascript
// 1. Find application window
const window = await findWindow('Cursor');

// 2. Activate window
await activateWindow(window);

// 3. Navigate within application
await clickOnText('File');
await navigateMenu(['File', 'Open']);
```

### Pattern 4: Form Filling

```javascript
// 1. Find form field
await clickOnText('Email');

// 2. Fill field
await fillFormField('Email', 'user@example.com');

// 3. Submit form
await clickButton('Submit');
```

## Best Practices

1. **Always capture first**: Screen capture before action
2. **Verify before acting**: Confirm element exists
3. **Use retries**: Implement retry logic
4. **Handle errors**: Graceful error handling
5. **Log everything**: Comprehensive logging
6. **Confirm sensitive ops**: Require confirmation
7. **Verify results**: Check success after action

## Anti-Patterns to Avoid

1. **Don't skip confirmation** for destructive operations
2. **Don't assume elements exist** - always verify
3. **Don't ignore errors** - handle gracefully
4. **Don't skip logging** - audit trail is critical
5. **Don't hardcode coordinates** - use element detection

## Performance Tips

1. **Cache screen captures** when possible
2. **Batch operations** to reduce overhead
3. **Use efficient selectors** for element finding
4. **Minimize OCR calls** - cache results
5. **Parallel operations** when safe

## References

- [Desktop Automation Guide](../DESKTOP_AUTOMATION.md)
- [Agent System](../AGENT_SYSTEM.md)
