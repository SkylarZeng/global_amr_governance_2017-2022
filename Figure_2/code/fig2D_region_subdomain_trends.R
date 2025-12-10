library(dplyr)
library(ggplot2)
library(RColorBrewer)

# Read data
data <- read.csv("../data/fig2D.csv")

# Custom WHO region order
ordered_who <- c(
  "African Region",
  "European Region",
  "Region of the Americas",
  "Western Pacific Region",
  "South-East Asia Region",
  "Eastern Mediterranean Region"
)

data$WHO_Region <- factor(data$WHO_Region, levels = ordered_who)

# Compute the mean score for each WHO Region–subdomain–year combination
regional_summary <- data %>%
  group_by(WHO_Region, subdomain, year) %>%
  summarise(value = mean(value, na.rm = TRUE), .groups = "drop")

# Compute overall mean (across all regions)
overall_summary <- data %>%
  group_by(subdomain, year) %>%
  summarise(value = mean(value, na.rm = TRUE), .groups = "drop") %>%
  mutate(WHO_Region = "Overall")

# Combine regional and overall data
plot_data <- bind_rows(regional_summary, overall_summary)

# Define colors using Set2 palette
region_colors <- brewer.pal(n = 6, name = "Set2")
names(region_colors) <- ordered_who
all_colors <- c(region_colors, Overall = "#020080")

# Plot
p <- ggplot(plot_data, aes(x = year, y = value, color = WHO_Region, group = WHO_Region)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  facet_wrap(~ subdomain, scales = "free_y") +
  scale_color_manual(values = all_colors) +
  labs(x = "Year", y = "Mean scores of subdomains") +
  theme_minimal() +
  theme(
    strip.text = element_text(size = 12, face = "bold"),
    plot.title = element_text(size = 16, face = "bold"),
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 12),
    legend.title = element_blank(),
    legend.position = "bottom",
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.6),
    axis.ticks = element_line(color = "black", linewidth = 0.25),
    axis.ticks.length = unit(0.1, "cm")
  )

# Save plot
ggsave("../output/fig2D.pdf",
       plot = p, width = 12, height = 12)
