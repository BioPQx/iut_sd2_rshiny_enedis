install.packages(c("httr", "jsonlite"))


library(httr)
library(jsonlite)

base_url <- "https://data.ademe.fr/data-fair/api/v1/datasets/dpe03existant/lines"
# Paramètres de la requête
params <- list(
  page = 1,
  size = 5,
  select = "numero_dpe,code_postal_ban,etiquette_dpe,date_reception_dpe",
  qs = 'code_postal_ban:"69008" AND date_reception_dpe:[2023-06-29 TO 2023-08-30]'
) 

# Encodage des paramètres
url_encoded <- modify_url(base_url, query = params)
print(url_encoded)

# Effectuer la requête
response <- GET(url_encoded)

# Afficher le statut de la réponse
print(status_code(response))

# On convertit le contenu brut (octets) en une chaîne de caractères (texte). Cela permet de transformer les données reçues de l'API, qui sont généralement au format JSON, en une chaîne lisible par R
content = fromJSON(rawToChar(response$content), flatten = FALSE)

# Afficher le nombre total de ligne dans la base de données
print(content$total)

# Afficher les données récupérées
df <- content$result
dim(df)
View(df)


# __________________________________AVEC BOUCLE__________________________________

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
    select = "numero_dpe,code_postal_ban,etiquette_dpe,date_reception_dpe",
    qs = 'code_postal_ban:"69008" AND date_reception_dpe:[2023-06-29 TO 2023-08-30]'
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
