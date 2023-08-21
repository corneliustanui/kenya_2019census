FROM rocker/shiny:4.3.1
RUN install2.r rsconnect 
WORKDIR /APPDIR
COPY app.R app.R
COPY Data/CountyGPS.rds Data/CountyGPS.rds
COPY Scripts/0_packages.R Scripts/0_packages.R
COPY Scripts/1.2_read_data.R Scripts/1.2_read_data.R
COPY Scripts/2_ui.R Scripts/2_ui.R
COPY Scripts/3_server.R Scripts/3_server.R

COPY Data/CountyGPS.rds Data/CountyGPS.rds
COPY Data/DataCatalogue.rds Data/DataCatalogue.rds
COPY Data/KenyaCounties.rds Data/KenyaCounties.rds
COPY Data/V1_T2.1.rds Data/V1_T2.1.rds
COPY Data/V1_T2.2.rds Data/V1_T2.2.rds
COPY Data/V3_T2.3.rds Data/V3_T2.3.rds

COPY deploy.R deploy.R
CMD Rscript deploy.R

