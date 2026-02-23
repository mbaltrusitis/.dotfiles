# notmatthew's vim files

## setup.

- `:Lazy sync`
- `:MasonInstallAll`

## Claude Code Integration (tmux workflow)

This config integrates with Claude Code CLI via MCP WebSocket for shared context.

### Architecture:
- **Neovim (Pane 1)**: Runs MCP WebSocket server invisibly in background
- **Claude CLI (Pane 2)**: Auto-discovers and connects to MCP server
- **No terminal management**: Using "none" provider - Claude runs in separate tmux pane
- **Bidirectional context**: Real-time selection tracking, file sharing, diffs

### How it works:
1. **Neovim** starts MCP WebSocket server on random port (10000-65535)
2. **Lock file** written to `~/.claude/ide/[port].lock` with connection details
3. **Claude CLI** reads lock file and connects via WebSocket
4. **Context flows** bidirectionally through MCP protocol

### Initial Setup:

**1. Install the helper script (already done):**
```bash
# Script installed at: ~/.local/bin/claude-connect
# Make sure ~/.local/bin is in your PATH
```

**2. Add to PATH (if needed):**
```bash
# Add to ~/.bashrc or ~/.zshrc:
export PATH="$HOME/.local/bin:$PATH"
```

### Daily Workflow:

**Start Neovim (Pane 1):**
```bash
nvim
# MCP server starts automatically, writes lock file
```

**Start Claude in another tmux pane (Pane 2):**
```bash
claude-connect
# Automatically connects to Neovim's MCP server
```

**Or manually:**
```bash
# In tmux pane 2
LOCK_FILE=$(ls -t ~/.claude/ide/*.lock | head -1)
PORT=$(jq -r '.port' "$LOCK_FILE")
CLAUDE_CODE_SSE_PORT="$PORT" ENABLE_IDE_INTEGRATION="true" ~/.claude/local/claude
```

### Hotkeys:

**Context sharing:**
- `<leader>cf` - Add current file to Claude context
- `<leader>cs` - Send visual selection to Claude (visual mode)

**Diff management:**
- `<leader>ca` - Accept diff from Claude
- `<leader>cd` - Deny diff from Claude

**Debugging:**
- `<leader>ci` - Show MCP server status

### Workflow Example:

1. **Edit code in Neovim** (pane 1)
   ```
   nvim myproject/src/main.rs
   ```

2. **Add file to Claude context**
   ```
   <Space>cf
   ```

3. **Switch to Claude pane** (pane 2)
   ```
   <C-b>o  # tmux: switch pane
   ```

4. **Ask Claude about the code**
   ```
   Claude has the file in context automatically!
   > "Can you refactor this function to use async?"
   ```

5. **Claude opens diff in Neovim**
   - Diff appears automatically in Neovim
   - Review changes side-by-side

6. **Accept or reject**
   ```
   <Space>ca  # Accept
   # or
   <Space>cd  # Deny
   ```

### Verification:

**Check MCP server is running:**
```vim
:ClaudeCodeStatus
" Should show: Claude Code integration is running on port XXXXX
```

**Check lock file:**
```bash
cat ~/.claude/ide/*.lock | jq
# {
#   "port": 12345,
#   "authToken": "...",
#   "ideName": "Neovim"
# }
```

**Test context sharing:**
1. Open a file in Neovim
2. Press `<Space>cf`
3. Switch to Claude pane
4. File should appear in Claude's context

### Using Neovim MCP Tools:

The MCP integration provides Claude with tools to interact with your Neovim instance:

#### File Operations

**Open Files**
```
"Open the config file at line 50"
"Show me the error in utils.lua around the authentication function"
```
Claude uses `openFile` to:
- Open files in Neovim
- Jump to specific lines
- Select text by pattern (e.g., "show me the `handle_error` function")
- Open files in background without stealing focus

**Save Files**
```
"Save the current file"
```
Claude uses `saveDocument` after making edits to persist changes.

