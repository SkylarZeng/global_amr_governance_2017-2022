library(ggplot2)
library(dplyr)
library(readr)
library(RColorBrewer)

# Read data
data <- read_csv("../data/fig2A.csv")

# Custom gradient color palette
myColors <- colorRampPalette(brewer.pal(11, "RdYlBu"))(100)

# Set grouping variable
group_var <- "subdomain"

# Compute annual mean score for each group
data_summary <- data %>%
  group_by(year, Group = .data[[group_var]]) %>%
  summarise(value = mean(value, na.rm = TRUE), .groups = "drop")

# Set Y-axis factor levels in ascending order (reversed for plotting)
data_summary$Group <- factor(data_summary$Group,
                             levels = rev(sort(unique(data_summary$Group))))

# Plot
p <- ggplot(data_summary, aes(x = year, y = Group, fill = value)) +
  geom_tile(color = "white", linewidth = 0.4) +
  
  scale_x_continuous(breaks = sort(unique(data_summary$year))) +
  
  scale_fill_gradientn(
    colours = myColors,
    limits = c(20, 66),
    breaks = seq(0, 100, by = 20),
    name = "Score"
  ) +
  
  guides(fill = guide_colorbar(barwidth = unit(250, "pt"),
                               barheight = unit(10, "pt"),
                               title = NULL)) +
  
  labs(
    x = NULL, y = NULL) +
  
  theme_classic() +
  theme(
    axis.line = element_blank(),
    legend.position = "bottom",
    plot.margin = unit(c(.5, 0.5, 0.5, 0.5), "cm")) +
  
  coord_cartesian(expand = 0, clip = "off")

# Save as PDF
ggsave("../output/fig2A.pdf", p, width = 10, height = 8)
