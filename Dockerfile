FROM rocker/shiny:4.3.1
RUN install2.r rsconnect 
WORKDIR /kenya_2019census/kenya_2019census
COPY . /
CMD Rscript deploy.R

