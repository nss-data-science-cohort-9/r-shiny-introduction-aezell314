#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# Define server logic required to draw an interactive map of burglaries in 2023 in Davidson County
function(input, output, session) {
  
  # Crime select input box
  output$crimeSelect <- renderUI({
    
    crimeOpts <-
      crimes_by_tract |>
      drop_na(Latitude) |>
      st_drop_geometry() |>
      distinct(Offense_Description) |>
      pull()
    
    # Add names, so that we can add all=0
    names(crimeOpts) <- crimeOpts
    crimeOpts <- c('All', crimeOpts)
    selectInput("crimeOpts", "Type of Crime", choices = crimeOpts, selected = crimeOpts[2])
  })
  
  output$crimemap <- renderLeaflet({
    
    plot_data <- if (input$crimeOpts == "All") {
      crimes_by_tract
    } else {
      crimes_by_tract |> filter(Offense_Description == input$crimeOpts)
    }    
    
    plot_data$popup_content <- paste0(
      "Incident Number: ", plot_data$`Incident_Number`, 
      "Latitude: ", plot_data$Latitude , 
      "Longitude: ", plot_data$Longitude
    )
    
    leaflet(data = plot_data
    ) |>  
      addTiles() |> 
      addMarkers(~Longitude, 
                 ~Latitude, 
                 popup = ~popup_content,
                 label = ~popup_content
      )
  })
  
  # Render the UI datatable element 
  output$numCrimesTable <- renderUI({
    DT::dataTableOutput("myDataTable") 
  })
  
  # Render the actual data table content on the server
  output$myDataTable <- DT::renderDataTable({
    
    plot_data <- if (input$crimeOpts == "All") {
      crimes_by_tract
    } else {
      crimes_by_tract |> filter(Offense_Description == input$crimeOpts)
    } 
    
    crimes_per_tract <- plot_data |>
      st_drop_geometry() |>
      group_by(tract) |>
      distinct(Incident_Number) |>
      count() |>
      rename('Census Tract'=tract, 'Count'=n)
    
    crimes_per_tract
  })
}
  