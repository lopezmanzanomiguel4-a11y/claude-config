---
name: synthese-cours
description: Transforme un support de cours (PDF, slides, notes) en synthèse PDF avec formules LaTeX et quiz de révision. À utiliser quand Miguel donne un cours ou un chapitre à synthétiser ou à réviser.
---

# Synthèse de cours

## Règles absolues
- Uniquement le contenu de la source. Aucune définition, exemple ou explication ajoutée de l'extérieur.
- Si un passage de la source est ambigu ou illisible, signale-le au lieu de compléter.
- Toutes les formules en mode math LaTeX.

## Étapes
1. Lis la source en entier avant d'écrire quoi que ce soit.
2. Repère la structure : chapitres, sections, définitions, formules, exemples chiffrés.
3. Rédige la synthèse en LaTeX :
   - un titre par chapitre ;
   - les définitions en encadré ;
   - les formules numérotées, avec la signification de chaque symbole ;
   - les exemples chiffrés de la source, recopiés fidèlement.
4. Ajoute à la fin de chaque chapitre 10 questions de quiz (QCM ou ouvertes), avec les réponses en fin de document.
5. Vérifie qu'un moteur LaTeX est installé (`xelatex --version` ou `pdflatex --version`).
   S'il n'y en a pas, arrête-toi et propose d'installer MiKTeX avant de continuer.
6. Compile en PDF.
7. Lance le sous-agent `verificateur` avec la synthèse et la source. Corrige tout ce qu'il signale, puis recompile.

## Livrable
Un PDF nommé `synthese-<nom-du-cours>-<chapitre>.pdf`, plus le fichier `.tex` source.
