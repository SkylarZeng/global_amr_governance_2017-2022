#!/usr/bin/env Rscript
# plot_Fig5A_forest.R
# Generate a publication-style forest plot for Figure 5A using model results in `output/`.

library(readr)
library(dplyr)
library(ggplot2)
library(janitor)
library(patchwork)
library(stringr)

# Find candidate input files in `output/`
expected <- file.path("output", "Fig5A_fixed_model_results.csv")
if (file.exists(expected)) {
  input_file <- expected
} else {
  candidates <- list.files("output", pattern = "Fig5A.*model.*result.*\\.csv$", full.names = TRUE, ignore.case = TRUE)
  if (length(candidates) == 0) {
    candidates <- list.files("output", pattern = "Fig5A.*result.*\\.csv$", full.names = TRUE, ignore.case = TRUE)
  }
  if (length(candidates) == 0) stop("No Fig5A results CSV found in output/ (expected 'output/Fig5A_model_results.csv')")
  input_file <- candidates[1]
}
cat("Using input:", input_file, "\n")

df <- read_csv(input_file) %>% clean_names()

# Ensure expected columns exist
if (!all(c("indicator", "coefficient", "standard_errors") %in% names(df))) {
  stop("Input CSV must contain columns named 'Indicator' (or similar), 'Coefficient' and 'Standard Errors'")
}

# Prepare data
df <- df %>%
  filter(if_all(everything(), ~ TRUE)) %>%
  mutate(
    indicator = str_trim(indicator),
    indicator = factor(indicator, levels = rev(unique(indicator)))
  ) %>%
  filter(!str_detect(toupper(indicator), "^COVID")) %>%
  mutate(
    lower = coefficient - qnorm(0.975) * standard_errors,
    upper = coefficient + qnorm(0.975) * standard_errors,
    ci_label = sprintf("%.2f (%.2f–%.2f)", coefficient, lower, upper),
    p_category = case_when(
      (tolower(p) != "" & !is.na(p) & as.numeric(p) < 0.01) ~ "p<0.01",
      (tolower(p) != "" & !is.na(p) & as.numeric(p) < 0.05) ~ "p<0.05",
      TRUE ~ "Not significant"
    )
  )

point_colors <- c("p<0.01" = "#DBA29D", "p<0.05" = "#98D0E0", "Not significant" = "#D0D1D4")

# Set x limits automatically with small padding
xmin <- min(df$lower, na.rm = TRUE)
xmax <- max(df$upper, na.rm = TRUE)
xpad <- 0.05 * (xmax - xmin)

forest_plot <- ggplot(df, aes(x = coefficient, y = indicator)) +
  geom_vline(xintercept = 0, linetype = "solid", colour = "black", linewidth = 0.6) +
  geom_segment(aes(x = lower, xend = upper, y = indicator, yend = indicator), color = "black", linewidth = 0.6) +
  geom_point(aes(fill = p_category), shape = 21, size = 4, stroke = 0.5, color = "black") +
  scale_fill_manual(values = point_colors, guide = "none") +
  scale_x_continuous(limits = c(xmin - xpad, xmax + xpad)) +
  labs(title = "Associations in early-adopting countries", y = NULL) +
  theme_classic(base_size = 13) +
  theme(
    text = element_text(color = "black"),
    plot.title = element_text(size = 15, hjust = 0.5, face = "bold"),
    axis.title = element_blank(),
    axis.text.y = element_text(size = 12, color = "black"),
    axis.text.x = element_text(angle = 45, hjust = 1, color = "black"),
    axis.ticks.y = element_blank(),
    axis.line.y = element_blank(),
    panel.grid = element_blank(),
    plot.margin = margin(10, 5, 10, 10)
  )

text_plot <- ggplot(df, aes(x = 1, y = indicator)) +
  geom_text(aes(label = ci_label), hjust = 0, size = 4, color = "black") +
  scale_x_continuous(limits = c(1, 1.05), expand = c(0, 0)) +
  labs(title = "Estimate (95% CI)") +
  theme_void(base_size = 13) +
  theme(plot.title = element_text(size = 15, hjust = 0, face = "bold"), plot.margin = margin(10, 20, 10, 5))

combined <- forest_plot + text_plot + plot_layout(ncol = 2, widths = c(3, 1))

out_pdf <- file.path("output", "Fig5A_forest.pdf")
dir.create("output", showWarnings = FALSE)
ggsave(out_pdf, plot = combined, width = 9.5, height = 5.5)
cat("Saved Figure 5A to:", out_pdf, "\n")
