#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/


# source app files
source("./Scripts/1_ui.R")
source("./Scripts/2_server.R")

# build app
shinyApp(ui = ui, server = server)

