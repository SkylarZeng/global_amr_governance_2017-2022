# **Figure 4 - DID Analysis**
- **Purpose:** This folder contains the code, input data, and output graphs used to generate Figure 4 in the project.
- **Primary software:** Stata (the provided scripts are Stata `.do` files and graphs are Stata `.gph` files).

---

## Directory Structure

```
Figure_4/
│
├── README.md
│
├── code/
│   ├── AMR_DID.do
│   ├── AMR_DID_amrgbdAS.do
│   ├── AMR_DID_amrgbdAT.do
│   └── AMU_DID.do
│
├── data/
│   ├── treatment_AMR.dta
│   ├── treatment_amrgbdAS.dta
│   ├── treatment_amrgbdAT.dta
│   └── treatment_AMU.dta
│
└── output/
    ├── AMR_event_study_combined.gph
    ├── AMR_event_study_combined.png
    ├── AMR_event_study_combined.svg
    ├── amrgbdAS_event_study_combined.gph
    ├── amrgbdAS_event_study_combined.png
    ├── amrgbdAS_event_study_combined.svg
    ├── amrgbdAT_event_study_combined.gph
    ├── amrgbdAT_event_study_combined.png
    ├── amrgbdAT_event_study_combined.svg
    ├── AMU_event_study_combined.gph
    ├── AMU_event_study_combined.png
    ├── AMU_event_study_combined.svg
    ├── fig4A_final.pdf
    ├── fig4B_final.pdf
    ├── fig4C_final.pdf
    └── fig4D_final.pdf
```
---

## **Reproducing Figure 4**
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

## **Notes & Requirements**
- **Stata version:**: Scripts were developed and tested on `Stata/SE 18.0`.
- **Packages:**: The do-files may depend on user-written packages. Check the top of each `.do` file for `ssc install` or `net install` commands and run them if required.
- **Paths:**: The do-files assume relative paths (e.g., `code/` and `data/`). Ensure Stata's working directory is the `Figure_4` folder or update paths inside the `.do` files.
- **Data use:**: The `data/` folder contains the Stata datasets used to generate the figures. 

## **Additional Notes**
- **Final revised files:**: `fig4A_final.pdf`, `fig4B_final.pdf`, `fig4C_final.pdf`, and `fig4D_final.pdf` are the final revised versions for Figure 4 panels A–D.
- **Data masking:**: The `iso3` column in each `.dta` file in the `data/` folder was replaced with random numbers to avoid revealing sensitive country identifiers. The datasets in `data/` therefore contain masked country identifiers and cannot be used to identify countries. 


## **Files Produced**
- **Graph files:**: `.gph` files located in `output/` are Stata graph files and can be re-opened in Stata or exported for publication.
- **Intermediate output:**: Any additional tables or temporary files created by the `.do` scripts will be created in the working directory or as specified in the scripts.


## Reporting guidance

- Present event-time coefficients with 95% confidence intervals for all three methods.
- Inspect pre-treatment leads for evidence of parallel trends; leads should be statistically insignificant.
- Report robustness checks (COVID-only models, exclusion of 2020–2021, and restricted temporal windows) as shown in the Supplementary Information.

---

## Contact

For questions on code, data, or reproducibility, contact the analysis team or the manuscript corresponding author.
