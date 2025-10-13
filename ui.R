library(shiny)
fluidPage(
  
  tags$head(
    tags$style(HTML("
      html, body, .tab-content, .tab-pane {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      body {background-color: #2B3F51;}
      
      .title-box {
        background-color: #4F5C6C;
        padding-top: 5px;
        padding-bottom: 5px;
        border-radius: 0px;
        margin-bottom: 10px;
        width: 100%;
        margin: 0px;
      }
      
      .sidebar {
        background-color: #4F5C6C;
        padding: 15px;
        border-radius: 0px;
        height: 80vh;         
        overflow-y: auto;     
      }
      
      .content-area {
        background-color: #4F5C6C;
        padding: 20px;
        border-radius: 0px;
        height: 80vh;         
        overflow-y: auto;
      }
      
      .nav-tabs {margin-top: 10px;}
      
      
      h2 {margin-top: 10px; margin-bottom: 10px; color: #ffffff ;text-decoration: underline;font-weight: 900;}
      h4, label {color: #ffffff;}
      h6, label {color: #5082B7;font-family: 'Arial';font-size: 12px;font-weight: 900;line-height: 0;}
      .nav-tabs > li > a {color: #ffffff;}
      
      
    "))
  ),
  
  # Titre en haut (pleine largeur)
  div(class = "title-box", h2("Projet Rshiny", align = "center")),
  
  # Onglets principaux
  tabsetPanel(
    
    # Onglet 1
    tabPanel(h6("Onglet 1"),
             fluidRow(
               column(
                 width = 3, 
                 div(class="sidebar",
                     h4("Filtres Onglet 1"),
                     checkboxGroupInput("choix1", "Choisissez :", 
                                        choices = c("Option A", "Option B", "Option C"))
                 )
               ),
               column(
                 width = 9,
                 div(class="content-area",
                     # Ici ajout des sous-onglets
                     tabsetPanel(
                       tabPanel("Sous-Onglet A", 
                                p("Contenu du sous-onglet A")),
                       tabPanel("Sous-Onglet B", 
                                p("Contenu du sous-onglet B")),
                       tabPanel("Sous-Onglet C", 
                                p("Contenu du sous-onglet C"))
                     )
                 )
               )
             )
    ),
    
    # Onglet 2
    tabPanel(h6("Onglet 2"),
             fluidRow(
               column(
                 width = 3,
                 div(class="sidebar",
                     h4("Filtres Onglet 2"),
                     radioButtons("choix2", "Sélection :", 
                                  choices = c("Choix 1", "Choix 2"))
                 )
               ),
               column(
                 width = 9,
                 div(class="content-area",
                     h4("Contenu Onglet 2"),
                     tabsetPanel(
                       tabPanel("Sous-Onglet A", p("Contenu A - Onglet 2")),
                       tabPanel("Sous-Onglet B", p("Contenu B - Onglet 2")),
                       tabPanel("Sous-Onglet C", p("Contenu C - Onglet 2"))
                     )
                 )
               )
             )
    )
  )
)
