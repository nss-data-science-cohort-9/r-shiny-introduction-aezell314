#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# Define UI for application that draws an interactive map of crime in 2023 in Davidson County
header <- dashboardHeader(
  title = "Davidson County Crime, 2023", titleWidth = 300
)

body <- dashboardBody(
  fluidRow(
    column(width = 9,
           column(width = 9,
                  box(width = NULL, solidHeader = TRUE,
                      leafletOutput("crimemap", height = 500)
                  ),
                  box(width = NULL,
                      uiOutput("numCrimesTable")
                  )
           ),
           column(width = 3,
                  box(width = NULL, status = "warning",
                      uiOutput("crimeSelect")
                  )
           )
    )
  )
)
  
  dashboardPage(
    header,
    dashboardSidebar(disable = TRUE),
    body
    
  )
  