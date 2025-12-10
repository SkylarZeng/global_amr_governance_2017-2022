"""
# Fig5-B-FDR.R
# Purpose: Fit a fixed-effects model, compute cluster-robust standard errors,
# and apply multiple-comparison corrections (BH-FDR and Holm) for a predefined
# family of governance predictors. Designed to use relative `data/` and
# `output/` directories for portability when uploaded to a repository.
# Usage: set `data_file` and `output_prefix` below, then run the script.
"""

library(plm)
library(sandwich)
library(lmtest)
library(dplyr)
library(broom)

# --- Configurable paths (relative to repository root) ---
data_file <- "data/fig5B_class2_29fe_re.csv"   # update if your filename differs
output_prefix <- "output/Fig5B"

# Read data
df <- read.csv(data_file)

# Fit a fixed-effects model (within estimator)
fixed_model <- plm(
  AMR ~ Strategic_vision + Multi_sector_engagement + Sustainability + Accountability +
    AMC_surveillance_system + AMR_surveillance_system + Optimization_antimicrobial +
    Professional_education + Public_awareness + Hygiene_prevention + Research_innovation +
    Reporting + Policy_adjustment + Effectiveness,
  data = df,
  index = c("Country_class", "Year"),
  model = "within"
)

summary(fixed_model)

# Compute cluster-robust (by group) variance-covariance and t-tests
vcov_cl_country <- vcovHC(fixed_model, type = "HC1", method = "arellano", cluster = "group")
fe_coeftest <- coeftest(fixed_model, vcov = vcov_cl_country)

# Collect coefficients into a data.frame
res_df <- data.frame(
  term = rownames(fe_coeftest),
  estimate = fe_coeftest[, "Estimate"],
  std_error = fe_coeftest[, "Std. Error"],
  statistic = fe_coeftest[, "t value"],
  p_value = fe_coeftest[, "Pr(>|t|)"],
  row.names = NULL,
  stringsAsFactors = FALSE
)

# Define family of governance predictors to correct together
family_terms <- c(
  "Strategic_vision",
  "Multi_sector_engagement", "Sustainability", "Accountability",
  "AMC_surveillance_system", "AMR_surveillance_system",
  "Optimization_antimicrobial", "Professional_education",
  "Public_awareness", "Hygiene_prevention", "Research_innovation",
  "Reporting", "Policy_adjustment", "Effectiveness"
)

# Subset results for family and apply corrections
fam_df <- res_df %>% filter(term %in% family_terms) %>%
  mutate(
    q_BH = p.adjust(p_value, method = "BH"),    # Benjamini-Hochberg FDR
    p_Holm = p.adjust(p_value, method = "holm")  # Holm (FWER)
  )

# Merge corrected values back into the full result table
out_df <- res_df %>%
  left_join(fam_df %>% select(term, q_BH, p_Holm), by = "term") %>%
  mutate(
    conf_low = estimate - 1.96 * std_error,
    conf_high = estimate + 1.96 * std_error,
    order_key = match(term, family_terms)
  ) %>%
  arrange(is.na(order_key), order_key)

# Write full table to CSV in `output/`
dir.create(dirname(paste0(output_prefix, "-fixed_model_results.csv")), showWarnings = FALSE, recursive = TRUE)
write.csv(out_df, paste0(output_prefix, "-fixed_model_results.csv"), row.names = FALSE)

# Prepare a publication-style table for the family predictors
report_family_pretty <- out_df %>%
  filter(term %in% family_terms) %>%
  mutate(
    beta_ci = sprintf("%.3f (%.3f, %.3f)", estimate, conf_low, conf_high),
    p_value_raw = signif(p_value, 3),
    q_BH = signif(q_BH, 3),
    p_Holm = signif(p_Holm, 3)
  ) %>%
  select(Predictor = term, `Beta (95% CI)` = beta_ci, `Robust SE` = std_error,
         `P (raw)` = p_value_raw, `Q (BH-FDR)` = q_BH, `P (Holm)` = p_Holm)

write.csv(report_family_pretty, paste0(output_prefix, "-family_pretty.csv"), row.names = FALSE)

print(report_family_pretty)

