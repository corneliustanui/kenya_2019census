# Author: Cornelius Tanui
# Purpose: Interactive App to Visualize KPHC2019 Data
# Date Created: 2019
# Date Updated: Version Controlled  on GitHub
# File Name: 0_packages_&_data.R
# File Purpose: Functional file to load packages and data.

# clear environment
rm(list = ls(all.names = TRUE))

# load packages
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

# load data
rKenyaCensus_datasets <- 
  data(package = "rKenyaCensus")[["results"]] %>% 
  as.data.frame() %>% 
  dplyr::select(Item, Title)

get_data <- function(ds_name, ...){
  require(rKenyaCensus)
  ds <- ds_name %>% as.data.frame()
  return(ds)
}

wite_data <- function(ds_name, ...){
  saveRDS(object = ds_name, 
          file = paste0("Data/", ds_name, ".RDS")
  )
}

V1_T2.1 <- get_data(ds_name = V1_T2.1)
wite_data(ds_name = V1_T2.1)

for (i in seq_along(rKenyaCensus_datasets$Item)) {
  
  rKenyaCensus_datasets$Item[i] <- get_data(ds_name = rKenyaCensus_datasets$Item[i])
  
  
  saveRDS(object = str_glue(rKenyaCensus_datasets$Item[i]), 
          file = paste0("Data/", rKenyaCensus_datasets$Item[i], ".RDS")
  )
}

my_species <- "V1_T2.1"

str_glue("rKenyaCensus::{my_species}")

# catalogue data
DataCatalogue <- readRDS("Data/DataCatalogue.RDS")%>% 
  as.data.frame()

# V3_T2.3 table
V3_T2.3 <- readRDS("Data/V3_T2.3.RDS")

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











