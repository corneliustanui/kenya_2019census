# Author: Cornelius Tanui
# Purpose: Interactive App to Visualize KPHC2019 Data
# Date Created: 2019
# Date Updated: Version Controlled  on GitHub
# File Name: 2_ui.R
# File Purpose: Functional file to design UI.

# define server
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
      
      menuItem("Dashboard", startExpanded = FALSE, icon = icon("dashboard"),
               menuSubItem("Demographics", tabName = "info1", icon = icon("people-roof")),
               menuSubItem("Healthcare", tabName = "info2", icon = icon("heart-pulse")),
               menuSubItem("Education", tabName = "info3", icon = icon("school")),
               menuSubItem("Water", tabName = "info4", icon = icon("faucet-drip")),
               menuSubItem("Electricity", tabName = "info5", icon = icon("plug-circle-bolt"))
      ),
      
      menuItem("About", 
               tabName = "info6",
               icon = icon("circle-info")
      )
    )
  ),
  
  dashboardBody(
    
    # reduce space between boxes
    tags$head(tags$style(HTML("div.col-sm-6 {padding:2px}"))),

    # customize size of infoBoxes
    tags$head(tags$style(HTML('.info-box {min-height: 45px;} .info-box-icon {height: 45px; line-height: 45px;} .info-box-content {padding-top: 0px; padding-bottom: 0px;}'))),
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
                  
                  tags$head(tags$style(".butt1{background-color:#FFAD00} .butt1{color: #FFFFFF;}")),
                  div(style = "display:inline-block; width:30#; text-align: center;",
                      downloadButton("download_data_cat", label = "Download csv", class = "butt1")),

                  DTOutput("data_description") %>% 
                    withSpinner(type = 6, 
                                size = 0.5,
                                color = "#FFAD00")
                )
               )
              ),
      
      tabItem("info1", 
              
              fluidRow(
                width = 12,
                
                # output values for infoBoxes
                valueBoxOutput("male", width = 4),
                valueBoxOutput("female", width = 4),
                valueBoxOutput("total", width = 4) 
              ),
              
              fluidRow(
                width = 12,
                
                column(
                  width = 3,
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
                      selected = unique(pp_age_sex_county_long$County)[1],
                      multiple = FALSE,
                      selectize = FALSE
                    ),
                    
                    shiny::selectInput(
                      inputId = "sub_county",
                      label = "Select Sub-county",
                      choices = NULL,
                      selected = NULL,
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
                      inline = FALSE
                    ),
                    
                    tags$head(tags$style(".butt2{background-color:#FFAD00} .butt2{color: #FFFFFF;}")),
                    div(style = "display:inline-block; width:30#; text-align: center;",
                        downloadButton("download_data1", label = "Download csv", class = "butt2")),
                    br(),
                    em("This is filtered data")
                  )
                ),
                
                column(
                  width = 9,
                  fluidRow(
                    box(
                      title = "Scatter Plot",
                      status = "warning",
                      collapsible = TRUE,
                      solidHeader = TRUE,
                      
                      plotlyOutput("plot1") %>% 
                        withSpinner(type = 6, 
                                    size = 0.5,
                                    color = "#FFAD00")
                    ),
                    
                    box(
                      title = "Density Plot",
                      status = "warning",
                      collapsible = TRUE,
                      solidHeader = TRUE,
                      
                      plotlyOutput("plot2") %>% 
                        withSpinner(type = 6, 
                                    size = 0.5,
                                    color = "#FFAD00")
                    )
                  ), 
                  
                  fluidRow(
                    box(
                      title = "Population Pyramid",
                      status = "warning",
                      collapsible = TRUE,
                      solidHeader = TRUE,
                      
                      plotlyOutput("plot3") %>% 
                        withSpinner(type = 6, 
                                    size = 0.5,
                                    color = "#FFAD00")
                    ),
                    
                    box(
                      title = "Map",
                      status = "warning",
                      collapsible = TRUE,
                      solidHeader = TRUE,
                      
                      leafletOutput("plot4") %>% 
                        withSpinner(type = 6, 
                                    size = 0.5,
                                    color = "#FFAD00")
                    )
                  )
                )
              )
            ),
              
      tabItem("info2", "Healthcare"),
      
      tabItem("info3", "Education"),
      
      tabItem("info4", "Water"),
      
      tabItem("info5", "Electricity"),
      
      tabItem("info6", 
              
              p("This app was programmed by", a("Cornelius Tanui", href = 'https://github.com/corneliustanui'),
                "a seasoned data scientist. Contact him on", a("LinkedIn", href = 'https://www.linkedin.com/in/cornelius-tanui-527979b9/'),  
                "or via", strong(em("kiplimocornelius@gmail.com.")))
              
              # HTML("<p> This app was programmed by <a href = 'https://github.com/corneliustanui'> Cornelius Tanui, </a> 
              #      a seasoned data scientist. Contact him on <a href = 'https://www.linkedin.com/in/cornelius-tanui-527979b9/'> LinkedIn </a> 
              #      or via em(kiplimocornelius@gmail.com).
              #      </p>")
              )
    ),
    
    # add footer
    tags$style(type = 'text/css', "footer{position: absolute; bottom:0.5%; right: 1%; padding:5px;}"),
    
    HTML('<footer>
            <a id = "copyright"> © 2023 by Cornelius Tanui </a>
          </footer>')
  )
)
      

