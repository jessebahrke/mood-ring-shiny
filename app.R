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
      body { background-color: #ffffff; font-family: -apple-system, sans-serif; }
      .nav-tabs { border: none; display: flex; justify-content: center; margin: 30px 0; gap: 40px; }
      .nav-tabs > li > a { border: none !important; background: transparent !important; color: #8e8e93; font-size: 18px; padding: 0; }
      .nav-tabs > li.active > a { color: #007aff !important; font-weight: 600; }

      /* Master Ring Logic: 12px Color, 6px White */
      .main-ring-wrapper {
        width: 220px; height: 220px;
        border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        margin: 0 auto;
        border: 12px solid #5A5A5A; 
        box-sizing: border-box;
      }
      .white-spacer {
        width: 100%; height: 100%;
        border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        border: 6px solid white; 
        box-sizing: border-box;
      }
      .profile-photo {
        width: 100%; height: 100%;
        border-radius: 50%;
        background-size: cover;
        background-position: center;
        background-color: #f0f0f0;
      }
      
      .mood-input-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; width: 220px; margin: 40px auto; }
      .mood-btn { width: 60px; height: 60px; border: none; border-radius: 50%; cursor: pointer; }
      
      .friends-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 40px 20px; max-width: 360px; margin: 0 auto; }
      .friend-widget { display: flex; flex-direction: column; align-items: center; }
      .friend-ring { width: 120px; height: 120px; border-radius: 50%; display: flex; align-items: center; justify-content: center; border: 6px solid #ccc; box-sizing: border-box; }
      .friend-spacer { width: 100%; height: 100%; border-radius: 50%; display: flex; align-items: center; justify-content: center; border: 3px solid white; box-sizing: border-box; }
      .friend-photo { width: 100%; height: 100%; border-radius: 50%; background-size: cover; }
      .friend-name { margin-top: 10px; color: #1c1c1e; font-size: 15px; }
    "))
  ),
  
  tabsetPanel(
    tabPanel("My Mode",
      div(style = "margin-top: 20px;",
          uiOutput("my_ring_ui"),
          div(class = "mood-input-grid",
              lapply(1:9, function(i) {
                actionButton(paste0("btn_", i), "", class = "mood-btn", style = paste0("background-color:", grid_colors[i], ";"))
              })
          )
      )
    ),
    tabPanel("Friends Mode",
      div(style = "margin-top: 20px;",
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