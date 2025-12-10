library(ggplot2)
library(dplyr)
library(readr)
library(RColorBrewer)

# Load data
data <- read_csv("../data/fig2C.csv")

# Define grouping variable (WHO Region)
group_var <- "WHO_Region"

# Custom WHO region order
ordered_who <- c(
  "Region of the Americas",
  "African Region",
  "Eastern Mediterranean Region",
  "Western Pacific Region",
  "European Region",
  "South-East Asia Region"
)

data[[group_var]] <- factor(data[[group_var]], levels = ordered_who)

# Key years for labelling
year_labels <- c(2017, 2022)

# Compute mean values for selected years
mean_labels <- data %>%
  filter(year %in% year_labels) %>%
  group_by(.data[[group_var]], year) %>%
  summarise(value = round(mean(value, na.rm = TRUE), 1), .groups = "drop") %>%
  mutate(hjust = ifelse(year == 2022, 0, 1))

# Build plot
p <- ggplot(data, aes(x = year, y = value)) +
  
  # SD band (±1 SD)
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
  
  # Labels for mean values in key years
  geom_label(
    data = mean_labels,
    aes(x = year, y = value, label = value,
        fill = .data[[group_var]], hjust = hjust),
    color = "white", size = 3.5, show.legend = FALSE
  ) +
  
  # Vertical reference lines for global milestones
  geom_vline(xintercept = 2017, linetype = "dashed", color = "darkorange") +
  geom_vline(xintercept = 2022, linetype = "dashed", color = "steelblue") +
  annotate("text", x = 2017, y = 15, label = "2017", hjust = 0, color = "darkorange") +
  annotate("text", x = 2022, y = 15, label = "2022", hjust = 1, color = "steelblue") +
  
  # Facet by WHO region
  facet_wrap(as.formula(paste("~", group_var)), nrow = 1) +
  
  # Color scales
  scale_color_brewer(palette = "Set2") +
  scale_fill_brewer(palette = "Set2") +
  
  # Axis labels
  labs(
    x = NULL,
    y = "Governance score",
    color = group_var,
    fill = group_var
  ) +
  
  # Theme settings
  theme_classic(base_size = 12) +
  theme(
    legend.position = "none",
    plot.margin = margin(rep(20, 4)),
    panel.spacing = unit(20, "pt")
  ) +
  
  coord_cartesian(clip = "off")

# Save figure
ggsave("../output/fig2C.pdf", p, width = 14, height = 6)
