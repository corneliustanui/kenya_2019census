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
    
    # data catalogue table
    output$data_description<- renderDataTable(
      server = FALSE, {
        DT::datatable(
          data = DataCatalogue,
          filter = "top",
          rownames = FALSE,
          selection = "single"
          # extensions = "Buttons",
          # options = list(
          #   dom = 'Bfrtip',
          #   buttons = c('copy', 'csv', 'pdf')
          #   )
          )
      }
    )
    
    # download DataCatalogue
    output$download_data_cat <- downloadHandler(
      filename = function() {
        paste("DataCatalogue_", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(DataCatalogue, file, row.names = FALSE)
      }
    )
    
    
    # reactive data
    pp_age_sex_county_react <- 
      reactive(
        {
          pp_age_sex_county_reactive <- 
            pp_age_sex_county_long %>%
            filter(County %in% input$county) %>% 
            filter(Age >= input$age[1] & Age <= input$age[2]) %>% 
            filter(Gender %in% input$gender)
          return(pp_age_sex_county_reactive)
        }
      )
    
    # data for download
    output$download_data1 <- downloadHandler(
      filename = function() {
        paste("Filtered_Data_", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(pp_age_sex_county_react(), file, row.names = FALSE)
      }
    )
    
    
    # plot 1
    output$plot1 <- renderPlotly({ 
      plot1 <- pp_age_sex_county_react() %>% 
        slice_sample(n = 5000, replace = TRUE) %>% 
        dplyr::mutate(text = paste("\nCounty: ", County,
                                   "\nSub-county: ", SubCounty)) %>% 
        ggplot(aes(x = Age, 
                   y = Population,
                   color = SubCounty,
                   text = text)) +
        geom_point(position = "jitter") +
        geom_smooth(method = "loess") +
        facet_wrap(~ Gender)+
        labs(x = "Age",
             y = "Log(Population)",
             title = "Population by Age and Sex",
             caption = "Source: KHPC2019") +
        theme(panel.border = element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(), 
              panel.background = element_blank(),
              axis.line = element_line(colour = "black"))
      plot1
    })
    
    #plot 2
    # density plot data (population  by age and sex)
    output$plot2 <- renderPlotly({
      plot2 <- pp_age_sex_county_react() %>% 
        slice_sample(n = 5000, replace = TRUE) %>% 
        dplyr::mutate(text = paste("\nCounty: ", County,
                                   "\nSub-county: ", SubCounty)) %>% 
        ggplot(aes(x = Population,
                   fill = SubCounty,
                   text = text)) +
        geom_density(alpha = 0.4, na.rm = TRUE) +
        facet_wrap(~ Gender)+
        labs(x = "Log(Population)",
             y = "Density",
             title = "Population by Age and Sex",
             caption = "Source: KHPC2019") +
        theme(panel.border = element_blank(), 
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(), 
              panel.background = element_blank(),
              axis.line = element_line(colour = "black"))
      
      plot2
    })
    
  }