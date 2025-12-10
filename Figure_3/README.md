# Figure 3: Regional Analysis

This directory contains the analysis code and data for Figure 3.

## Directory Structure

```
Figure_3/
│
├── README.md
│
├── code/
│   ├── fig3A.R
│   └── fig3B.R
│
├── data/
│   ├── fig3A.csv
│   └── fig3B.csv
│
└── output/
    ├── fig3A.pdf
    └── fig3B.pdf
```

## Required R Packages

```r
library(ggplot2)
library(dplyr)
library(readr)
library(RColorBrewer)
```

## How to Reproduce

Run the analysis scripts from the `Figure_3/` directory:

```bash
# Generate both panels
Rscript code/fig3A.R
Rscript code/fig3B.R
```

The scripts will generate the corresponding PDF files in the `output/` directory:
- `fig3A.pdf` - Panel A visualization
- `fig3B.pdf` - Panel B visualization

## Methodology Approach

The analysis presents regional-level visualizations of AMR governance indicators across WHO regions, showing temporal trends and regional comparisons.

## Notes & Requirements

- All scripts use relative paths and should be run from the `Figure_3/` directory
- Output directories are created automatically if they do not exist
- Ensure all required R packages are installed before running the scripts
- Input data files must be present in the `data/` directory

## Final Revised Files

**Final revised files:** `fig3A.pdf` and `fig3B.pdf` are the final revised versions for Figure 3 panels A and B.

## Contact

For questions on code, data, or reproducibility, contact the analysis team or the manuscript corresponding author.

