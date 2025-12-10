# Figure 5: Trajectory Analysis and Governance Association Models

This directory contains the analysis code and data for Figure 5.

## Directory Structure

```
Figure_5/
│
├── README.md
│
├── code/
│   ├── analyze_trajectory_latent_class_growth_modeling.R
│   ├── Fig5-A-FDR.R
│   ├── Fig5-B-FDR.R
│   ├── plot_Fig5A_forest.R
│   └── plot_Fig5B_forest.R
│
├── data/
│   ├── fig5A_early_adopting_governance.csv
│   ├── fig5B_class2_29fe_re.csv
│   ├── fig5B_class3_99bad_moderate_fe_re.csv
│   ├── fig5B_traj_class1_65moderate_fe_re.csv
│   └── trajectory_deltaAMR.csv
│
└── output/
    ├── Fig5A-fixed_model_results.csv
    ├── Fig5A-fixed_model_results.pdf
    ├── Fig5A_forest.pdf
    ├── Fig5B-fixed_model_results.csv
    ├── Fig5B-fixed_model_results.pdf
    ├── Fig5B_forest.pdf
    ├── Fig5AB_final.pdf
    └── trajectory_deltaAMR_model3_class.csv
```

## Required R Packages

```r
library(lcmm)
library(plm)
library(sandwich)
library(lmtest)
library(ggplot2)
library(dplyr)
library(broom)
library(readr)
library(janitor)
library(patchwork)
library(stringr)
```

## How to Reproduce

Run the analysis scripts in the following order:

```bash
# 1. Trajectory class modeling
Rscript code/analyze_trajectory_latent_class_growth_modeling.R

# 2. Model calculations
Rscript code/Fig5-A-FDR.R
Rscript code/Fig5-B-FDR.R

# 3. Visualizations
Rscript code/plot_Fig5A_forest.R
Rscript code/plot_Fig5B_forest.R
```

All scripts should be run from the `Figure_5/` directory. Output files will be generated in the `output/` directory.

## Methodology Approach

The analysis consists of three main components:

1. **Trajectory Class Modeling**: Latent class growth modeling (LCGM) is used to identify distinct AMR trajectory patterns across countries. Models with varying numbers of latent classes are compared using information criteria.

2. **Fixed-Effects Regression**: Panel data regression models with fixed effects are estimated to examine associations between governance indicators and AMR outcomes. Cluster-robust standard errors are computed, and multiple comparison corrections are applied.

3. **Visualization**: Forest plots are generated to visualize effect estimates with confidence intervals, color-coded by statistical significance.

## Notes & Requirements

- All scripts use relative paths and should be run from the `Figure_5/` directory
- Output directories are created automatically if they do not exist
- Ensure all required R packages are installed before running the scripts
- Input data files must be present in the `data/` directory
- Model selection in trajectory analysis should be based on information criteria and interpretability

## Reporting Guidance

- Present event-time coefficients with 95% confidence intervals for all three methods.

- Inspect pre-treatment leads for evidence of parallel trends; leads should be statistically insignificant.

- Report robustness checks (COVID-only, exclude 2020–2021, narrower windows) where applicable.

## Final Revised Files

**Final revised files:** `Fig5AB_final.pdf` is the final revised version for Figure 5 panels A and B.

## Data Masking

**Data masking:** The `iso3` and `country` columns in each `.dta` file in the `data/` folder were replaced with random numbers to avoid revealing sensitive country identifiers. The datasets in `data/` therefore contain masked country identifiers and cannot be used to identify countries. Document this masking in any data availability statements or methods descriptions when sharing results.

## Contact

For questions on code, data, or reproducibility, contact the analysis team or the manuscript corresponding author.

