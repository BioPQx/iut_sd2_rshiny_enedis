install.packages(c("httr", "jsonlite"))

library(httr)
library(jsonlite)

base_url <- "https://data.ademe.fr/data-fair/api/v1/datasets/dpe03existant/lines"

final_df <- data.frame()
page <- 1

repeat {
  params <- list(
    page = page,
    size = 5,
    select = paste(
      "nom_commune_ban",
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
      sep = ","
    ),
    qs = 'code_departement_ban : "01" OR code_departement_ban : "30"'
  )
  
  url_encoded <- modify_url(base_url, query = params)
  response <- GET(url_encoded)
  stop_for_status(response)
  
  content <- fromJSON(rawToChar(response$content), flatten = TRUE)
  df <- content$results
  
  final_df <- rbind(final_df, df)
  
  if (nrow(df) < 5) break
  page <- page + 1
  Sys.sleep(0.2)  # sécurité pour éviter de spammer l'API
}

dim(final_df)
View(final_df)
