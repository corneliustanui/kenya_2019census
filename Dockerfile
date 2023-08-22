FROM rocker/shiny:4.3.1
RUN install2.r rsconnect 
WORKDIR /KPHC2019/kenya_2019census
COPY . .
CMD Rscript deploy.R
