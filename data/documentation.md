# Data Documentation

This folder contains **synthetic datasets, metadata files, and data structure examples** used to illustrate the inputs required for the global AMR governance analysis.

## Country Identifier Masking

The governance and AMR datasets used in the study include information from **193 countries**.  
Because country-level governance indicators and associated AMR outcomes may be considered **sensitive information**, **country names are not included** in the example data provided in this repository.

### How countries are represented
- Each country is assigned a **numeric identifier** (e.g., `1`, `2`, `3`, …, `193`).
- These identifiers are **consistent across all synthetic datasets** in this folder.
- No mapping between numeric identifiers and actual country names is provided here.
- This masking follows best practices for sharing structured analytical workflows without exposing sensitive or proprietary data.

### What is included
- Synthetic datasets that mimic the **structure**, **variable types**, and **expected formats** of the real analytical data.
- Metadata describing each variable and its role in the analysis.
- Code for processing, cleaning, and merging these datasets within the analytical workflow.

### What is not included
- Real country names  
- Real indicator values  
- Any raw data obtained from WHO, FAO, WOAH, UNICEF, GBD, or other proprietary or licensed sources  

### Accessing real data
Users wishing to fully reproduce the analysis must obtain the original datasets directly from their respective sources, as described in the main manuscript and the repository's primary README.

### Use of synthetic data
The synthetic datasets are intended to:
- Demonstrate the expected **input structure** for governance indicators and AMR outcomes  
- Enable users to test the **data processing pipeline** and **analytical workflow**  
- Ensure reproducibility without compromising sensitive information  

If additional structured examples or variable dictionaries are needed, please refer to the `docs/` folder for further guidance.

---
