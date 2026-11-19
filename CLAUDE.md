# Add-ons

Overview of everything installed. When a task fits one of these, use it instead of doing the work by hand.

## Plugins (`~/.claude/settings.json` → `enabledPlugins`)

| Plugin | Marketplace (GitHub) | What it gives |
|---|---|---|
| **ponytail** | `DietrichGebert/ponytail` | Lazy-senior-dev mode: simplest working solution, YAGNI, stdlib first. Skills: `/ponytail`, `/ponytail-review`, `/ponytail-audit`, `/ponytail-debt`, `/ponytail-gain`, `/ponytail-help`. Turn off with "stop ponytail" |
| **superpowers** | `obra/superpowers` | Process skills: brainstorming, writing-plans, executing-plans, systematic-debugging, test-driven-development, verification-before-completion, requesting/receiving-code-review, using-git-worktrees, finishing-a-development-branch, subagent-driven-development, dispatching-parallel-agents, writing-skills |
| **example-skills** | `anthropics/skills` | algorithmic-art, canvas-design, frontend-design, theme-factory, brand-guidelines, web-artifacts-builder, webapp-testing, mcp-builder, skill-creator, doc-coauthoring, internal-comms, slack-gif-creator |
| **academy-guide** | `anthropics/skills` | Guide for Anthropic Academy content |
| **context7** | `anthropics/claude-plugins-official` | MCP server with current library/framework docs. Use it for API, config and version questions, even for well-known libraries |
| **php-lsp** | `anthropics/claude-plugins-official` | PHP language server (needs `intelephense` on PATH) |
| **jdtls-lsp** | `anthropics/claude-plugins-official` | Java language server (needs Eclipse JDT LS `jdtls` on PATH and a JDK) |

## Skills outside plugins

- **graphify** (`pip install graphifyy`, then `graphify install`): turns code, docs and other input into a knowledge graph. Trigger: `/graphify`.
- **Built-in skills** (anthropic-skills):
  - Office and PDF files: docx, xlsx, pptx, pdf.
  - Claude features: docs, deep-research, learn, consolidate-memory, skill-creator, mcp-builder.
  - Design: canvas-design, algorithmic-art.
  - Browser and computer use: built-in-browser, chrome-browser, computer-use.
- **Claude Code skills:**
  - Review: code-review, simplify, security-review.
  - Run and schedule: run, loop, schedule.
  - Setup and tooling: init, update-config, fewer-permission-prompts, keybindings-help, claude-api, workflow-authoring.
  - Artifacts: dataviz, artifact-design, artifact-capabilities, artifact-diagramming.

## MCP servers and app tools (Claude desktop app)

| Server | Use |
|---|---|
| **Claude_Browser** | Built-in browser pane. Default browser for web pages and dev-server previews (`.claude/launch.json`) |
| **claude-in-chrome** | The real Chrome with the user's own sign-ins. Only when asked for |
| **context7** | Library docs (see the context7 plugin above) |
| **visualize** | Inline SVG/HTML widgets: diagrams and charts in the chat |
| **terminal** | Read and drive the Terminal panel tabs |
| **scheduled-tasks** | Local scheduled tasks |
| **mcp-registry** | Search for and suggest more connectors |
| **ccd_*** | App tools: sessions, task list, panes, PR status, settings |

There is also an **Artifact** tool that publishes HTML pages to claude.ai, private by default.
