# ============================================================================
# Fig5A-res-forest.R
# ============================================================================
# Purpose: Generate forest plot for Figure 5A respiratory disease sensitivity analysis
# 
# Input:  output/Fig5A-fixed_model_results-respiratory.csv
# Output: output/Fig5A-fixed_model_results-respiratory.pdf
# ============================================================================

library(readr)
library(dplyr)
library(ggplot2)
library(janitor)
library(patchwork)
library(stringr)

# ============================================================================
# Configuration
# ============================================================================
input_file <- "output/Fig5A-fixed_model_results-respiratory.csv"
output_file <- "output/Fig5A-fixed_model_results-respiratory.pdf"

# ============================================================================
# Data Preparation
# ============================================================================
cat("Reading model results...\n")
df <- read_csv(input_file) %>%
  clean_names()

# Process data for plotting
df <- df %>%
  filter(model == "Fixed effects") %>%
  mutate(
    indicator = str_trim(indicator),  
    indicator = factor(indicator, levels = rev(unique(indicator)))
  ) %>%
  filter(indicator != "Respiratory1") %>% 
  mutate(
    coefficient = coefficient,
    standard_errors = standard_errors,
    lower = coefficient - qnorm(0.975) * standard_errors,
    upper = coefficient + qnorm(0.975) * standard_errors,
    ci_label = sprintf("%.2f (%.2f–%.2f)", coefficient, lower, upper),
    p_category = case_when(
      p < 0.01 ~ "p<0.01",
      p < 0.05 ~ "p<0.05",
      TRUE ~ "Not significant"
    )
  )

# ============================================================================
# Plot Configuration
# ============================================================================
# Significance color mapping
point_colors <- c("p<0.01" = "#DBA29D", "p<0.05" = "#98D0E0", "Not significant" = "#D0D1D4")

# ============================================================================
# Main Forest Plot
# ============================================================================
forest_plot <- ggplot(df, aes(x = coefficient, y = indicator)) +
  geom_vline(xintercept = 0, linetype = "solid", colour = "black", linewidth = 0.6) +
  geom_segment(aes(x = lower, xend = upper, y = indicator, yend = indicator),
               color = "black", linewidth = 0.6) +
  geom_point(aes(fill = p_category), shape = 21, size = 4, stroke = 0.5, color = "black") +
  scale_fill_manual(values = point_colors, guide = "none") +
  scale_x_continuous(
    limits = c(-0.35, 0.30), 
    breaks = seq(-0.35, 0.3, 0.05), 
    expand = c(0, 0), 
    labels = scales::number_format(accuracy = 0.01)
  ) +
  labs(
    title = "Associations in countries with the greatest AMR improvements", 
    family = "Arial", 
    color = "black"
  ) +
  theme_classic(base_size = 13) +
  theme(
    text = element_text(family = "Arial", color = "black"),
    plot.title = element_text(size = 15, hjust = 0.5, face = "bold"),
    axis.title = element_blank(),
    axis.text.y = element_text(size = 12, family = "Arial", color = "black"),
    axis.text.x = element_text(angle = 45, hjust = 1, family = "Arial", color = "black"),
    axis.ticks.y = element_blank(),
    axis.line.y = element_blank(),
    panel.grid = element_blank(),       
    panel.grid.major = element_blank(),  
    panel.grid.minor = element_blank(),  
    plot.margin = margin(10, 5, 10, 10)
  )

# ============================================================================
# Confidence Interval Text Plot
# ============================================================================
text_plot <- ggplot(df, aes(x = 1, y = indicator)) +
  geom_text(aes(label = ci_label), hjust = 0, size = 4, family = "Arial", color = "black") +
  scale_x_continuous(limits = c(1, 1.05), expand = c(0, 0)) +
  labs(title = "Estimate (95% CI)", family = "Arial", color = "black") +
  theme_void(base_size = 13) +
  theme(
    text = element_text(family = "Arial", color = "black"),
    plot.title = element_text(size = 15, hjust = 0, face = "bold"),
    plot.margin = margin(10, 20, 10, 5)
  )

# ============================================================================
# Combine and Save
# ============================================================================
combined <- forest_plot + text_plot + plot_layout(ncol = 2, widths = c(3, 1))

cat("Saving plot to:", output_file, "\n")
ggsave(
  output_file,
  plot = combined, 
  width = 9.5, 
  height = 5.5, 
  device = cairo_pdf
)

cat("Forest plot generation complete!\n")

