# ============================================================================
# ARIMA Time Series Forecasting for Human Antimicrobial Usage (2019-2021)
# ============================================================================
# This script uses ARIMA models to forecast Human Antimicrobial Usage patterns
# for global and country-level data from 2019 to 2021
# ============================================================================

library(tidyverse)
library(readr)
library(forecast)

# ============================================================================
# 1. LOAD DATA
# ============================================================================

# Read Antimicrobial Usage estimates data. Data from Browne et al., Lancet Planet Health 2019.
antibiotic_data <- read_csv("../data/total_antibiotic_consumption_estimates (Browne et al., Lancet Planet Health 2021).csv")

# ============================================================================
# 2. EXAMPLE: GLOBAL FORECAST
# ============================================================================

# Filter for global data and prepare for modeling
global_data <- antibiotic_data %>% 
  filter(Location == "Global") %>% 
  select(1:3) %>% 
  rename("value" = 3)

# Convert to time series object (annual data starting from 2000)
ts_global <- ts(global_data$value, start = 2000, frequency = 1)

# Fit ARIMA model using auto.arima for automatic parameter selection
arima_model <- auto.arima(ts_global)

# Forecast for the next 3 years (2019-2021)
global_forecast <- forecast(arima_model, h = 3)


# ============================================================================
# 3. FUNCTION: FORECAST FOR INDIVIDUAL LOCATIONS
# ============================================================================

#' Forecast Antimicrobial Usage for a specific location
#'
#' @param data A data frame containing Year and value columns
#' @param h Number of years to forecast (default: 3)
#' @return A data frame with forecasted values and 95% confidence intervals
forecast_by_location <- function(data, h = 3) {
  # Convert to time series object
  ts_data <- ts(data$value, start = min(data$Year), frequency = 1)
  
  # Fit ARIMA model
  arima_fit <- auto.arima(ts_data)
  
  # Generate forecast
  forecast_result <- forecast(arima_fit, h = h)
  
  # Prepare results with confidence intervals
  return(data.frame(
    Year = (max(data$Year) + 1):(max(data$Year) + h),
    Predicted_Value = as.numeric(forecast_result$mean),
    Lower_CI_95 = as.numeric(forecast_result$lower[, 2]),  # 95% lower bound
    Upper_CI_95 = as.numeric(forecast_result$upper[, 2])   # 95% upper bound
  ))
}

# ============================================================================
# 4. APPLY FORECAST TO ALL LOCATIONS
# ============================================================================

# Prepare data for all locations
all_locations_data <- antibiotic_data %>% 
  select(1:3) %>% 
  rename("value" = 3)

# Apply forecasting function to each location
forecast_results <- all_locations_data %>%
  group_by(Location) %>%
  do(forecast_by_location(.)) %>%
  ungroup()

# Save forecasted results for all locations
write_csv(forecast_results, "../output/Human_AMU_forecast_2019_2021.csv")
