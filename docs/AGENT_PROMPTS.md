# Agent Prompt Usage Guide

## Overview

This guide explains how to use the agent prompt system for new Cursor instances. Use `docs/AGENT_PROMPT_DECISION_TREE.md` to choose the right prompt for your goal.

## Available Prompts (canonical)

### Orchestration and entry

- **`prompts/head-guru-orchestrator.md`** — Finalization and reconciliation; multi-agent coordination
- **`prompts/MASTER_10_EXPERT_SYSTEM.md`** — Sequential 10-expert run (Security → … → DevEx)
- **`prompts/PERFECT_EXECUTION_PROMPT.md`** — Phase 0 gate; read first before other work

### Single-domain experts

- **`prompts/expert-01-security-secrets.md`** through **`prompts/expert-10-developer-experience.md`** — Deep dive on one domain (security, performance, code quality, testing, docs, CI/CD, integrations, frontend, data, DevEx)

### Audits and finalization

- **`prompts/ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT.md`** — Full system audit
- **`prompts/finalization-*.md`** — Role-specific finalization (Shopify store ops, release manager, etc.)

## How to Use

### Step 1: Phase 0 first

1. Read `docs/status/PLAN_AGENT_ENTRY.md`
2. Complete Phase 0 per `prompts/PERFECT_EXECUTION_PROMPT.md`
3. Confirm sign-off in `docs/status/PHASE_0_FINALIZATION.md`

### Step 2: Choose prompt

Use **`docs/AGENT_PROMPT_DECISION_TREE.md`** to pick:

- Full system audit → `ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT.md`
- 10-expert run → `MASTER_10_EXPERT_SYSTEM.md`
- Finalization → `head-guru-orchestrator.md`
- Single domain → `expert-N-*.md`

### Step 3: Load and run

1. Open the chosen prompt file
2. Provide as system prompt or context
3. Run per prompt instructions

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

### Starting orchestration (Head Guru)

1. Complete Phase 0 per `docs/status/PLAN_AGENT_ENTRY.md` and `prompts/PERFECT_EXECUTION_PROMPT.md`
2. Load `prompts/head-guru-orchestrator.md` or `prompts/MASTER_10_EXPERT_SYSTEM.md`
3. Provide `README.md`, `NEXT_STEPS.md`, and `docs/status/INDEX_REPORTS.md` as context
4. Agent can run experts in sequence and produce sign-offs in `docs/status/`

### Single-domain expert

1. Load one of `prompts/expert-01-security-secrets.md` through `prompts/expert-10-developer-experience.md`
2. Provide repo context (README, OPERATOR_RUNBOOK)
3. Agent will audit that domain and update docs/config per prompt

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

- [Agent Prompt Decision Tree](AGENT_PROMPT_DECISION_TREE.md)
- [Head Guru Orchestrator](../prompts/head-guru-orchestrator.md)
- [MASTER_10_EXPERT_SYSTEM](../prompts/MASTER_10_EXPERT_SYSTEM.md)
- [Desktop Automation Guide](DESKTOP_AUTOMATION.md)
