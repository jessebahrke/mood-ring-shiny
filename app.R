# library(rsconnect)
# rsconnect::setAccountInfo(name='jessebahrke', token='CB450D8264DE8036815912D114B18B5A', secret='oi4EzZnOjWFU8jHbuUqzHntE3EgKLoZStabWeTLF')
# rsconnect::deployApp('/Users/jessebahrke/Documents/mode-ring-shiny/')
# shiny::runApp("/Users/jessebahrke/Documents/mode-ring-shiny/")

library(shiny)

# 1. Setup Colors (The 8 colors in requested order for the logo ring)
logo_colors <- c(
  "#FF0000", "#FF8000", "#FFFF00", "#80FF00", 
  "#00FF00", "#008080", "#0000FF", "#800080"
)

# Colors for the 9-button grid inside the app
grid_colors <- c(
  "#FF0000", "#FF8000", "#FFFF00", 
  "#800080", "#5A5A5A", "#80FF00", 
  "#0000FF", "#008080", "#00FF00" 
)

# Setup Mock Data
friends <- data.frame(
  name = c("Nina", "Natalie", "Jillian", "Kristen", "Denali", "Dr. Silas"),
  color = c("#00FF00", "#FF0000", "#5A5A5A", "#FFFF00", "#0000FF", "#FF8000"),
  img = paste0("https://i.pravatar.cc/150?u=", 1:6),
  stringsAsFactors = FALSE
)

# Create the faded ring CSS using a conic gradient
rainbow_fade <- paste0("conic-gradient(", paste(logo_colors, collapse = ", "), ", ", logo_colors[1], ")")

