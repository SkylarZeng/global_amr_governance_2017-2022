* ------------------------------------------------------------
* Title: AMR event-study (AMR_DID_amrgbdAS.do)
* Purpose: Estimate event-study coefficients using DID-2S,
*          stacked DiD (stackedev), and TWFE OLS for the
*          amrgbdAS specification.
* Author: Skylar (Yige) Zeng
* Data: treatment_amrgbdAS.dta
* Output: AMR/amrgbdAS event-study graphs
* Stata: Stata/SE 18.0
* References: Gardner (2021); Cengiz et al. (2019)
* ------------------------------------------------------------

* Install required user-written packages (uncomment to install)
* ssc install did_imputation, replace
* ssc install reghdfe, replace
* ssc install avar, replace
* ssc install stackedev, replace
* ssc install blindschemes, replace
* ssc install ftools, replace
* ssc install did2s, replace
* ssc install event_plot, replace
* ssc install did_multiplegt, replace
* ssc install csdid, replace
* ssc install eventstudyinteract, replace
* ssc install did_multiplegt_dyn, replace
* ssc install gtools, replace
* ssc install drdid, replace

* AMR (amrgbdAS) analysis
use "treatment_amrgbdAS.dta", clear
rename amr Y

* Generate the first treatment year (Ei)
gen Ei = .
bysort i (t): replace Ei = t if D == 1 & missing(Ei)  // First treatment year
gen first_Ei = .
bysort i (Ei): replace first_Ei = Ei if _n == 1
bysort i (t): replace first_Ei = first_Ei[_n-1] if missing(first_Ei)
bysort i (t): replace first_Ei = first_Ei[_N] if missing(first_Ei)
replace Ei = first_Ei
drop first_Ei
* Generate relative time (K) since treatment
gen K = t - Ei  // Number of periods since treated
replace K = . if missing(Ei)  // Set K to missing for never-treated units
tabulate K // Check the distribution of K
* Generate recategorized Kc_8 (-11 to 8)
gen Kc_8 = K if !missing(K)
replace Kc_8 = 8 if K > 8 & !missing(K)
replace Kc_8 = -11 if K < -11 & !missing(K)
tabulate Kc_8 // Check distribution of Kc_8
* Calculate pre-treatment mean for each unit
egen pre_treatment_mean = mean(Y) if t < Ei, by(i)
bysort i (t): replace pre_treatment_mean = pre_treatment_mean[_n-1] if missing(pre_treatment_mean)
* Create `tau` based on the treatment indicator
gen tau = Y - pre_treatment_mean if D == 1
* Generate error term
reg Y D i.t, cluster(i)
predict fitted_values
gen eps = Y- fitted_values
* Verify the generated variables
list i t Y Ei K D
* Adjust First Treatment Year (Ei) Accordingly
gen Ei_adj = t - Kc_8 if !missing(Ei)

*Preparation
sum Ei_adj
gen lastcohort = Ei_adj==r(max) // dummy for the latest- or never-treated cohort
forvalues l = 0/8 {
	gen L`l'event = Kc_8==`l'
	}
	forvalues l = 1/11 {
		gen F`l'event = Kc_8==-`l'
		}

