#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# Define server logic required to draw a histogram
function(input, output, session) {
  
  # Histogram showing body mass by island
  output$distPlot <- renderPlot({
    
    plot_data <- if (input$island == "All") {
      penguins
    } else {
      penguins |> filter(island == input$island)
    }    
    island_title <- if_else(input$island == 'All', 'Islands', 'Island')
    title <- glue('Distribution of {input$hist_variable} for {input$island} {island_title}')
    
    plot_data |>
      ggplot(aes(x = .data[[input$hist_variable]])) +
      geom_histogram(bins = input$bins, col = 'darkgray', border = 'white') +
      labs(title = title, 
           subtitle = 'For Penguins near Palmer Station, Antarctica', 
           x = 'Body Mass (g)', 
           y = 'Count')
  })
  
  # Bar chart showing the counts by species
  output$barPlot <- renderPlot({
    
    plot_data <- if (input$island == "All") {
      penguins
    } else {
      penguins |> filter(island == input$island)
    }    
    island_title <- if_else(input$island == 'All', 'Islands', 'Island')
    title <- glue('Species Counts for {input$island} {island_title}')
    
    plot_data |>
      ggplot(aes(x = species)) +
      geom_bar(aes(fill=species)) +
      labs(title = title, 
           subtitle = 'For Penguins near Palmer Station, Antarctica', 
           x = 'Species', 
           y = 'Count')
  })
  
  output$selectedTable <- renderDataTable({
    selected_data <- if (input$island == "All") {
      penguins
    } else {
      penguins |> filter(island == input$island)
    }    
    
    selected_data 
  })
  
}
