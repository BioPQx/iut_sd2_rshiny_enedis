library(shiny)
library(bslib)

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

ui <- fluidPage(
  theme = unicorn_theme,
  
  tags$head(
    tags$style(HTML("
      body {
        color: var(--bs-body-color);
      }
      .title-box {
        background-color: var(--bs-secondary);
        color: var(--bs-body-fg);
        height: 60px;
        font-size: 28px;
        padding-left:20px;
        line-height: 60px;
        letter-spacing: 2px;
        display: flex;
        align-items: center;
        justify-content: space-between;
      }
      .title-actions {
        display: flex;
        align-items: center;
        gap: 18px;
      }
      .sidebar-panel {
        background-color: var(--bs-secondary);
        color: var(--bs-body-fg);
        min-height: 90vh;
        border-top-right-radius: 15px;
        padding: 18px;
        box-shadow: 2px 0 8px #24354f80;
      }
      .main-content {
        background-color: var(--bs-body-bg);
        color: var(--bs-body-color);
        min-height: 90vh;
        border-radius: 10px;
        margin-left:10px;
        overflow: auto;
        padding: 20px;
      }
      .section-title {
        color: var(--bs-fg);
        font-size: 15px;
        margin-bottom: 8px;
        font-weight: bold;
        letter-spacing: 1px;
      }
      .circle-legend {
        background: var(--bs-secondary);
        color: var(--bs-body-bg);
        border-radius: 7px; padding: 10px; margin-top: 16px
      }
    "))
  ),
  
  div(
    class="title-box",
    span("Projet RShiny"),
    div(
      class="title-actions",
      tags$a(href="https://github.com/BioPQx/iut_sd2_rshiny_enedis",
             tags$img(src="https://raw.githubusercontent.com/BioPQx/iut_sd2_rshiny_enedis/refs/heads/main/img_github.png",
                      alt="github projet", width = "45px", height = "45px")
      ),
      selectInput("theme_choice", label = NULL,
                  choices = c(
                    "Sombre" = "dark",
                    "Clair" = "light",
                    "Licorne" = "unicorn"
                  ),
                  selected = "dark_theme",
                  width = "130px",
      )
    )
  ),
  
  fluidRow(
    column(
      width = 3,
      div(class="sidebar-panel",
          div(class="section-title","VARIABLES"),
          selectInput("variables", "Variable des places (en ratio):", choices = c("VAR_AN_MOY")),
          selectInput("trou", "Variable des trous (en volume):", choices = c("HOP 2015")),
          div(class="section-title","FONDS"),
          selectInput("fonds", "Modifier l'ordre des fonds:", choices = c("analyse", "maille", "contour")),
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
                     div(style="height:500px; background:var(--bs-body-bg); border-radius:8px; margin-bottom:12px; color:var(--bs-body-color);",
                         "Zone de visualisation de la carte ici..."),
                     div(class="circle-legend", "Légende graphique ici")
            ),
            tabPanel("Données", p("Affichage des données")),
            tabPanel("Maille", p("Affichage de la maille")),
            tabPanel("Contour", p("Affichage des contours"))
          )
      )
    )
  )
)

