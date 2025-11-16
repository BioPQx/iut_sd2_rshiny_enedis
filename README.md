# iut_sd2_rshiny_enedis
Projet RShiny S3 <br>
Par Antoine MAURIN et Ewann MARRE

Ce document `README.md` est présent dans le repository du projet. Il permet de présenter les objectifs globaux, les livrables attendus et les spécifications de l'application à développer.

## Objectifs globaux & Livrables

Voici les principaux livrables attendus pour ce projet :

* **Repository GitHub**
    * Nommé `iut_sd2_shiny_enedis`.
    * Contient tous les scripts utilisés (commentés).
    * Inclut ce fichier `README.md` pour présenter les informations importantes.
* **Rapport d'étude RMarkdown (4 pages max)**
    * Mise en forme, rédaction et export au format HTML.
    * Contient : KPI pertinents, statistiques bivariées et différents types de graphiques.
    * Permet l'automatisation (choix du code postal, type de logement).
* **Documentation Technique (2 pages max)**
    * Rédigée en markdown.
    * Inclut un schéma de l'architecture.
    * Explique l'installation locale et présente les packages nécessaires.
* **Documentation Fonctionnelle (2 pages max)**
    * Rédigée en markdown.
    * Présente l'intérêt de chaque page.
    * Détaille les fonctionnalités majeures de l'application.
* **Captation Vidéo (5 min max)**
    * Explique comment installer l'application en local.
    * Présente les fonctionnalités majeures de l'application.

## Spécifications de l'application (Cahier des charges)

L'application doit respecter les fonctionnalités décrites dans les packs suivants, tels que définis dans le cahier des charges.

### Pack "Standard"
* Application déployée sur shinyapps.io (accessible via URL).
* Dispose d'au moins 3 onglets/pages différents.
* Utilise des images et des icônes.
* Contient une cartographie interactive (avec markers).
* Possède une page "Contexte" (présentation, visualisation des données).
* Interaction via widgets (select, checkbox, sliders, radio buttons).
* Filtre dynamique des données pour actualiser les tableaux et visualisations.
* Proposition de plusieurs KPI.
* Au moins 4 types de graphiques (histogramme, boite à moustache, diagramme, nuage de point).

### Pack "Intermédiaire"
* Permet à l'utilisateur de choisir un thème de son choix.
* Boutons d'export pour les graphiques (.png) et les données (.csv).
* Permet de sélectionner 2 variables (X et Y) pour calcul de corrélation et régression linéaire simple.

### Pack "Expert"
* Dispose d'une charte visuelle personnalisée (via script CSS).
* Permet de rafraîchir les données (via API et date de réception du DPE).
* Demande de se connecter avec un utilisateur/mot de passe pour accéder à l'application.

## Liens utiles

* [Lien vers l'application shinyapps.io](https-votre-lien-ici.shinyapps.io/app-name) (à compléter)
* [Lien vers la vidéo de présentation](lien-vers-la-video) (à compléter)
* [Lien vers la documentation technique](lien-vers-doc-technique.md) (à compléter)
* [Lien vers la documentation fonctionnelle](lien-vers-doc-fonctionnelle.md) (à compléter)
