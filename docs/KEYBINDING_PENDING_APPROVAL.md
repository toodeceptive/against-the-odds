# Keybindings: Pending Approval & Theme Preview

**Purpose**: Add these **user-level** keybindings in Cursor so you can open the pending-approval file and start the theme preview with one shortcut. (Workspace keybindings are not natively supported; add once in Keyboard Shortcuts.)

**Approved (2026-01-31):** **Ctrl+Alt+T** is the approved shortcut for starting theme dev; the browser opens the preview URL automatically when the server is ready. **Ctrl+Alt+P** opens the pending-approval file.

**Added to your Cursor settings (2026-01-31):** Both keybindings have been added to your user `keybindings.json` (Ctrl+Alt+P, Ctrl+Alt+T). The theme dev task is set to reveal and focus the terminal when you run it, so the preview terminal appears automatically when you press **Ctrl+Alt+T**. If you need to re-add them (e.g. on another machine), use the steps below.

## How to add (if not already present)

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

| Shortcut       | Task                                       | Effect                                                                                               |
| -------------- | ------------------------------------------ | ---------------------------------------------------------------------------------------------------- |
| **Ctrl+Alt+P** | Open pending approval                      | Opens `docs/status/pending-approval.md` in the editor (run from repo root).                          |
| **Ctrl+Alt+T** | Shopify: Theme Dev (preview before commit) | **Approved.** Starts theme dev server; browser opens preview URL automatically (run from repo root). |

**Note**: Run Cursor with the repo root as the workspace folder so task paths resolve. See `OPERATOR_RUNBOOK.md` and `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md`. For the full workflow when you prompt an agent, see [docs/guides/WORKFLOW_PIPELINE_VISUAL_GUIDE.md](guides/WORKFLOW_PIPELINE_VISUAL_GUIDE.md).
