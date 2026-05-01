# library(rsconnect)
# rsconnect::setAccountInfo(name='jessebahrke', token='CB450D8264DE8036815912D114B18B5A', secret='oi4EzZnOjWFU8jHbuUqzHntE3EgKLoZStabWeTLF')
# rsconnect::deployApp('/Users/jessebahrke/Documents/mode-ring-shiny/')
# shiny::runApp("/Users/jessebahrke/Documents/mode-ring-shiny/")

library(shiny)

# 1. Setup Colors
grid_colors <- c(
  "#FF0000", "#FF8000", "#FFFF00",
  "#800080", "#5A5A5A", "#80FF00",
  "#0000FF", "#008080", "#00FF00"
)

# 2. Setup Mock Data
friends <- data.frame(
  name = c("Nina", "Natalie", "Jillian", "Kristen", "Denali", "Dr. Silas"),
  color = c("#00FF00", "#FF0000", "#5A5A5A", "#FFFF00", "#0000FF", "#FF8000"),
  img = paste0("https://i.pravatar.cc/150?u=", 1:6),
  stringsAsFactors = FALSE
)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body { background-color: #ffffff; font-family: -apple-system, sans-serif; overflow-x: hidden; padding-bottom: 80px; }
      
      /* Navigation Styling */
      .nav-tabs { border: none !important; display: flex; justify-content: center; margin: 20px auto; width: 100%; max-width: 450px; padding: 0; }
      .nav-tabs > li { flex: 1; text-align: center; list-style: none; position: relative; }
      .nav-tabs > li:nth-child(4) { display: none; }
      .nav-tabs > li > a { border: none !important; background: transparent !important; color: #8e8e93; font-size: 11px; padding: 10px 0; text-transform: uppercase; letter-spacing: 0.8px; display: block; }
      .nav-tabs > li.active > a { color: #007aff !important; font-weight: 600; }
      .nav-tabs > li.active > a::after { content: ''; position: absolute; bottom: 0; left: 25%; width: 50%; height: 2px; background-color: #007aff; border-radius: 2px; }

      .settings-footer { position: fixed; bottom: 35px; left: 0; width: 100%; display: flex; justify-content: center; z-index: 1000; }
      .settings-link { color: #8e8e93; font-size: 11px; text-transform: uppercase; letter-spacing: 0.8px; text-decoration: none !important; }

      /* Ring & Photo Styling */
      .main-ring-wrapper { width: 220px; height: 220px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 40px auto 0; border: 12px solid #5A5A5A; box-sizing: border-box; }
      .white-spacer { width: 100%; height: 100%; border-radius: 50%; display: flex; align-items: center; justify-content: center; border: 6px solid white; box-sizing: border-box; }
      .profile-photo { width: 100%; height: 100%; border-radius: 50%; background-size: cover; background-position: center; background-color: #f0f0f0; }
      
      .mood-input-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; width: 220px; margin: 30px auto; }
      .mood-btn { width: 60px; height: 60px; border: none; border-radius: 50%; cursor: pointer; }
      
      /* Education Page Styling - No Bars */
      .info-container { max-width: 480px; margin: 30px auto 0; padding: 0 25px; color: #1c1c1e; line-height: 1.6; }
      .info-header { font-size: 1.4em; font-weight: 400; margin-bottom: 8px; }
      .info-subhead { font-size: 0.9em; font-weight: 600; margin-top: 24px; margin-bottom: 8px; color: #3a3a3c; }
      .color-key-row { display: flex; align-items: center; gap: 12px; margin-bottom: 10px; font-size: 0.85em; }
      .color-dot { width: 12px; height: 12px; border-radius: 50%; flex-shrink: 0; }
    "))
  ),

  div(class = "settings-footer", actionLink("go_settings", "Settings", class = "settings-link")),

  tabsetPanel(id = "main_tabs",
    tabPanel("Mode",
      div(uiOutput("my_ring_ui"),
          div(class = "mood-input-grid",
              lapply(1:9, function(i) {
                actionButton(paste0("btn_", i), "", class = "mood-btn", style = paste0("background-color:", grid_colors[i], ";"))
              })
          )
      )
    ),

    tabPanel("Friends",
      div(class = "friends-view-container", style="margin-top: 50px;",
          div(style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 25px 10px; max-width: 280px; margin: 0 auto;",
              lapply(1:nrow(friends), function(i) {
                div(style="display: flex; flex-direction: column; align-items: center;",
                    div(style=paste0("width:110px; height:110px; border-radius:50%; border:6px solid ", friends$color[i], "; display:flex; align-items:center; justify-content:center; box-sizing:border-box;"),
                        div(style="width:100%; height:100%; border:3px solid white; border-radius:50%; display:flex; align-items:center; justify-content:center; box-sizing:border-box;",
                            div(style=paste0("width:100%; height:100%; border-radius:50%; background-size:cover; background-image:url('", friends$img[i], "');"))
                        )
                    ),
                    div(style="margin-top:8px; font-size:13px;", friends$name[i])
                )
              })
          )
      )
    ),

    tabPanel("Education",
      div(class = "info-container",
          div(class = "info-header", "The Circumplex Model"),
          tags$p(style="font-size: 0.9em; color: #8e8e93;", "This application uses James Russell's Circumplex Model to map human emotion onto a two-dimensional space."),
          
          div(class = "info-subhead", "The Dimensions"),
          tags$p(style="font-size: 0.85em;", tags$strong("Valence:"), " Represents the horizontal axis. It measures how 'pleasant' (Right) or 'unpleasant' (Left) an emotion feels."),
          tags$p(style="font-size: 0.85em;", tags$strong("Arousal:"), " Represents the vertical axis. It measures the level of 'energy' or 'activation'—ranging from high (Top) to low (Bottom)."),
          
          div(class = "info-subhead", "Color Mappings"),
          div(class="color-key-row", div(class="color-dot", style="background:#FF0000;"), tags$span(tags$strong("Red:"), " High Energy / Low Pleasure (Stressed)")),
          div(class="color-key-row", div(class="color-dot", style="background:#FFFF00;"), tags$span(tags$strong("Yellow:"), " High Energy / High Pleasure (Excited)")),
          div(class="color-key-row", div(class="color-dot", style="background:#00FF00;"), tags$span(tags$strong("Green:"), " Low Energy / High Pleasure (Calm)")),
          div(class="color-key-row", div(class="color-dot", style="background:#0000FF;"), tags$span(tags$strong("Blue:"), " Low Energy / Low Pleasure (Sad)")),
          div(class="color-key-row", div(class="color-dot", style="background:#5A5A5A;"), tags$span(tags$strong("Grey:"), " Neutral (Balanced)")),

      )
    ),

    tabPanel("Settings",
      div(style="max-width: 400px; margin: 40px auto; padding: 0 20px;",
          tags$h3("Account", style="font-weight:300; margin-bottom:20px;"),
          div(style="padding: 15px 0; display: flex; justify-content: space-between; border-bottom: 0.5px solid #eee;", "Profile Visibility", tags$span("Public", style="color:#007aff;")),
          div(style="padding: 15px 0; display: flex; justify-content: space-between; border-bottom: 0.5px solid #eee;", "Privacy Policy", tags$span(">")),
          div(style="padding: 15px 0; display: flex; justify-content: space-between;", "Log Out", style="color:#ff3b30;")
      )
    )
  )
)

server <- function(input, output, session) {
  selected_color <- reactiveVal("#5A5A5A")
  observe({ lapply(1:9, function(i) { observeEvent(input[[paste0("btn_", i)]], { selected_color(grid_colors[i]) }) }) })
  observeEvent(input$go_settings, { updateTabsetPanel(session, "main_tabs", selected = "Settings") })
  
  output$my_ring_ui <- renderUI({
    div(class = "main-ring-wrapper", style = paste0("border-color: ", selected_color(), ";"),
        div(class = "white-spacer",
            div(class = "profile-photo", style = "background-image: url('contact_photo.png');")
        )
    )
  })
}

shinyApp(ui = ui, server = server)