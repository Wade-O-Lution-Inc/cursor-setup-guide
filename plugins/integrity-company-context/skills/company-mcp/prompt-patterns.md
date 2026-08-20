# Company MCP — prompt patterns

Copy/adapt these when driving the agent. Prefer pack-first.

## Pack-first (default)

> Using Company MCP, get the context pack for **Aligned Data Centers**. Summarize what’s solid for an account overview (contacts, recent meetings, open asks). List citation ids. Do not invent missing fields.

## UI scaffold

> From the Company MCP pack for **\<company\>**, propose a React component tree and TypeScript types for header / contacts / meetings / asks. Only include properties present in the pack. Flag `warnings` as gaps. Put citation ids in comments above bindings.

## Sales / PM brief

> Brief me on **\<company\>** for a customer call: stage, sentiment, decision-makers, open asks, last 3 substantive meetings. Cite sources. If a section is empty or warned, say so.

## Grounded Q&A

> Ask Company MCP: “What did we last discuss with **\<company\>** about SLA/uptime?” If `ungrounded`, say so and show pack/leaf evidence only.

## Ambiguity

> Resolve **Acme** via Company MCP. If ambiguous, list candidates and stop — don’t pick one.

## Meeting list model

> Use `search_company_meetings` for **\<company\>** with query “integration”. Return `{ id, title, date, snippet }` from results/citations only.
