---
name: example-skill
description: >-
  [What this skill does] and [when to use it]. Use when [specific trigger
  scenarios that help the agent match this skill to the task].
---

# [Human-Readable Title]

## When to Use

[One or two sentences describing when the agent should follow this procedure.]

## Required Inputs

- [What the agent needs from the user before starting]
- [E.g., which module, which schema, what change is needed]

## Procedure

### Step 1: [Review / Check Current State]

[Read relevant docs or check existing state before making changes.]

### Step 2: [Do the Thing]

[The core action. Be specific about file paths, commands, and patterns.]

### Step 3: [Register / Update Dependencies]

[If the change needs to be registered somewhere — a manifest, config, docs.]

### Step 4: [Verify]

[Run a verification command. Example: tests, dry-run, lint check.]

## Boundaries

- This skill [does X] only
- Does NOT [dangerous thing] — that requires human approval
- Does NOT [out-of-scope thing] — that's a separate step

## Expected Output

- [Artifact 1: e.g., "One new file in `migrations/`"]
- [Artifact 2: e.g., "Updated entry in `MANIFEST`"]
