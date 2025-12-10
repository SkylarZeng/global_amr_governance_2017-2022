================================================================================
* Difference-in-Differences Event-Study Analysis
* Outcome: AMR Global Burden (GBD)
* Specification: Control Period Analysis
* Methods: Gardner (2021) Two-Stage DID, Stacked Event-Study DID, TWFE OLS
================================================================================

* ssc install reghdfe, replace
* ssc install did2s, replace
* ssc install stackedev, replace
* ssc install event_plot, replace

use "treatment_amrgbdAS_control.dta", clear
rename amr Y

* --- DESCRIPTIVE STATISTICS ---

correlate Y X1 X2 X3 X4 X5 X6 X7 X8 X9 X10, covariance
correlate Y X1 X2 X3 X4 X5 X6 X7 X8 X9 X10, means covariance

pwcorr Y X1 X2 X3 X4 X5 X6 X7 X8 X9 X10, sig star(0.05)

reg Y X1 X2 X3 X4 X5 X6 X7 X8 X9 X10
estat vif

* --- EVENT-STUDY VARIABLE CONSTRUCTION ---

gen Ei = .
bysort i (t): replace Ei = t if D == 1 & missing(Ei)

gen first_Ei = .
bysort i (Ei): replace first_Ei = Ei if _n == 1
bysort i (t): replace first_Ei = first_Ei[_n-1] if missing(first_Ei)
bysort i (t): replace first_Ei = first_Ei[_N] if missing(first_Ei)
replace Ei = first_Ei
drop first_Ei

gen K = t - Ei
replace K = . if missing(Ei)

gen Kc_8 = K if !missing(K)
replace Kc_8 = 8 if K > 8 & !missing(K)
replace Kc_8 = -11 if K < -11 & !missing(K)

egen pre_treatment_mean = mean(Y) if t < Ei, by(i)
bysort i (t): replace pre_treatment_mean = pre_treatment_mean[_n-1] if missing(pre_treatment_mean)

gen tau = Y - pre_treatment_mean if D == 1

* Create event indicators
forvalues l = 0/8 {
	gen L`l'event = Kc_8 == `l'
}
forvalues l = 1/11 {
	gen F`l'event = Kc_8 == -`l'
}
drop F1event

* --- ESTIMATION: METHOD 1 - GARDNER TWO-STAGE DID ---

did2s Y, first_stage(i.i i.t X1 X2 X3 X4 X5 X6 X7 X8 X9 X10) second_stage(F*event L*event) treatment(D) cluster(i)
matrix did2s_b = e(b)
matrix did2s_v = e(V)

* --- ESTIMATION: METHOD 2 - STACKED EVENT-STUDY DID ---

gen treat_year = .
replace treat_year = Ei if Ei != 2022

gen no_treat = 0
bysort i (t): replace no_treat = 1 if missing(treat_year)

cap drop F*event L*event
forvalues l = 0/8 {
	gen L`l'event = Kc_8 == `l'
	replace L`l'event = 0 if no_treat == 1
}
forvalues l = 1/11 {
	gen F`l'event = Kc_8 == -`l'
	replace F`l'event = 0 if no_treat == 1
}
drop F1event

preserve
stackedev Y X1 X2 X3 X4 X5 X6 X7 X8 X9 X10 F*event L*event, cohort(treat_year) time(t) never_treat(no_treat) unit_fe(i) clust_unit(i)
restore
matrix stackedev_b = e(b)
matrix stackedev_v = e(V)

* --- ESTIMATION: METHOD 3 - TWFE OLS ---

reghdfe Y X1 X2 X3 X4 X5 X6 X7 X8 X9 X10 F*event L*event, absorb(i t) vce(cluster i)
matrix ols_b = e(b)
matrix ols_v = e(V)

* --- COMBINED EVENT-STUDY PLOT ---

event_plot ///
    did2s_b#did2s_v    ///
    stackedev_b#stackedev_v ///
    ols_b#ols_v        ///
, stub_lag(L#event) stub_lead(F#event) ///
  plottype(scatter) ciplottype(rcap) together ///
  lag_opt1(   mcolor(red)    lcolor(red)    msymbol(circle) ) ///
  lead_opt1(  mcolor(red)    lcolor(red)    msymbol(circle) ) ///
  lag_ci_opt1(lcolor(red%40) lwidth(thin)) ///
  lead_ci_opt1(lcolor(red%40) lwidth(thin)) ///
  lag_opt2(   mcolor(orange) lcolor(orange)   msymbol(circle) ) ///
  lead_opt2(  mcolor(orange) lcolor(orange)   msymbol(circle) ) ///
  lag_ci_opt2(lcolor(orange%40) lwidth(thin)) ///
  lead_ci_opt2(lcolor(orange%40) lwidth(thin)) ///
  lag_opt3(   mcolor(navy)   lcolor(navy)   msymbol(circle) ) ///
  lead_opt3(  mcolor(navy)   lcolor(navy)   msymbol(circle) ) ///
  lag_ci_opt3(lcolor(navy%40) lwidth(thin)) ///
  lead_ci_opt3(lcolor(navy%40) lwidth(thin)) ///
  graph_opt(  ///
      title("AMR Global Burden (GBD): Event-Study Estimates") ///
      xtitle("Time Since NAP Launch (years)") ///
      ytitle("Average Causal Effect") ///
      xlabel(-11(1)8) ///
      legend(order(1 "Gardner DID-2S" 3 "Stacked DID" 5 "TWFE OLS") ///
       rows(1) position(6) region(style(none))) ///
      xline(-0.5, lcolor(gs8) lpattern(dash)) ///
      yline(0, lcolor(gs8)) ///
      graphregion(color(white)) ///
      bgcolor(white) ///
  ) ///
  perturb(-0.325(0.13)0.325) ///
  noautolegend

graph export amrgbdAS_did_control.svg

* --- ROBUSTNESS TEST 1: PARALLEL TRENDS ---

did2s Y, first_stage(i.i i.t) second_stage(F*event L*event) treatment(D) cluster(i)
test (F2event=0) (F3event=0) (F4event=0) (F5event=0) (F6event=0) ///
     (F7event=0) (F8event=0) (F9event=0) (F10event=0) (F11event=0)

* --- ROBUSTNESS TEST 2: PLACEBO TEST ---

gen Ei_placebo = Ei - 1
gen K_placebo = t - Ei_placebo
gen Kc8_placebo = K_placebo
replace Kc8_placebo = 8 if K_placebo > 8
replace Kc8_placebo = -11 if K_placebo < -11

forvalues l = 0/8 {
    gen L`l'placebo = (Kc8_placebo == `l')
}
forvalues l = 1/11 {
    gen F`l'placebo = (Kc8_placebo == -`l')
}
drop F1placebo

did2s Y, first_stage(i.i i.t) second_stage(F*placebo L*placebo) treatment(D) cluster(i)
test (F2placebo=0) (F3placebo=0) (F4placebo=0) (F5placebo=0) (F6placebo=0) ///
     (F7placebo=0) (F8placebo=0) (F9placebo=0) (F10placebo=0) (F11placebo=0)

* --- End of Analysis ---
