library(dplyr)
library(ggplot2)

# Read data
data <- read.csv("../data/fig2B.csv")

# Compute the mean value of each domain for each year
mean_data <- data %>%
  group_by(domain, year) %>%
  summarise(value = round(mean(value, na.rm = TRUE), 1), .groups = "drop")

# Compute slope, R² and p-value for each domain
slopes <- mean_data %>%
  group_by(domain) %>%
  do({
    model <- lm(value ~ year, data = .)
    slope <- coef(model)[2]
    r_squared <- summary(model)$r.squared
    p_value <- summary(model)$coefficients[2, 4]
    legend_label <- paste("Slope: ", round(slope, 2), 
                          ", R²: ", round(r_squared, 2), 
                          ", P: ", round(p_value, 4), sep = "")
    cbind(., Slope = slope, R_squared = r_squared, P_value = p_value, Legend_Label = legend_label)
  })

# Set text positions so that annotation labels for each domain appear on different rows
slopes <- slopes %>%
  group_by(domain) %>%
  mutate(
    label_x = min(year) - 0.5, 
    label_y = max(value) + 2.5 * (as.numeric(factor(domain)) - 1)
  )

# Plot mean value of each domain by year with linear regression lines and confidence intervals
p <- ggplot(slopes, aes(x = year, y = value, color = domain, group = domain)) +
  geom_smooth(method = "lm", se = TRUE, size = 1.5, aes(fill = domain), alpha = 0.5) +
  geom_point(size = 3) +
  geom_text(aes(label = Legend_Label, color = domain), 
            x = slopes$label_x, y = slopes$label_y, 
            size = 4, hjust = 0, vjust = 1, show.legend = FALSE) +
  labs(x = "Year", y = "Mean value of AMR governance domains") +
  theme_minimal() +
  theme(
    legend.title = element_blank(),
    legend.position = "right",
    panel.border = element_rect(color = "black", fill = NA, size = 1),
    axis.ticks.length = unit(0.1, "cm"),
    axis.ticks = element_line(size = 0.5, color = "black")
  ) +
  scale_color_manual(values = c("#FDBE83", "#C8A3B5", "#2F4E68")) + 
  scale_fill_manual(values = c("#FDBE83", "#C8A3B5", "#2F4E68")) + 
  guides(color = guide_legend(title = "domain", override.aes = list(size = 6, shape = 16)))

# Save plot to PDF
ggsave("../output/fig2B.pdf", p, width = 8, height = 6)