ui <- fluidPage(
  tags$head(
    tags$style(HTML(paste0("
      body { background-color: #ffffff; font-family: -apple-system, sans-serif; overflow-x: hidden; padding-bottom: 80px; }
      
      /* --- LOGIN HERO STYLING --- */
      .login-container { max-width: 320px; margin: 80px auto; text-align: center; display: flex; flex-direction: column; align-items: center; }
      .login-logo-ring {
        width: 140px; height: 140px; border-radius: 50%; padding: 12px;
        background: ", rainbow_fade, ";
        margin-bottom: 25px; display: flex; align-items: center; justify-content: center; box-sizing: border-box;
      }
      .logo-inner-white { width: 100%; height: 100%; background: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; overflow: hidden; }
      .avatar-silhouette {
        width: 100%; height: 100%; background-color: #5A5A5A;
        mask: url('https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/svgs/solid/user.svg') no-repeat center;
        -webkit-mask: url('https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/svgs/solid/user.svg') no-repeat center;
        mask-size: 60% 60%; -webkit-mask-size: 60% 60%;
      }
      .login-title { font-size: 28px; font-weight: 300; margin-bottom: 40px; color: #1c1c1e; letter-spacing: -0.5px; }
      .login-input-group { width: 100%; margin-bottom: 12px; }
      .login-input-group input { width: 100%; padding: 14px; border: 1px solid #d1d1d6; border-radius: 12px; font-size: 16px; background: #fbfbfd; box-sizing: border-box; }
      .login-btn { width: 100%; padding: 14px; background-color: #007aff; color: white; border: none; border-radius: 12px; font-size: 16px; font-weight: 600; margin-top: 15px; cursor: pointer; }

      /* --- APP UI STYLING --- */
      .nav-tabs { border: none !important; display: flex; justify-content: center; margin: 20px auto; width: 100%; max-width: 450px; padding: 0; }
      .nav-tabs > li { flex: 1; text-align: center; list-style: none; position: relative; }
      .nav-tabs > li > a { border: none !important; background: transparent !important; color: #8e8e93; font-size: 11px; padding: 10px 0; text-transform: uppercase; letter-spacing: 0.8px; display: block; }
      .nav-tabs > li.active > a { color: #007aff !important; font-weight: 600; }
      .nav-tabs > li.active > a::after { content: ''; position: absolute; bottom: 0; left: 25%; width: 50%; height: 2px; background-color: #007aff; border-radius: 2px; }
      .nav-tabs > li:nth-child(4) { display: none; }

      /* --- GEAR ICON STYLING --- */
      .settings-gear-container { position: fixed; bottom: 25px; right: 25px; z-index: 1000; }
      .gear-icon { 
        width: 24px; height: 24px; background-color: #8e8e93;
        mask: url('https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/svgs/solid/gear.svg') no-repeat center;
        -webkit-mask: url('https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/svgs/solid/gear.svg') no-repeat center;
      }

      /* Main App Elements */
      .main-ring-wrapper { width: 220px; height: 220px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 40px auto 0; border: 12px solid #5A5A5A; box-sizing: border-box; }
      .white-spacer { width: 100%; height: 100%; border-radius: 50%; display: flex; align-items: center; justify-content: center; border: 6px solid white; box-sizing: border-box; }
      .profile-photo { width: 100%; height: 100%; border-radius: 50%; background-size: cover; background-position: center; background-color: #f0f0f0; }
      .mood-input-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; width: 220px; margin: 30px auto; }
      .mood-btn { width: 60px; height: 60px; border: none; border-radius: 50%; cursor: pointer; }
      .friends-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 25px 10px; max-width: 280px; margin: 50px auto 0; }
      
      .info-container { max-width: 480px; margin: 30px auto 0; padding: 0 25px; color: #1c1c1e; line-height: 1.6; }
      .info-subhead { font-size: 0.95em; font-weight: 600; margin-top: 24px; margin-bottom: 8px; color: #3a3a3c; }
      .color-dot { width: 12px; height: 12px; border-radius: 50%; flex-shrink: 0; }
    ")))
  ),
  uiOutput("display_ui")
)

server <- function(input, output, session) {
  is_logged_in <- reactiveVal(FALSE)
  selected_color <- reactiveVal("#5A5A5A")

  observeEvent(input$login_btn, { is_logged_in(TRUE) })
  observe({ lapply(1:9, function(i) { observeEvent(input[[paste0("btn_", i)]], { selected_color(grid_colors[i]) }) }) })
  observeEvent(input$go_settings, { updateTabsetPanel(session, "main_tabs", selected = "Settings") })

  output$display_ui <- renderUI({
    if (!is_logged_in()) {
      div(class = "login-container",
          div(class = "login-logo-ring", div(class = "logo-inner-white", div(class = "avatar-silhouette"))),
          div(class = "login-title", "Mode Ring"),
          div(class = "login-input-group", textInput("email_login", NULL, placeholder = "Email")),
          div(class = "login-input-group", passwordInput("pass_login", NULL, placeholder = "Password")),
          actionButton("login_btn", "Sign In", class = "login-btn")
      )
    } else {
      tagList(
        conditionalPanel(
          condition = "input.main_tabs == 'Mode'",
          div(class = "settings-gear-container", 
              actionLink("go_settings", label = div(class = "gear-icon"), class = "settings-link")
          )
        ),
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
            div(class = "friends-grid",
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
          ),
          tabPanel("Education",
            div(class = "info-container",
                div(style="font-size:1.4em; font-weight:400;", "The Science of 'Mode'"),
                tags$p(style="font-size:0.9em; color:#8e8e93; margin-top:10px;", 
                       "Mode Ring uses the Circumplex Model of Affect to help you communicate your internal state at a glance."),
                
                div(class = "info-subhead", "The Core Dimensions"),
                tags$p(style="font-size: 0.85em;", tags$strong("Valence:"), " The horizontal axis. This measures the 'pleasure' of an emotion, ranging from unpleasant (displeasure) to pleasant."),
                tags$p(style="font-size: 0.85em;", tags$strong("Arousal:"), " The vertical axis. This measures the 'activation' or physical energy level, ranging from low (stillness) to high (alertness)."),

                div(class = "info-subhead", "How to Select Your Mode"),
                tags$p(style="font-size: 0.85em; color: #3a3a3c;", "Perform a quick 'Internal Scan' by asking two questions:"),
                tags$ol(style="font-size: 0.85em; padding-left: 20px;",
                  tags$li(tags$strong("Body (Energy):"), " Is my heart racing or am I feeling heavy/tired? (Up vs. Down)"),
                  tags$li(tags$strong("Mind (Pleasure):"), " Is this a feeling I'd generally like to continue or escape? (Right vs. Left)")
                ),

                div(class = "info-subhead", "The Quadrants"),
                div(style="display:flex; flex-direction:column; gap:12px;",
                    div(style="display:flex; align-items:flex-start; gap:12px; font-size:0.85em;", 
                        div(class="color-dot", style="background:#FF0000; margin-top:4px;"), 
                        div(tags$strong("Red: High Energy / Unpleasant"), tags$br(), "Commonly: Anxious, Frustrated, or Overwhelmed.")),
                    div(style="display:flex; align-items:flex-start; gap:12px; font-size:0.85em;", 
                        div(class="color-dot", style="background:#FFFF00; margin-top:4px;"), 
                        div(tags$strong("Yellow: High Energy / Pleasant"), tags$br(), "Commonly: Excited, Motivated, or Joyful.")),
                    div(style="display:flex; align-items:flex-start; gap:12px; font-size:0.85em;", 
                        div(class="color-dot", style="background:#00FF00; margin-top:4px;"), 
                        div(tags$strong("Green: Low Energy / Pleasant"), tags$br(), "Commonly: Calm, Content, or Serene.")),
                    div(style="display:flex; align-items:flex-start; gap:12px; font-size:0.85em;", 
                        div(class="color-dot", style="background:#0000FF; margin-top:4px;"), 
                        div(tags$strong("Blue: Low Energy / Unpleasant"), tags$br(), "Commonly: Sad, Lonely, or Bored.")),
                    div(style="display:flex; align-items:flex-start; gap:12px; font-size:0.85em;", 
                        div(class="color-dot", style="background:#5A5A5A; margin-top:4px;"), 
                        div(tags$strong("Grey: Neutral / Balanced"), tags$br(), "A steady baseline state; neither high energy nor strong emotion."))
                )
            )
          ),
          tabPanel("Settings",
            div(style="max-width:400px; margin:40px auto; padding:0 20px;",
                tags$h3("Account", style="font-weight:300; margin-bottom:20px;"),
                div(style="padding:15px 0; display:flex; justify-content:space-between; border-bottom:0.5px solid #eee;", "Profile Visibility", tags$span("Public", style="color:#007aff;")),
                div(style="padding:15px 0; display:flex; justify-content:space-between;", "Log Out", style="color:#ff3b30;")
            )
          )
        )
      )
    }
  })

  output$my_ring_ui <- renderUI({
    div(class = "main-ring-wrapper", style = paste0("border-color: ", selected_color(), ";"),
        div(class = "white-spacer",
            div(class = "profile-photo", style = "background-image: url('contact_photo.png');")
        )
    )
  })
}

shinyApp(ui, server)