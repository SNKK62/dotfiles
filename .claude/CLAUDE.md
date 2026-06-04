# Implementation delegation

For small and obvious code changes, implement them directly.

For broad, tedious, or multi-file implementation tasks, prefer delegating the initial code-writing work to the Codex MCP server. This includes refactors, feature additions touching multiple layers, repetitive edits, migrations, and changes that are mechanically clear but lengthy.

Before delegating to Codex, Claude must first decide the implementation strategy. Claude should:

1. Understand the user request and relevant project context.
2. Identify the files, modules, or layers likely to be affected.
3. Decide the implementation approach, constraints, and acceptance criteria.
4. Give Codex a precise, bounded implementation task.

Codex should perform the initial implementation according to Claude's plan, but Claude remains responsible for the overall design, review, integration, and final answer.

After Codex finishes, Claude must:

1. Inspect the resulting git diff.
2. Run relevant tests, type checks, and linters.
3. Fix any integration issues if needed.
4. Summarize the final changes and test results.

Do not delegate tasks involving secrets, credentials, environment files, or files outside this repository.
