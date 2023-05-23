#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#  http://shiny.rstudio.com/
#

ui <- dashboardPage(
  skin = "green",
  dashboardHeader(
    title = "2019 KHPC Analytics"
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", 
               tabName = "home",
               icon = icon("home")),
      
      menuItem("Demographics", startExpanded = FALSE, icon = icon("people-roof"),
               menuSubItem("Sub info 1", tabName = "info1"),
               menuSubItem("Sub info 2", tabName = "info2")
      ),
      
      menuItem("Healthcare", startExpanded = FALSE, icon = icon("heart-pulse"),
                 menuSubItem("Sub info 3", tabName = "info3"),
                 menuSubItem("Sub info 4", tabName = "info4")
                 
      ),
      
      menuItem("Education", startExpanded = FALSE, icon = icon("school"),
               menuSubItem("Sub info 5", tabName = "info5"),
               menuSubItem("Sub info 6", tabName = "info6")
      ),
      
      menuItem("Water", startExpanded = FALSE, icon = icon("faucet-drip"),
             menuSubItem("Sub info 7", tabName = "info7"),
             menuSubItem("Sub info 8", tabName = "info8")
             
      ),
      
      menuItem("Electricity", startExpanded = FALSE, icon = icon("plug-circle-bolt"),
               menuSubItem("Sub info 9", tabName = "info9"),
               menuSubItem("Sub info 10", tabName = "info10")
               
      )
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem("home", 
              HTML("<p>This secondary data from Kenya Household and Population Census <a href='https://www.knbs.or.ke/'>(KPHC)</a>of 2019, 
              made available in R by <a href='https://shelkariuki.netlify.app/#about' > Shelmith Kariuki </a> through her elegantly 
              written <a href = 'https://github.com/Shelmith-Kariuki/rKenyaCensus' > rKenyaCensus </a> package.</p>"),
              
              HTML("<p> This Shiny application uses <a href = 'https://rstudio.github.io/shinydashboard/'> shinydashboard </a> 
                   framework, and <a href = 'https://plotly.com/'> plotly </a> graphing library's 
                   <a href = 'https://www.rdocumentation.org/packages/plotly/versions/4.10.0/topics/ggplotly' > ggplotly</a> 
                   function for interactivity of <a href = 'https://ggplot2.tidyverse.org/'> ggplot2 </a> objects.</p>"),
              
              HTML("<p> Data files available for public use are listed in the tables;</p>"),
              
              fluidRow(
                box(
                  title = "Source Tables",
                  status = "warning",
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  width = 12,
                  height = 5,
                  
                  DTOutput("data_description")
                )
              )
              ),
      
      tabItem("info1",
              
              column(width = 3,
                box(
                  width = NULL,
                  title = "Filters",
                  status = "warning",
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  
                  shiny::selectInput(
                    inputId = "county",
                    label = "Select county",
                    choices = unique(pp_age_sex_county_long$County),
                    selected = unique(pp_age_sex_county_long$County),
                    multiple = FALSE,
                    selectize = FALSE
                  ),
                  
                  shiny::sliderInput(
                    inputId = "age",
                    label = "Age", 
                    min = min(pp_age_sex_county_long$Age, na.rm = T),
                    max = max(pp_age_sex_county_long$Age, na.rm = T), 
                    value = c(min(pp_age_sex_county_long$Age, na.rm = T), 
                              max(pp_age_sex_county_long$Age, na.rm = T)),
                    step = 5
                  ),
                  
                  shiny::checkboxGroupInput(
                    inputId = "gender",
                    label = "Select gender",
                    choices = unique(pp_age_sex_county_long$Gender), 
                    selected = unique(pp_age_sex_county_long$Gender), 
                    inline = T
                  )
                  
                )
              ),
              
              column(width = 9,
                fluidRow(
                  box(
                    title = "Scatter Plot",
                    status = "warning",
                    collapsible = TRUE,
                    solidHeader = TRUE,
                    
                    plotOutput("plot1")
                    ),
                  
                  box(
                    title = "Density Plot",
                    status = "warning",
                    collapsible = TRUE,
                    solidHeader = TRUE,
                    
                    plotOutput("plot2")
                    )
                  )
                )
              ),
              
      tabItem("info2", "Sub info 2"),
      
      tabItem("info3", "Sub info 3"),
      
      tabItem("info4", "Sub info 4"),
      
      tabItem("info5", "Sub info 5"),
      
      tabItem("info6", "Sub info 6"),
      
      tabItem("info7", "Sub info 7"),
      
      tabItem("info8", "Sub info 8"),
      
      tabItem("info9", "Sub info 9"),
      
      tabItem("info10", "Sub info 10")
    )
  )
)
      

