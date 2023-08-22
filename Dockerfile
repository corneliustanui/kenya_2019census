FROM rocker/shiny:4.3.1
RUN install2.r rsconnect tidyverse shinydashboard shinyWidgets shinycssloaders plotly DT sp sf leaflet
WORKDIR /kenya_2019census
COPY Data/ /Data/
COPY Scripts/ /Scripts/
COPY app.R app.R
COPY deploy.R deploy.R
CMD Rscript deploy.R
