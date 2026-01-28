# Agent Best Practices

## General Practices

### 1. Screen Analysis First
Always capture and analyze screen before taking action:
```javascript
const analysis = await analyzeScreen();
// Then act based on analysis
```

### 2. Verify Before Acting
Verify elements exist before interacting:
```javascript
const element = await findElementByText('Button');
if (element) {
  await clickMouse('left', { x: element.position.x, y: element.position.y });
}
```

### 3. Require Confirmation
Always confirm destructive operations:
```javascript
if (requiresConfirmation(action)) {
  const confirmed = await requestConfirmation(action, details);
  if (!confirmed) return;
}
```

### 4. Log All Actions
Maintain comprehensive logs:
```javascript
orchestrator.logAction('click', 'Clicked Save button', { x: 100, y: 200 });
```

### 5. Handle Errors Gracefully
Always handle errors:
```javascript
try {
  await performAction();
} catch (error) {
  console.error('Action failed:', error);
  // Provide fallback or manual instructions
}
```

## Issue Detection Practices

### Comprehensive Detection
- Check multiple issue types
- Consider application context
- Look for patterns
- Track state changes

### Prioritization
- Fix high severity first
- Address blocking issues
- Consider dependencies
- Batch related fixes

## Fix Application Practices

### Strategy First
- Generate fix strategy before applying
- Assess automation feasibility
- Calculate confidence
- Plan rollback

### Step-by-Step Execution
- Execute steps sequentially
- Verify after each step
- Handle step failures
- Support partial completion

### Verification
- Always verify fixes
- Compare before/after states
- Check for new issues
- Confirm functionality

## Safety Practices

### Confirmation Rules
- Always confirm destructive ops
- Confirm credential changes
- Confirm system modifications
- Confirm application restarts

### Rollback Support
- Enable rollback for all fixes
- Track state changes
- Support undo operations
- Document rollback procedures

## Performance Practices

### Optimization
- Cache screen captures
- Minimize OCR calls
- Batch operations
- Use efficient selectors

### Monitoring
- Monitor performance
- Track execution times
- Identify bottlenecks
- Optimize slow operations

## Integration Practices

### Use Existing Tools
- Leverage existing scripts
- Use browser automation
- Integrate with APIs
- Reuse utilities

### Extend Functionality
- Build on existing automation
- Add new capabilities
- Integrate with workflows
- Enhance existing scripts

## Reporting Practices

### Action Reports
- Document all actions
- Report issues found
- Report fixes applied
- Note remaining issues

### Logging
- Log all operations
- Include timestamps
- Capture screenshots
- Maintain audit trail

## References

- [Master Agent Prompt](../../prompts/master-agent-prompt.md)
- [Desktop Automation Guide](../DESKTOP_AUTOMATION.md)
- [Agent System](../AGENT_SYSTEM.md)
