# Author: Cornelius Tanui
# Purpose: Interactive App to Visualize KPHC2019 Data
# Date Created: 2019
# Date Updated: Version Controlled  on GitHub
# File Name: 0_packages_&_data.R
# File Purpose: Functional file to load packages and data.

# clear environment
rm(list = ls(all.names = TRUE))

# load packages
# devtools::install_github("Shelmith-Kariuki/rKenyaCensus")

library(rKenyaCensus)
library(tidyverse)
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinycssloaders)
library(plotly)
library(DT)
library(ggplot2)
library(ggpmisc)
library(gmodels)
library(magrittr)
library(rsconnect)
library(packrat)
library(renv)
library(sp)
library(sf)

# list of available data
rKenyaCensus_datasets <- 
  data(package = "rKenyaCensus")[["results"]] %>% 
  as.data.frame() %>% 
  dplyr::select(Item, Title)

# read data from package, and write to folder
read_write_data <- function(ds_name, ...){
  
  # read data from package
  require(rKenyaCensus)
  ds <- ds_name %>% as.data.frame()

  # write data to folder
  ds_name_original <- deparse(substitute(ds_name))
  
  write_rds(x = ds_name,
            file = paste0("Data/", ds_name_original, ".rds")
  )
  
  return(ds)
}

my_species <- "V1_T2.2"
str_glue("rKenyaCensus::{my_species}")

# Data Cleaning
# County GPS centroids 
CountyGPS <- read_write_data(ds_name = CountyGPS)

# Catalogue
DataCatalogue <- read_write_data(ds_name = DataCatalogue)

# Shapefiles of Kenya County boundaries
KenyaCounties_SHP <- read_write_data(ds_name = KenyaCounties_SHP)

# Census Indicators at a Glance
V1_T2.1 <- read_write_data(ds_name = V1_T2.1)

# Distribution of Population by Sex and County
V1_T2.2 <- read_write_data(ds_name = V1_T2.2)

# V3_T2.3 table
V3_T2.3 <- read_write_data(ds_name = V3_T2.3)

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











