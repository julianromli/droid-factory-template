# Droid Factory Template

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive template for [Factory AI](https://factory.ai) with 112+ specialist droids, custom commands, skills, and MCP integrations. Supercharge your AI-assisted development workflow.

## Features

- **112 Specialist Droids** - AI agents for every domain (backend, frontend, DevOps, security, SEO, and more)
- **12 Custom Commands** - Slash commands for common workflows
- **13 Skill Modules** - Reusable skills for complex tasks
- **Orchestrator System** - Multi-agent coordination and task optimization
- **MCP Integrations** - Pre-configured Model Context Protocol servers
- **Coding Guidelines** - AGENTS.md with best practices

## Directory Structure

```
droid-factory-template/
├── commands/           # Custom slash commands
├── droids/             # Specialist AI agents
├── hooks/              # Automation scripts
├── orchestrator/       # Multi-agent coordination docs
│   └── memory/         # Learning patterns & templates
├── skills/             # Skill modules
├── AGENTS.md           # Coding guidelines & rules
├── config.json         # Custom model configurations
└── mcp.json            # MCP server configurations
```

## Installation

1. **Clone this repository**
   ```bash
   git clone https://github.com/julianromli/droid-factory-template.git
   ```

2. **Copy to your Factory directory**
   ```bash
   # Windows
   xcopy /E /I droid-factory-template\* %USERPROFILE%\.factory\

   # macOS/Linux
   cp -r droid-factory-template/* ~/.factory/
   ```

3. **Configure API keys** in `mcp.json` (see Configuration section)

4. **Restart Factory CLI** to load the new configurations

## Configuration

Edit `mcp.json` and replace the placeholder API keys:

| Service | Key | Get it from |
|---------|-----|-------------|
| Exa | `YOUR_EXA_API_KEY` | [exa.ai](https://exa.ai) |
| Firecrawl | `YOUR_FIRECRAWL_API_KEY` | [firecrawl.dev](https://firecrawl.dev) |
| Ref | `YOUR_REF_API_KEY` | [ref.tools](https://ref.tools) |
| Supabase | `YOUR_SUPABASE_PROJECT_REF` | [supabase.com](https://supabase.com) |
| Mayar | `YOUR_MAYAR_API_KEY` | [mayar.id](https://mayar.id) |
| Google | `YOUR_GOOGLE_API_KEY` | [Google AI Studio](https://aistudio.google.com) |
| Context7 | `YOUR_CONTEXT7_API_KEY` | [context7.com](https://context7.com) |
| Morph | `YOUR_MORPH_API_KEY` | [morphllm.com](https://morphllm.com) |

## Usage

### Commands

Use slash commands in Factory CLI:

| Command | Description |
|---------|-------------|
| `/code-review` | Comprehensive code review |
| `/create-prd` | Generate Product Requirements Document |
| `/generate-agents` | Create AGENTS.md for a project |
| `/generate-tasks` | Break down specs into tasks |
| `/orchestrator` | Multi-agent task coordination |
| `/pr-ready` | Check PR readiness |
| `/release-notes` | Generate release notes |
| `/test-plan` | Create test plans |
| `/todo-scan` | Scan TODOs and FIXMEs |
| `/seo` | SEO analysis and optimization |
| `/indexes` | Database index suggestions |
| `/mobile-responsiveness` | Mobile UI audit |

### Droids

Droids are automatically invoked based on task context. You can also explicitly call them:

```
Use the typescript-pro droid to refactor this code
```

### Skills

Skills are invoked automatically or manually:

```
Use the frontend-design skill to create a pricing page
```

## Included Droids

### Development
`typescript-pro` · `javascript-pro` · `python-pro` · `golang-pro` · `rust-pro` · `java-pro` · `csharp-pro` · `php-pro` · `ruby-pro` · `elixir-pro` · `scala-pro` · `cpp-pro` · `c-pro` · `sql-pro`

### Frameworks
`django-pro` · `fastapi-pro` · `nextjs-app-router-developer` · `flutter-expert` · `unity-developer` · `wordpress-developer` · `minecraft-bukkit-pro`

### Architecture
`architect-review` · `backend-architect` · `database-architect` · `database-optimizer` · `graphql-architect` · `hybrid-cloud-architect` · `kubernetes-architect`

### DevOps & Infrastructure
`devops-specialist` · `terraform-specialist` · `network-engineer` · `incident-responder` · `observability-engineer` · `mlops-engineer`

### Security
`backend-security-coder` · `frontend-security-coder` · `mobile-security-coder` · `security-auditor` · `red-team-specialist` · `blue-team-specialist`

### Code Quality
`code-reviewer` · `code-quality-reviewer` · `performance-reviewer` · `security-code-reviewer` · `test-coverage-reviewer` · `documentation-accuracy-reviewer`

### Testing
`test-automator` · `tdd-orchestrator` · `test-plan-writer`

### Documentation
`docs-architect` · `documentation-specialist` · `tutorial-engineer` · `reference-builder` · `api-documenter`

### SEO
`seo-content-writer` · `seo-content-planner` · `seo-content-auditor` · `seo-content-refresher` · `seo-keyword-strategist` · `seo-meta-optimizer` · `seo-structure-architect` · `seo-snippet-hunter` · `seo-authority-builder` · `seo-cannibalization-detector`

### Business & Analysis
`business-analyst` · `data-analyst` · `data-scientist` · `data-engineer` · `quant-analyst` · `risk-manager`

### Other Specialists
`prompt-engineer` · `context-manager` · `ui-ux-designer` · `ui-visual-validator` · `mermaid-expert` · `legal-advisor` · `hr-pro` · `sales-automator` · `content-marketer` · `customer-support` · `search-specialist`

## Included Skills

| Skill | Description |
|-------|-------------|
| `agents-md-generator` | Generate hierarchical AGENTS.md structures |
| `backend-dev` | Backend development workflow orchestration |
| `browser` | Chrome DevTools Protocol automation |
| `frontend-design` | Create distinctive, production-grade UI |
| `frontend-ui-animator` | Add purposeful UI animations |
| `frontend-ui-integration` | Integrate UI with backend APIs |
| `mgrep` | Semantic code search |
| `product-management` | PM activities (PRDs, roadmaps, research) |
| `rsc-data-optimizer` | Optimize Next.js data fetching with RSC |
| `shadcn-management` | Manage shadcn/ui components |
| `skill-creator` | Guide for creating new skills |
| `task-generator` | Generate task lists from specs |
| `template-skill` | Template for new skills |

## Orchestrator

The orchestrator system enables multi-agent coordination for complex tasks:

- **Task Optimization** - Intelligent task breakdown and assignment
- **Conflict Resolution** - Handle conflicts between agents
- **Quality Gates** - Automated quality checks
- **Distributed Execution** - Parallel task execution
- **Performance Analytics** - Track and optimize performance

See `orchestrator/` for detailed documentation.

## Custom Models

The `config.json` includes custom model configurations for use with local proxies or alternative providers. Modify as needed for your setup.

## Author

**Faiz Intifada**

- GitHub: [@julianromli](https://github.com/julianromli)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Feel free to:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## Acknowledgments

- [Factory AI](https://factory.ai) for the amazing AI development platform
- All the open-source MCP server projects integrated in this template
