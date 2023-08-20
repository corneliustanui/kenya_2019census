body <- dashboardBody(
  fluidRow(
    width = 12,
    ("valueBoxOutput male"),
    ("valueBoxOutput female"),
    ("valueBoxOutput total"),
    
  ),
  
  fluidRow(
    width = 12,
    column(width = 3,
           box(
             title = "Controls", width = NULL, status = "primary",
             "Box content",
             height = 300,
           )
    ),
    
    column(width = 9,
      fluidRow(
        box(
          title = "Box 1", width = 6, status = "primary",
          "Box content",
          height = 300,
        ),
        box(
          title = "Box 2", width = 6, status = "primary",
          "Box content",
          height = 300,
        )
      ),
      
      fluidRow(
        box(
          title = "Box 3", width = 6, status = "primary",
          "Box content",
          height = 300,
        ),
        box(
          title = "Box 4", width = 6, status = "primary",
          "Box content",
          height = 300,
        )
      )
    )
    )
  )

# We'll save it in a variable `ui` so that we can preview it in the console
ui <- dashboardPage(
  dashboardHeader(title = "Mixed layout"),
  dashboardSidebar(),
  body
)

# Preview the UI in the console
shinyApp(ui = ui, server = function(input, output) { })