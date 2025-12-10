**Overview**
- **Purpose:**: This folder contains the code, input data, and output graphs used to generate Figure 4 in the project.
- **Primary software:**: Stata (the provided scripts are Stata `.do` files and graphs are Stata `.gph` files).

**Repository Structure**
- **`code/`**: Stata do-files used to run the analyses and produce the figure.
  - `AMR_DID.do` : Main difference-in-differences script for AMR.
  - `AMR_DID_amrgbdAS.do` : Variant analysis for amrgbdAS.
  - `AMR_DID_amrgbdAT.do` : Variant analysis for amrgbdAT.
  - `AMU_DID.do` : Difference-in-differences script for AMU.
- **`data/`**: Input Stata datasets used by the do-files.
  - `treatment_AMR.dta`
  - `treatment_amrgbdAS.dta`
  - `treatment_amrgbdAT.dta`
  - `treatment_AMU.dta`
- **`output/`**: Generated graphs (Stata graph files) and other outputs.
  - `AMR_event_study_combined.gph`
  - `AMR_event_study_combined.png`
  - `AMR_event_study_combined.svg`
  - `amrgbdAS_event_study_combined.gph`
  - `amrgbdAS_event_study_combined.png`
  - `amrgbdAS_event_study_combined.svg`
  - `amrgbdAT_event_study_combined.gph`
  - `amrgbdAT_event_study_combined.png`
  - `amrgbdAT_event_study_combined.svg`
  - `AMU_event_study_combined.gph`
  - `AMU_event_study_combined.png`
  - `AMU_event_study_combined.svg`
  - `fig4A_final.pdf`  (final revised file)
  - `fig4B_final.pdf`  (final revised file)
  - `fig4C_final.pdf`  (final revised file)
  - `fig4D_final.pdf`  (final revised file)

**Reproducing Figure 4**
- **Set working directory:**: In Stata, set the working directory to the `Figure_4` folder. For example:
  - In Stata GUI:
    - `cd "<full/path>/Figure_4"`
  - From a terminal (batch mode), if you have Stata's command-line executable available:
    - `stata -b do "code/AMR_DID.do"`
    - or `stata-mp -b do "code/AMR_DID.do"` (if using Stata MP)
- **Run the do-files:**: Open the `.do` file(s) in Stata and execute them. Typical sequence to reproduce the graphs:
  - `do "code/AMR_DID.do"`  --> produces `output/AMR_event_study_combined.gph`
  - `do "code/AMR_DID_amrgbdAS.do"`  --> produces `output/amrgbdAS_event_study_combined.gph`
  - `do "code/AMR_DID_amrgbdAT.do"`  --> produces `output/amrgbdAT_event_study_combined.gph`
  - `do "code/AMU_DID.do"`  --> produces `output/AMU_event_study_combined.gph`
- **Open produced graphs:**: In Stata use `graph use "output/AMR_event_study_combined.gph"` (replace filename as needed). You can also export to PNG/PDF from Stata using `graph export`.

**Notes & Requirements**
- **Stata version:**: Scripts were developed and tested on `Stata/SE 18.0`.
- **Packages:**: The do-files may depend on user-written packages. Check the top of each `.do` file for `ssc install` or `net install` commands and run them if required.
- **Paths:**: The do-files assume relative paths (e.g., `code/` and `data/`). Ensure Stata's working directory is the `Figure_4` folder or update paths inside the `.do` files.
- **Data use:**: The `data/` folder contains the Stata datasets used to generate the figures. Ensure you have rights to use and share these datasets according to your project's data policy.

**Additional Notes**
- **Final revised files:**: `fig4A_final.pdf`, `fig4B_final.pdf`, `fig4C_final.pdf`, and `fig4D_final.pdf` are the final revised versions for Figure 4 panels A–D.
- **Data masking:**: The `iso3` column in each `.dta` file in the `data/` folder was replaced with random numbers to avoid revealing sensitive country identifiers. The datasets in `data/` therefore contain masked country identifiers and cannot be used to identify countries. Document this masking in any data availability statements or methods descriptions when sharing results.


**Files Produced**
- **Graph files:**: `.gph` files located in `output/` are Stata graph files and can be re-opened in Stata or exported for publication.
- **Intermediate output:**: Any additional tables or temporary files created by the `.do` scripts will be created in the working directory or as specified in the scripts.

# DID Sensitivity and Robustness Analysis — Figure 4

## Supplementary Figures (Figure 4 panels)

This folder contains the Stata code, input data, and generated figures used for event-study Difference-in-Differences (DID) sensitivity and robustness analyses that produce Figure 4 and associated panels.

---

## Folder structure

