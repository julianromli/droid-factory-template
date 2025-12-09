---
description: Execute project using intelligent planning with parallel specialist execution
argument-hint: <objective>
---

# Orchestrator: Intelligent Project Execution

Execute the objective: `$ARGUMENTS`

## Execution Flow

### Phase 1: Discovery
Analyze the current project context organically:
- Check common files: `README.md`, `package.json`, `requirements.txt`, `plan.md`, `docs/`, `src/`
- Detect tech stack from configuration files
- Use targeted file reading, avoid unnecessary directory listing

### Phase 2: Planning
Create a phased execution approach:
- Load orchestrator patterns from `/orchestrator/`
- Identify available specialist droids from `/droids/`
- Create TodoWrite with comprehensive phase breakdown
- Determine optimal execution strategy based on dependency graph

### Phase 3: Droid Selection
Auto-rank droids based on:
- Project complexity
- Tech stack match
- Dependency analysis
- Expertise level

**Available Droid Categories:**
- **Backend**: backend-architect, backend-security-coder, database-architect, database-optimizer
- **Frontend**: frontend-developer, nextjs-app-router-developer, ui-ux-designer
- **Mobile**: mobile-developer, flutter-expert
- **Security**: security-auditor, incident-responder
- **Testing**: test-automator, tdd-orchestrator, code-reviewer, debugger
- **DevOps**: devops-specialist, cloud-architect, kubernetes-architect
- **Data**: data-engineer, data-analyst, mlops-engineer
- **Documentation**: docs-architect, api-documenter, tutorial-engineer

### Phase 4: Parallel Execution
Request Factory to execute specialist droids in parallel:
- Generate detailed prompts for each specialist
- Delegate to Factory for parallel droid execution
- Monitor progress and detect bottlenecks

### Phase 5: Integration & Verification
- Synthesize results from all droids
- Ensure all components work together
- Run quality gates and verification checks

## Key Principles

1. **Context-aware discovery** - Find project structure organically
2. **Proactive issue resolution** - Predict and prevent problems
3. **Adaptive execution** - Adjust strategy based on complexity
4. **Continuous learning** - Track success patterns and learn from failures
5. **Autonomous completion** - Continue until project is fully complete

## Error Recovery

- Auto-diagnose failures
- Try alternative strategies
- Graceful degradation when needed
- Rollback capabilities available
