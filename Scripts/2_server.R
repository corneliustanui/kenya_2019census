#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/


# define server

server <-
  function(input, output, session){
    
    DataCatalogue <- readRDS("Data/DataCatalogue.RDS")%>% 
      as.data.frame()
    
    V3_T2.3 <- readRDS("Data/V3_T2.3.RDS")
    
    
    output$data_description<- renderDataTable(
      server = FALSE, {
        DT::datatable(
          data = DataCatalogue,
          filter = "top",
          rownames = FALSE,
          selection = "single",
          extensions = "Buttons",
          options = list(
            dom = 'Bfrtip',
            buttons = c('copy', 'csv', 'pdf')
            )
          )
      }
    )
  }