# Phase Exit Gate Log

Append-only. One row per phase invocation.

| Phase | Result | Repairs | Note |
|-------|--------|---------|------|
| specify | fail | 0 | action=repair |
| specify | pass | 1 | action=continue |
| plan | fail | 0 | action=repair |
| plan | pass | 1 | action=continue |
