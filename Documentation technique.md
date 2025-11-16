# Packages Nécessaires
Pour fonctionner, l'application nécessite les packages R suivants.

`shiny` : Le framework de base pour l'application.

`plotly` : Pour les graphiques interactifs.

`dplyr` : Utilisé pour la manipulation de données (filtrage dynamique).

`rlang` : Nécessaire pour l'évaluation dynamique des filtres dplyr (!!parse_expr()).

`bslib` : Pour la gestion des thèmes Bootstrap 5 et le changement dynamique.

`ggplot2` : Pour la création des graphiques de base (avant conversion en plotly).

`shinymanager` : Pour gérer l'écran de connexion et l'authentification des utilisateurs.

**Commande d'installation**
Vous pouvez installer toutes les dépendances en une seule fois avec la commande suivante dans votre console R :

```R
install.packages(c(
  "shiny", "plotly", "dplyr", "rlang",
  "bslib", "ggplot2", "shinymanager"
))
```

# Installation et Lancement
Suivez ces étapes pour lancer l'application sur votre poste local.

**Prérequis**
- Avoir installé R sur votre machine.

- Avoir installé RStudio Desktop (recommandé).

**Étapes**
### Obtenir les fichiers :

- Téléchargez les fichiers `ui.R` et `server.R`.

- Placez-les dans le même dossier. L'application `style.css` (référencée dans `ui.R`) doit également s'y trouver si elle existe.

- *Alternative (si le projet est sur Git)* : Clonez le dépôt `git clone <url_du_projet>`.

### Installer les packages :

- Ouvrez RStudio.

- Exécutez la commande d'installation fournie à la section précédente pour installer toutes les dépendances.

### Lancer l'application :

- Dans RStudio, ouvrez le fichier `ui.R` ou `server.R`.

- Cliquez sur le bouton **"Run App"** qui apparaît en haut à droite de l'éditeur.

- *Alternative* : Exécutez `shiny::runApp()` dans la console R, en vous assurant que le répertoire de travail est bien celui contenant les fichiers.

### Se connecter :

- L'application vous présentera un écran de connexion.

- Utilisez l'un des identifiants définis dans server.R pour vous connecter. Par exemple :

  - Utilisateur : `admin` / Mot de passe : `adminpass`

  - Utilisateur : `asardell` / Mot de passe : `licorne`
