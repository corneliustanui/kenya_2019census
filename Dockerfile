FROM rocker/shiny:4.3.1
RUN install2.r rsconnect 
WORKDIR /kenya_2019census/kenya_2019census
COPY app.R app.R
COPY Scripts/0_packages.R Scripts/0_packages.R
COPY Scripts/1.2_read_data.R Scripts/1.2_read_data.R
COPY Scripts/2_ui.R Scripts/2_ui.R
COPY Scripts/3_server.R Scripts/3_server.R

COPY ./Data/. /Data/

COPY deploy.R deploy.R
CMD Rscript deploy.R

