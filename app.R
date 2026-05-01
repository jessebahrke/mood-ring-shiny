#library(rsconnect)
#rsconnect::setAccountInfo(name='jessebahrke', token='CB450D8264DE8036815912D114B18B5A', secret='oi4EzZnOjWFU8jHbuUqzHntE3EgKLoZStabWeTLF')
#rsconnect::deployApp('/Users/jessebahrke/Documents/mode-ring-shiny/')
#shiny::runApp("/Users/jessebahrke/Documents/mode-ring-shiny/")

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
      body { background-color: #ffffff; font-family: -apple-system, sans-serif; overflow-x: hidden; }
      
      /* Centered Tabs with Underline */
      .nav-tabs { 
        border: none; display: flex; justify-content: center; align-items: center;
        margin: 20px auto; width: 100%; max-width: 500px; padding: 0;
      }
      .nav-tabs > li { flex: 1; text-align: center; list-style: none; position: relative; }
      .nav-tabs > li > a { 
        border: none !important; background: transparent !important; 
        color: #8e8e93; font-size: 11px; padding: 10px 0;
        text-transform: uppercase; letter-spacing: 0.8px; display: block;
      }
      .nav-tabs > li.active > a { color: #007aff !important; font-weight: 600; }
      .nav-tabs > li.active > a::after {
        content: ''; position: absolute; bottom: 0; left: 25%; width: 50%;
        height: 2px; background-color: #007aff; border-radius: 2px;
      }

      /* Ring & Photo Styling */
      .main-ring-wrapper { width: 220px; height: 220px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto; border: 12px solid #5A5A5A; box-sizing: border-box; }
      .white-spacer { width: 100%; height: 100%; border-radius: 50%; display: flex; align-items: center; justify-content: center; border: 6px solid white; box-sizing: border-box; }
      .profile-photo { width: 100%; height: 100%; border-radius: 50%; background-size: cover; background-position: center; background-color: #f0f0f0; }
      
      /* Input Grid Spacing */
      .mood-input-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; width: 220px; margin: 30px auto; }
      .mood-btn { width: 60px; height: 60px; border: none; border-radius: 50%; cursor: pointer; }
      
      /* Friends Grid - Tightened and Bumped Down */
      .friends-view-container { margin-top: 50px; } /* This bumps the whole grid down */
      .friends-grid { 
        display: grid; 
        grid-template-columns: repeat(2, 1fr); 
        gap: 25px 10px; 
        max-width: 280px; 
        margin: 0 auto; 
      }
      .friend-widget { display: flex; flex-direction: column; align-items: center; }
      .friend-ring { width: 110px; height: 110px; border-radius: 50%; display: flex; align-items: center; justify-content: center; border: 6px solid #ccc; box-sizing: border-box; }
      .friend-spacer { width: 100%; height: 100%; border-radius: 50%; display: flex; align-items: center; justify-content: center; border: 3px solid white; box-sizing: border-box; }
      .friend-photo { width: 100%; height: 100%; border-radius: 50%; background-size: cover; }
      .friend-name { margin-top: 8px; color: #1c1c1e; font-size: 13px; font-weight: 400; }

      /* Info Tab Styling */
      .info-container { max-width: 500px; margin: 30px auto 0; padding: 10px 20px; color: #1c1c1e; line-height: 1.5; }
      .info-header { font-size: 1.3em; font-weight: 400; margin-bottom: 15px; color: #1c1c1e; }
      .color-key { display: flex; align-items: center; margin-bottom: 8px; gap: 10px; font-size: 0.85em; }
      .dot { width: 12px; height: 12px; border-radius: 50%; flex-shrink: 0; }
    "))
  ),
  
  tabsetPanel(
    tabPanel("My Mode",
      div(style = "margin-top: 40px;",
          uiOutput("my_ring_ui"),
          div(class = "mood-input-grid",
              lapply(1:9, function(i) {
                actionButton(paste0("btn_", i), "", class = "mood-btn", style = paste0("background-color:", grid_colors[i], ";"))
              })
          )
      )
    ),
    
    tabPanel("Friends Mode",
      div(class = "friends-view-container",
          div(class = "friends-grid",
              lapply(1:nrow(friends), function(i) {
                div(class = "friend-widget",
                    div(class = "friend-ring", style = paste0("border-color: ", friends$color[i], ";"),
                        div(class = "friend-spacer",
                            div(class = "friend-photo", style = paste0("background-image: url('", friends$img[i], "');"))
                        )
                    ),
                    div(class = "friend-name", friends$name[i])
                )
              })
          )
      )
    ),

    tabPanel("What Are Modes",
      div(class = "info-container",
          div(class = "info-header", "Understanding Your Mode"),
          tags$p(style="font-size: 0.9em;", "Based on the ", tags$strong("Circumplex Model of Affect"), "."),
          tags$ul(style="font-size: 0.85em;",
            tags$li(tags$strong("Valence:"), " Pleasure (Left to Right)"),
            tags$li(tags$strong("Arousal:"), " Energy (Top to Bottom)")
          ),
          tags$hr(style="margin: 15px 0;"),
          tags$h5("The Color Guide", style="margin-bottom: 10px; font-weight:600; font-size:0.9em;"),
          div(class="color-key", div(class="dot", style="background:#FF0000;"), tags$span("Red: High Energy / Challenging")),
          div(class="color-key", div(class="dot", style="background:#FFFF00;"), tags$span("Yellow: High Energy / Pleasant")),
          div(class="color-key", div(class="dot", style="background:#00FF00;"), tags$span("Green: Low Energy / Pleasant")),
          div(class="color-key", div(class="dot", style="background:#0000FF;"), tags$span("Blue: Low Energy / Challenging")),
          div(class="color-key", div(class="dot", style="background:#5A5A5A;"), tags$span("Grey: Neutral / Balanced")),
          tags$p(style="margin-top:15px; font-style:italic; color:#888; font-size: 0.8em;", 
                 "Select a mode that matches your current state.")
      )
    )
  )
)

server <- function(input, output) {
  selected_color <- reactiveVal("#5A5A5A")
  
  observe({
    lapply(1:9, function(i) {
      observeEvent(input[[paste0("btn_", i)]], {
        selected_color(grid_colors[i])
      })
    })
  })
  
  output$my_ring_ui <- renderUI({
    div(class = "main-ring-wrapper", style = paste0("border-color: ", selected_color(), ";"),
        div(class = "white-spacer",
            div(class = "profile-photo", style = "background-image: url('contact_photo.png');")
        )
    )
  })
}

shinyApp(ui = ui, server = server)