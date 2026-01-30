# Keybindings: Pending Approval & Theme Preview

**Purpose**: Add these **user-level** keybindings in Cursor so you can open the pending-approval file and start the theme preview with one shortcut. (Workspace keybindings are not natively supported; add once in Keyboard Shortcuts.)

## How to add

1. **Open Keyboard Shortcuts**: `Ctrl+K Ctrl+S` (or **File → Preferences → Keyboard Shortcuts**).
2. **Open keybindings.json**: Click the **{}** icon (Open Keyboard Shortcuts (JSON)) to edit user `keybindings.json`.
3. **Add** these entries inside the `[]` array:

```json
{
  "key": "ctrl+alt+p",
  "command": "workbench.action.tasks.runTask",
  "args": "Open pending approval"
},
{
  "key": "ctrl+alt+t",
  "command": "workbench.action.tasks.runTask",
  "args": "Shopify: Theme Dev (preview before commit)"
}
```

4. Save the file. If Cursor does not accept `args` for runTask, use **Tasks: Run Task** from the Command Palette and bind the key to that, then choose the task when prompted; or run the task from **Terminal → Run Task**.

## What they do

| Shortcut       | Task                                       | Effect                                                                      |
| -------------- | ------------------------------------------ | --------------------------------------------------------------------------- |
| **Ctrl+Alt+P** | Open pending approval                      | Opens `docs/status/pending-approval.md` in the editor (run from repo root). |
| **Ctrl+Alt+T** | Shopify: Theme Dev (preview before commit) | Starts theme dev server; browser opens preview URL (run from repo root).    |

**Note**: Run Cursor with the repo root as the workspace folder so task paths resolve. See `OPERATOR_RUNBOOK.md` and `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md`.
