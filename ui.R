library(shiny)
library(bslib)

light_theme <- bs_theme(
  version = 5,
  bg = "#FFFFFF", fg = "#000000", primary = "#2C3E50"
)

dark_theme <- bs_theme(
  version = 5,
  bg = "#2C3E50", fg = "#FFFFFF", primary = "#E74C3C"
)

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
      "Projet RShiny",
      tags$a(href="https://github.com/BioPQx/iut_sd2_rshiny_enedis",
      tags$img(src="https://raw.githubusercontent.com/BioPQx/iut_sd2_rshiny_enedis/refs/heads/main/img_github.png", alt="github projet", width = "45px", height = "45px")),
      theme = light_theme,
      selectInput("theme_choice", "Choisissez un thème:", c("Clair", "Sombre")),
      textOutput("txt"),
  ),
  
  fluidRow(
    column(
      width = 3,
      div(class="sidebar-panel",
          div(class="section-title","VARIABLES"),
          selectInput("variables", "Variable des places (en ratio):", 
                      choices = c("VAR_AN_MOY")),
          selectInput("trou", "Variable des trous (en volume):", 
                      choices = c("HOP 2015")),
          
          div(class="section-title","FONDS"),
          selectInput("fonds", "Modifier l'ordre des fonds:", 
                      choices = c("analyse", "maille", "contour")),
          sliderInput("opacity", "Opacité du layering affiché", min = 0, max = 100, value = 25),
          
          checkboxInput("show_points", "Afficher les ronds sur la carte", TRUE),
          checkboxInput("show_legende", "Afficher la légende"),
          checkboxInput("show_donnees", "Afficher les brutes")
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
            tabPanel("Données", p("Affichage des données")),
            tabPanel("Maille", p("Affichage de la maille")),
            tabPanel("Contour", p("Affichage des contours"))
          )
      )
    )
  )
)
