# Spec Kit Bootstrap Checklist

**Machine day-1:** [../../docs/day1.md](../../docs/day1.md)  
**Full narrative:** [../../docs/specify/bootstrap.md](../../docs/specify/bootstrap.md)  
**CLI:** `../../bin/cursor-setup adopt-sdd`  
**Sync:** [../SYNC.md](../SYNC.md)

## 1. Machine (once)

- [ ] Spec Kit 0.13.0
- [ ] `./bin/cursor-setup install-global` + `doctor`
- [ ] `sdd-ctl sync` + `preflight` green (ctl on `origin/main`)

## 2–4. Prefer CLI

```bash
./bin/cursor-setup adopt-sdd /path/to/your-repo \
  --lint-cmd 'YOUR_LINT' --test-cmd 'YOUR_TEST'
specify workflow list   # expect sdd + sdd-remote
```

Manual steps: [../../docs/specify/bootstrap.md](../../docs/specify/bootstrap.md).
