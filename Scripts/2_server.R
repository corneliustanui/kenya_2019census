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
    
    # catalogue data
    DataCatalogue <- readRDS("Data/DataCatalogue.RDS")%>% 
      as.data.frame()
    
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
    
    
    # V3_T2.3 table
    V3_T2.3 <- readRDS("Data/V3_T2.3.RDS")
    
    # Remove unnecessary records 
    pp_age_sex_county <- V3_T2.3 %>% 
      filter(SubCounty != "ALL" & 
               Age != "Total" & 
               Age != "Not Stated" &
               !grepl("-", Age))
    
    # For age above 100 years, replace with 100
    pp_age_sex_county <-
      pp_age_sex_county %>% 
      dplyr::mutate(Age = as.numeric(ifelse(Age == "100+", 100, Age))) %>% 
      
      #drop unnecessary cols
      dplyr::select(-Total)
    
    # reshape data to long
    pp_age_sex_county_long <-
      pp_age_sex_county %>% 
      tidyr::pivot_longer(cols = c("Male", "Female"),
                          names_to = "Gender",
                          values_to = "Population")
    
    
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
    
    
    # plot 1
    output$plot1 <- renderPlot({ 
      plot1 <- pp_age_sex_county_react() %>% 
      slice_sample(n = 5000, replace = TRUE) %>% 
      ggplot(aes(x = Age, y = log(Population), 
                 color = Gender)) +
      geom_point(position = "jitter") +
      geom_smooth(method = "loess") +
      labs(x = "Age",
           y = "Population",
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
    output$plot2 <- renderPlot({
      plot2 <- pp_age_sex_county_react() %>% 
        slice_sample(n = 5000, replace = TRUE) %>% 
        ggplot(aes(x = log(Population), fill = Gender)) +
        geom_density(alpha = 0.4) +
        labs(x = "Population (in log scale)",
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