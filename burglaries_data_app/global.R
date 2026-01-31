library(shiny)
library(glue)
library(DT)
library(tidyverse)
library(shinydashboard)
library(sf)

# Getting 2023 crime data via API
base_url <- "https://services2.arcgis.com/HdTo6HJqh92wn4D8/arcgis/rest/services/Metro_Nashville_Police_Department_Incidents_view/FeatureServer/0/query?where=1=1&outFields=*&f=json"

params <- list(
  where = "Incident_Occurred >= '2023-01-01 00:00:00' AND Incident_Occurred <= '2023-12-31 23:59:59'",
  outFields = 'incident_number,latitude,longitude,zip_code,offense_description',
  f = 'json'
)

url_obj <- parse_url(base_url)
url_obj$query <- params
full_url <- build_url(url_obj)

response <- GET(full_url)
data_parsed <- fromJSON(content(response, 'text', encoding = 'UTF-8'))

crimes <- data_parsed$features$attributes |>
  distinct(Incident_Number, .keep_all = TRUE) |> 
  drop_na(Latitude)

# Reading in Davidson County census tract shapefile
DC_tracts <- st_read('../data/DC/DC.shp') |>
  rename(tract=TRACTCE) |>
  mutate(tract=as.numeric(tract))

# Adding spatial geometry to crimes data
 crimes_geo <- st_as_sf(
   crimes,
   coords = c('Longitude', 'Latitude'),
   crs = st_crs(DC_tracts),
   remove = FALSE
 )

# # Spatial join to determine the census tract associated with each crime
 crimes_by_tract <- 
   st_join(DC_tracts, crimes_geo, join = st_contains)
