# Panel Model Selection and Pandemic-Period Robustness Analysis

## Overview

This folder contains code and data for panel model selection and robustness analyses assessing the associations between governance subdomains and antimicrobial resistance (AMR) prevalence improvements. The analysis covers two country groups: (1) early-adopting countries with National Action Plans (NAPs) launched before the Global Action Plan (GAP), and (2) countries with the greatest AMR prevalence improvements.

**Analysis Window:** 2017-2021 (restricted due to data availability)

Although this window captures only the early stage of governance implementation, it provides valuable insight into the mechanisms through which governance translates into AMR improvement.

## Methodology

### 1. Selection of Panel Model

Both fixed effects and random effects models were initially estimated using the `plm` package in R (version 4.3.2). The Hausman test returned p < 0.001, indicating that the fixed effects model is the preferred specification. Consistent results across both models, however, indicate a high degree of robustness in the estimated associations.

**Key Findings:**
- In both model types, subdomain **1.2 Multi-sector engagement** and subdomain **2.1 AMU surveillance system** show significant positive associations with AMR prevalence scores in both country groups (Figure 5 in the manuscript; Figure S17).
- Under the fixed effects specification, subdomain **1.1 Strategic vision** and subdomain **2.2 AMR surveillance system** are also significant, though these associations do not persist under random effects, indicating potential sensitivity to unobserved heterogeneity.
- The random effects model serves as a robustness check, supporting the stability of the core findings.

**Reference:** Figure S17 in the manuscript appendix (pp. 184-185)

### 2. Controlling for Pandemic-Era Confounding (2020-2021)

Given that 2020-2021 encompass the COVID-19 pandemic, which may have influenced AMR surveillance, antimicrobial use, healthcare system strain, and reporting, we employed three complementary strategies to assess robustness:

#### 2.1 Removing the Pandemic Years (2020-2021)

After restricting the study window to 2017-2019, fixed effects models were re-estimated for both country groups.

**Findings:**
- In the 17 early-adopting countries, subdomain **1.1 Strategic vision** (β = 0.14, 95% CI: 0.01-0.27, p<0.05) and subdomain **1.2 Multi-sector engagement** (β = 0.06, 95% CI: 0.01-0.11, p<0.05) remained significant, while other subdomains became non-significant.
- For the 29 high-improvement countries, most associations became statistically non-significant.

**Interpretation:** This attenuation likely reflects the substantial reduction in temporal variation when truncating the dataset to 2017-2019 only (a 40% reduction in the analytic timeframe). Given that governance effects generally require multiple years to materialize, removing two of the five available years may have limited the ability to detect subdomains whose impacts emerge more gradually.

**Reference:** Figure S18 in the manuscript appendix (pp. 186-187)

#### 2.2 Controlling for Pandemic Intensity

To account for pandemic impacts while retaining the full 2017-2021 window, we adjusted for:

**a) Age-standardized COVID-19 death rates (from GBD)**

**Findings:**
- In early-adopting countries, subdomains **1.1 Strategic vision** (β = 0.09, 95% CI: 0.01-0.17, p<0.05), **1.2 Multi-sector engagement** (β = 0.05, 95% CI: 0.02-0.08, p<0.01), **2.1 AMU surveillance** (β = 0.05, 95% CI: 0.03-0.07, p<0.01), and **2.2 AMR surveillance system** (β = 0.06, 95% CI: 0.00-0.11, p<0.05) were all significantly associated with AMR improvement.

**Reference:** Figure S19 in the manuscript appendix (pp. 188-189)

**b) Respiratory infection-related death rates**

We constructed a respiratory infection-related death rates variable by combining age-standardized death rates from COVID-19, upper respiratory infections, and lower respiratory infections (from GBD).

**Findings:**
- Only **1.1 Strategic vision** lost significance in the early-adopting group.
- **1.2 Multi-sector engagement** (β = 0.05, 95% CI: 0.02-0.08, p<0.01) and **2.1 AMU surveillance system** (β = 0.05, 95% CI: 0.03-0.07, p<0.01) remained consistently significant, further supporting the robustness of these two subdomains.

**Reference:** Figure S20 in the manuscript appendix (pp. 189-190)

