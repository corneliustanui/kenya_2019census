
KenyaCounties_SHP_1 <- spTransform(KenyaCounties_SHP, CRS("+init=epsg:4326"))

bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)

pal <- colorBin("YlOrRd", domain = KenyaCounties_SHP_1@data$PD, bins = bins)

labels <- sprintf(
  "<strong>%s</strong><br/>%g people / m<sup>2</sup>",
  KenyaCounties_SHP_1$County, KenyaCounties_SHP_1$PD
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


# factpal <- colorFactor(topo.colors(47), KenyaCounties_SHP_1@data$County)

plot4 <- leaflet() %>% 
  addProviderTiles("CartoDB.Positron", 
                   options = providerTileOptions(opacity = 0.99)) %>%
  addPolygons(data = KenyaCounties_SHP_1,
              stroke = FALSE, 
              fillOpacity = 0.5, 
              smoothFactor = 0.5,
              color = ~factpal(County),
              label = ~paste(County, ": ", Population),
              labelOptions = labelOptions(direction = "auto")) %>% 
  addTiles() %>% 
  setView(lng = 37.9062,
          lat = 0.0236, 
          zoom = 6)

plot4


# plot the ke_adm shapefile on R. See help for details on the functions and the arguments used
tm_shape(KenyaCounties_SHP_1, 'Kenya', 
         projection = '+init=epsg:4326', 
         bbox = KenyaCounties_SHP_1) +
  tmap_options(check.and.fix = TRUE,
               max.categories = 47) +
  tm_fill(col = "County", 
          alpha = 0.5, 
          palette('Okabe-Ito'), 
          legend.show = F) + 
  tm_text("County", 
          size = "Area", 
          col = 'steelblue', 
          legend.size.show = F, 
          legend.col.show = F)

KenyaCounties_SHP_2 <- as.data.frame(KenyaCounties_SHP_1)

