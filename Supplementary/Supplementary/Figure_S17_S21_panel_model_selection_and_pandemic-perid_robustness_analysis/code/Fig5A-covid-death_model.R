# ============================================================================
# Fig5A-covid-death.R
# ============================================================================
# Purpose: Fit fixed-effects panel models for Figure 5A analysis with 
#          COVID-19 death rate as a sensitivity covariate
# 
# Analysis: 
#   1. Main fixed-effects model (without COVID covariate)
#   2. Sensitivity model including COVID-19 death rate
#
# Input:  data/fig5A_early_adopting_governance.csv
#         data/COVID_deaths.xlsx
# Output: output/Fig5A-fixed_model_results-COVID01.csv
#         output/Fig5A-fixed_model_results-COVID01.pdf
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
covid_death_file <- "data/COVID_deaths.xlsx"
output_dir <- "output"
output_prefix <- file.path(output_dir, "Fig5A-fixed_model_results-COVID01")

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
  "covid" = "COVID1"
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
# Main Analysis: Fixed-Effects Model (without COVID covariate)
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
# Sensitivity Analysis: Fixed-Effects Model with COVID-19 Death Rate
# ============================================================================
if (file.exists(covid_death_file)) {
  cat("\nReading COVID-19 death data...\n")
  
  # Read and prepare COVID death data
  dfdeath <- read_excel(covid_death_file, sheet = 1) %>%
    select(3, 7, 8) %>%
    rename(Country = 1, Year = 2, covid = 3)
  
  # Create ID for joining
  dfx_small <- df %>%
    mutate(id = seq_len(n()), .before = 1) %>%
    select(1:4)
  
  # Join COVID death data
  dfy <- left_join(dfx_small, dfdeath, by = c("Country" = "Country", "Year" = "Year")) %>%
    select(id, covid)
  
  # Prepare analysis dataset with COVID covariate
  dfx2 <- df %>%
    mutate(id = seq_len(n()), .before = 1) %>%
    select(id, Country_class, Year, AMR,
           Strategic_vision, Multi_sector_engagement, Sustainability, Accountability,
           AMC_surveillance_system, AMR_surveillance_system, Optimization_antimicrobial,
           Professional_education, Public_awareness, Hygiene_prevention, Research_innovation,
           Reporting, Policy_adjustment, Effectiveness) %>%
    left_join(dfy, by = "id")
  
  cat("Fitting sensitivity model with COVID-19 death rate...\n")
  fixed_covid <- plm(
    AMR ~ Strategic_vision + Multi_sector_engagement + Sustainability + 
          Accountability + AMC_surveillance_system + AMR_surveillance_system + 
          Optimization_antimicrobial + Professional_education + Public_awareness + 
          Hygiene_prevention + Research_innovation + Reporting + Policy_adjustment + 
          Effectiveness + covid,
    data = dfx2,
    index = c("Country_class"),
    model = "within"
  )
  
  cat("Sensitivity model summary:\n")
  print(summary(fixed_covid))
  
  # ============================================================================
  # Format Results for Output
  # ============================================================================
  # Create mapping dataframe for joining
  indicator_map <- data.frame(
    term = names(indicator_labels),
    Indicator = unname(indicator_labels),
    stringsAsFactors = FALSE
  )
  
  model_df_covid <- tidy(fixed_covid) %>%
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
  write.csv(model_df_covid, paste0(output_prefix, ".csv"), row.names = FALSE)
  cat("\nResults saved to:", paste0(output_prefix, ".csv"), "\n")
  print(model_df_covid)
  
} else {
  warning("COVID death Excel file not found at '", covid_death_file, 
          "'. Skipping COVID sensitivity model step.")
}