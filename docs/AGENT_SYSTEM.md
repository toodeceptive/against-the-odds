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

### Orchestration (multi-agent)

- **Prompt**: `prompts/head-guru-orchestrator.md` or `prompts/MASTER_10_EXPERT_SYSTEM.md`
- **Capabilities**: Finalization, reconciliation, sequential expert audits
- **Use Case**: Full project audit and perfection; see `docs/AGENT_PROMPT_DECISION_TREE.md`

### Phase 0 / entry

- **Prompt**: `prompts/PERFECT_EXECUTION_PROMPT.md`
- **Focus**: Phase 0 gate and execution quality
- **Use Case**: Entry before any other work; sign-off in `docs/status/PHASE_0_FINALIZATION.md`

### Single-domain experts

- **Prompts**: `prompts/expert-01-security-secrets.md` through `prompts/expert-10-developer-experience.md`
- **Focus**: Security, performance, code quality, testing, docs, CI/CD, integrations, frontend, data, DevEx
- **Use Case**: Deep dive on one domain; see decision tree

## Usage

### Starting an Agent

1. **Open new Cursor instance**
2. **Read** `docs/status/PLAN_AGENT_ENTRY.md` and complete Phase 0 per `prompts/PERFECT_EXECUTION_PROMPT.md`
3. **Choose prompt** from `docs/AGENT_PROMPT_DECISION_TREE.md` (orchestrator, MASTER_10, expert-N, finalization-\*)
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
  requireConfirmation: true,
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
- [Agent Prompt Decision Tree](AGENT_PROMPT_DECISION_TREE.md)
- [Head Guru Orchestrator](../prompts/head-guru-orchestrator.md)
