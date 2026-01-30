# Agent Prompt Usage Guide

## Overview

This guide explains how to use the agent prompt system for new Cursor instances to enable full desktop automation capabilities.

## Available Prompts

### Master Agent Prompt

**File**: `prompts/master-agent-prompt.md`

**Purpose**: Main prompt for general-purpose desktop automation agents

**Use When**: Starting a new Cursor agent for comprehensive automation

**Key Features**:

- Full desktop automation capabilities
- Issue detection and resolution
- Screen viewing and analysis
- Mouse/keyboard control
- Window management

### Specialized Agent Prompts

#### Debugging Agent

**File**: `prompts/debugging-agent.md`

**Use When**: Focused on debugging and fixing issues

**Specialization**: Issue detection, root cause analysis, fix application

#### Setup Agent

**File**: `prompts/setup-agent.md`

**Use When**: Setting up environment and configuring tools

**Specialization**: Environment setup, tool installation, configuration

#### Testing Agent

**File**: `prompts/testing-agent.md`

**Use When**: Running tests and quality verification

**Specialization**: Test execution, quality checks, verification

#### Optimization Agent

**File**: `prompts/optimization-agent.md`

**Use When**: Optimizing performance and code quality

**Specialization**: Performance optimization, code improvement

## How to Use

### Step 1: Choose Agent Type

Decide which agent type fits your needs:

- **Master Agent**: General automation
- **Debugging Agent**: Fixing issues
- **Setup Agent**: Configuration
- **Testing Agent**: Quality assurance
- **Optimization Agent**: Performance improvement

### Step 2: Load Prompt

In new Cursor instance:

1. Open the appropriate prompt file
2. Copy the prompt content
3. Provide to the agent as system prompt or context

### Step 3: Provide Context

Also provide context information:

- `prompts/agent-context.md` - Project context
- `prompts/agent-capabilities.md` - Available capabilities

### Step 4: Start Automation

Agent can now:

- View and analyze screens
- Control mouse and keyboard
- Manage windows
- Detect and fix issues
- Automate workflows

## Prompt Structure

### Master Prompt Components

1. **System Role**: Defines agent's role and permissions
2. **Capabilities**: Lists all available capabilities
3. **Workflow**: Describes issue resolution workflow
4. **Safety Rules**: Confirmation and safety requirements
5. **Usage Instructions**: How to use the capabilities
6. **Best Practices**: Guidelines for effective use
7. **Integration**: How to use with existing systems

### Specialized Prompt Components

1. **Role**: Specialized focus area
2. **Methodology**: Specific approach for the specialization
3. **Tools**: Relevant tools and libraries
4. **Workflows**: Specialized workflows
5. **Success Criteria**: How to measure success

## Example Usage

### Starting Master Agent

1. Open new Cursor instance
2. Load `prompts/master-agent-prompt.md`
3. Provide `prompts/agent-context.md` as context
4. Agent can now:
   - Detect issues automatically
   - Debug problems
   - Apply fixes
   - Report results

### Starting Debugging Agent

1. Open new Cursor instance
2. Load `prompts/debugging-agent.md`
3. Provide issue description
4. Agent will:
   - Analyze the issue
   - Identify root cause
   - Generate fix strategy
   - Apply fix (with confirmation)

## Integration with Project

### Use Existing Scripts

Agents can execute existing PowerShell scripts:

```javascript
execSync('powershell -ExecutionPolicy Bypass -File scripts/setup/auto-configure-env.ps1');
```

### Use Browser Automation

Agents can use Playwright for web automation:

```javascript
import { connectToBrowser } from './src/browser-automation/shopify-admin.js';
const browser = await connectToBrowser();
```

### Use API Integrations

Agents can use API scripts:

```javascript
execSync('powershell -ExecutionPolicy Bypass -File scripts/shopify/test-connection.ps1');
```

## Safety Considerations

### Confirmation Flow

1. Agent detects action requires confirmation
2. Agent presents confirmation request
3. User confirms or rejects
4. Agent proceeds or cancels
5. Agent logs the decision

### Emergency Stop

Agents support emergency stop:

- Set emergency stop flag
- All automation halts immediately
- Resume when safe

## Best Practices

1. **Start with Master Agent** for general automation
2. **Use Specialized Agents** for specific tasks
3. **Provide Context** for better results
4. **Monitor Actions** through logs
5. **Verify Results** after automation
6. **Review Reports** for insights

## Troubleshooting

### Agent Not Working

- Verify prompt loaded correctly
- Check context provided
- Review capability documentation
- Check dependencies installed

### Actions Not Executing

- Check emergency stop status
- Verify confirmation provided
- Review safety rules
- Check permissions

## References

- [Master Agent Prompt](../prompts/master-agent-prompt.md)
- [Agent Context](../prompts/agent-context.md)
- [Agent Capabilities](../prompts/agent-capabilities.md)
- [Desktop Automation Guide](DESKTOP_AUTOMATION.md)
