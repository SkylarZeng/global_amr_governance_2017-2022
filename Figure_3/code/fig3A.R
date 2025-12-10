library(ggplot2)
library(dplyr)
library(readr)
library(RColorBrewer)

# Read data
data <- read_csv("../data/fig3A.csv")

# Set grouping variable: WHO Region
group_var <- "WHO_Region"

# Define custom WHO region order
ordered_who <- c(
  "African Region",
  "Region of the Americas",
  "Eastern Mediterranean Region",
  "South-East Asia Region",
  "Western Pacific Region",
  "European Region"
)

# Manually assign colors for each region
group_colors <- c(
  "Region of the Americas" = "#8da0cb",
  "African Region" = "#66c2a5",
  "Eastern Mediterranean Region" = "#ffd92f",
  "Western Pacific Region" = "#e78ac3",
  "European Region" = "#fc8d62",
  "South-East Asia Region" = "#a6d854"
)

data[[group_var]] <- factor(data[[group_var]], levels = ordered_who)

# Key reference years for annotation
year_labels <- c(2000, 2015, 2021)

# Compute group-level mean values in key reference years
mean_labels <- data %>%
  filter(year %in% year_labels) %>%
  group_by(.data[[group_var]], year) %>%
  summarise(value = round(mean(value, na.rm = TRUE), 1), .groups = "drop") %>%
  mutate(hjust = ifelse(year == 2021, 0, 1))

# Plot
p <- ggplot(data, aes(x = year, y = value)) +
  
  # Standard deviation band
  stat_summary(
    aes(fill = .data[[group_var]]),
    fun.data = mean_sdl, fun.args = list(mult = 1),
    geom = "ribbon", alpha = 0.4, color = NA
  ) +
  
  # Mean trend line
  stat_summary(
    aes(color = .data[[group_var]]),
    fun = mean, geom = "line", size = 2.5
  ) +
  
  # Labels for mean values at reference years
  geom_label(
    data = mean_labels,
    aes(x = year, y = value, label = value, fill = .data[[group_var]], hjust = hjust),
    color = "white", size = 3.5, show.legend = FALSE
  ) +
  
  # Vertical reference lines and annotations
  geom_vline(xintercept = 2000, linetype = "dashed", color = "grey50") +
  geom_vline(xintercept = 2015, linetype = "dashed", color = "darkorange") +
  geom_vline(xintercept = 2021, linetype = "dashed", color = "steelblue") +
  annotate("text", x = 2000, y = 15, label = "2000", hjust = 0, color = "grey50") +
  annotate("text", x = 2015, y = 15, label = "2015", hjust = 1, color = "darkorange") +
  annotate("text", x = 2021, y = 15, label = "2021", hjust = 1, color = "steelblue") +
  
  # Facet by WHO region
  facet_wrap(as.formula(paste("~", group_var)), nrow = 1) +
  
  # Apply manual colors
  scale_color_manual(values = group_colors) +
  scale_fill_manual(values = group_colors) +
  
  # Labels and theme
  labs(
    x = NULL,
    y = "AMU score",
    color = group_var,
    fill = group_var
  ) +
  theme_classic(base_size = 12) +
  theme(
    strip.text = element_text(face = "bold"),
    plot.title = element_text(size = 16, face = "bold"),
    legend.position = "bottom",
    plot.margin = margin(rep(20, 4)),
    panel.spacing = unit(20, "pt")
  ) +
  coord_cartesian(clip = "off")

# Save as PDF
ggsave("../output/fig3A.pdf", plot = p, width = 14, height = 6)
