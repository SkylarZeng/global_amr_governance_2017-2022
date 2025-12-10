# ==============================================================================
# Trajectory Analysis Using Latent Class Growth Modeling (LCGM)
# ==============================================================================
# 
# This script performs latent class growth modeling (LCGM) to identify distinct
# trajectory classes in longitudinal data. The analysis fits multiple models
# with varying numbers of latent classes and compares them using information
# criteria (AIC, BIC) to select the optimal model.
#
# Input:  Longitudinal data with columns: id, Year, Value
# Output: Data with trajectory class assignments and visualization
#
# ==============================================================================

# Load required packages
library(lcmm)
library(ggplot2)

# ==============================================================================
# Configuration
# ==============================================================================

# Define input and output file paths
data_file <- "data/trajectory_AMRp_class.csv"
output_file <- "output/trajectory_AMRp3_class.csv"

# ==============================================================================
# Data Import
# ==============================================================================

# Read input data (expects columns: id, Year, Value)
data <- read.csv(data_file, stringsAsFactors = FALSE)

# ==============================================================================
# Model Fitting: Latent Class Growth Models (1-7 classes)
# ==============================================================================

# Fit base model (single class, no mixture)
model1 <- hlme(Value ~ Year, subject = "id", ng = 1, data = data)

# Fit mixture models with 2-7 latent classes
# Note: Models are initialized using the base model (B = model1) for stability
model2 <- hlme(Value ~ Year, mixture = ~ Year, subject = "id", ng = 2, 
               data = data, B = model1)
model3 <- hlme(Value ~ Year, mixture = ~ Year, subject = "id", ng = 3, 
               data = data, B = model1)
model4 <- hlme(Value ~ Year, mixture = ~ Year, subject = "id", ng = 4, 
               data = data, B = model1)
model5 <- hlme(Value ~ Year, mixture = ~ Year, subject = "id", ng = 5, 
               data = data, B = model1)
model6 <- hlme(Value ~ Year, mixture = ~ Year, subject = "id", ng = 6, 
               data = data, B = model1)
model7 <- hlme(Value ~ Year, mixture = ~ Year, subject = "id", ng = 7, 
               data = data, B = model1)

# ==============================================================================
# Model Comparison
# ==============================================================================

# Compare models using AIC, BIC, and class proportions
# Lower AIC and BIC values indicate better model fit
summarytable(
  model1, model2, model3, model4, model5, model6, model7,
  which = c("AIC", "BIC", "%class")
)

# ==============================================================================
# Extract Trajectory Class Assignments
# ==============================================================================

# Select best model based on information criteria and interpretability
# Note: Model selection should be based on the summary table output above
best_model <- model3

# Extract trajectory class assignments for each subject
# pprob contains posterior probabilities and class assignments
traj_class_df <- data.frame(
  id = best_model$pprob$id,
  traj_class = best_model$pprob$class
)

# Merge trajectory class assignments into original dataset
data <- merge(data, traj_class_df, by = "id")

# ==============================================================================
# Visualization
# ==============================================================================

# Create trajectory plot showing:
# - Individual trajectories (semi-transparent lines)
# - Mean trajectory for each class (bold lines)
p <- ggplot(data, aes(x = Year, y = Value, group = id, 
                      color = as.factor(traj_class))) +
  geom_line(alpha = 0.3) +
  stat_summary(aes(group = traj_class), fun = mean, geom = "line", 
               size = 1.5) +
  labs(
    x = "Year",
    y = "Value",
    color = "Trajectory Class"
  ) +
  theme_minimal()

print(p)

# ==============================================================================
# Export Results
# ==============================================================================

# Create output directory if it does not exist
dir.create(dirname(output_file), recursive = TRUE, showWarnings = FALSE)

# Write output: original data with trajectory class assignments
write.csv(data, output_file, row.names = FALSE)
cat("Trajectory-classified data written to:", output_file, "\n")