#### 2.3 Including a Pandemic-Period Dummy Variable

We introduced a COVID-period dummy variable (0 for 2017-2019, 1 for 2020-2021) into the fixed effects models.

**Findings:**
- Relative to the primary results, only **2.2 AMR surveillance system** lost significance in the early-adopting group.
- **1.2 Multi-sector engagement** (β = 0.04, 95% CI: 0.02-0.07, p<0.01) and **2.1 AMU surveillance system** (β = 0.04, 95% CI: 0.02-0.06, p<0.01) remained significant.

**Reference:** Figure S21 in the manuscript appendix (p. 190)

## File Structure

```
.
├── README.md                           # This file
├── code/                               # Analysis scripts
│   ├── Fig5A-covid-death_model.R      # Fig5A: Fixed effects model with COVID-19 death rate
│   ├── Fig5A-covid-forest_visualization.R  # Fig5A: Forest plot for COVID-19 analysis
│   ├── Fig5A-res-death_model.R        # Fig5A: Fixed effects model with respiratory death rate
│   ├── Fig5A-res-forest_visualization.R   # Fig5A: Forest plot for respiratory analysis
│   ├── Fig5B-covid-death_model.R       # Fig5B: Fixed effects model with COVID-19 death rate
│   ├── Fig5B-covid-forest_visualization.R # Fig5B: Forest plot for COVID-19 analysis
│   ├── Fig5B-res-death_model.R        # Fig5B: Fixed effects model with respiratory death rate
│   └── Fig5B-res-forest_visualization.R  # Fig5B: Forest plot for respiratory analysis
├── data/                               # Input data files
│   ├── fig5A_early_adopting_governance.csv  # Fig5A: Early-adopting countries dataset
│   ├── fig5B_class2_29fe_re.csv      # Fig5B: Countries with greatest AMR improvements
│   ├── COVID_deaths.xlsx              # COVID-19 death rates (masked for sensitivity)
│   └── [other data files]
└── output/                             # Generated results
    ├── Fig5A-fixed_model_results-COVID01.csv
    ├── Fig5A-fixed_model_results-COVID01.pdf
    ├── Fig5A-fixed_model_results-respiratory.csv
    ├── Fig5A-fixed_model_results-respiratory.pdf
    ├── Fig5B-fixed_model_results-COVID01.csv
    ├── Fig5B-fixed_model_results-COVID01.pdf
    ├── Fig5B-fixed_model_results-respiratory.csv
    └── Fig5B-fixed_model_results-respiratory.pdf
```

## Data Description

### Input Data Files

1. **fig5A_early_adopting_governance.csv**: Dataset for 17 early-adopting countries with NAPs launched before the GAP
   - Variables include: Country, Country_class, Year, AMR, and 14 governance subdomain scores

2. **fig5B_class2_29fe_re.csv**: Dataset for 29 countries with the greatest AMR prevalence improvements
   - Variables include: Country, Country_class, Year, AMR, and 14 governance subdomain scores

3. **COVID_deaths.xlsx**: Age-standardized COVID-19 death rates from GBD
   - **Note:** Location names and ISO3 codes have been masked with numeric indicators for sensitivity concerns
   - Columns: measure_name, location_name (numeric), ISO3 (numeric), age_name, cause_name, metric_name, year, val, upper, lower

### Governance Subdomains

The analysis examines associations between AMR prevalence and 14 governance subdomains:

**Domain 1: Governance and Coordination**
- 1.1 Strategic vision
- 1.2 Multi-sector engagement
- 1.3 Sustainability
- 1.4 Accountability

**Domain 2: Implementation**
- 2.1 AMC surveillance system
- 2.2 AMR surveillance system
- 2.3 Optimization of antimicrobial use
- 2.4 Professional education
- 2.5 Public awareness
- 2.6 Hygiene and prevention
- 2.7 Research innovation

**Domain 3: Monitoring and Evaluation**
- 3.1 Reporting
- 3.2 Policy adjustment
- 3.3 Effectiveness

## Running the Analysis

### Prerequisites

