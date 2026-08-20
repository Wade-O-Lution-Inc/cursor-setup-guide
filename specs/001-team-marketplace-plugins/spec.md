# Feature Specification: Team Marketplace Plugins for SDD

**Feature Branch**: `001-team-marketplace-plugins`

**Created**: 2026-08-20

**Status**: Draft

**Input**: User description: "Make SDD Full, Lite, and Review available to every named seat on the Integrity Cursor Team by packaging this repo as a Cursor Team marketplace with three plugins (SDD chat surface, safety hooks, company-context skill). Dual-path with the existing install-global CLI. Admin runbook for human dashboard leftover steps. Engine remains sdd-ctl; SDD is not an MCP server."

## Overview

Make Spec-Driven Development (SDD) Full, Lite, and Review available to every named seat on the Integrity Cursor Team by distributing the project’s SDD capabilities as a Cursor Team marketplace offering with three plugins: an SDD chat surface, safety hooks, and a company-context skill. Marketplace distribution coexists with the existing global install CLI path (dual-path). An admin runbook covers leftover human steps in the Cursor team dashboard. SDD orchestration remains on the existing SDD control engine (sdd-ctl); SDD is not delivered or represented as an MCP server.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Named seat runs SDD modes from team marketplace (Priority: P1)

A named seat on the Integrity Cursor Team installs the team marketplace packaging and can start Spec-Driven Development in Full, Lite, or Review mode through the SDD chat surface plugin without a separate one-off setup beyond joining the team and enabling the marketplace plugins.

**Why this priority**: Delivering SDD Full, Lite, and Review to every named seat is the primary product outcome.

**Independent Test**: With only the SDD chat surface plugin enabled for a named seat, that seat can invoke Full, Lite, and Review and receive the expected SDD workflow entry for each mode.

**Acceptance Scenarios**:

1. **Given** a named seat on the Integrity Cursor Team with the SDD chat surface plugin available, **When** they choose SDD Full, **Then** they enter the Full SDD workflow through the team-delivered chat surface.
2. **Given** the same seat, **When** they choose SDD Lite, **Then** they enter the Lite SDD workflow through the same surface.
3. **Given** the same seat, **When** they choose SDD Review, **Then** they enter the Review SDD workflow through the same surface.
4. **Given** a person who is not a named seat on the Integrity Cursor Team, **When** they attempt to use the team marketplace packaging, **Then** they do not receive Integrity team marketplace access as if they were a named seat.

---

### User Story 2 - Safety and company-context plugins ship with the marketplace package (Priority: P2)

A named seat who enables the team marketplace also receives the safety hooks plugin and the company-context skill plugin so SDD work is guarded by team safety expectations and grounded in company context, alongside the SDD chat surface.

**Why this priority**: The feature is defined as three plugins; safety and company context are required packaging outcomes, not optional add-ons.

**Independent Test**: With the three marketplace plugins enabled for a named seat, the defined team safety protections (no force-push unless explicitly requested, no unsolicited commits, gated dependency installs, gated MCP server installs) and company-context guidance are present for SDD sessions without a separate ad-hoc install of those capabilities.

**Acceptance Scenarios**:

1. **Given** a named seat with all three team marketplace plugins enabled, **When** they start an SDD session, **Then** safety hooks are active and enforce the team safety protections defined in FR-004.
2. **Given** the same seat in an SDD session, **When** they need company context, **Then** the company-context skill is available without a separate manual skill install.
3. **Given** the team marketplace packaging, **When** an administrator inventories delivered capabilities, **Then** exactly three plugins are defined: SDD chat surface, safety hooks, and company-context skill.

---

### User Story 3 - Dual-path install via existing global CLI (Priority: P2)

A named seat (or operator) who cannot or does not use the team marketplace path can still obtain equivalent SDD readiness through the existing global install CLI path, so marketplace distribution and CLI distribution remain dual-path rather than a single forced channel.

**Why this priority**: The feature explicitly preserves the existing install-global CLI as a parallel path, not a deprecated remnant.

**Independent Test**: Without relying on team marketplace enablement, running the existing global install CLI path leaves the user able to use SDD Full, Lite, and Review with the same engine constraint as the marketplace path.

**Acceptance Scenarios**:

