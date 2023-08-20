# # Author: Cornelius Tanui
# # Purpose: Interactive App to Visualize KPHC2019 Data
# # Date Created: 2019
# # Date Updated: Version Controlled  on GitHub
# # File Name: 1.1_write_data.R
# # File Purpose: Functional file to load packages and data.
# 
# # clear environment
# rm(list = ls(all.names = TRUE))
# 
# # list of available data
# rKenyaCensus_datasets <- 
#   data(package = "rKenyaCensus")[["results"]] %>% 
#   as.data.frame() %>% 
#   dplyr::select(Item, Title)
# 
# # read data from package, and write to folder
# write_data <- function(ds_name, ...){
#   
#   # get data from package
#   require(rKenyaCensus)
#   ds <- ds_name %>% as.data.frame()
#   
#   # write data to folder
#   ds_name_original <- deparse(substitute(ds_name))
#   
#   write_rds(x = ds_name,
#             file = paste0("Data/", ds_name_original, ".rds")
#   )
#   
#   return(ds)
# }
# 
# my_species <- "V1_T2.2"
# str_glue("rKenyaCensus::{my_species}")
# 
# # Data Cleaning
# # County GPS centroids 
# CountyGPS <- write_data(ds_name = CountyGPS)
# 
# # Catalogue
# DataCatalogue <- write_data(ds_name = DataCatalogue)
# 
# # Shapefiles of Kenya County boundaries
# KenyaCounties_SHP <- write_data(ds_name = KenyaCounties_SHP)
# 
# # Census Indicators at a Glance
# V1_T2.1 <- write_data(ds_name = V1_T2.1)
# 
# # Distribution of Population by Sex and County
# V1_T2.2 <- write_data(ds_name = V1_T2.2)
# 
# # V3_T2.3 table
# V3_T2.3 <- write_data(ds_name = V3_T2.3)
# 
