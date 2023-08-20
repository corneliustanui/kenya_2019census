# Author: Cornelius Tanui
# Purpose: Interactive App to Visualize KPHC2019 Data
# Date Created: 2019
# Date Updated: Version Controlled  on GitHub
# File Name: 3_server.R
# File Purpose: Functional file to design UI.

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
    
    # sub-county filter
    observeEvent(pp_age_sex_county_react(), {
      choices <- unique(pp_age_sex_county_react()$SubCounty)
      freezeReactiveValue(input, "sub_county")
      updateSelectInput(inputId = "sub_county", choices = choices) 
    })
    
    pp_age_sex_sub_county_react <- reactive({
      req(input$sub_county)
      pp_age_sex_county_react() %>% 
        dplyr::filter(SubCounty %in% input$sub_county)
    })
    
    # value boxes
    output$male <- shinydashboard::renderValueBox({ 
      shinydashboard::infoBox(value = sum(pp_age_sex_sub_county_react()[pp_age_sex_sub_county_react()$Gender == "Male", ]$Population_raw), 
                              title = "Male population",
                              icon = icon("mars", class = "fa-2xs"),
                              color = "teal",
                              fill = TRUE)
      
    })
    
    output$female <- shinydashboard::renderValueBox({ 
      shinydashboard::infoBox(value = sum(pp_age_sex_sub_county_react()[pp_age_sex_sub_county_react()$Gender == "Female", ]$Population_raw), 
                              title = "Female population",
                              icon = icon("venus", class = "fa-2xs"),
                              color = "teal",
                              fill = TRUE)
      
    })
    
    output$total <- shinydashboard::renderValueBox({ 
      shinydashboard::infoBox(value = sum(pp_age_sex_sub_county_react()$Population_raw), 
                              title = "Total population",
                              icon = icon("mars-and-venus", class = "fa-2xs"),
                              color = "teal",
                              fill = TRUE)
      
    })
    
    # prepare data for download
    pp_age_sex_sub_county_raw <- reactive({
      pp_age_sex_sub_county_react() %>% 
      dplyr::select(-Population) %>% 
      dplyr::rename("Population" = Population_raw)
    })
    
    output$download_data1 <- downloadHandler(
      filename = function() {
        paste("Filtered_Data_", Sys.Date(), ".csv", sep="")
      },
      
      content = function(file) {
        write.csv(pp_age_sex_sub_county_raw(), file, row.names = FALSE)
      }
    )
    
    # plot 1
    output$plot1 <- renderPlotly({ 
      plot1 <- pp_age_sex_sub_county_react() %>% 
        #slice_sample(n = 5000, replace = TRUE) %>% 
        dplyr::mutate(text = paste("\nCounty: ", County,
                                   "\nSub-county: ", SubCounty,
                                   "\nGender: ", Gender,
                                   "\nPopulation: ", Population_raw,
                                   "\nAge: ", Age)) %>% 
        ggplot(aes(x = Age, 
                   y = Population,
                   color = Gender,
                   text = text)) +
        geom_point(position = "jitter") +
        geom_smooth(method = "loess",
                    formula = 'y ~ x') +
        labs(x = "Age",
             y = "Log(Population)",
             title = "Population by Age and Sex",
             caption = "Source: KHPC2019") +
        theme(panel.border = element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(), 
              panel.background = element_blank(),
              axis.line = element_line(colour = "black"))
      
      ggplotly(plot1, tooltip = "text")
    })
    
    #plot 2
    # density plot data (population  by age and sex)
    output$plot2 <- renderPlotly({
      plot2 <- pp_age_sex_sub_county_react() %>% 
        #slice_sample(n = 5000, replace = TRUE) %>% 
        dplyr::mutate(text = paste("\nCounty: ", County,
                                   "\nSub-county: ", SubCounty,
                                   "\nGender: ", Gender,
                                   "\nPopulation: ", Population_raw,
                                   "\nAge: ", Age)) %>% 
        ggplot(aes(x = Population,
                   fill = Gender,
                   # text = text
                   )) +
        geom_density(alpha = 0.4, na.rm = TRUE) +
        labs(x = "Log(Population)",
             y = "Density",
             title = "Population by Age and Sex",
             caption = "Source: KHPC2019") +
        theme(panel.border = element_blank(), 
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(), 
              panel.background = element_blank(),
              axis.line = element_line(colour = "black"))
      
      ggplotly(plot2)
    })
    
    #plot 3
    # pyramid data (population  by age and sex)
    output$plot3 <- renderPlotly({
      plot3 <- pp_age_sex_sub_county_react() %>% 
        mutate(Population_raw = ifelse(Gender == "Male", Population_raw*(-1), Population_raw*1),
               text = paste("\nCounty: ", County,
                            "\nSub-county: ", SubCounty,
                            "\nGender: ", Gender,
                            "\nPopulation: ", Population_raw,
                            "\nAge: ", Age))%>%
        ggplot(aes(x = Age, 
                   y = Population_raw, 
                   fill = Gender, 
                   text = text)) +
        geom_bar(stat = "identity") +
        coord_flip()+
        scale_y_continuous(labels = abs, 
                           limits = max(pp_age_sex_sub_county_react()$Population_raw) * c(-1,1),
                           breaks = seq(from = - max(pp_age_sex_sub_county_react()$Population_raw), 
                                        to = max(pp_age_sex_sub_county_react()$Population_raw), 
                                        by = 5000)) + 
        labs(title = "Population by Age and Sex", 
             x = "Age",
             y = "Population",
             caption = "Source: KHPC2019") +
        theme(panel.border = element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(), 
              panel.background = element_blank(),
              axis.line = element_line(colour = "black"))
      
      ggplotly(plot3, tooltip = "text")
    })
    
    #plot 4
    # map
    output$plot4 <- renderLeaflet({
      
      KenyaCounties_SHP_1 <- spTransform(KenyaCounties_SHP, CRS("+init=epsg:4326"))
      
      bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
      
      pal <- colorBin("YlOrRd", domain = KenyaCounties_SHP_1@data$PD, bins = bins)
      
      labels <- sprintf(
        "<strong>%s</strong><br/>%g people / m<sup>2</sup>",
        KenyaCounties_SHP_1$County, 
        KenyaCounties_SHP_1$PD
      ) %>% lapply(htmltools::HTML)
      
      plot4 <- 
        leaflet(KenyaCounties_SHP_1) %>% 
        setView(lng = 37.9062,
                lat = 0.0236, 
                zoom = 6) %>% 
        addProviderTiles("CartoDB.Positron", 
                         options = providerTileOptions(opacity = 0.99)) %>%
        addPolygons(
          fillColor = ~pal(PD),
          weight = 2,
          opacity = 1,
          color = "white",
          dashArray = "3",
          fillOpacity = 0.7,
          highlightOptions = highlightOptions(
            weight = 5,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.7,
            bringToFront = TRUE),
          label = labels,
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "15px",
            direction = "auto")) %>%
        addLegend(pal = pal, 
                  values = ~PD, 
                  opacity = 0.7, 
                  title = "Population Density",
                  position = "bottomright")
      
      plot4
      
    })
    
    
  }