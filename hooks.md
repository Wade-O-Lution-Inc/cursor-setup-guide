# Hooks

Hooks are shell scripts triggered by Cursor lifecycle events. They run before the agent takes an action, and can **block** the action by exiting with a non-zero status code. Think of them as Git pre-commit hooks, but for the AI agent.

## When to Use Hooks

Add hooks when you need to enforce **hard constraints** that rules alone can't guarantee:

| Hook Event | Fires When | Use For |
|------------|-----------|---------|
| `beforeSubmitPrompt` | Agent is about to submit a prompt to the LLM | Scanning for leaked secrets in prompts |
| `beforeShellExecution` | Agent is about to run a shell command | Blocking dangerous commands (`--no-verify`, `rm -rf /`) |
| `beforeTabFileRead` | Agent is about to read a file | Preventing reads of `.env`, `.key`, `.pem`, credential files |

Rules tell the agent what to do. Hooks enforce what it **cannot** do, even if it tries.

## Configuration

Create `.cursor/hooks.json` in your repo:

```json
{
  "hooks": [
    {
      "event": "beforeSubmitPrompt",
      "script": ".cursor/hooks/detect-secrets.sh",
      "description": "Scan prompts for leaked API keys and secrets"
    },
    {
      "event": "beforeShellExecution",
      "script": ".cursor/hooks/block-no-verify.sh",
      "description": "Prevent --no-verify in git commands"
    },
    {
      "event": "beforeTabFileRead",
      "script": ".cursor/hooks/block-sensitive-reads.sh",
      "description": "Block reading .env, .key, .pem, and credential files"
    }
  ]
}
```

Hook scripts receive the relevant content on **stdin** (the prompt text, the command to run, or the file path). They must:

- Exit `0` to allow the action
- Exit non-zero to **block** the action (stderr is shown to the user)

## The Three Hooks You Should Start With

### 1. Secret Detection (`beforeSubmitPrompt`)

Scans agent prompts and outputs for patterns that look like API keys, tokens, or credentials. Catches accidental leaks before they reach the LLM.

**Patterns to detect:**
- Anthropic keys (`sk-ant-...`)
- GitHub PATs (`ghp_...`)
- AWS access keys (`AKIA...`)
- Slack tokens (`xoxb-...`, `xoxp-...`)
- JWTs (`eyJhbGciOi...`)
- Generic secrets (`Bearer ...`, `secret_...`)

**Template:** [templates/hooks/detect-secrets.sh](templates/hooks/detect-secrets.sh)

### 2. Git Safety (`beforeShellExecution`)

Prevents the agent from bypassing Git hooks with `--no-verify` or `--no-gpg-sign`. Pre-commit hooks exist for a reason — the agent shouldn't be allowed to skip them.

**Template:** [templates/hooks/block-no-verify.sh](templates/hooks/block-no-verify.sh)

### 3. Sensitive File Blocking (`beforeTabFileRead`)

Blocks the agent from reading files that commonly contain secrets: `.env` files, private keys, PEM certificates, credential JSON files, and SSH keys.

This is defense-in-depth alongside `.cursorignore` — even if a file slips past ignore rules, the hook blocks the read.

**Template:** [templates/hooks/block-sensitive-reads.sh](templates/hooks/block-sensitive-reads.sh)

## Writing Custom Hooks

Hook scripts are plain bash. The input comes on stdin:

```bash
#!/bin/bash
INPUT=$(cat)

# Check for something bad
if echo "$INPUT" | grep -qE 'dangerous-pattern'; then
  echo "BLOCKED: Explanation of why this was blocked" >&2
  exit 1
fi

exit 0
```

### Guidelines

1. **Keep hooks fast.** They run synchronously before every action. A slow hook degrades the agent experience.
2. **Use regex, not external tools.** Don't call `curl`, `node`, or Python — keep dependencies to bash builtins and `grep`.
3. **Write clear error messages.** The stderr output is shown to the user when a hook blocks. Make it actionable.
4. **Test hooks locally.** Pipe sample input to the script: `echo "sk-ant-api03-abc123" | bash .cursor/hooks/detect-secrets.sh`
5. **Make scripts executable.** `chmod +x .cursor/hooks/*.sh`

## Hooks + Rules: Defense in Depth

Rules and hooks are complementary:

| Layer | Mechanism | Enforcement |
|-------|-----------|-------------|
| Rules (`.mdc`) | "NEVER read `.env` files" | Soft — the agent *should* follow it |
| `.cursorignore` | File-level ignore | Medium — files are hidden from the agent |
| Hooks (`hooks.json`) | Script blocks the action | Hard — the action is physically prevented |

For security-critical concerns (secrets, credential files, Git safety), use all three layers.

## Template

See [templates/hooks.json](templates/hooks.json) and the individual hook scripts in [templates/hooks/](templates/hooks/) for copy-paste starters.
