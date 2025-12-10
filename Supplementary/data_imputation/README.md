# Data Imputation

This directory contains code and data for imputing missing values in antimicrobial usage (AMU) datasets. The imputation workflow addresses missing data in three domains: Human AMU (forecasting), Animal AMU, and Corpland AMU.

## Directory Structure

```
data_imputation/
│
├── README.md
│
├── code/
│   ├── arima_human_amu_forecast.R
│   └── Complete data imputation.R
│
├── data/
│   ├── animal_cropland_amu.csv
│   ├── map.csv
│   ├── SDI2021.csv
│   └── total_antibiotic_consumption_estimates (Browne et al., Lancet Planet Health 2021).csv
│
└── output/
    ├── fill_animal+corp.csv
    └── Human_AMU_forecast_2019_2021.csv
```

## Overview

This folder implements two complementary imputation strategies:

1. **Human AMU Forecasting** (`arima_human_amu_forecast.R`): Uses ARIMA time series models to forecast human antimicrobial usage for 2019-2021 at global and country levels.

2. **Animal and Corpland AMU Imputation** (`Complete data imputation.R`): Imputes missing values in animal and cropland antimicrobial usage data using:
   - **Animal AMU**: SDI (Socio-demographic Index) Annual Percent Change (APC) method
   - **Corpland AMU**: Random sampling from existing values within the same country

## Required R Packages

```r
library(tidyverse)
library(readr)
library(forecast)
library(dplyr)
```

## Data Sources

### Input Data Files

- **`animal_cropland_amu.csv`**: Main dataset containing animal and cropland antimicrobial usage data with missing values
- **`map.csv`**: Mapping file linking ISO3 country codes to location IDs
- **`SDI2021.csv`**: Socio-demographic Index data used for Animal AMU imputation
- **`total_antibiotic_consumption_estimates (Browne et al., Lancet Planet Health 2021).csv`**: Human antimicrobial usage estimates from Browne et al. (Lancet Planet Health 2021), used for forecasting

### Output Data Files

- **`fill_animal+corp.csv`**: Complete dataset with imputed Animal and Corpland AMU values
- **`Human_AMU_forecast_2019_2021.csv`**: Forecasted human AMU values for 2019-2021 with 95% confidence intervals

## How to Reproduce

### 1. Human AMU Forecasting

Run the ARIMA forecasting script from the `data_imputation/` directory:

```bash
Rscript code/arima_human_amu_forecast.R
```

This script:
- Loads human AMU estimates from Browne et al. (2021)
- Fits ARIMA models using `auto.arima()` for automatic parameter selection
- Generates 3-year forecasts (2019-2021) for all locations
- Outputs forecasts with 95% confidence intervals to `output/Human_AMU_forecast_2019_2021.csv`

### 2. Animal and Corpland AMU Imputation

Run the complete imputation script:

```bash
Rscript code/Complete\ data\ imputation.R
```

This script:
- Loads animal/cropland AMU data, mapping file, and SDI data
- Calculates SDI Annual Percent Change (APC) by country
- Imputes Animal AMU using APC-based back-calculation and forward projection
- Imputes Corpland AMU using random sampling from existing country values
- Outputs complete dataset to `output/fill_animal+corp.csv`

## Methodology

### Human AMU Forecasting (ARIMA)

The ARIMA forecasting approach:
- Uses `auto.arima()` to automatically select optimal ARIMA model parameters
- Fits models separately for each location (country/global)
- Generates point forecasts and 95% prediction intervals
- Assumes annual frequency time series starting from 2000

### Animal AMU Imputation (SDI APC Method)

1. **Calculate SDI Annual Percent Change (APC)**:
   - Fit linear regression: `SDI ~ Year` for each country
   - Convert regression coefficient to annual percent change: `APC = 100 * (exp(β) - 1)`

2. **Impute Animal AMU**:
   - Use 2020 Animal AMU as baseline
   - For years < 2020: Back-calculate using `Animal_2020 * (1/(1+APC))^(2020-year)`
   - For years > 2020: Forward-project using `Animal_2020 * (1+APC)^(year-2020)`

### Corpland AMU Imputation (Random Sampling)

1. **Identify countries with partial missingness**: Countries with some but not all years missing
2. **For each country with partial missingness**:
   - Randomly sample from existing Corpland values within the same country
   - Replace missing values with sampled values (with replacement)
3. **Countries with complete missingness or no missingness**: Left unchanged

## Notes & Requirements

- All scripts use relative paths and should be run from the `data_imputation/` directory
- Output directories are created automatically if they do not exist
- Ensure all required R packages are installed before running the scripts
- Input data files must be present in the `data/` directory
- The Animal AMU imputation requires SDI data to be available for matching countries
- The Corpland imputation only affects countries with partial missingness; countries with complete missingness remain unchanged

## Data Citation

When using the human AMU data, please cite:
- **Browne et al. (2021)**: Total antibiotic consumption estimates. *Lancet Planet Health*, 2021.

## Contact

For questions on code, data, or reproducibility, contact the analysis team or the manuscript corresponding author.

