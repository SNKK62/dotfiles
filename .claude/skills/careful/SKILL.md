---
name: careful
description: Plan an implementation, write a markdown implementation document, delegate the implementation to Codex, and commit changes incrementally with change logs.
argument-hint: "<implementation request>"
disable-model-invocation: true
---

# Careful workflow

You are running the `/careful` workflow.

User request:

$ARGUMENTS

## Roles

Claude is responsible for:

- Understanding the request.
- Investigating the repository.
- Deciding the requirements, implementation strategy, task boundaries, and acceptance criteria.
- Writing a markdown implementation document before Codex starts coding.
- Searching the web when external or up-to-date information is needed.
- Asking the user for clarification when the answer cannot be determined from the repository, documentation, web search, or reasonable assumptions.
- Reviewing Codex's implementation.
- Running tests, type checks, linters, and other relevant verification commands.
- Creating change log entries before each commit.
- Making incremental commits.

Codex is responsible for:

- Performing the initial implementation according to Claude's written plan.
- Following the constraints and acceptance criteria in the implementation document.
- Avoiding unrelated edits.
- Not deciding the overall architecture or implementation strategy unless Claude explicitly delegates a narrowly scoped design choice.

## Workflow

### 1. Understand the request

Analyze the user's request and inspect the repository as needed.

If the request is ambiguous, first try to resolve the ambiguity by:

1. Reading relevant files in the repository.
2. Looking for existing conventions, architecture, tests, and documentation.
3. Using web search when the uncertainty depends on external APIs, libraries, frameworks, current behavior, or recent documentation.

If the ambiguity is still blocking after investigation, ask the user a concise clarification question before implementation.

If the ambiguity is not blocking, proceed with explicit assumptions and record them in the implementation document.

### 2. Create planning and change log directories

Ensure these directories exist:

- `change_logs/`
- `change_logs/plans/`

### 3. Write the implementation document

Before asking Codex to implement anything, create a markdown document under:

`change_logs/plans/YYYYMMDD-HHMMSS-fight-plan.md`

The document must include:

- Original user request.
- Requirements.
- Non-goals.
- Repository context and relevant files.
- Implementation strategy.
- Codex task instructions.
- Acceptance criteria.
- Verification plan.
- Risks and assumptions.
- Commit plan.

The implementation strategy must be decided by Claude, not Codex.

### 4. Delegate implementation to Codex

Delegate the implementation to the Codex MCP server if available.

Give Codex:

- The path to the implementation document.
- A concise summary of the task.
- The exact scope of files or modules to modify when known.
- The acceptance criteria.
- Instructions to avoid unrelated changes.
- Instructions not to commit.

Codex should only implement the changes. Claude remains responsible for review, testing, change logs, and commits.

If Codex MCP is not available, use Codex CLI from the repository root with workspace write access, passing the implementation document as context.

Preferred fallback command shape:

`codex exec --sandbox workspace-write "<task based on the implementation document>"`

Do not use broader filesystem or network access unless the user explicitly approves it.

### 5. Review Codex changes

After Codex finishes:

1. Inspect `git status`.
2. Inspect `git diff`.
3. Check whether Codex followed the implementation document.
4. Fix integration issues directly if needed.
5. Do not commit unrelated changes.

### 6. Verify

Run the most relevant verification commands for the project, such as tests, type checks, linters, formatters, or builds.

Prefer commands already used by the project, such as scripts in `package.json`, `Makefile`, CI configs, README, or existing documentation.

If a verification command cannot be run, record why.

### 7. Commit incrementally

Make small, logical commits.

Before each commit:

1. Write a change log entry under:

   `change_logs/YYYYMMDD-HHMMSS-short-description.md`

2. The change log entry must include:
   - Summary.
   - Files changed.
   - Reason for the change.
   - Verification performed.
   - Known limitations or follow-ups.

3. Stage only the files relevant to that commit.

4. Commit with a concise message.

Commit message style:

`type(scope): summary`

Use common types such as:

- `feat`
- `fix`
- `refactor`
- `test`
- `docs`
- `chore`

### 8. Final response

At the end, summarize:

- What was implemented.
- Which plan document was created.
- Which change log entries were created.
- Commit hashes and messages.
- Verification commands and results.
- Any remaining risks, assumptions, or follow-ups.