```
.
├── code/
│   ├── AMR_DID.do
│   ├── AMR_DID_amrgbdAS.do
│   ├── AMR_DID_amrgbdAT.do
│   └── AMU_DID.do
├── data/
│   ├── treatment_AMR.dta
│   ├── treatment_amrgbdAS.dta
│   ├── treatment_amrgbdAT.dta
│   └── treatment_AMU.dta
├── output/
│   └── [Stata graphs & exported figures]
└── README.md
```

## Key files

- `code/`: Stata `.do` files implementing event-study DID estimators and producing the figures in `output/`.
- `data/`: Stata `.dta` datasets used by the `.do` scripts. **Note:** identifiers have been masked (see Data masking).
- `output/`: Saved Stata graphs (`.gph`) and exported images/PDFs used for publication.

## Outcomes and scripts

- **AMR** — Antimicrobial resistance prevalence: `code/AMR_DID.do`
- **AMU** — Antimicrobial use: `code/AMU_DID.do`
- **amrgbdAS** — AMR GBD (acute/subacute): `code/AMR_DID_amrgbdAS.do`
- **amrgbdAT** — AMR GBD (treated): `code/AMR_DID_amrgbdAT.do`

Each script follows the same workflow: data preparation, generation of event-time indicators, three complementary estimators, and combined plotting and export.

---

## Methodological approach

All scripts report three complementary DID estimators for robustness:

- **DID-2S (`did2s`)** — two-stage estimator for staggered adoption (Gardner, 2021).
- **Stacked event-study (`stackedev`)** — cohort stacking approach (Cengiz et al., 2019).
- **Traditional TWFE OLS (`reghdfe`)** — two-way fixed effects with cluster-robust standard errors.

Outputs for each method (coefficient matrices and variance matrices) are combined into a single event-study visualization and exported for publication.

---

## Data requirements and structure

Each `.dta` file should contain at least:
- `i`: unit identifier (country/region; note masked in distributed datasets)
- `t`: time period (year)
- `D`: treatment indicator (binary)
- outcome variable (scripts rename it to `Y` at start)
- covariates as required by specification (e.g., `X1`..`X10`)
- `treat_year` or `Ei` (cohort adoption year) where applicable

### Data masking

To protect sensitive identifiers, the `iso3` column in every `.dta` file under `data/` has been replaced with random numeric identifiers. The datasets therefore do not contain real country codes. Document this masking in any data availability or methods statements accompanying results.

---

## Output files (present in `output/`)

Typical outputs produced by the scripts (existing files at time of editing):
- `AMR_event_study_combined.gph`, `AMR_event_study_combined.png`, `AMR_event_study_combined.svg`
- `amrgbdAS_event_study_combined.gph`, `amrgbdAS_event_study_combined.png`, `amrgbdAS_event_study_combined.svg`
- `amrgbdAT_event_study_combined.gph`, `amrgbdAT_event_study_combined.png`, `amrgbdAT_event_study_combined.svg`
- `AMU_event_study_combined.gph`, `AMU_event_study_combined.png`, `AMU_event_study_combined.svg`
- `fig4A_final.pdf`  (final revised file)
- `fig4B_final.pdf`  (final revised file)
- `fig4C_final.pdf`  (final revised file)
- `fig4D_final.pdf`  (final revised file)

The `fig4*_final.pdf` files are the final revised publication-ready panels for Figure 4 (A–D).

---

## Software requirements

- **Stata:** tested on `Stata/SE 18.0`.
- **Packages used (install if needed):** `reghdfe`, `did2s`, `stackedev`, `event_plot`.

Install in Stata:
```stata
ssc install reghdfe, replace
ssc install did2s, replace
ssc install stackedev, replace
ssc install event_plot, replace
```

---

## Reproducing the results

From within Stata set the working directory to this folder and run the `.do` scripts. Example:

```stata
cd "/Users/skylar/Desktop/GOHIAMR/Data & code availability/Figure_4"
do code/AMR_DID.do
```

To run all scripts in sequence:

```stata
do code/AMR_DID.do
do code/AMR_DID_amrgbdAS.do
do code/AMR_DID_amrgbdAT.do
do code/AMU_DID.do
```

Notes:
- Ensure `data/` contains the expected `.dta` files. Update relative paths in `.do` files if your directory differs.

---

## Reporting guidance

- Present event-time coefficients with 95% confidence intervals for all three methods.
- Inspect pre-treatment leads for evidence of parallel trends; leads should be statistically insignificant.
- Report robustness checks (COVID-only, exclude 2020–2021, narrower windows) where applicable.

---

## Contact

For questions on code, data, or reproducibility, contact the analysis team or the manuscript corresponding author.