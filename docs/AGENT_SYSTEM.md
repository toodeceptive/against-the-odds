# Agent System Documentation

## Overview

The Agent System provides comprehensive desktop automation capabilities for Cursor agents, enabling full PC control, issue detection, debugging, and automated problem resolution.

## Architecture

```
Agent Prompt System
    ↓
Desktop Automation Libraries
    ↓
Screen Capture → OCR → Analysis
    ↓
Issue Detection → Debugging → Fix Application
    ↓
Verification → Reporting
```

## Agent Types

### Master Agent
- **Prompt**: `prompts/master-agent-prompt.md`
- **Capabilities**: Full desktop automation, issue detection, debugging, fixing
- **Use Case**: General purpose automation and problem solving

### Debugging Agent
- **Prompt**: `prompts/debugging-agent.md`
- **Focus**: Issue detection and resolution
- **Use Case**: Debugging specific problems

### Setup Agent
- **Prompt**: `prompts/setup-agent.md`
- **Focus**: Environment setup and configuration
- **Use Case**: Initial setup and configuration

### Testing Agent
- **Prompt**: `prompts/testing-agent.md`
- **Focus**: Testing and quality assurance
- **Use Case**: Test execution and verification

### Optimization Agent
- **Prompt**: `prompts/optimization-agent.md`
- **Focus**: Performance and code optimization
- **Use Case**: System and code optimization

## Usage

### Starting an Agent

1. **Open new Cursor instance**
2. **Load agent prompt** from `prompts/master-agent-prompt.md`
3. **Provide context** from `prompts/agent-context.md`
4. **Begin automation**

### Basic Workflow

```javascript
// Agent would use these functions:

// 1. Detect issues
const issues = await detectIssues();

// 2. Debug issue
const debug = await debugIssue(issues[0]);

// 3. Generate solution
const solution = await generateSolution(issues[0], { autoApply: false });

// 4. Apply fix (with confirmation)
const result = await applyFix(issues[0], solution.solution, {
  requireConfirmation: true
});
```

## Available Libraries

### Screen Operations
- `screen-capture.js` - Screen capture
- `ocr-reader.js` - OCR text extraction
- `screen-analyzer.js` - Screen analysis

### Input Control
- `mouse-control.js` - Mouse automation
- `keyboard-control.js` - Keyboard automation
- `input-simulator.js` - High-level input

### Window Management
- `window-manager.js` - Window operations

### Issue Management
- `issue-detector.js` - Issue detection
- `pattern-matcher.js` - Pattern matching
- `state-comparator.js` - State comparison

### Debugging and Fixing
- `debugger.js` - Automated debugging
- `fix-applier.js` - Fix application
- `solution-engine.js` - Solution generation

### Application Automation
- `apps/cursor-automation.js` - Cursor IDE
- `apps/browser-automation.js` - Browser control
- `apps/system-apps.js` - System applications
- `apps/file-explorer.js` - File Explorer

### Safety and Orchestration
- `safety-manager.js` - Safety controls
- `confirmation-system.js` - Confirmation handling
- `orchestrator.js` - Main orchestrator
- `task-executor.js` - Task execution
- `workflow-manager.js` - Workflow management

## Safety Features

### Confirmation Requirements
- Destructive operations
- Credential changes
- System modifications
- Application restarts

### Safety Measures
- Action logging
- Rollback support
- Emergency stop
- Scope limiting

## Integration

### With Existing Scripts
Agents can use existing PowerShell scripts:
- Environment setup
- Credential verification
- Health monitoring
- API operations

### With Browser Automation
Agents can use Playwright for web automation:
- Shopify admin automation
- Web application testing
- Data extraction

## Best Practices

1. **Always capture screen first** before taking action
2. **Verify issues exist** before attempting fixes
3. **Require confirmation** for sensitive operations
4. **Log all actions** for audit trail
5. **Support rollback** for all fixes
6. **Use existing tools** when available
7. **Report clearly** all actions and results

## Troubleshooting

### Agent Not Responding
- Check emergency stop status
- Verify screen capture working
- Check OCR accuracy
- Review action logs

### Fixes Not Working
- Check fix strategy confidence
- Verify root cause analysis
- Review error logs
- Try alternative approaches

### Performance Issues
- Reduce monitoring frequency
- Cache screen captures
- Optimize OCR calls
- Batch operations

## References

- [Desktop Automation Guide](DESKTOP_AUTOMATION.md)
- [Agent Prompts Guide](AGENT_PROMPTS.md)
- [Master Agent Prompt](../prompts/master-agent-prompt.md)
