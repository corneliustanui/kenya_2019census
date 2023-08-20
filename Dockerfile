FROM rocker/shiny:4.2.1
RUN install2.r rsconnect
WORKDIR /kenya_2019census/kenya_2019census
COPY app.R app.R
COPY deploy.R deploy.R
CMD Rscript deploy.R