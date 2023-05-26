
# clear environment
rm(list = ls(all.names = TRUE))


# load packages

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











