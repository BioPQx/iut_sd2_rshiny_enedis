# Documentation Fonctionnelle : Projet RShiny

Cette documentation présente les fonctionnalités clés et la structure de l'application "Projet RShiny", un outil d'analyse exploratoire de données, axé sur les Diagnostics de Performance Énergétique (DPE).

## Fonctionnalités Majeures
L'application offre plusieurs fonctionnalités puissantes pour l'exploration et la visualisation de données :

- **Sélection de Variable** : Permet à l'utilisateur de choisir une variable spécifique (ex: `type_installation_chauffage`) depuis un menu déroulant pour une analyse détaillée.

- **Filtrage Dynamique** : Offre la possibilité de filtrer le jeu de données (ex: exclure les valeurs 'NA') pour affiner l'analyse et les visualisations.

- **Visualisation Instantanée** : Génère automatiquement un graphique (ex: diagramme en barres pour les variables catégorielles) résumant la variable sélectionnée, en indiquant le nombre total d'observations (ex: "sur 233 000 DPE").

- **Résumé Statistique** : Affiche un résumé quantitatif des données, comme le décompte des observations pour les "Top catégories" (ex: `individuel: 96361 observations`).

- **Analyse Automatisée** : Un module "Analyse automatique" identifie le type de variable (ex: "Variable catégorielle"), la catégorie dominante, et propose des suggestions contextuelles pour faciliter l'analyse.

- **Navigation par Onglets** : L'interface principale est divisée en plusieurs vues (Carte, Données, Maille, Contour) pour différentes méthodes d'exploration.

- **Gestion de Session** : L'application gère les sessions utilisateur ("Connecté en tant que...").

- **Personnalisation de l'Interface** : Un bouton "Sombre" permet de basculer entre les thèmes clair et sombre pour le confort visuel.

- **Actions** : Un bouton d'action flottant (`+`) est présent, afin de se deconnecter de l'application.

## Intérêt de Chaque Page de l'Application
L'interface principale est un tableau de bord interactif composé d'un panneau de contrôle latéral et d'une zone de visualisation centrale à onglets.

### Panneau de Contrôle (Latéral)
- **Objectif** : Définir les paramètres de l'analyse. C'est ici que l'utilisateur sélectionne la **variable d'intérêt** et applique les **filtres** nécessaires. Les modifications dans ce panneau mettent à jour dynamiquement la zone de visualisation principale.

### Zone de Visualisation (Onglets)
L'application segmente l'analyse en quatre vues distinctes, accessibles par des onglets :

  **1. Onglet "Carte" :**

-    Présente un résumé visuel (graphique en barres) et **quantitatif** ("Top catégories") de la variable sélectionnée. Elle inclut également le module d'"Analyse automatique" pour des insights rapides. Note : Bien que nommé "Carte", il affiche l'analyse statistique de base.

  **2. Onglet "Données" :**

-    Visualiser les données sous forme de différents graphiques avec possibilité de filtrer afin d'afinner ses analyses

  **3. Onglet "Sortie brute" :**

-    Présenter les données brutes ou filtrées sous forme de tableau. L'utilisateur peut y inspecter les lignes de données individuelles qui composent les graphiques et les analyses.
