# Agent Guidelines & Defaults

### General Principles
- Make minimal, focused, and targeted changes; avoid unsolicited large-scale refactors.
- Adhere strictly to existing codebase conventions, architecture, and coding style.
- Ask for clarification when requirements or architectural decisions are ambiguous.

### Execution & Scripting Rules
- Do not use inline heredocs (`<< 'EOF'` or `<< EOF`) or multi-line python/bash execution commands.
- Always write scripts to a file first, then execute them via `python3 <script_name>` or `bash <script_name>`.
- Always show the full code in chat before running it.

### Code Quality & Testing
- Run relevant tests and linters to verify changes whenever feasible.
- Add automated tests for new business logic and regression tests for bug fixes.
- Never weaken, disable, or stub out failing tests to force a pass.

### Security & Secrets
- Never log, commit, or hardcode secrets, API keys, private tokens, or credentials.
- Respect `.gitignore` and keep sensitive environment files (e.g., `.env`) untracked.

### Git & Workspace Hygiene
- Do not initiate git commits unless explicitly requested.
- Do not delete or rename existing files without a clear technical reason.
- Avoid introducing new external dependencies unless strictly necessary.
- Clean up any temporary files or debug scripts created during investigation.
