# ============================================================================
# Fig5A-res-death.R
# ============================================================================
# Purpose: Fit fixed-effects panel models for Figure 5A analysis with 
#          respiratory disease death rate as a sensitivity covariate
# 
# Analysis: 
#   1. Main fixed-effects model (without respiratory covariate)
#   2. Sensitivity model including respiratory disease death rate
#
# Input:  data/fig5A_early_adopting_governance.csv
#         data/respiratory_deaths.xlsx (or similar)
# Output: output/Fig5A-fixed_model_results-respiratory.csv
#         output/Fig5A-fixed_model_results-respiratory.pdf
# ============================================================================

# Load required libraries
library(plm)
library(tidyverse)
library(broom)
library(readxl)

# ============================================================================
# Configuration
# ============================================================================
data_file <- "data/fig5A_early_adopting_governance.csv"
respiratory_death_file <- "data/respiratory_deaths.xlsx"  # Update path as needed
output_dir <- "output"
output_prefix <- file.path(output_dir, "Fig5A-fixed_model_results-respiratory")

# Create output directory if it doesn't exist
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# ============================================================================
# Variable name to indicator label mapping
# ============================================================================
indicator_labels <- c(
  "Strategic_vision" = "1.1 Strategic vision",
  "Multi_sector_engagement" = "1.2 Multi-sector engagement",
  "Sustainability" = "1.3 Sustainability",
  "Accountability" = "1.4 Accountability",
  "AMC_surveillance_system" = "2.1 AMC surveillance system",
  "AMR_surveillance_system" = "2.2 AMR surveillance system",
  "Optimization_antimicrobial" = "2.3 Optimization of antimicrobial use",
  "Professional_education" = "2.4 Professional education",
  "Public_awareness" = "2.5 Public awareness",
  "Hygiene_prevention" = "2.6 Hygiene and prevention",
  "Research_innovation" = "2.7 Research innovation",
  "Reporting" = "3.1 Reporting",
  "Policy_adjustment" = "3.2 Policy adjustment",
  "Effectiveness" = "3.3 Effectiveness",
  "respiratory" = "Respiratory1"
)

# ============================================================================
# Data Preparation
# ============================================================================
cat("Reading primary dataset...\n")
df <- read.csv(data_file)

# Select variables for modeling
dfx <- df %>%
  select(
    Country_class, Year, AMR,
    Strategic_vision,
    Multi_sector_engagement,
    Sustainability,
    Accountability,
    AMC_surveillance_system,
    AMR_surveillance_system,
    Optimization_antimicrobial,
    Professional_education,
    Public_awareness,
    Hygiene_prevention,
    Research_innovation,
    Reporting,
    Policy_adjustment,
    Effectiveness
  )

# ============================================================================
# Main Analysis: Fixed-Effects Model (without respiratory covariate)
# ============================================================================
cat("\nFitting main fixed-effects model...\n")
fixed_model <- plm(
  AMR ~ Strategic_vision + Multi_sector_engagement + Sustainability + 
        Accountability + AMC_surveillance_system + AMR_surveillance_system + 
        Optimization_antimicrobial + Professional_education + Public_awareness + 
        Hygiene_prevention + Research_innovation + Reporting + Policy_adjustment + 
        Effectiveness,
  data = dfx,
  index = c("Country_class"),
  model = "within"
)

cat("Main model summary:\n")
print(summary(fixed_model))

# ============================================================================
# Sensitivity Analysis: Fixed-Effects Model with Respiratory Death Rate
# ============================================================================
if (file.exists(respiratory_death_file)) {
  cat("\nReading respiratory disease death data...\n")
  
  # Read and prepare respiratory death data
  # Note: Adjust column selection based on actual file structure
  dfdeath <- read_excel(respiratory_death_file, sheet = 1) %>%
    rename(Country = 1)
  
  # Create ID for joining
  dfx_small <- df %>%
    mutate(id = seq_len(n()), .before = 1) %>%
    select(1:4)
  
  # Join respiratory death data (adjust column index as needed)
  dfy <- left_join(dfx_small, dfdeath, by = c("Country" = "Country", "Year" = "Year")) %>%
    select(id, respiratory = 6)  # Adjust column index as needed
  
  # Prepare analysis dataset with respiratory covariate
  dfx2 <- df %>%
    mutate(id = seq_len(n()), .before = 1) %>%
    select(id, Country_class, Year, AMR,
           Strategic_vision, Multi_sector_engagement, Sustainability, Accountability,
           AMC_surveillance_system, AMR_surveillance_system, Optimization_antimicrobial,
           Professional_education, Public_awareness, Hygiene_prevention, Research_innovation,
           Reporting, Policy_adjustment, Effectiveness) %>%
    left_join(dfy, by = "id")
  
  cat("Fitting sensitivity model with respiratory disease death rate...\n")
  fixed_respiratory <- plm(
    AMR ~ Strategic_vision + Multi_sector_engagement + Sustainability + 
          Accountability + AMC_surveillance_system + AMR_surveillance_system + 
          Optimization_antimicrobial + Professional_education + Public_awareness + 
          Hygiene_prevention + Research_innovation + Reporting + Policy_adjustment + 
          Effectiveness + respiratory,
    data = dfx2,
    index = c("Country_class"),
    model = "within"
  )
  
  cat("Sensitivity model summary:\n")
  print(summary(fixed_respiratory))
  
  # ============================================================================
  # Format Results for Output
  # ============================================================================
  # Create mapping dataframe for joining
  indicator_map <- data.frame(
    term = names(indicator_labels),
    Indicator = unname(indicator_labels),
    stringsAsFactors = FALSE
  )
  
  model_df_respiratory <- tidy(fixed_respiratory) %>%
    left_join(indicator_map, by = "term") %>%
    mutate(
      Indicator = ifelse(is.na(Indicator), term, Indicator),
      Model = "Fixed effects",
      Coefficient = estimate,
      `Standard Errors` = std.error,
      `t value` = statistic,
      P = p.value
    ) %>%
    select(Indicator, Model, Coefficient, `Standard Errors`, `t value`, P)
  
  # Save results
  write.csv(model_df_respiratory, paste0(output_prefix, ".csv"), row.names = FALSE)
  cat("\nResults saved to:", paste0(output_prefix, ".csv"), "\n")
  print(model_df_respiratory)
  
} else {
  warning("Respiratory death Excel file not found at '", respiratory_death_file, 
          "'. Skipping respiratory sensitivity model step.")
}