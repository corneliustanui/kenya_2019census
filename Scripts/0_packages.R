# Author: Cornelius Tanui
# Purpose: Interactive App to Visualize KPHC2019 Data
# Date Created: 2019
# Date Updated: Version Controlled  on GitHub
# File Name: 0_packages.R
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

