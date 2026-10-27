# Installe la config Claude Code de ce repo dans %USERPROFILE%\.claude
# Usage (dans PowerShell, depuis le dossier du repo) :
#   powershell -ExecutionPolicy Bypass -File .\install.ps1
# Fichier volontairement sans accents (compatibilite Windows PowerShell 5.1).

$ErrorActionPreference = 'Stop'
$repo   = $PSScriptRoot
$cible  = Join-Path $HOME '.claude'
$stamp  = Get-Date -Format 'yyyyMMdd-HHmmss'

New-Item -ItemType Directory -Force -Path $cible | Out-Null

# 1. CLAUDE.md (sauvegarde de l'ancien s'il existe)
$claudeMd = Join-Path $cible 'CLAUDE.md'
if (Test-Path $claudeMd) {
    Copy-Item $claudeMd "$claudeMd.bak-$stamp"
    Write-Host "Ancien CLAUDE.md sauvegarde en CLAUDE.md.bak-$stamp"
}
Copy-Item (Join-Path $repo 'CLAUDE.md') $claudeMd -Force

# 2. Skills, agents, hooks
foreach ($dossier in @('skills', 'agents', 'hooks')) {
    $src = Join-Path $repo $dossier
    $dst = Join-Path $cible $dossier
    New-Item -ItemType Directory -Force -Path $dst | Out-Null
    Copy-Item (Join-Path $src '*') $dst -Recurse -Force
}

# 3. settings.json : ajoute le hook en gardant tes autres reglages
$settingsPath = Join-Path $cible 'settings.json'
if (Test-Path $settingsPath) {
    Copy-Item $settingsPath "$settingsPath.bak-$stamp"
    $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
} else {
    $settings = New-Object PSObject
}

$hookScript = (Join-Path $cible 'hooks\bloque-danger.ps1') -replace '\\', '/'

$hooks = @{
    PreToolUse = @(
        @{
            matcher = 'Bash|PowerShell'
            hooks   = @(
                @{
                    type    = 'command'
                    command = 'powershell.exe'
                    args    = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $hookScript)
                }
            )
        }
    )
}

if ($settings.PSObject.Properties.Name -contains 'hooks') {
    $settings.hooks = $hooks
} else {
    $settings | Add-Member -NotePropertyName 'hooks' -NotePropertyValue $hooks
}

$json = $settings | ConvertTo-Json -Depth 20
[System.IO.File]::WriteAllText($settingsPath, $json, (New-Object System.Text.UTF8Encoding $false))

Write-Host ''
Write-Host "Config installee dans $cible"
Write-Host 'Lance claude dans un dossier, puis tape /hooks, /agents et /skills pour verifier.'
