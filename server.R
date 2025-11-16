library(shiny)
library(plotly)
library(dplyr)
library(rlang)
library(bslib)
library(ggplot2)
library(shinymanager)

credentials <- data.frame(
  user = c("utilisateur1", "admin", "utilisateur2", "asardell","2"),
  password = c("motdepasse1", "adminpass", "motdepasse2", "licorne","2"),
  stringsAsFactors = FALSE
)

# --- Charger le CSV ---
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
server <- function(input, output, session) {
  
  # ---------------------------- AUTH ----------------------------
  res_auth <- shinymanager::secure_server(
    check_credentials = check_credentials(credentials)
  )
  
  output$user_info <- renderText({
    paste("Connecté en tant que :", res_auth$user)
  })
  
  # ---------------------------- THEMES ---------------------------
  observe({
    req(input$theme_choice)
    session$setCurrentTheme(themes[[input$theme_choice]])
  })
  
  # ----------------------- VARIABLES DISPONIBLES ----------------
  observe({
    updateSelectInput(session, "var_selected", choices = names(data))
  })
  
  # ------------------- FONCTION TYPE VARIABLE -------------------
  get_type <- function(v) {
    if (is.numeric(v)) return("numeric")
    if (is.character(v) || is.factor(v)) return("categorical")
    return("other")
  }
  
  # ---------------------------- GRAPHIQUE ------------------------
  output$graph_plot <- renderPlotly({
    req(input$var_selected)
    
    df <- data
    
    # Filtre optionnel
    if (input$filter_condition != "") {
      try({ df <- df %>% filter(!!parse_expr(input$filter_condition)) }, silent = TRUE)
    }
    
    var <- input$var_selected
    col <- df[[var]]
    var_type <- get_type(col)
    
    label <- paste0(var, " (sur ", format(nrow(data), big.mark=" "), " DPE)")
    
    # Style général
    base_theme <- theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(size=18, face="bold"),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_line(color="#DDDDDD"),
        axis.title = element_text(face="bold"),
        axis.text = element_text(size=12)
      )
    
    # -------- NUMERIQUE --------
    if (var_type == "numeric") {
      p <- ggplot(df, aes_string(x = var)) +
        geom_histogram(bins = 50, fill="#4C72B0", color="white", alpha=0.85) +
        geom_vline(aes(xintercept = mean(col, na.rm = TRUE)),
                   linetype = "dashed", color="#C44741", linewidth=0.9) +
        annotate("text", x = mean(col, na.rm = TRUE), y = Inf, vjust = -0.5,
                 label = paste("Moyenne :", round(mean(col, na.rm=TRUE),2)),
                 color="#C44741", fontface="bold", size=4) +
        labs(title = label, x = var, y = "Nombre d'observations") +
        base_theme
      
      # -------- CATEGORIEL --------
    } else if (var_type == "categorical") {
      top_vals <- df %>% count(!!sym(var)) %>% arrange(desc(n)) %>% slice_head(n = 20)
      p <- ggplot(top_vals, aes_string(x = var, y = "n")) +
        geom_col(fill="#4C72B0", alpha=0.85) +
        coord_flip() +
        labs(title = paste0(label, " — Top 20"), y = "Fréquence", x = var) +
        base_theme
      
      # -------- AUTRE --------
    } else {
      p <- ggplot() + labs(title="Type non supporté") + base_theme
    }
    
    ggplotly(p) %>%
      layout(hoverlabel = list(bgcolor="white", font=list(size=13, color="black")),
             plot_bgcolor="white", paper_bgcolor="white", margin=list(t=60, b=60))
  })
  
  # ---------------------- STATISTIQUES DESCRIPTIVES ------------------------
  output$stats_box <- renderUI({
    req(input$var_selected)
    
    df <- data
    if (input$filter_condition != "") {
      try({ df <- df %>% filter(!!parse_expr(input$filter_condition)) }, silent=TRUE)
    }
    
    var <- input$var_selected
    col <- df[[var]]
    
    if (is.numeric(col)) {
      stats <- list(
        Min = min(col, na.rm=TRUE),
        Q1 = quantile(col,0.25, na.rm=TRUE),
        Médiane = median(col, na.rm=TRUE),
        Moyenne = round(mean(col, na.rm=TRUE),2),
        Q3 = quantile(col,0.75, na.rm=TRUE),
        Max = max(col, na.rm=TRUE),
        N = sum(!is.na(col))
      )
      
      HTML(paste0(
        "<h4><b>Statistiques descriptives : ", var, "</b></h4>",
        "<ul>",
        paste0("<li><b>", names(stats), " :</b> ", stats, collapse="</li>"),
        "</li></ul>"
      ))
    } else {
      tab <- df %>% count(!!sym(var)) %>% arrange(desc(n)) %>% head(10)
      HTML(paste0(
        "<h4><b>Top catégories : ", var, "</b></h4>",
        paste(apply(tab,1,function(r) paste0(r[1], " : <b>", r[2], "</b> occurrences<br>")),
              collapse = "")
      ))
    }
  })
  
  # ---------------------- ANALYSE AUTOMATIQUE ------------------------
  output$auto_box <- renderUI({
    req(input$var_selected)
    req(input$auto_analysis)
    
    df <- data
    if (input$filter_condition != "") {
      try({ df <- df %>% filter(!!parse_expr(input$filter_condition)) }, silent=TRUE)
    }
    
    var <- input$var_selected
    col <- df[[var]]
    
    if (is.numeric(col)) {
      min_val <- min(col, na.rm=TRUE)
      max_val <- max(col, na.rm=TRUE)
      mean_val <- round(mean(col, na.rm=TRUE),2)
      median_val <- median(col, na.rm=TRUE)
      
      HTML(paste0(
        "<h4><b>Analyse automatique — ", var, "</b></h4>",
        "<p>Variable <b>numérique</b> avec <b>", length(col), "</b> valeurs.</p>",
        "<p>Moyenne : <b>", mean_val, "</b>, Médiane : <b>", median_val, "</b></p>",
        "<p>Distribution : ",
        if (abs(mean_val-median_val) < 0.1*mean_val) "symétrique" else "asymétrique",
        "</p>",
        "<p>Min : <b>", min_val, "</b>, Max : <b>", max_val, "</b></p>"
      ))
      
    } else {
      tab <- df %>% count(!!sym(var)) %>% arrange(desc(n))
      HTML(paste0(
        "<h4><b>Analyse automatique — ", var, "</b></h4>",
        "<p>Variable <b>catégorielle</b> avec <b>", nrow(tab), "</b> catégories.</p>",
        "<p>Catégorie dominante : <b>", tab[[var]][1], "</b> (", tab$n[1], " occurrences)</p>",
        "<p>Suggestion : regrouper les catégories rares.</p>"
      ))
    }
  })
  

  # ---------------------- CARTE INTERACTIVE ------------------------
  output$map <- renderLeaflet({
    req(data$coordonnee_cartographique_y_ban, data$coordonnee_cartographique_x_ban)
    
    leaflet(data) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addCircleMarkers(
        lng = ~coordonnee_cartographique_x_ban,
        lat = ~coordonnee_cartographique_y_ban,
        radius = 3,
        color = "#CA3E47",
        stroke = FALSE,
        fillOpacity = 0.6,
        popup = ~paste0(
          "<b>DPE :</b> ", DPE,
          "<br><b>Surface :</b> ", surface_habitable_logement,
          "<br><b>Département :</b> ", code_departement_ban
        ),
        clusterOptions = markerClusterOptions()
      )
  })
  
  # ---------------------- Sortie Brute ------------------------
  
  output$raw_table <- DT::renderDataTable({
    df <- data
    
    # appliquer le filtre si renseigné
    if (input$filter_condition != "") {
      try({
        df <- df %>% filter(!!rlang::parse_expr(input$filter_condition))
      }, silent = TRUE)
    }
    
    DT::datatable(
      df,
      options = list(pageLength = 25, scrollX = TRUE),
      rownames = FALSE
    )
  })
  
  output$export_csv <- downloadHandler(
    filename = function() {
      paste0("sortie_brute_", Sys.Date(), ".csv")
    },
    content = function(file) {
      df <- data
      
      # appliquer le filtre si renseigné
      if (input$filter_condition != "") {
        try({
          df <- df %>% filter(!!rlang::parse_expr(input$filter_condition))
        }, silent = TRUE)
      }
      write.csv(df, file, row.names = FALSE)
    }
  )
}
