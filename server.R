library(shiny)
library(plotly)
library(readr)
library(dplyr)
library(vroom)
library(rlang)

url <- "https://raw.githubusercontent.com/BioPQx/iut_sd2_rshiny_enedis/refs/heads/main/df_dpe.csv"
data <- read.csv(url)

function(input, output, session) {
  
  # Met à jour dynamiquement les listes déroulantes selon les colonnes du CSV

    updateSelectInput(session, "var_x", choices = names(data), selected = names(data)[1])
    updateSelectInput(session, "var_y", choices = names(data), selected = names(data)[2])
    
    
    get_plot_type <- function(data, x, y) {
      if (is.numeric(data[[x]]) && is.numeric(data[[y]])) {
        return("scatter")
      } else if ((is.factor(data[[x]]) || is.character(data[[x]])) && is.numeric(data[[y]])) {
        return("boxplot")
      } else if ((is.factor(data[[y]]) || is.character(data[[y]])) && is.numeric(data[[x]])) {
        return("boxplot")
      } else {
        return("bar")  # deux colonnes catégorielles
      }
    }
    
    output$graph_plot <- renderPlotly({
      req(input$var_x, input$var_y, input$max_points)
      
      plot_data <- head(data, input$max_points)  # Limite initiale
      
      # Appliquer le filtre si le champ n'est pas vide
      if (input$filter_condition != "") {
        # Attention : parse_expr peut générer une erreur si la syntaxe est incorrecte
        try({
          plot_data <- plot_data %>% filter(!!parse_expr(input$filter_condition))
        }, silent = TRUE)
      }
      
      # Détecter le type de graphique
      plot_type <- get_plot_type(plot_data, input$var_x, input$var_y)
      
      p <- switch(plot_type,
                  scatter = ggplot(plot_data, aes_string(x = input$var_x, y = input$var_y)) +
                    geom_point(color="#5082B7", alpha=0.8) +
                    theme_minimal(),
                  boxplot = ggplot(plot_data, aes_string(x = input$var_x, y = input$var_y)) +
                    geom_boxplot(fill="#5082B7", alpha=0.5) +
                    theme_minimal(),
                  bar = ggplot(plot_data, aes_string(x = input$var_x, fill=input$var_y)) +
                    geom_bar(position="dodge") +
                    theme_minimal()
      )
      
      ggplotly(p)
    })
}
