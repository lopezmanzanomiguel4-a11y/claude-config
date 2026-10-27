# Hook PreToolUse : bloque les commandes dangereuses avant qu'elles s'executent.
# Claude Code envoie la commande prevue en JSON sur l'entree standard.
# Fichier volontairement sans accents (compatibilite Windows PowerShell 5.1).

$callInput = [Console]::In.ReadToEnd() | ConvertFrom-Json
$command = [string]$callInput.tool_input.command

$regles = @(
    @{ motif = 'rm\s+-[a-zA-Z]*r[a-zA-Z]*f|rm\s+-[a-zA-Z]*f[a-zA-Z]*r'; raison = 'Suppression recursive forcee (rm -rf) bloquee.' },
    @{ motif = 'Remove-Item\b.*-Recurse';                                raison = 'Suppression recursive (Remove-Item -Recurse) bloquee.' },
    @{ motif = '\bdel\s+/s|\brmdir\s+/s|\brd\s+/s';                      raison = 'Suppression recursive (del/rmdir /s) bloquee.' },
    @{ motif = '\bformat\s+[a-zA-Z]:';                                   raison = 'Formatage de disque bloque.' },
    @{ motif = 'git\s+push\b.*(--force|-f\b)';                           raison = 'git push --force bloque : demande a Miguel.' },
    @{ motif = 'git\s+add\b.*\.env\b';                                   raison = 'Ajout d un fichier .env a Git bloque : jamais de secrets sur GitHub.' },
    @{ motif = '/api/system\b.*(coreVoltage|frequency)|(coreVoltage|frequency).*/api/system\b'; raison = 'Changement de voltage ou de frequence du Bitaxe bloque : accord explicite de Miguel requis.' }
)

foreach ($regle in $regles) {
    if ($command -match $regle.motif) {
        @{
            hookSpecificOutput = @{
                hookEventName            = 'PreToolUse'
                permissionDecision       = 'deny'
                permissionDecisionReason = $regle.raison
            }
        } | ConvertTo-Json -Compress -Depth 5
        exit 0
    }
}

# Aucune regle touchee : pas de decision, le flux normal de permissions s'applique.
exit 0
