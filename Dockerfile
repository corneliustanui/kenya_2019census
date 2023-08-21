FROM rocker/shiny:4.3.1
RUN install2.r rsconnect 
WORKDIR /kenya_2019census/kenya_2019census
COPY app.R app.R
COPY Scripts /Scripts
COPY Data /Data
COPY deploy.R deploy.R
CMD Rscript deploy.R