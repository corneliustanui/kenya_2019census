library(rsconnect)

# a function to stop the script when one of the variables cannot be found
# and to strip quotation marks from the secrets when you supplied them
error_on_missing_name <- function(name) {
  var <- Sys.getenv(name, unset = NA)
  if(is.na(var)) {
    stop(paste0("cannot find ", name, " !"), call. = FALSE)
  }
  gsub("\"", "", var)
}

# Authenticate
setAccountInfo(name = error_on_missing_name("SHINY_ACC_NAME"),
               token = error_on_missing_name("TOKEN"),
               secret = error_on_missing_name("SECRET"))

# Deploy the application.
deployApp(appFiles = c('Scripts/0_packages.R', 
                       'Scripts/1.2_read_data.R', 
                       'Scripts/2_ui.R', 
                       'Scripts/3_server.R',
                       
                       'app.R', 
                       
                       'Data/CountyGPS.rds', 
                       'Data/DataCatalogue.rds', 
                       'Data/KenyaCounties_SHP.rds', 
                       'Data/V1_T2.1.rds', 
                       'Data/V1_T2.2.rds', 
                       'Data/V3_T2.3.rds'),
          appName = error_on_missing_name("MASTERNAME"),
          forceUpdate = TRUE)