- R version 4.3.2 or later
- Required R packages:
  - `plm` (panel data models)
  - `tidyverse` (data manipulation)
  - `broom` (model tidying)
  - `readxl` (Excel file reading)
  - `ggplot2` (plotting)
  - `janitor` (data cleaning)
  - `patchwork` (plot composition)

Install packages if needed:
```r
install.packages(c("plm", "tidyverse", "broom", "readxl", "ggplot2", "janitor", "patchwork"))
```

### Analysis Workflow

#### Step 1: Run Model Estimation Scripts

Run the model estimation scripts to generate regression results:

```r
# Fig5A analyses
source("code/Fig5A-covid-death_model.R")      # COVID-19 sensitivity analysis
source("code/Fig5A-res-death_model.R")       # Respiratory infection sensitivity analysis

# Fig5B analyses
source("code/Fig5B-covid-death_model.R")     # COVID-19 sensitivity analysis
source("code/Fig5B-res-death_model.R")        # Respiratory infection sensitivity analysis
```

These scripts will:
- Read the primary datasets from `data/`
- Fit fixed-effects panel models
- Join external death rate data (COVID-19 or respiratory infections)
- Fit sensitivity models including death rate covariates
- Save results as CSV files in `output/`

#### Step 2: Generate Forest Plots

After running the model scripts, generate publication-ready forest plots:

```r
# Fig5A forest plots
source("code/Fig5A-covid-forest_visualization.R")
source("code/Fig5A-res-forest_visualization.R")

# Fig5B forest plots
source("code/Fig5B-covid-forest_visualization.R")
source("code/Fig5B-res-forest_visualization.R")
```

These scripts will:
- Read the model results from `output/`
- Create forest plots with confidence intervals
- Apply color coding for statistical significance (p<0.01: red, p<0.05: blue, not significant: grey)
- Save publication-ready PDF figures in `output/`

### Output Files

Each analysis generates:
- **CSV file**: Regression coefficients, standard errors, t-values, and p-values
- **PDF file**: Forest plot visualization

File naming convention:
- `Fig5A-fixed_model_results-COVID01.csv/pdf`: Fig5A analysis with COVID-19 death rate
- `Fig5A-fixed_model_results-respiratory.csv/pdf`: Fig5A analysis with respiratory death rate
- `Fig5B-fixed_model_results-COVID01.csv/pdf`: Fig5B analysis with COVID-19 death rate
- `Fig5B-fixed_model_results-respiratory.csv/pdf`: Fig5B analysis with respiratory death rate

## Key Results Summary

### Consistent Findings Across Robustness Checks

**Subdomain 1.2 Multi-sector engagement** and **Subdomain 2.1 AMU surveillance system** consistently show significant positive associations with AMR improvement across:
- Main fixed effects models
- Models excluding pandemic years
- Models controlling for COVID-19 burden
- Models controlling for respiratory infection burden
- Models with pandemic-period dummy variable

This robustness across multiple specifications reinforces the foundational role of multi-sector engagement and AMU surveillance in enabling coordinated One Health governance systems.

### Model-Specific Findings

**Fixed Effects Models (Preferred Specification):**
- Additional significant associations: 1.1 Strategic vision, 2.2 AMR surveillance system

**Random Effects Models (Robustness Check):**
- Core findings (1.2 Multi-sector engagement, 2.1 AMU surveillance) remain consistent
- Some associations (1.1 Strategic vision, 2.2 AMR surveillance) do not persist, indicating potential sensitivity to unobserved heterogeneity

## Notes on Data Sensitivity

- **Location masking**: The `COVID_deaths.xlsx` file has been anonymized for sensitivity concerns. Location names and ISO3 codes have been replaced with numeric indicators (1-193) while maintaining the data structure necessary for analysis.

## References

This analysis corresponds to Figures S17-S21 in the manuscript appendix (pp. 182-193), which present:
- **Figure S17**: Random effects model results
- **Figure S18**: Results excluding pandemic years (2017-2019 only)
- **Figure S19**: Results controlling for COVID-19 burden
- **Figure S20**: Results controlling for respiratory infection burden
- **Figure S21**: Results with pandemic-period dummy variable

## Contact

For questions about this analysis, please refer to the main manuscript or contact the corresponding authors.

