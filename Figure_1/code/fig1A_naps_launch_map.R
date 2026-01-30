library(sf)
library(ggplot2)
library(dplyr)
library(RColorBrewer)

# Read basemap (GS 2021)
basemap_file <- "../data/worldmap_gs_2021/Worldmap_GS_2021.shp"
my_sf <- read_sf(basemap_file)

# Read boundaries (overlay)
boundaries_file <- "../data/worldmap_gs_2021/Worldmap_GS_2021_boundaries.shp"
boundaries_sf <- read_sf(boundaries_file)
boundaries_sf <- st_transform(boundaries_sf, st_crs(my_sf))
old_s2 <- sf_use_s2()
sf_use_s2(FALSE)
boundaries_sf <- st_crop(
  boundaries_sf,
  st_bbox(c(xmin = -180, ymin = -60, xmax = 180, ymax = 90), crs = st_crs(boundaries_sf))
)
sf_use_s2(old_s2)

# Read nap CSV
csv_file <- "../data/fig1A.csv"
nap_data <- read.csv(csv_file)

# Harmonize a few legacy ISO3 codes used by this basemap
nap_data$ISO3[nap_data$ISO3 == "ROU"] <- "ROM"
nap_data$ISO3[nap_data$ISO3 == "TLS"] <- "TMP"

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

# Merge basemap with nap data
my_sf <- my_sf %>%
  left_join(nap_data, by = c("SOC" = "ISO3"))

# Assign "NoNAP" to missing values
my_sf$Yearperiod[is.na(my_sf$Yearperiod)] <- "NoNAP"

# Factor ordering
my_sf$Yearperiod <- factor(
  my_sf$Yearperiod,
  levels = c("NoNAP", "Before 2015", "2015-16", "2017-18", "2019-20", "2021-22", "After 2022")
)

# Remove Antarctica (keep rows where SOC is missing, otherwise they'd become holes)
my_sf <- my_sf %>% filter(is.na(SOC) | SOC != "ATA")

# Plot map
map_plot <- ggplot(data = my_sf) +
  geom_sf(aes(fill = Yearperiod), color = "black", linewidth = 0.15) +
  geom_sf(data = boundaries_sf, inherit.aes = FALSE, color = "black", linewidth = 0.15) +
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
