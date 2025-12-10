library(sf)
library(ggplot2)
library(dplyr)
library(RColorBrewer)

# Read GeoJSON
geojson_file <- "../data/world-geo-json-zh-2.1.4/world.zh.json"
my_sf <- read_sf(geojson_file)

# Read nap CSV
csv_file <- "../data/fig1A.csv"
nap_data <- read.csv(csv_file)

# Color palette
blues <- brewer.pal(9, "Blues")

color_mapping <- c(
  "NoNAP"      = "gray",
  "Before 2015" = blues[9],
  "2015-16"     = blues[8],
  "2017-18"     = blues[7],
  "2019-20"     = blues[6],
  "2021-22"     = blues[5],
  "After 2022"  = blues[4]
)

# Merge GeoJSON with nap data
my_sf <- my_sf %>%
  left_join(nap_data, by = c("iso_a3" = "ISO3"))

# Assign "NoNAP" to missing values
my_sf$Yearperiod[is.na(my_sf$Yearperiod)] <- "NoNAP"

# Factor ordering
my_sf$Yearperiod <- factor(
  my_sf$Yearperiod,
  levels = c("NoNAP", "Before 2015", "2015-16", "2017-18", "2019-20", "2021-22", "After 2022")
)

# Remove Antarctica
my_sf <- my_sf %>% filter(iso_a3 != "ATA")

# Plot map
map_plot <- ggplot(data = my_sf) +
  geom_sf(aes(fill = Yearperiod), color = "black", size = 0.1) +
  scale_fill_manual(values = color_mapping, name = "NAP Year Period") +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    legend.position = "right"
  )

# Save to PDF
ggsave("../output/fig1A.pdf", plot = map_plot, width = 10, height = 7)