# Figure 2: Governance Heatmap and Trends

This directory contains the analysis code and data for Figure 2.

## Directory Structure

```
Figure_2/
│
├── README.md
│
├── code/
│   ├── fig2A_heatmap_governance.R
│   ├── fig2B_domain_trends.R
│   ├── fig2C_region_overall_trends.R
│   └── fig2D_region_subdomain_trends.R
│
├── data/
│   ├── fig2A.csv
│   ├── fig2B.csv
│   ├── fig2C.csv
│   └── fig2D.csv
│
└── output/
    ├── fig2A.pdf
    ├── fig2B.pdf
    ├── fig2C.pdf
    └── fig2D.pdf
```

## Required R Packages

```r
library(ggplot2)
library(dplyr)
library(readr)
library(RColorBrewer)
```

## How to Reproduce

Run the analysis scripts from the `Figure_2/` directory:

```bash
# Generate all panels
Rscript code/fig2A_heatmap_governance.R
Rscript code/fig2B_domain_trends.R
Rscript code/fig2C_region_overall_trends.R
Rscript code/fig2D_region_subdomain_trends.R
```

The scripts will generate the corresponding PDF files in the `output/` directory:
- `fig2A.pdf` - Governance heatmap
- `fig2B.pdf` - Domain trends
- `fig2C.pdf` - Regional overall trends
- `fig2D.pdf` - Regional subdomain trends

## Methodology Approach

The analysis consists of four main visualizations:

1. **Panel A (Heatmap)**: Displays governance scores across subdomains and years using a color gradient heatmap
2. **Panel B (Domain Trends)**: Shows temporal trends in governance scores across different domains
3. **Panel C (Region Overall Trends)**: Presents overall governance trends by WHO region
4. **Panel D (Region Subdomain Trends)**: Displays subdomain-specific trends by WHO region

## Notes & Requirements

- All scripts use relative paths and should be run from the `Figure_2/` directory
- Output directories are created automatically if they do not exist
- Ensure all required R packages are installed before running the scripts
- Input data files must be present in the `data/` directory

## Final Revised Files

**Final revised files:** `fig2A.pdf`, `fig2B.pdf`, `fig2C.pdf`, and `fig2D.pdf` are the final revised versions for Figure 2 panels A–D.

## Contact

For questions on code, data, or reproducibility, contact the analysis team or the manuscript corresponding author.

