# Author: Cornelius Tanui
# Purpose: Interactive App to Visualize KPHC2019 Data
# Date Created: 2019
# Date Updated: Version Controlled  on GitHub
# File Name: 1.2_read_data.R
# File Purpose: Functional file to load packages and data.

# clear environment
rm(list = ls(all.names = TRUE))

# Read data from folder
CountyGPS <- readRDS("./Data/CountyGPS.rds")
DataCatalogue <- readRDS("./Data/DataCatalogue.rds")
KenyaCounties_SHP <- readRDS("./Data/KenyaCounties_SHP.rds")
V1_T2.1 <- readRDS("./Data/V1_T2.1.rds")
V1_T2.2 <- readRDS("./Data/V1_T2.2.rds")
V3_T2.3 <- readRDS("./Data/V3_T2.3.rds")

# Remove unnecessary records 
pp_age_sex_county <- V3_T2.3 %>% 
  filter(SubCounty != "ALL" & 
           Age != "Total" & 
           Age != "Not Stated" &
           !grepl("-", Age))

# For age above 100 years, replace with 100
pp_age_sex_county <-
  pp_age_sex_county %>% 
  dplyr::mutate(Age = as.numeric(ifelse(Age == "100+", 100, Age))) %>% 
  
  #drop unnecessary cols
  dplyr::select(-Total)

# reshape data to long
pp_age_sex_county_long <-
  pp_age_sex_county %>% 
  tidyr::pivot_longer(cols = c("Male", "Female"),
                      names_to = "Gender",
                      values_to = "Population") %>% 
  
  # convert pop to log scale
  dplyr::mutate(Population_raw = Population,
                Population = round(log(Population), 1)) %>% 
  
  # keep only valid pop values
  dplyr::filter(!is.na(Population)) %>% 
  as.data.frame()
