library(shiny)
library(plotly)
library(bslib)
library(shinymanager)
library(leaflet)
library(sf)



# --- Thème initial obligatoire pour Bootstrap 5 ---
initial_theme <- bs_theme(version = 5, bg = "white", fg = "black")

ui <- fluidPage(
  theme = initial_theme,
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    tags$style(HTML("
      html, body, .container-fluid {
        height: 100%;
        width: 100%;
        margin: 0;
        padding: 0;
      }

      body { 
        color: var(--bs-body-color);
        overflow: hidden;
      }

      /* --- Bandeau du haut --- */
      .title-box {
        background-color: var(--bs-secondary);
        color: var(--bs-body-fg);
        height: 8%;
        min-height: 60px;
        font-size: 28px;
        padding-left: 20px;
        line-height: 60px;
        letter-spacing: 2px;
        display: flex;
        align-items: center;
        justify-content: space-between;
      }

      .title-actions { display: flex; align-items: center; gap: 18px; }

      .menu-button {
        background: none;
        border: none;
        font-size: 28px;
        color: var(--bs-body-fg);
        cursor: pointer;
        margin-right: 10px;
      }

      /* --- Zone principale --- */
      .main-layout {
        display: flex;
        flex-direction: row;
        height: 92%;
        width: 100%;
        transition: all 0.3s ease;
      }

      /* --- Sidebar fixe en pixels --- */
      .sidebar-panel {
        background-color: var(--bs-secondary);
        color: var(--bs-body-fg);
        width: 280px;
        min-width: 280px;
        height: 100%;
        border-top-right-radius: 15px;
        padding: 18px;
        box-shadow: 2px 0 8px #24354f80;
        transition: all 0.3s ease;
        flex-shrink: 0;
      }

      .sidebar-hidden {
        margin-left: -280px;
        opacity: 0;
        transition: all 0.3s ease;
      }

      /* --- Zone principale flexible --- */
      .main-content {
        flex: 1;
        background-color: var(--bs-body-bg);
        color: var(--bs-body-color);
        border-radius: 10px;
        overflow: auto;
        padding: 20px;
        margin: 10px;
        height: calc(100% - 20px);
        transition: all 0.3s ease;
      }

      .section-title { color: var(--bs-fg); font-size: 15px; margin-bottom: 8px; font-weight: bold; letter-spacing: 1px; }
      .circle-legend { background: var(--bs-secondary); color: var(--bs-body-bg); border-radius: 7px; padding: 10px; margin-top: 16px; }
    "))
  ),
  
  # --- Bandeau titre ---
  div(
    class="title-box",
    div(
      style="display:flex; align-items:center; gap:10px;",
      tags$button(id="menu_toggle", class="menu-button", icon("bars")),
      span("Projet RShiny")
    ),
    div(
      class="title-actions",
      tags$a(
        href="https://github.com/BioPQx/iut_sd2_rshiny_enedis",
        tags$img(
          src="https://raw.githubusercontent.com/BioPQx/iut_sd2_rshiny_enedis/refs/heads/main/img_github.png",
          alt="github projet",
          width="45px",
          height="45px"
        )
      ),
      selectInput(
        "theme_choice",
        label = NULL,
        choices = c("Sombre"="dark", "Clair"="light", "Licorne"="unicorn"),
        selected = "dark",
        width = "130px"
      )
    )
  ),
  
  # --- Contenu principal dynamique ---
  div(
    class = "main-layout",
    
    # Sidebar
    div(
      id = "sidebar_panel",
      class = "sidebar-panel",
      h4(textOutput("user_info")),
      style = "width: clamp(150px, 30%, 450px);",
      div(class="section-title", "VARIABLES"),
      selectInput("var_selected", "Variable :", choices = NULL),
      div(
        style = "display: flex; align-items: center;",
        textInput(
          inputId = "filter_condition",
          label = "Filtrer les données :",
          value = ""
        ),
        tags$span(
          icon("info-circle"),
          title = "Exemple : type_batiment == 'maison'",
          style = "margin-left: 5px; cursor: pointer;"
        )
      )
    ),
    
    # Contenu principal
    div(
      id = "main_content",
      class = "main-content",
      tabsetPanel(
        tabPanel(
          "Carte",
          leafletOutput("map", height = "800px")
        ),
        tabPanel(
          "Données",
          plotlyOutput("graph_plot", height="65%"),
          hr(),
          fluidRow(
            column(
              width = 6,
              uiOutput("stats_box")
            ),
            column(
              width = 6,
              uiOutput("auto_box"),
              actionButton("auto_analysis", "Analyse automatique", class = "btn btn-primary")
            )
          )
        ),
        tabPanel(
          "Sortie brute",
          fluidRow(
            column(
              width = 12,
              downloadButton("export_csv", "Exporter CSV", class = "btn btn-success"),
              br(), br(),
              DT::dataTableOutput("raw_table")
            )
          )
        )
      )
    ),
  
  # --- Script JS pour basculer la sidebar ---
  tags$script(HTML("
    $(document).on('click', '#menu_toggle', function() {
      $('#sidebar_panel').toggleClass('sidebar-hidden');
    });
  "))
),
)
ui <- shinymanager::secure_app(ui, language = "fr")
