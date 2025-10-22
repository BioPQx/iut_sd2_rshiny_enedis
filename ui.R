library(shiny)
library(plotly)
library(readr)
library(dplyr)
library(vroom)
library(rlang)

fluidPage(
  
  tags$head(
    tags$style(HTML("
      body {background-color: #37475A;}
      .title-box {
        background-color: #2B3F51;
        color: #cccccc;
        height: 60px;
        font-size: 28px;
        padding-left:20px;
        line-height: 60px;
        letter-spacing: 2px;
      }
      .sidebar-panel {
        background-color: #45576A;
        min-height: 90vh;
        color: #ffffff;
        border-top-right-radius: 15px;
        padding: 18px;
        box-shadow: 2px 0 8px #24354f80;
      }
      .main-content {
        background-color: #f8f8f8;
        min-height: 90vh;
        border-radius: 10px;
        margin-left:10px;
        overflow: auto;
        padding: 20px;
      }
      .section-title {
        color: #5082B7;
        font-size: 15px;
        margin-bottom: 8px;
        font-weight: bold;
        letter-spacing: 1px;
      }
      .options-label {
        color: #ffffff;
        font-size: 13px;
        font-weight: bold;
      }
      .shiny-tab-input {
        background-color: #eeeeee; color: #2B3F51;
      }
      .nav-tabs {background-color: #f8f8f8;}
      .nav-tabs .active a {background-color: #5082B7 !important; color:#fff;}
      .circle-legend {background: #ffffff; color: #37475A; border-radius: 7px; padding: 10px; margin-top: 16px}
    "))
  ),
  
  div(class="title-box",
      "Projet RShiny"
  ),
  
  fluidRow(
    column(
      width = 3,
      div(class="sidebar-panel",
          div(class="section-title","VARIABLES"),
          fluidRow(
            column(6, selectInput("var_x", "Axe X :", choices = NULL)),
            column(6, selectInput("var_y", "Axe Y :", choices = NULL))
          ),
          numericInput(
            inputId = "max_points",
            label = "Nombre maximum de points à afficher",
            value = 100,  # valeur par défaut
            min = 10,
            max = 10000,
            step = 100
          ),
          div(
            style = "display: flex; align-items: center;",
            textInput(
              inputId = "filter_condition",
              label = "Filtrer les données :",
              value = ""
            ),
            tags$span(
              icon("info-circle"),  # icône info (de font-awesome)
              title = "Exemple : Sepal.Length > 5 & Species == 'setosa'",
              style = "margin-left: 5px; cursor: pointer;"
            )
          )
      )
    ),
    column(
      width = 9,
      div(class="main-content",
          tabsetPanel(
            tabPanel("Carte", 
                     div(style="height:500px; background:#e5e5e5; border-radius:8px; margin-bottom:12px;",
                         "Zone de visualisation de la carte ici..."),
                     div(class="circle-legend",
                         "Légende graphique ici"
                     )
            ),
            tabPanel("Données", 
                     plotlyOutput("graph_plot", height = "500px")
            ),
            tabPanel("Maille", p("Affichage de la maille")),
            tabPanel("Contour", p("Affichage des contours"))
          )
      )
    )
  )
)
