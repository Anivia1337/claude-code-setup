<#
  Claude Code Team-Setup: Plugins, Marktplaetze, CLAUDE.md und graphify.

    .\install.ps1                 # alles ausser den Sprachservern
    .\install.ps1 -Lsp            # dazu php-lsp und jdtls-lsp
    .\install.ps1 -SkipGraphify   # ohne graphify (braucht Python)

  Bestehende Einstellungen bleiben: settings.json wird nur ergaenzt (Backup
  daneben), CLAUDE.md bekommt einen markierten Block, den ein erneuter Lauf
  ersetzt statt verdoppelt. Laeuft in Windows PowerShell 5.1 und PowerShell 7.
#>
param(
    [switch]$Lsp,
    [switch]$SkipGraphify,
    [string]$ClaudeDir = (Join-Path $HOME '.claude')
)
$ErrorActionPreference = 'Stop'
$hier = $PSScriptRoot
New-Item -ItemType Directory -Force $ClaudeDir | Out-Null

# ---------- settings.json ergaenzen ----------
$vorlage = Get-Content (Join-Path $hier 'settings.json') -Raw | ConvertFrom-Json
$plugins = @($vorlage.enabledPlugins.PSObject.Properties.Name |
    Where-Object { $Lsp -or $_ -notmatch '-lsp@' })

$ziel = Join-Path $ClaudeDir 'settings.json'
if (Test-Path $ziel) {
    Copy-Item $ziel "$ziel.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
    $s = Get-Content $ziel -Raw | ConvertFrom-Json
} else { $s = [pscustomobject]@{} }
if (-not $s) { $s = [pscustomobject]@{} }

foreach ($feld in 'enabledPlugins', 'extraKnownMarketplaces') {
    if (-not $s.PSObject.Properties[$feld]) { $s | Add-Member $feld ([pscustomobject]@{}) }
}
foreach ($p in $plugins) {
    if (-not $s.enabledPlugins.PSObject.Properties[$p]) { $s.enabledPlugins | Add-Member $p $true }
}
foreach ($m in $vorlage.extraKnownMarketplaces.PSObject.Properties) {
    if (-not $s.extraKnownMarketplaces.PSObject.Properties[$m.Name]) {
        $s.extraKnownMarketplaces | Add-Member $m.Name $m.Value
    }
}
# UTF-8 ohne BOM, auch unter PowerShell 5.1
[IO.File]::WriteAllText($ziel, ($s | ConvertTo-Json -Depth 20), (New-Object Text.UTF8Encoding $false))
Write-Host "settings.json: $($plugins.Count) Plugins eingetragen"

# ---------- CLAUDE.md: markierter Block ----------
$start = '<!-- claude-code-setup:start -->'; $ende = '<!-- claude-code-setup:end -->'
$block = "$start`n" + (Get-Content (Join-Path $hier 'CLAUDE.md') -Raw).Trim() + "`n$ende"
$md = Join-Path $ClaudeDir 'CLAUDE.md'
$alt = if (Test-Path $md) { Get-Content $md -Raw } else { '' }
$muster = [regex]::Escape($start) + '[\s\S]*?' + [regex]::Escape($ende)
$neu = if ($alt -match $muster) { [regex]::Replace($alt, $muster, { $block }) }
       elseif ($alt.Trim()) { $alt.TrimEnd() + "`n`n" + $block + "`n" }
       else { $block + "`n" }
[IO.File]::WriteAllText($md, $neu, (New-Object Text.UTF8Encoding $false))
Write-Host "CLAUDE.md: Block aktualisiert ($md)"

# ---------- Plugins installieren (claude CLI) ----------
# Ohne CLI auf dem PATH: die Desktop-App bringt eine eigene claude.exe mit.
$claude = (Get-Command claude -ErrorAction SilentlyContinue).Source
if (-not $claude) {
    $claude = Get-ChildItem "$env:LOCALAPPDATA\Claude-Data\*\claude-code\*\*\claude.exe", "$env:LOCALAPPDATA\AnthropicClaude\*\claude.exe" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName
}
if ($claude) {
    foreach ($m in $vorlage.extraKnownMarketplaces.PSObject.Properties) {
        & $claude plugin marketplace add $m.Value.source.repo 2>&1 | Out-Host
    }
    foreach ($p in $plugins) { & $claude plugin install $p --scope user 2>&1 | Out-Host }
} else {
    Write-Warning 'Keine claude CLI gefunden. Die Plugins stehen in settings.json; in Claude Code mit /plugin installieren, falls sie nicht von selbst kommen.'
}

# ---------- graphify ----------
if (-not $SkipGraphify) {
    $py = Get-Command py, python -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($py) {
        & $py.Source -m pip install --user --upgrade graphifyy
        & $py.Source -m graphify install
    } else {
        Write-Warning 'Kein Python gefunden: graphify uebersprungen (winget install Python.Python.3.12, dann erneut ausfuehren).'
    }
}

if ($Lsp) {
    Write-Host 'Sprachserver brauchen: npm install -g intelephense (PHP) und Eclipse JDT LS als "jdtls" auf dem PATH plus ein JDK (Java).'
}
Write-Host 'Fertig. Claude Code bzw. die Desktop-App neu starten.'
