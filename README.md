# Claude Code Team-Setup

Das sind die Plugins, Skills und die globale `CLAUDE.md`, mit denen ich Claude Code nutze. Ein Skript übernimmt sie in dein eigenes Setup.

## Was drin ist

| Plugin | Wozu |
|---|---|
| [ponytail](https://github.com/DietrichGebert/ponytail) | Die einfachste Lösung, die funktioniert: YAGNI, Standardbibliothek zuerst, wenig Code. Ausschalten mit „stop ponytail“ |
| [superpowers](https://github.com/obra/superpowers) | Arbeitsabläufe: brainstorming, Pläne, systematisches Debugging, TDD, Code-Review, Prüfen vor dem Abschluss |
| [example-skills](https://github.com/anthropics/skills) | Design, Kunst, Web-Artifacts, Webapp-Tests, MCP-Builder, Skill-Creator und mehr |
| [academy-guide](https://github.com/anthropics/skills) | Anthropic-Academy-Inhalte |
| [context7](https://github.com/anthropics/claude-plugins-official) | Aktuelle Dokumentation zu Bibliotheken und Frameworks |
| php-lsp, jdtls-lsp *(optional)* | Sprachserver für PHP und Java |

Dazu kommen:
- **graphify**: macht aus Code und Dokumenten einen Wissensgraphen (`/graphify`).
- **`CLAUDE.md`**: eine Übersicht aller Add-ons für Claude, damit es sie auch von selbst benutzt.

## Installation (Windows)

```powershell
git clone https://github.com/Anivia1337/claude-code-setup.git
cd claude-code-setup
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Optionen:
- `-Lsp`: installiert zusätzlich php-lsp und jdtls-lsp.
- `-SkipGraphify`: lässt graphify weg.

Danach Claude Code bzw. die Desktop-App neu starten.

Das Skript macht Folgendes:
1. **`~/.claude/settings.json` ergänzen:** Es trägt Plugins und Marktplätze ein. Bestehende Einträge bleiben, daneben liegt ein Backup `settings.json.bak-…`.
2. **Block in `~/.claude/CLAUDE.md` setzen:** Der Block steht zwischen `<!-- claude-code-setup:start/end -->`. Ein erneuter Lauf ersetzt ihn, der Rest deiner Datei bleibt unangetastet.
3. **Plugins installieren:** Das läuft über die `claude` CLI. Steht sie nicht auf dem PATH, nimmt das Skript die `claude.exe` der Desktop-App. Findet es keine von beiden, installierst du die Plugins in Claude Code mit `/plugin`.
4. **graphify installieren:** `pip install --user graphifyy` und `graphify install`. Dafür braucht es Python 3, zum Beispiel per `winget install Python.Python.3.12`.

Für `-Lsp` brauchst du zusätzlich:
- **PHP:** `npm install -g intelephense`.
- **Java:** Eclipse JDT LS als `jdtls` auf dem PATH und ein JDK.

## Connectors (von Hand)

Diese Connectors hängen am Claude-Konto, nicht an einer Datei, und lassen sich deshalb nicht per Skript übernehmen:

- **Galaxus:** Produktsuche im Galaxus/Digitec-Sortiment mit Preis, Bewertungen und Link. So kommt er dazu:
  1. In Claude (Web oder Desktop-App) **Einstellungen → Connectors** öffnen.
  2. Unter **Connectors durchsuchen** nach „Galaxus“ suchen und **Verbinden** drücken.

  Danach steht er in Claude Code und in der App zur Verfügung.

## Manuell / macOS / Linux

Kopiere `enabledPlugins` und `extraKnownMarketplaces` aus [settings.json](settings.json) in deine `~/.claude/settings.json`. Hänge [CLAUDE.md](CLAUDE.md) an deine `~/.claude/CLAUDE.md` an. Danach:

```sh
claude plugin marketplace add DietrichGebert/ponytail
claude plugin marketplace add obra/superpowers
claude plugin marketplace add anthropics/skills
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin install ponytail@ponytail --scope user
claude plugin install superpowers@superpowers-dev --scope user
claude plugin install example-skills@anthropic-agent-skills --scope user
claude plugin install academy-guide@anthropic-agent-skills --scope user
claude plugin install context7@claude-plugins-official --scope user
pip install --user graphifyy && graphify install
```

## Hinweise

- **ponytail und superpowers ziehen manchmal in verschiedene Richtungen:** ponytail will wenig, superpowers will Planung und Tests. Wen das stört, schaltet eines davon in `/plugin` aus.
- **Fremde Plugins führen Hooks aus.** Schau dir die verlinkten Repos an, bevor du installierst.

## Lizenz

MIT für die Dateien hier. Die Plugins haben ihre eigenen Lizenzen.