// DID-2S estimation (Gardner 2021)
* Estimation
did2s Y, first_stage(i.i i.t) second_stage(F*event L*event) treatment(D) cluster(i)
// Y: outcome variable
// first_stage(): fixed effects used to estimate counterfactual Y_it(0). This should be everything besides treatment
// second_stage(): treatment such as dummy variable or event-study leads and lags
// cluster(): variable to cluster on 	
*Plotting
event_plot, default_look stub_lag(L#event) stub_lead(F#event) together graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") xlabel(-11(1)8) title("Gardner (2021)") name(DID2S, replace))		
*Saving estimates for later
matrix did2s_b = e(b)
matrix did2s_v = e(V)

// stacked DiD estimation (Cengiz et al. 2019)
*Create a variable equal to the time that the unit first received treatment. It must be missing for never treated units.
gen treat_year=.
replace treat_year=Ei if Ei!=2022

*Create never treated indicator that equals one if a unit never received treatment and zero if it did.
gen no_treat = 0
bysort i (t): replace no_treat = 1 if missing(treat_year)

*Preparation
cap drop F*event L*event
sum Ei
forvalues l = 0/8 {
	gen L`l'event = Kc_8==`l'
	replace L`l'event = 0 if no_treat==1
	}
	forvalues l = 1/11 {
		gen F`l'event = Kc_8==-`l'
		replace F`l'event = 0 if no_treat==1
		}
		drop F1event // normalize K=-1 (and also K=-15) to zero
		
* Run stackedev
preserve
stackedev Y F*event L*event, cohort(treat_year) time(t) never_treat(no_treat) unit_fe(i) clust_unit(i)
restore
// Y: outcome variable
// L*event: lags to include
// F*event: leads to include
// time(): numerical variable equal to time
// never_treat(): binary indicator that equals one if a unit never received treatment and zero if it did
// unit_fe(): variable indicating unit fixed effects
// clust_unit(): variable indicating the unit by which to cluster variances

*Plotting
event_plot e(b)#e(V), default_look graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") xlabel(-11(1)8) title("Cengiz et al. (2019)") name(CDLZ, replace)) stub_lag(L#event) stub_lead(F#event) together

*Saving estimates for later
matrix stackedev_b = e(b)
matrix stackedev_v = e(V)

// TWFE OLS estimation
*Estimation
reghdfe Y F*event L*event, absorb(i t) vce(cluster i)
estimates store ols_model

*Plotting
event_plot, default_look stub_lag(L#event) stub_lead(F#event) together ///
graph_opt(xtitle("Days since the event") ytitle("OLS coefficients") xlabel(-11(1)8) ///
title("OLS") name(ols, replace))

*Saving estimates for later
matrix ols_b = e(b)
matrix ols_v = e(V)

* Now combine the four into one event study plot
event_plot ///
    did2s_b#did2s_v    /// 1: Gardner (DID‑2S)
    stackedev_b#stackedev_v /// 2: Cengiz et al.
    ols_b#ols_v        /// 3: TWFE OLS
, stub_lag(L#event) stub_lead(F#event) ///
  plottype(scatter) ciplottype(rcap) together ///
  /// 1) Gardner in red
  lag_opt1(   mcolor(red)    lcolor(red)    msymbol(circle) ) ///
  lead_opt1(  mcolor(red)    lcolor(red)    msymbol(circle) ) ///
  lag_ci_opt1(lcolor(red%40) lwidth(thin))                    ///
  lead_ci_opt1(lcolor(red%40) lwidth(thin))                  ///
  /// 2) Cengiz et al. in orange
  lag_opt2(   mcolor(orange) lcolor(orange)   msymbol(circle) ) ///
  lead_opt2(  mcolor(orange) lcolor(orange)   msymbol(circle) ) ///
  lag_ci_opt2(lcolor(orange%40) lwidth(thin))                 ///
  lead_ci_opt2(lcolor(orange%40) lwidth(thin))                ///
  /// 3) TWFE OLS in dark‑blue
  lag_opt3(   mcolor(navy)   lcolor(navy)   msymbol(circle) ) ///
  lead_opt3(  mcolor(navy)   lcolor(navy)   msymbol(circle) ) ///
  lag_ci_opt3(lcolor(navy%40)   lwidth(thin))                 ///
  lead_ci_opt3(lcolor(navy%40)   lwidth(thin))                ///
  graph_opt(  ///
      title("AMR Event‐Study Estimates") ///
      xtitle("Periods Since Event") ///
      ytitle("Average Causal Effect") ///
      xlabel(-11(1)8)  ///
      legend(order(1 "Gardner 2021" ///
                   2 "Cengiz et al. 2019" ///
                   3 "TWFE OLS") ///
             rows(1) position(6) region(style(none))) ///
      xline(-1, lcolor(gs8) lpattern(dash)) ///
      yline(0,    lcolor(gs8)) ///
      graphregion(color(white)) ///
      bgcolor(white) ///
  ) ///
  perturb(-0.325(0.13)0.325) ///
  noautolegend
  
* — Save as a Stata graph file (.gph) for later editing
graph save "AMR_event_study_combined.gph", replace

* — Export as a high‑resolution PNG
graph export "AMR_event_study_ASdeath.png", width(1200) replace

* Export to SVG
graph export AMR_event_study_ASdeath.svg