**Check for Unsaved Changes**
```
"Is this file dirty?"
"Does this file have unsaved changes?"
```
Claude uses `checkDocumentDirty` to verify if a file needs saving.

#### Selection & Context

**Get Current Selection**
```
"What's currently selected?"
"Explain this selected code"
```
Claude uses `getCurrentSelection` to see what you have highlighted right now.

**Get Latest Selection**
```
"What did I just send you?"
"Explain the last selection I sent"
```
Claude uses `getLatestSelection` to see what you sent via `:ClaudeCodeSend` (preserved for `visual_demotion_delay_ms` duration).

**Your workflow:**
1. Highlight code in visual mode
2. Run `:ClaudeCodeSend` (or `<leader>cs`)
3. Ask Claude to analyze/explain it
4. Claude calls `getLatestSelection` to retrieve it

**Get Open Editors**
```
"What files do I have open?"
"List all open buffers"
```
Claude uses `getOpenEditors` to see your current workspace context.

**Get Workspace Folders**
```
"What's my current workspace?"
"What folders are open?"
```
Claude uses `getWorkspaceFolders` to understand the project structure.

#### Diagnostics & Errors

**Get Diagnostics**
```
"What errors are in this file?"
"Show me all warnings in the workspace"
```
Claude uses `getDiagnostics` to:
- Check for LSP errors/warnings in specific files
- Get all diagnostics across open files
- Help you fix compilation/linting issues

#### Diff View

**Open Diff**
```
"Show me the changes you made"
"Compare the old and new versions"
```
Claude uses `openDiff` to:
- Show before/after comparisons
- Preview changes before applying them
- Help you review edits side-by-side

**Close Diff Tabs**
```
"Close all the diff views"
```
Claude uses `closeAllDiffTabs` to clean up after reviews.

#### Practical Examples

**Example 1: Code Review**
```
You: "Check for errors in my current file"
Claude: *calls getDiagnostics*
        "Found 3 errors in lua/config.lua:
         - Line 42: undefined variable 'foo'
         - Line 58: missing closing bracket
         - Line 72: unused parameter 'bar'"
```

**Example 2: Code Explanation**
```
You: *Select function in visual mode, run :ClaudeCodeSend*
You: "Explain this function"
Claude: *calls getLatestSelection*
        "This function handles authentication by..."
```

**Example 3: Refactoring**
```
You: "Refactor the parse_config function"
Claude: *calls openFile to see the function*
        *suggests changes*
        *calls openDiff to show before/after*
You: "Looks good!"
Claude: *applies the edit*
        *calls saveDocument*
```

**Example 4: Navigation**
```
You: "Show me where the error is in handlers.lua"
Claude: *calls getDiagnostics*
        *calls openFile with line number and text selection*
        "I've opened handlers.lua at line 156 where the error occurs"
```

#### Tips

- **Send selections** - Use `:ClaudeCodeSend` (or `<leader>cs`) to send code snippets for analysis
- **Ask about errors** - Claude can check diagnostics and jump to error locations
- **Review changes** - Claude can show diffs before applying edits
- **Context awareness** - Claude can see what files you have open and what you're working on
- **Longer selection visibility** - The `visual_demotion_delay_ms` setting keeps selections available after exiting visual mode

### Troubleshooting:

**Claude can't connect:**
```bash
# Check if server is running
:ClaudeCodeStatus

# Check lock file exists
ls ~/.claude/ide/

# Restart Neovim to restart server
```

**"command not found: claude-connect":**
```bash
# Check script exists
ls -la ~/.local/bin/claude-connect

# Check PATH
echo $PATH | grep -o "$HOME/.local/bin"

# Add to PATH
export PATH="$HOME/.local/bin:$PATH"
```

**Port conflicts:**
```lua
-- In plugin config, restrict port range if needed
port_range = { min = 15000, max = 15100 }
```

## hotkeys.
