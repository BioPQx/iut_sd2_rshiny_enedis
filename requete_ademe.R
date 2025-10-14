install.packages(c("httr", "jsonlite"))

library(httr)
library(jsonlite)

base_url <- "https://data.ademe.fr/data-fair/api/v1/datasets/dpe03existant/lines"

# Initialiser un dataframe vide
final_df <- data.frame()

# Initialiser la page
page <- 1

repeat {
  # Paramètres de la requête
  params <- list(
    page = page,
    size = 5,
    select = "nom_commune_ban",
      "etiquette_ges",
      "code_departement_ban",
      "annee_construction",
      "besoin_chauffage",
      "type_batiment",
      "type_installation_chauffage",
      "date_etablissement_dpe",
      "code_postal_ban",
      "surface_habitable_logement",
      "hauteur_sous_plafond",
      "etiquette_dpe",
    qs = 'code_departement_ban : "01"  OR code_departement_ban : "30"'
  )
  
  # Encodage de l'URL avec paramètres
  url_encoded <- modify_url(base_url, query = params)
  
  # Effectuer la requête GET
  response <- GET(url_encoded)
  
  # Extraire le contenu JSON et convertir en dataframe
  content <- fromJSON(rawToChar(response$content), flatten = TRUE)
  df <- content$results
  
  # Ajouter les résultats au dataframe final
  final_df <- rbind(final_df, df)
  
  # Si moins de 5 résultats renvoyés, fin de la boucle
  if (nrow(df) < 5) {
    break
  }
  
  # Page suivante
  page <- page + 1
}

# Afficher la dimension du dataframe final
dim(final_df)
# Afficher les données
View(final_df)
