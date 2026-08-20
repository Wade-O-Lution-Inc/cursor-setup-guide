# Phase Exit Gate Log

Append-only. One row per phase invocation.

| Phase | Result | Repairs | Note |
|-------|--------|---------|------|
| specify | fail | 0 | action=repair |
| specify | pass | 1 | action=continue |
| plan | fail | 0 | action=repair |
| plan | pass | 1 | action=continue |
| implement | fail | 0 | action=repair |
| implement | pass | 1 | action=continue |
| light_gate | pass | 0 | action=continue |
