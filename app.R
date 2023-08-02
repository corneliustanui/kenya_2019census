# Author: Cornelius Tanui
# Purpose: Interactive App to Visualize KPHC2019 Data
# Date Created: 2019
# Date Updated: Version Controlled  on GitHub
# File Name: app.R
# File Purpose: Combine functional files for the app.

# source app files
source("./Scripts/0_packages_&_data.R")
source("./Scripts/1_ui.R")
source("./Scripts/2_server.R")

# build app
shinyApp(ui = ui, server = server)

# TODO: Add copyright at as a footer on each page
# TODO: Add a population pyramid chart
# TODO: Add a demographics map and color by median age
