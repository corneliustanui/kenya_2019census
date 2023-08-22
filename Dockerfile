FROM rocker/shiny:4.3.1
RUN install2.r rsconnect tidyverse shinydashboard shinyWidgets shinycssloaders plotly DT sp sf leaflet
WORKDIR /kenya_2019census
COPY . kenya_2019census/
CMD Rscript kenya_2019census/deploy.R
