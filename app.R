library(shiny)

# Color mapping from AFFECT.svg
grid_colors <- c(
  "#FF0000", "#FF8000", "#FFFF00", 
  "#800080", "#5A5A5A", "#80FF00", 
  "#0000FF", "#008080", "#00FF00" 
)

# Mock data for 6 friends
friends <- data.frame(
  name = c("Nina", "Natalie", "Jillian", "Kristen", "Denali", "Dr. Silas"),
  color = c("#00FF00", "#FF0000", "#5A5A5A", "#FFFF00", "#0000FF", "#FF8000"),
  img = paste0("https://i.pravatar.cc/150?u=", 1:6),
  stringsAsFactors = FALSE
)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body { background-color: #ffffff; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }
      
      /* Minimalist Tab Styling - No Boxes, No Borders */
      .nav-tabs { 
        border: none; 
        display: flex; 
        justify-content: center; 
        margin: 30px 0;
        gap: 40px; 
      }
      .nav-tabs > li { float: none; }
      .nav-tabs > li > a { 
        border: none !important; 
        background: transparent !important;
        color: #8e8e93; 
        font-size: 18px;
        padding: 0;
        transition: color 0.3s ease;
      }
      .nav-tabs > li.active > a { 
        color: #007aff !important; /* Apple Blue */
        font-weight: 600;
      }
      .nav-tabs > li > a:hover { color: #007aff; }

      /* My Mode Styling */
      .main-ring {
        width: 210px; height: 210px;
        border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        margin: 0 auto;
        transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
      }
      .main-photo {
        width: 180px; height: 180px;
        border-radius: 50%;
        background-size: cover;
        background-position: center;
        border: 5px solid white;
      }
      
      /* Mood Grid (Input) */
      .mood-input-grid {
        display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;
        width: 220px; margin: 40px auto;
      }
      .mood-btn { width: 60px; height: 60px; border: none; border-radius: 50%; cursor: pointer; }
      
      /* Friends Mode Grid (2x3) */
      .friends-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 40px 20px;
        max-width: 360px;
        margin: 0 auto;
      }
      .friend-widget { display: flex; flex-direction: column; align-items: center; }
      .friend-ring {
        width: 120px; height: 120px;
        border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
      }
      .friend-photo {
        width: 100px; height: 100px;
        border-radius: 50%;
        background-size: cover;
        border: 4px solid white;
      }
      .friend-name { margin-top: 10px; color: #1c1c1e; font-size: 15px; font-weight: 400; }
    "))
  ),
  
  tabsetPanel(
    tabPanel("My Mode",
      div(style = "margin-top: 20px;",
          uiOutput("my_ring_ui"),
          div(class = "mood-input-grid",
              lapply(1:9, function(i) {
                actionButton(paste0("btn_", i), "", 
                             class = "mood-btn", 
                             style = paste0("background-color:", grid_colors[i], ";"))
              })
          )
      )
    ),
    
    tabPanel("Friends Mode",
      div(style = "margin-top: 20px;",
          div(class = "friends-grid",
              lapply(1:nrow(friends), function(i) {
                div(class = "friend-widget",
                    div(class = "friend-ring", 
                        style = paste0("border: 6px solid ", friends$color[i], ";"),
                        div(class = "friend-photo", 
                            style = paste0("background-image: url('", friends$img[i], "');"))
                    ),
                    div(class = "friend-name", friends$name[i])
                )
              })
          )
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
    div(class = "main-ring", 
        style = paste0("border: 12px solid ", selected_color(), ";",
                       "box-shadow: 0 8px 30px ", selected_color(), "22;"),
        div(class = "main-photo", 
            style = "background-image: url('contact_photo.png');")
    )
  })
}

shinyApp(ui = ui, server = server)