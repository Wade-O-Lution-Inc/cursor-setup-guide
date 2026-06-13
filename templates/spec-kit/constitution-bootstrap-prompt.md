# Constitution Bootstrap Prompt

Use this prompt in Cursor Agent **once** after `specify init`, or when `.cursor/rules/` governance changes materially.

---

**Prompt:**

```
Read all always-on rules in .cursor/rules/ (project, engineering discipline, environment, security/git, testing, and any repo-specific orchestrator).

Compile a Spec Kit constitution at .specify/memory/constitution.md with:

1. Core Principles (NON-NEGOTIABLE where applicable) — architecture layers, scope discipline, ship-with-tests, secrets safety, git/PR discipline
2. Technology Constraints — stack, job patterns, secret injection prefix ({SECRETS_PREFIX})
3. SDD Quality Gates — clarify before plan; analyze before implement when 3+ boundaries; no implement without tasks.md; mark [X] in tasks.md
4. Governance — source of truth is .cursor/rules/; refresh constitution when rules change

Keep under 80 lines. No secrets. Reference repo doc paths where helpful.

Do not duplicate entire rules — distill enforceable gates the speckit-implement phase must follow.
```

---

**After generation:** commit `.specify/memory/constitution.md`. Day-to-day source of truth remains `.mdc` rules.

**Reference output:** [meeting_notes_workflow/.specify/memory/constitution.md](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/blob/staging/.specify/memory/constitution.md)
