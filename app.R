# Author: Cornelius Tanui
# Purpose: Interactive App to Visualize KPHC2019 Data
# Date Created: 2019
# Date Updated: Version Controlled  on GitHub
# File Name: app.R
# File Purpose: Combine functional files for the app.

# source app files
source("./Scripts/0_packages.R")
# source("./Scripts/1.1_write_data.R")
source("./Scripts/1.2_read_data.R")
source("./Scripts/2_ui.R")
source("./Scripts/3_server.R")

# build app
shinyApp(ui = ui, server = server)