1. **Given** a user who uses the existing global install CLI path and does not enable the team marketplace plugins, **When** setup completes successfully, **Then** they can still run SDD Full, Lite, and Review.
2. **Given** a user who already completed the global install CLI path, **When** they later enable the team marketplace plugins, **Then** both paths remain valid and neither path is presented as the only supported option.
3. **Given** documentation or operator guidance for this feature, **When** a reader looks for install options, **Then** both the team marketplace path and the existing global install CLI path are described.

---

### User Story 4 - Admin completes leftover dashboard steps via runbook (Priority: P3)

A team administrator follows a written admin runbook to complete any human-only leftover steps in the Cursor team dashboard that automation cannot finish, so marketplace packaging can be fully activated for named seats.

**Why this priority**: Marketplace packaging still requires human dashboard actions; without a runbook those steps are tribal knowledge and block seat-wide availability.

**Independent Test**: An administrator who has never performed the leftover dashboard steps can complete them using only the runbook and verify that named seats then see the team marketplace plugins.

**Acceptance Scenarios**:

1. **Given** team marketplace packaging is prepared but leftover dashboard steps remain, **When** an administrator follows the admin runbook, **Then** each leftover human step is listed in order with a clear done condition.
2. **Given** an administrator has completed every runbook step, **When** a named seat opens their Cursor team marketplace view, **Then** the three Integrity plugins are available to enable.
3. **Given** a leftover step that only a human can perform in the dashboard, **When** the runbook is consulted, **Then** that step is called out as manual (not claimed as fully automated).

---

### Edge Cases

- What happens when a named seat enables only one of the three plugins? The SDD chat surface alone must still expose Full, Lite, and Review; safety and company-context capabilities apply only when their plugins are enabled, and guidance must not imply all three are optional for the intended team baseline.
- What happens when marketplace enablement fails or is delayed after the global CLI path already succeeded? The CLI path remains usable; marketplace failure must not revoke CLI-based SDD readiness.
- What happens when someone attempts to treat SDD as an MCP server? Product behavior and operator guidance MUST reject that model; SDD orchestration stays on the existing SDD control engine (sdd-ctl), not MCP.
- What happens when dashboard leftover steps are partially completed? Named seats may not see all three plugins until remaining runbook steps are finished; the runbook MUST make incomplete state detectable by listing unchecked steps.
- What happens when a seat is removed from the Integrity Cursor Team? They lose team marketplace access for these plugins; CLI-path readiness is unchanged unless separately revoked by normal CLI uninstall or policy.
- What happens when an agent attempts a force-push, an unsolicited commit, or an ungated dependency or MCP install while safety hooks are enabled? Those actions MUST be blocked or require explicit user request per FR-004; they MUST NOT proceed silently.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The product MUST package this project’s SDD capabilities for distribution as a Cursor Team marketplace offering targeted at the Integrity Cursor Team.
- **FR-002**: The marketplace offering MUST deliver exactly three plugins: an SDD chat surface, safety hooks, and a company-context skill.
- **FR-003**: Every named seat on the Integrity Cursor Team MUST be able to obtain SDD Full, Lite, and Review through the SDD chat surface after marketplace plugins are available to the team.
- **FR-004**: The safety hooks plugin MUST apply the following team safety protections during SDD-related agent activity for seats that enable it (each independently verifiable):
  - **No force-push unless explicitly requested**: Agents MUST NOT force-push to a remote unless the user has explicitly requested that action in the current task.
  - **No unsolicited commits**: Agents MUST NOT create git commits unless the user has explicitly asked to commit in the current task.
  - **Gated dependency installs**: Agents MUST NOT add or install new project dependencies unless the user has explicitly requested that install.
  - **Gated MCP installs**: Agents MUST NOT install or configure new MCP servers unless the user has explicitly approved that action.
