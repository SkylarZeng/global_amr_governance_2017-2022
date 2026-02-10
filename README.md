# Global AMR Governance Analysis
A Reproducible Framework for Evaluating National AMR Action Plans and Governance Performance (2017–2022)

**Study on global antimicrobial resistance (AMR) governance across 193 countries, integrating policy documents, WHO monitoring systems, agricultural inputs, and AMR burden data to evaluate governance effectiveness and associated health outcomes.**

---

## Main Findings
- Developed a multidimensional **AMR Governance Index** capturing policy design, implementation tools, monitoring capacity, and multisector coordination.
- Evaluated the **impact of national AMR action plans (NAPs)** on antimicrobial resistance trends using difference-in-differences and joinpoint methods.
- Quantified how **governance improvements** relate to changes in AMU, AMR prevalence, and AMR-attributable mortality.
- Introduced a reproducible computational workflow integrating policy analytics, surveillance datasets, and epidemiological models.

---

## Repository Structure

This repository contains the full analytical workflow organized by figure/analysis:

```
global_amr_governance_2017-2022/
├── LICENSE
├── README.md
│
├── Figure_1/                    # NAP launch map visualization
├── Figure_2/                    # Governance heatmaps and trend analyses
├── Figure_3/                    # Regional trends in AMU and AMR prevalence scores, 2000–2021
├── Figure_4/                    # Difference-in-differences event studies
├── Figure_5/                    # Trajectory and latent class growth modeling
│
└── Supplementary/               # Supplementary analyses and sensitivity/robustness test
    ├── data_imputation/
    ├── DID_sensitivity_robustness_test/
    └── panel_model_selection_and_pandemic-perid_robustness_analysis/
```

Each folder contains its own `README.md` with detailed information about code, data, and reproduction instructions.

---

## Environment

All analyses were performed using R, Python, and Stata. Required software versions:
- **R (≥ 4.2)**
- **Stata (≥ 17)**
- **Python (≥ 3.9)**

Environment files are included for reproducibility:
- `environment.yml` — Conda environment
- `requirements.txt` — Python dependencies
- `sessionInfo_R.txt` — R package versions

Recreate the environment:
```bash
conda env create -f environment.yml
conda activate amr-governance
```

---

## Citation

If you use this repository, please cite our study:

Chen W, Zeng Y, Zheng J, Wang J, Gu W, Li M, et al.  
**Informing the 2026 update of the Global Action Plan on antimicrobial resistance: a longitudinal evaluation of governance across 193 countries.**  
Manuscript under revision, 2025.

If you use this repository, please cite the associated study (details added after publication).  
A placeholder BibTeX entry is provided:
```
@article{chen2026amrgovernance,
  title={Evaluation of antimicrobial resistance governance across 193 countries to inform the 2026 Global Action Plan update},
  author={Chen, Weiye and Zeng, Yige and Zheng, Jinxin and Wang, Jing and Gu, Wei and Li, Min and Cheng, Zile and Qian, Jing and Zhang, Xiaoxi and Kabali, Emmanuel and Lv, Chao and Chen, Yiwen and Yang, Guangrui and Zhou, Nan and Tan, Xiao and Zhu, Chendi and Tun, Hein Min and Gilani, Mashkoor Mohsin and Rahman, Tanvir and Zhou, Zhemin and Xiao, Yonghong and Chen, Hong and Shi, Chunlei and Bergquist, Robert and Fitzgerald, J. Ross and Chen, Sheng and Chang, Yunfu and Wang, Zhaojun and Zhou, Xiaonong and Guo, Xiaokui and Utzinger, Jürg and Song, Junxia and Zhu, Yongzhang},
  year={2026},
  note={Manuscript accepted. Please update with journal details once published.}
}
```
---

## Contact

Questions related to data, code, or reproducibility may be directed to the contributors of this repository.

For inquiries regarding the study design, analytical framework, or interpretation of results, please contact the corresponding authors as listed in the manuscript.
