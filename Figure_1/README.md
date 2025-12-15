# Figure 1A: NAP Launch Map

This directory contains the analysis code and data for Figure 1 panel A.

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
│   └── worldmap_gs_2021_648/
│       ├── Worldmap_GS_2021_648.shp
│       ├── Worldmap_GS_2021_648.dbf
│       ├── Worldmap_GS_2021_648.shx
│       ├── Worldmap_GS_2021_648.prj
│       ├── Worldmap_GS_2021_648.cpg
│       ├── Worldmap_GS_2021_648_boundaries.shp
│       ├── Worldmap_GS_2021_648_boundaries.dbf
│       ├── Worldmap_GS_2021_648_boundaries.shx
│       ├── Worldmap_GS_2021_648_boundaries.prj
│       └── Worldmap_GS_2021_648_boundaries.cpg
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

Run the analysis script from the `Figure_1/code/` directory (the script uses paths relative to `code/`):

```bash
cd code
Rscript fig1A_naps_launch_map.R
```

The script will generate `output/fig1A.pdf`.

## Methodology Approach

The analysis creates a world map visualization showing the launch periods of National Action Plans (NAPs) for antimicrobial resistance (AMR) across countries. Countries are color-coded by the time period in which they launched their NAP, with gray for countries without a NAP.

## Notes & Requirements

- Input data are `data/fig1A.csv` (NAP year/period by ISO3 code) and the basemap shapefiles under `data/worldmap_gs_2021_648/`.
- A small ISO3 harmonization is applied for basemap compatibility (`ROU→ROM`, `TLS→TMP`).
- The script draws an additional boundaries overlay and crops map bounds to `xmin=-180, ymin=-60, xmax=180, ymax=90`.

## Final Revised Files

**Final revised files:** `output/fig1A.pdf` is the final revised version for Figure 1 panel A.

## Contact

For questions on code, data, or reproducibility, contact the analysis team or the manuscript corresponding author.

