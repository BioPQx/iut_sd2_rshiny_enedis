library(shiny)
library(plotly)
library(dplyr)
library(rlang)
library(bslib)
library(ggplot2)

# --- Charger le CSV globalement ---
url <- "https://raw.githubusercontent.com/BioPQx/iut_sd2_rshiny_enedis/refs/heads/main/df_dpe.csv"
data <- read.csv(url)

# --- Définir les thèmes ---
light_theme <- bs_theme(
  version = 5,
  bg = "white", fg = "black", primary = "skyblue", secondary = "lightgrey", base_font = font_google("Funnel Sans"), heading_font = font_google("Outfit")
)

dark_theme <- bs_theme(
  version = 5,
  bg = "#393E46", fg = "#DFD0B8", primary = "#CA3E47", secondary = "#222831", base_font = font_google("Saira"), heading_font = font_google("Smooch Sans")
)

unicorn_theme <- bs_theme(
  version = 5,
  bg = "#D1E9F6", fg = "black", primary = "#BB9AB1", secondary = "#E8C5E5", base_font = font_google("Indie Flower"), heading_font = font_google("Indie Flower")
)

themes <- list(
  light = light_theme,
  dark = dark_theme,
  unicorn = unicorn_theme
)

# --- Fonction serveur ---
function(input, output, session) {
  
  # --- Appliquer un thème initial ---
  session$setCurrentTheme(themes[["dark"]])
  
  # --- Changement dynamique de thème ---
  observe({
    req(input$theme_choice)
    if (!is.null(themes[[input$theme_choice]])) {
      try({
        session$setCurrentTheme(themes[[input$theme_choice]])
      }, silent = TRUE)
    }
  })
  
  # --- Mettre à jour les selectInput pour les axes X et Y ---
  updateSelectInput(session, "var_x", choices = names(data), selected = names(data)[1])
  updateSelectInput(session, "var_y", choices = names(data), selected = names(data)[2])
  
  # --- Détection automatique du type de graphique ---
  get_plot_type <- function(df, x, y) {
    if (is.numeric(df[[x]]) && is.numeric(df[[y]])) {
      "scatter"
    } else if ((is.factor(df[[x]]) || is.character(df[[x]])) && is.numeric(df[[y]])) {
      "boxplot"
    } else if ((is.factor(df[[y]]) || is.character(df[[y]])) && is.numeric(df[[x]])) {
      "boxplot"
    } else {
      "bar"
    }
  }
  
  # --- Graphique interactif ---
  output$graph_plot <- renderPlotly({
    req(input$var_x, input$var_y, input$max_points)
    
    # Limiter le nombre de points
    plot_data <- head(data, input$max_points)
    
    # Appliquer le filtre SQL si renseigné
    if (input$filter_condition != "") {
      try({
        plot_data <- plot_data %>% filter(!!parse_expr(input$filter_condition))
      }, silent = TRUE)
    }
    
    # Déterminer le type de graphique
    plot_type <- get_plot_type(plot_data, input$var_x, input$var_y)
    
    # Créer le graphique ggplot
    p <- switch(plot_type,
                scatter = ggplot(plot_data, aes_string(x=input$var_x, y=input$var_y)) +
                  geom_point(color="#5082B7", alpha=0.8) +
                  theme_minimal(),
                boxplot = ggplot(plot_data, aes_string(x=input$var_x, y=input$var_y)) +
                  geom_boxplot(fill="#5082B7", alpha=0.5) +
                  theme_minimal(),
                bar = ggplot(plot_data, aes_string(x=input$var_x, fill=input$var_y)) +
                  geom_bar(position="dodge") +
                  theme_minimal()
    )
    
    # Convertir en plotly interactif
    ggplotly(p)
  })
}
