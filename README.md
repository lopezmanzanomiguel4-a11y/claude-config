# claude-config

Ma configuration Claude Code : instructions permanentes, skills, sous-agents et garde-fous.
Chaque nouveau projet démarre avec un Claude déjà configuré.

## Contenu

| Fichier | Rôle |
|---|---|
| `CLAUDE.md` | Qui je suis et comment Claude doit travailler. Lu au début de chaque session. |
| `skills/synthese-cours/SKILL.md` | Recette : cours PDF → synthèse LaTeX + quiz → vérification. |
| `agents/verificateur.md` | Sous-agent qui contrôle une synthèse contre sa source, sans avoir vu la rédaction. |
| `hooks/bloque-danger.ps1` | Garde-fou : bloque `rm -rf`, suppressions récursives, `git push --force`, l'ajout d'un `.env` et tout changement de voltage/fréquence du Bitaxe. |
| `install.ps1` | Copie tout dans `%USERPROFILE%\.claude` et branche le hook dans `settings.json`. |

## Installation (Windows)

```powershell
cd C:\Users\<toi>\claude-config
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Le script sauvegarde ton ancien `CLAUDE.md` et ton ancien `settings.json` avant de les remplacer.

## Vérifier que tout marche

Dans un dossier de test, lance `claude`, puis :

- `/hooks` : le hook `PreToolUse` sur `Bash|PowerShell` doit apparaître.
- `/agents` : `verificateur` doit apparaître.
- `/skills` : `synthese-cours` doit apparaître.
- Test du garde-fou : demande « lance `Remove-Item test -Recurse` ». Claude doit être bloqué avec le message du hook.

## Workflow de mise à jour

1. Modifie un fichier dans ce repo (ou demande à Claude Code de le faire).
2. Relance `install.ps1`.
3. `git add .` → `git commit -m "ajoute ..."` → `git push`.

## Prochaines briques

- Skills et agents du projet Bitaxe MCP.
- Skills et agents du labo finance multi-agents.
