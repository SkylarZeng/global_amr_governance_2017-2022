# Figure 1: NAP Launch Map

This directory contains the analysis code and data for Figure 1.

## Directory Structure

```
Figure_1/
│
├── README.md
│
├── code/
│   └── fig1A_naps_launch_map.R
│
├── data/
│   ├── fig1A.csv
│   └── world-geo-json-zh-2.1.4/
│       ├── demo-echarts.html
│       ├── LICENSE
│       ├── package.json
│       ├── README.md
│       ├── world.zh.json
│       └── world.zh.jsonc
│
└── output/
    └── fig1A.pdf
```

## Required R Packages

```r
library(sf)
library(ggplot2)
library(dplyr)
library(RColorBrewer)
```

## How to Reproduce

Run the analysis script from the `Figure_1/` directory:

```bash
Rscript code/fig1A_naps_launch_map.R
```

The script will generate `output/fig1A.pdf`.

## Methodology Approach

The analysis creates a world map visualization showing the launch periods of National Action Plans (NAPs) for antimicrobial resistance (AMR) across countries. Countries are color-coded by the time period in which they launched their NAP, with different shades of blue representing different periods and gray for countries without a NAP.

## Notes & Requirements

- All scripts use relative paths and should be run from the `Figure_1/` directory
- Output directories are created automatically if they do not exist
- Ensure all required R packages are installed before running the scripts
- Input data files must be present in the `data/` directory
- The script uses GeoJSON data for world map boundaries

## Final Revised Files

**Final revised files:** `fig1A.pdf` is the final revised version for Figure 1 panel A.

## Contact

For questions on code, data, or reproducibility, contact the analysis team or the manuscript corresponding author.

