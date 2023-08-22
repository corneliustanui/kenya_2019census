FROM rocker/shiny:4.3.1
RUN install2.r rsconnect tidyverse shinydashboard shinyWidgets shinycssloaders plotly DT sp sf leaflet
WORKDIR /KPHC2019
COPY ./app.R /KPHC2019/app.R
COPY ./deploy.R /KPHC2019/deploy.R

COPY ./Scripts /KPHC2019/Scripts/ 
COPY ./Data /KPHC2019/Data/

CMD Rscript deploy.R
