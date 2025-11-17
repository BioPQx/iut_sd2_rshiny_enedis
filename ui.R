library(shiny)
library(plotly)
library(bslib)
library(shinymanager)
library(leaflet)
library(sf)
library(markdown)



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
          src="https://raw.githubusercontent.com/BioPQx/iut_sd2_rshiny_enedis/refs/heads/main/Img/img_github.png",
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
          "Contexte",
          fluidRow(
            # --- COLONNE GAUCHE : TEXTE (Largeur 8/12) ---
            column(
              width = 8, 
              h2("Diagnostic de Performance Énergétique pour l’Open Data University"),
              p("Avec l’accélération du changement climatique et la hausse des prix de l’énergie, la sobriété énergétique est au cœur des préoccupations des Français. Aussi, afin d’éclairer et inspirer les acteurs de la transition écologique, Enedis propose des analyses et chiffres clés pour éclairer et orienter les décisions."),
              p("En particulier, un des leviers de réduction des gaz à effets de serre (GES) et des consommations énergétiques est l’amélioration de la performance énergétique des bâtiments. Ainsi, l’un des objectifs de la Stratégie Bas Carbone (feuille de route de la France pour réduire ses émissions de GES et atteindre la neutralité carbone en 2050), est de diminuer d‘ici 2030 les émissions de gaz à effets de serre des bâtiments."),
              p("Dans ce contexte, le Diagnostic de Performance Energétique (DPE) permet d’évaluer la performance énergétique et climatique d’un bâtiment. Il consiste en une étiquette pouvant aller de A à G pour chaque logement ou bâtiment, qui évalue sa consommation d’énergie et son impact en terme d’émission de GES. Il sert notamment à identifier les passoires énergétiques (étiquettes F et G du DPE, c’est-à-dire les logements qui consomment le plus d’énergie et/ou émettent le plus de gaz à effet de serre). Il a pour objectif d’informer l’acquéreur ou le locataire sur la « valeur verte », de recommander des travaux à réaliser pour l’améliorer et d’estimer ses charges énergétiques. De plus, la mise en location de ces passoires thermiques sera progressivement interdite (interdiction pour les bâtiments notés G+ au 1er janvier 2023, qui sera étendue par la suite)."),
              p("Point à noter :"),
              tags$ul(
                tags$li("Les données proviennent des bases de l'ADEME"),
                tags$li("Utilisez les onglets pour naviguer.")
              )
            ),
            
            # --- COLONNE DROITE : IMAGE (Largeur 4/12) ---
            column(
              width = 4,
              div(
                style = "margin-top: 20px; text-align: center;", # Style optionnel pour centrer et aérer
                
                # REMPLACEZ "mon_image.png" PAR LE NOM DE VOTRE FICHIER
                # Le fichier doit être dans un dossier nommé 'www' à côté de votre script
                img(src = "https://raw.githubusercontent.com/BioPQx/iut_sd2_rshiny_enedis/refs/heads/main/Img/DPE-C.png", width = "100%", style = "border-radius: 10px;"),
                img(src = "https://raw.githubusercontent.com/BioPQx/iut_sd2_rshiny_enedis/refs/heads/main/Img/picto-maison-png.webp", width = "100%", style = "border-radius: 10px;")
              )
            )
          )
        ),
        tabPanel(
          "Carte",
          leafletOutput("map", height = "800px")
        ),
        tabPanel(
          "Données",
          plotlyOutput("graph_plot", height="65%", width="100%"),
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
