# get base image of R shiny, use installed version of R
FROM rocker/shiny:4.3.1

# install all packages used by this app
RUN install2.r rsconnect tidyverse shinydashboard shinyWidgets shinycssloaders plotly DT sp sf leaflet

# create image's work dir
WORKDIR /KPHC2019

# copy files from remote repo(GitHub) work dir to image ork dir
# to copy all files at once (keeping folder structure), use "COPY . .""
COPY ./app.R /KPHC2019/app.R
COPY ./deploy.R /KPHC2019/deploy.R

COPY ./Scripts /KPHC2019/Scripts/ 
COPY ./Data /KPHC2019/Data/

# run the deploy script
CMD Rscript deploy.R
