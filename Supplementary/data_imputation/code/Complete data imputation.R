# ====================================================================
# Complete Imputation Workflow for Antimicrobial Usage Data
# ====================================================================
# Goal: Impute missing values in Animal and Corpland columns
# Methods:
#   - Animal: Predict using SDI (Socio-demographic Index) Annual Percent Change (APC)
#   - Corpland: Impute using random sampling from existing values within the same country
# ====================================================================

library(tidyverse)
library(dplyr)

# --------------------------------------------------------------------
# 1. Load data
# --------------------------------------------------------------------

# Load main dataset
df_raw <- read.csv("../data/animal_cropland_amu.csv", header = TRUE)

# Load auxiliary datasets
map <- read.csv("../data/map.csv", header = TRUE)
sdi <- read.csv("../data/SDI2021.csv", header = TRUE)


# --------------------------------------------------------------------
# 2. Data preprocessing
# --------------------------------------------------------------------
# Extract usage columns (first 5 columns)
df_usage <- df_raw %>% 
  select(1:5) %>%
  rename(
    brk_a3   = 1,  # ISO3 code
    name     = 2,  # country name
    year     = 3,  # year
    Animal   = 4,  # antimicrobial usage in animals
    Corpland = 5   # antimicrobial usage in cropland
  )

# --------------------------------------------------------------------
# 3. Calculate SDI Annual Percent Change (APC)
# --------------------------------------------------------------------
# Calculate APC by location_id
df_apc_by_id <- sdi %>%
  group_by(location_id) %>%
  summarize(
    beta = coef(lm(sdi ~ year))[2],      # regression coefficient
    apc = 100 * (exp(beta) - 1),         # convert to annual percent change
    .groups = "drop"
  )

# Calculate APC by location_name (backup mapping)
df_apc_by_name <- sdi %>%
  group_by(location_name) %>%
  summarize(
    beta = coef(lm(sdi ~ year))[2],
    apc = 100 * (exp(beta) - 1),
    .groups = "drop"
  ) %>%
  rename(name = location_name)

# Merge APC with map data (to get ISO3 mapping)
df_apc_merged <- left_join(map, df_apc_by_id, by = "location_id")

# --------------------------------------------------------------------
# 4. Impute Animal usage
# --------------------------------------------------------------------
# Use Animal in year 2020 as baseline
df_animal_2020 <- df_usage %>%
  select(brk_a3, name, year, Animal) %>%
  filter(year == 2020) %>%
  left_join(df_apc_merged, by = "brk_a3")

# Split into countries successfully matched vs. unmatched
df_animal_matched <- df_animal_2020 %>%
  filter(!is.na(name_long))

df_animal_unmatched <- df_animal_2020 %>%
  filter(is.na(name_long)) %>%
  select(1:4) %>%
  left_join(df_apc_by_name, by = "name")

# Combine APC information for all countries
df_animal_with_apc <- bind_rows(
  df_animal_matched %>% select(brk_a3, name, year, Animal, apc),
  df_animal_unmatched %>% select(brk_a3, name, year, Animal, apc)
)

# Generate Animal usage for 2000–2021 based on APC
df_animal_imputed <- df_animal_with_apc %>%
  group_by(name) %>%
  mutate(apc = apc / 100) %>%  # convert percentage to proportion
  reframe(
    brk_a3 = brk_a3,
    name = name,
    year = 2000:2021,
    Animal = case_when(
      year == 2020 ~ Animal,                                     # use original value for 2020
      year < 2020 ~ Animal * (1 / (1 + apc))^(2020 - year),      # back-calculate for earlier years
      year > 2020 ~ Animal * (1 + apc)^(year - 2020)             # project forward for later years
    )
  ) %>%
  distinct()

# --------------------------------------------------------------------
# 5. Impute Corpland usage
# --------------------------------------------------------------------
# Summarize missingness of Corpland for each country
corpland_na_summary <- df_usage %>%
  group_by(brk_a3) %>%
  summarize(
    NA_count   = sum(is.na(Corpland)),
    Total_years = n(),
    .groups = "drop"
  )

# Identify countries with partial missingness (0 < NA < total years)
countries_partial_missing <- corpland_na_summary %>%
  filter(NA_count > 0 & NA_count < max(Total_years)) %>%
  pull(brk_a3)

# Subset countries with partial missingness for random imputation
df_corpland_partial <- df_usage %>%
  filter(brk_a3 %in% countries_partial_missing) %>%
  select(brk_a3, name, year, Corpland)

df_corpland_imputed <- df_corpland_partial %>%
  group_by(brk_a3, name) %>%
  complete(year = 2000:2021) %>%
  group_modify(~ {
    country_data <- .x
    valid_values <- country_data$Corpland[!is.na(country_data$Corpland)]
    
    # If no valid values exist, keep NA as is
    if (length(valid_values) == 0) {
      return(country_data)
    }
    
    # Impute missing values by random sampling from existing values
    na_indices <- which(is.na(country_data$Corpland))
    if (length(na_indices) > 0) {
      imputed_values <- sample(
        valid_values, 
        size = length(na_indices), 
        replace = TRUE
      )
      country_data$Corpland[na_indices] <- imputed_values
    }
    
    return(country_data)
  }) %>%
  ungroup()

# Keep countries with no or complete missingness as they are
df_corpland_complete <- df_usage %>%
  filter(!(brk_a3 %in% countries_partial_missing)) %>%
  select(brk_a3, name, year, Corpland)

df_corpland_final <- bind_rows(df_corpland_imputed, df_corpland_complete) %>%
  arrange(brk_a3, year)

# --------------------------------------------------------------------
# 6. Merge imputed data
# --------------------------------------------------------------------
# Prepare final usage dataset with imputed Animal and Corpland
df_usage_final <- df_raw %>%
  select(ISO3, Country, Year) %>%
  # Merge imputed Animal
  left_join(
    df_animal_imputed %>% 
      select(name, year, Animal) %>%
      rename(Country = name, Year = year),
    by = c("Country", "Year")
  ) %>%
  # Merge imputed Corpland
  left_join(
    df_corpland_final %>% 
      select(brk_a3, year, Corpland) %>%
      rename(ISO3 = brk_a3, Year = year),
    by = c("ISO3", "Year")
  ) %>%
  # Final column order
  select(ISO3, Country, Year, Animal, Corpland)


# --------------------------------------------------------------------
# 7. Export data
# --------------------------------------------------------------------
# Save as CSV
write.csv(df_usage_final, "../output/fill_animal+corp.csv", row.names = FALSE)
