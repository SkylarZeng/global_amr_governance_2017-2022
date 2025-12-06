# Global AMR Governance Analysis
A Reproducible Framework for Evaluating National AMR Action Plans and Governance Performance (2017–2022)

**Study on global antimicrobial resistance (AMR) governance across 193 countries, integrating policy documents, WHO monitoring systems, agricultural inputs, and AMR burden data to evaluate governance effectiveness and associated health outcomes.**

---

# Main Findings
- Developed a multidimensional **AMR Governance Index** capturing policy design, implementation tools, monitoring capacity, and multisector coordination.
- Evaluated the **impact of national AMR action plans (NAPs)** on antimicrobial resistance trends using difference-in-differences and joinpoint methods.
- Quantified how **governance improvements** relate to changes in AMU, AMR prevalence, and AMR-attributable mortality.
- Introduced a reproducible computational workflow integrating policy analytics, surveillance datasets, and epidemiological models.

---

# Updates
**Dec 2025:** Repository structure finalized; synthetic data examples added for reproducibility.  
**Nov 2025:** Statistical workflow (DID, joinpoint, panel models) implemented and tested.  
**Oct 2025:** Governance index construction scripts completed (AHP + entropy integration).  
**Sep 2025:** Initial repository created for global AMR governance project.  

---

# Reproducing Results

This repository contains the full analytical workflow used to evaluate AMR governance performance across countries.  
Folders:

### `data/`
- Synthetic datasets illustrating required structures for governance indicators, AMR outcomes, and covariates.  
- Metadata describing all publicly available data sources (TrACSS, GLASS, FAOSTAT, WOAH, UNICEF, GBD AMR).  
- No proprietary or restricted data included.

### `code/`
- Scripts for:
  - Governance index construction  
  - Delphi–AHP and entropy weighting  
  - Difference-in-differences and event-study estimation  
  - Joinpoint analysis  
  - Panel regression models  
- Modular functions for input processing and reproducibility.

### `results/`
- Optional output files, figures, and intermediate analytical objects.

### `docs/`
- Conceptual overview, indicator definitions, methodological notes.

---

### Workflow Scripts
Representative scripts include:

- `governance_index.R` — Processes indicators and constructs sectoral + composite indices  
- `ahp_entropy_weighting.R` — Implements hybrid weighting framework  
- `did_eventstudy.do` / `.R` — Policy timing harmonization, TWFE DID, and event-study models  
- `joinpoint_analysis.R` — Identifies temporal inflection points in AMR trends  
- `panel_models.R` — ΔAMR construction and fixed-effects regression models  

---
## Environment

All analyses in this study were performed using a reproducible computational environment integrating R, Python, and Stata. The repository includes environment files (e.g., `environment.yml`, `requirements.txt`, and session information) to facilitate replication.

### Software
- **R (≥ 4.2)**  
  Used for governance index construction, indicator standardization, weighting integration (Delphi, AHP, entropy), longitudinal trend analysis, and visualization.
- **Stata (≥ 17)**  
  Used for difference-in-differences (DID), stacked event-study models, two-stage DID, fixed-effects panel analyses, and robustness checks.
- **Python (≥ 3.9)**  
  Used for Delphi sensitivity analyses, non-parametric subgroup testing, and selected data-processing tasks.

### Key R Packages
- `tidyverse` (data wrangling and visualization)  
- `data.table` (large-scale panel data processing)  
- `readxl` / `openxlsx` (importing structured indicator sources)  
- `ggplot2` / `patchwork` (figures and composites)  
- `survey` (indicator weighting procedures)  
- `fixest` (panel models and clustered inference)  
- `segmented` or `Joinpoint` (joinpoint trend estimation)

### Key Stata Packages
- `reghdfe` (high-dimensional fixed-effects modeling)  
- `eventstudyinteract` (stacked event-study estimators)  
- `did_imputation` (two-stage DID)  
- `estout` (results export)

### Key Python Packages
- `pandas` (data manipulation)  
- `numpy` (array computation)  
- `scipy` (non-parametric tests)  
- `statsmodels` (supporting statistics where applicable)

### Hardware
Most analyses were conducted on standard academic computing environments. No GPU or high-performance computing resources are required for replication.

### Reproducibility
Environment files defining exact package versions are included:

- `environment.yml` — Conda environment for Python and R components  
- `requirements.txt` — Python dependencies  
- `sessionInfo_R.txt` — versioned R package list  
- `stata_do_files/` — all Stata code for DID analyses with notes on reproducibility  

Users can recreate the environment with:

```bash
conda env create -f environment.yml
conda activate amr-governance
```

---
# Citation

If you use this repository, please cite our study:

Chen W, Zeng Y, Zheng J, Wang J, Gu W, Li M, et al.  
**Informing the 2026 update of the Global Action Plan on antimicrobial resistance: a longitudinal evaluation of governance across 193 countries.**  
Manuscript under review, 2025.

If you use this repository, please cite the associated study (details added after publication).  
A placeholder BibTeX entry is provided:
```
@article{chen2025amrgovernance,
  title={Informing the 2026 update of the Global Action Plan on antimicrobial resistance: a longitudinal evaluation of governance across 193 countries},
  author={Chen, Weiye and Zeng, Yige and Zheng, Jinxin and others},
  year={2025},
  note={Manuscript under review}
}
```