- **FR-005**: The company-context skill plugin MUST make company context available to seats that enable it during SDD-related work.
- **FR-006**: The product MUST preserve a dual-path model: team marketplace distribution and the existing install-global CLI path both remain supported ways to become SDD-ready.
- **FR-007**: An administrator-facing runbook MUST document every leftover human step in the Cursor team dashboard required to finish marketplace activation, including order and completion checks.
- **FR-008**: SDD orchestration MUST continue to use the existing SDD control engine (sdd-ctl); this feature MUST NOT replace that engine.
- **FR-009**: SDD MUST NOT be delivered or represented as an MCP server.
- **FR-010**: Operator and seat-facing guidance MUST describe Full, Lite, and Review as the supported SDD modes for this packaging, without introducing additional named SDD modes in this feature.
- **FR-011**: Guidance MUST present marketplace and install-global CLI as complementary paths, not as mutually exclusive or silently superseding each other.

### Key Entities

- **Integrity Cursor Team**: The Cursor team whose named seats are the audience for marketplace distribution.
- **Named seat**: An entitled team member who should receive marketplace plugins and SDD mode access.
- **Team marketplace package**: The packaged distribution of this project’s SDD-related capabilities for the Integrity Cursor Team.
- **Plugin**: One of the three delivered units—SDD chat surface, safety hooks, or company-context skill.
- **Team safety protections**: The four enforceable behaviors delivered by the safety hooks plugin—no force-push unless explicitly requested, no unsolicited commits, gated dependency installs, and gated MCP installs.
- **SDD mode**: One of Full, Lite, or Review workflow entries exposed to seats.
- **Global install CLI path**: The existing install-global CLI distribution path retained as the dual-path alternative to marketplace enablement.
- **Admin runbook**: Ordered human instructions for leftover Cursor team dashboard steps that automation does not complete.
- **SDD control engine (sdd-ctl)**: The existing orchestration engine that remains authoritative for SDD; not replaced and not redefined as MCP.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of named seats on the Integrity Cursor Team can enable the three marketplace plugins and start at least one of SDD Full, Lite, or Review from the SDD chat surface without a custom per-seat packaging exception.
- **SC-002**: An administrator who has not previously activated the marketplace can complete all leftover dashboard steps using only the admin runbook, with each step marked done, in one uninterrupted activation pass.
- **SC-003**: In a dual-path verification, one seat using only marketplace plugins and one seat using only the existing global install CLI path can each complete an SDD mode entry (Full, Lite, or Review) successfully.
- **SC-004**: Reviewers confirm that published guidance for this feature states SDD is not an MCP server and that orchestration remains on sdd-ctl, with zero contradictory “SDD as MCP” claims in seat- or admin-facing materials produced by this feature.
- **SC-005**: Inventory of the marketplace offering lists exactly three plugins (SDD chat surface, safety hooks, company-context skill) with no additional plugin required for the baseline Integrity team packaging described here.
- **SC-006**: With the safety hooks plugin enabled, a verification pass confirms each FR-004 protection: force-push without explicit request is blocked; an unsolicited commit is blocked; a dependency install without explicit request is blocked; an MCP server install without explicit approval is blocked.

## Out of Scope / Non-goals

- Creating, changing, or administering Integrity Cursor Team membership, seat assignment, or billing.
- Inventing new SDD modes beyond Full, Lite, and Review.
- Redesigning or replacing the existing SDD control engine (sdd-ctl).
- Delivering or representing SDD as an MCP server.
- Authoring a new company knowledge base from scratch (this feature packages access to existing company-context skill content).
- Redesigning the team’s overall safety policy beyond distributing the four protections defined in FR-004 as the safety hooks plugin.
- Deprecating or removing the existing install-global CLI path.
- Automating every Cursor team dashboard action; leftover human steps remain and are covered by the admin runbook only.

## Assumptions

- The Integrity Cursor Team and its named-seat roster already exist.
- Full, Lite, and Review already exist as SDD modes; this feature makes them available through packaging and distribution, not by inventing new modes.
- The existing install-global CLI path continues to function as today aside from coexisting with the marketplace path.
- Leftover dashboard steps are finite and knowable; the runbook covers only human actions that remain after packaging is prepared.
- “Every named seat” means every seat currently entitled on the Integrity Cursor Team at activation time, not anonymous or external users.
- Company-context content already exists as team knowledge to be surfaced by the company-context skill; this feature packages access to that skill rather than authoring a new knowledge base from scratch.
- Safety policy intent for hooks matches the four protections in FR-004; this feature distributes those protections as a plugin rather than inventing a broader safety program.
