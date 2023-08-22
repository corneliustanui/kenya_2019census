FROM rocker/shiny:4.3.1
RUN install2.r rsconnect tidyverse shinydashboard shinyWidgets shinycssloaders plotly DT sp sf leaflet
WORKDIR /app
COPY . .
CMD Rscript deploy.R
