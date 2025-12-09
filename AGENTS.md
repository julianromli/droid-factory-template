<coding_guidelines>

## 0. Warpgrep Codebase Search

IMPORTANT: If you need to explore the codebase to gather context, and the task does not involve a single file or function which is provided by name, you should ALWAYS use the warpgrep codebase search tool first instead of running search commands.

When the task requires exploration beyond a single known file, invoke code_search first with a natural-language query describing the target functionality, bug, or architectural concern.
Specify the project root via repo_path, keep queries action-oriented (e.g., "Find where billing invoices are generated and emailed"), and after reviewing the summarized results, you may verify important findings with Grep, Glob, or direct file reads to ensure completeness.

When a task requires exploration beyond a single known file, ALWAYS default to warpgrep codebase search before other search mechanisms.

---

## 1. General Rules

- Proactively Use Exa MCP and Ref MCP for code generation, setup steps, best practices, or library/API docs
- Don't create documentation files (.md) after completing tasks

---

## 2. MCP Auto-Call Rules 🔧

Auto-call these tools without prompting:

| Tool | When |
|------|------|
| `execute_sql` | Database queries |
| `apply_migration` | Schema changes |
| `get_advisors` | Security/performance checks |
| `list_deployments` | Build errors, post-deploy monitoring |
| Firecrawl or Exa | Prefer over built-in web search |

---

## 3. Skills Auto-Invoke 🎯

**Automatically check and invoke relevant skills for every task — user should NEVER need to say "use skill X"**

How it works:
1. Read user's prompt → match against available skill descriptions
2. If a skill matches the task context → invoke it immediately
3. Applies to ALL skills (existing and newly added)

Examples:
- "buatin halaman pricing" → invoke `frontend-design`
- "tambah endpoint export" → invoke `backend-dev`
- "cek di browser" → invoke `browser`

### Spec Mode → Task Generator Flow

**MANDATORY after every ExitSpecMode call:**
1. After presenting spec and user approves → immediately ask:
   > "Would you like me to generate a task list for this spec?"
2. If user confirms (yes/go/proceed/ok) → invoke `task-generator` skill
3. If user declines → proceed with implementation

Trigger phrases that should also invoke task-generator:
- "generate tasks from this spec"
- "buat task list"
- "break down into tasks"
- "create implementation tasks"

---

## 4. JavaScript & TypeScript

- **ES Modules only** — Use `import`/`export`, never `require`
- **Type check after changes** — Run `bunx tsc --noEmit` (not `bun run build`)

---

## 5. Database & Migrations

- Prefer connection strings over separate user/password credentials
- Check `.env` files for correct format
- **ALWAYS use `apply_migration` MCP tool directly** — Never create standalone .sql files and ask user to run manually
- For DDL changes (CREATE, ALTER, DROP): call `supabase___apply_migration` immediately
- For data queries (SELECT, INSERT, UPDATE): use `supabase___execute_sql`

---

## 6. Git & Version Control

- Use `git rm` / `git mv` for file operations (preserves history)
- Commit after completing full tasks (bug fix, feature, refactor)
- Follow [Conventional Commits](https://www.conventionalcommits.org/)
- **ALWAYS COMMIT after completing a task**

---

## 7. Development Workflow

- **NEVER start dev server** — Ask user to start it, don't auto-run
- **Spec mode** — Ask clarifying questions after research, before writing files

---

## 8. UI & Styling

- Tailwind: prefer `size-x` over `w-x h-x` when values are the same
- Prefer `gap-*` over margin for flex/grid spacing

---

## 9. DO NOT ❌

- Don't start dev servers without permission
- Don't rely on `bun run build` for type checking

---

## 10. File Editing

- Prefer `edit_file` over `str_replace` or full file writes — handles indentation and fuzzy matching, faster with fewer errors

</coding_guidelines>
