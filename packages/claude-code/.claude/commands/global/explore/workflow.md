---
description: Claude Code project workflow from inception to production
argument-hint: [stage]
---

# Claude Code Project Workflow

A structured workflow for building projects from scratch using Claude Code.

## Input Handling

<input_handling>
**If $ARGUMENTS is provided:**
- Jump to the specified stage (e.g., "discovery", "requirements", "architecture", "planning", "setup", "implementation", "deployment")
- Show detailed guidance for that stage

**If $ARGUMENTS is empty:**
- Show the full workflow overview
- Ask which stage to start with
</input_handling>

## Workflow Stages

### Stage 1: Discovery

**Goal:** Understand the problem, explore the space

**Workflow:**
- Conversational exploration with Claude
- No code yet, just talking through the idea
- Ask Claude to poke holes, suggest alternatives

**Document to Produce:**
```
docs/CONCEPT.md
├── Problem statement
├── Target user
├── Key insight / why now
├── Success criteria
└── Open questions
```

**How to start:** Just describe your idea and discuss it. When ready, ask Claude to write CONCEPT.md.

---

### Stage 2: Requirements

**Goal:** Define what to build (not how)

**Workflow:**
- Use `/global:explore:interview` skill
- Claude interviews YOU to extract requirements
- Captures decisions and rationale

**Document to Produce:**
```
docs/REQUIREMENTS.md
├── User stories / jobs to be done
├── Functional requirements (must have / nice to have)
├── Non-functional requirements (performance, security)
├── Constraints (budget, timeline, platform)
└── Decision log (choices made + why)
```

**IMPORTANT: WHAT not HOW**

Requirements must be **technology-agnostic**. Specify capabilities needed, not specific products or implementations.

| Wrong (HOW) | Right (WHAT) |
|-------------|--------------|
| "Use AWS Textract for OCR" | "System extracts text from images" |
| "Store in PostgreSQL" | "Relational database storage" |
| "Use JWT tokens" | "Secure token-based sessions" |
| "Deploy on Vercel" | "Web hosting with CI/CD" |
| "Use OpenAI embeddings" | "Vector embeddings for search" |

Tech choices (PostgreSQL vs MySQL, AWS vs GCP, etc.) belong in **ARCHITECTURE.md**.

**How to start:** Run `/global:explore:interview docs/CONCEPT.md`

---

### Stage 3: Architecture

**Goal:** Define how to build it (high-level)

**Workflow:**
- Share REQUIREMENTS.md with Claude
- Ask for architecture options
- Discuss tradeoffs
- Use plan mode for complex options

**Documents to Produce:**
```
docs/ARCHITECTURE.md
├── System diagram (mermaid or ASCII)
├── Tech stack choices + rationale
├── Data model (conceptual)
├── Key integration points
├── Security model
└── Cost model (rough)

docs/ADR/                          # Architecture Decision Records
├── 001-database-choice.md
├── 002-auth-strategy.md
└── ...
```

**How to start:** "Based on REQUIREMENTS.md, propose 2-3 architecture options with tradeoffs"

---

### Stage 4: Planning

**Goal:** Break work into trackable tasks

**Workflow:**
- Initialize beads: `/beads:init`
- Create epics for major workstreams
- Break into individual issues with dependencies
- This becomes your living backlog

**Documents to Produce:**
```
.beads/                            # Issue tracker (auto-managed)
├── issues/
│   ├── PROJECT-001.md
│   ├── PROJECT-002.md
│   └── ...
└── config.yaml

docs/ROADMAP.md                    # Optional high-level view
├── Phase 1: Foundation
├── Phase 2: Core features
├── Phase 3: Polish
└── Phase 4: Launch
```

**How to start:** `/beads:init` then "Create tasks from ARCHITECTURE.md"

---

### Stage 5: Project Setup

**Goal:** Scaffold the codebase, establish conventions

**Workflow:**
- Create repo structure
- Set up tooling (linting, testing, CI)
- Write CLAUDE.md with project conventions

**Document to Produce:**
```
CLAUDE.md                          # THE KEY FILE - auto-loaded every session
├── Project overview (1-2 sentences)
├── Tech stack
├── Directory structure
├── Key commands (build, test, deploy)
├── Coding conventions
├── What NOT to do
└── Links to other docs
```

**CLAUDE.md Template:**
```markdown
# Project Name

One-line description.

## Stack
- Frontend: [tech]
- Backend: [tech]
- Database: [tech]

## Commands
- `pnpm install` - install deps
- `pnpm dev` - start local dev
- `pnpm test` - run tests

## Structure
- `src/` - source code
- `tests/` - test files
- `docs/` - documentation

## Conventions
- [Key patterns to follow]

## Do NOT
- [Anti-patterns to avoid]
```

**How to start:** "Scaffold the project based on ARCHITECTURE.md"

---

### Stage 6: Implementation

**Goal:** Build the thing

**Workflow:**
```
Per session:
1. /beads:ready              → find unblocked work
2. /beads:show PROJECT-XXX   → get context
3. Work on task (use plan mode for complex work)
4. /commit                   → commit changes
5. /beads:close PROJECT-XXX  → mark done
```

**For complex features:**
- Enter plan mode first
- Claude explores codebase, proposes approach
- You approve, then Claude implements

**Documents Updated:**
- CLAUDE.md (add new patterns as they emerge)
- .beads/ issues (status updates)
- Code + inline comments where needed

**How to start:** `/beads:ready`

---

### Stage 7: Testing & QA

**Goal:** Verify it works

**Workflow:**
- Write tests alongside implementation
- Use `/global:implement:browser-debug` for UI testing
- Create test fixtures/golden datasets for LLM components

**Document to Produce:**
```
docs/TESTING.md                    # Optional
├── How to run tests
├── Test data setup
├── Manual test checklist
└── Known limitations
```

---

### Stage 8: Deployment

**Goal:** Ship to production

**Workflow:**
- Infrastructure as code
- Environment configuration
- CI/CD setup

**Documents to Produce:**
```
docs/DEPLOYMENT.md
├── Environments (dev, staging, prod)
├── How to deploy
├── Environment variables
├── Secrets management
└── Rollback procedure

docs/RUNBOOK.md                    # For production issues
├── Common issues + fixes
├── Monitoring dashboards
├── Escalation contacts
└── Incident response
```

---

## Quick Reference

| Stage | Key Document | Purpose |
|-------|--------------|---------|
| Discovery | `docs/CONCEPT.md` | Why are we building this |
| Requirements | `docs/REQUIREMENTS.md` | **What** are we building (tech-agnostic) |
| Architecture | `docs/ARCHITECTURE.md` | **How** will it work (tech choices) |
| Planning | `.beads/` | Trackable tasks |
| Setup | `CLAUDE.md` | Session context (auto-loaded) |
| Implementation | Code + beads | The actual work |
| Deployment | `docs/DEPLOYMENT.md` | How to ship |

## Session Pattern

```bash
# Start of any session
/beads:ready                    # What can I work on?
/beads:show PROJECT-XXX         # Get full context
[work on the task]
/commit                         # Commit when done
/beads:close PROJECT-XXX        # Mark complete
```

## Key Insight

**CLAUDE.md is your persistent brain.** It auto-loads every session and accumulates project knowledge over time. Keep it updated as you learn new patterns and gotchas.

---

## Instructions

Based on the stage requested (or overview if none specified):

1. **If showing overview:** Display the stages summary and ask which stage to start with
2. **If specific stage:** Show detailed guidance for that stage and offer to help execute it
3. **Always:** Remind about the key documents and offer to create/update them
