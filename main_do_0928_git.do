cd  D:\data\tdgx\
use data_0928_1,clear
merge 1:1 id using data_0928_2
keep if _merge==3
drop _merge
save data_0928,replace


use data_0928,clear
**Fig. 2. The impact of power outage under different cumulative installed capacities.
reghdfe lnoutage_hour ee* heatwave  cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19, absorb(c#ym t) vce(cluster c )
coefplot, baselevels keep(ee*) vertical ///
addplot(line @b @at, lcolor(gray)) ///
yscale(range(0.05 0.2)) ///
yline(0,lc(gray) lp(dash)) ///
ytitle("Estimation") graphregion(fcolor(white)) ///
ciopts(recast(ci) lcolor("230 159 0") fcolor(gray)) xlabel(1 "[0-2]" 2 "[2-3]" 3 "[3-4]" 4 "[4-5]" 5 "[5-6]" 6 "[6-7]" 7 "[7-8]" 8 "[8-9]" 9 "[9-10]" 10 "[10-11]" 11 "[11-12]" 12 "[12-13]", nogrid labsize(*0.8)) xtitle("ln(Cul_dpv)") ytitle("Coefficient",size(4)) 
graph export "figure_2.png", as(png) replace width(2000) height(1500)
****Table 1. The impact of increased HDPV installed capacities on power outages
reghdfe lnoutage_hour ln_cul_pdv, absorb(c#ym t) vce(cluster c )
est store m1
reghdfe lnoutage_hour ln_cul_pdv heatwave cold_wave rain wind , absorb(c#ym t) vce(cluster c )
est store m2
reghdfe lnoutage_hour ln_cul_pdv heatwave cold_wave rain wind wind_cap cepv_cap copv_cap , absorb(c#ym t) vce(cluster c )
est store m3
reghdfe lnoutage_hour ln_cul_pdv heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19, absorb(c#ym t) vce(cluster c )
est store m4
xtset c t
mkspline cul_pdv1 10  cul_pdv2= ln_cul_pdv
reghdfe lnoutage_hour cul_pdv* heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19, absorb(c#ym t) vce(cluster c )
est store m5
esttab m1 m2 m3 m4 m5 using table1.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.5f) star(* 0.10 ** 0.05 *** 0.01)
***Table 2. Heterogeneity analysis
reghdfe lnout_sum_plan ln_cul_pdv , absorb(c#ym t) vce(cluster c )
est store m1
reghdfe lnout_sum_plan ln_cul_pdv heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19, absorb(c#ym t) vce(cluster c )
est store m2
reghdfe lnout_sum_unplan ln_cul_pdv , absorb(c#ym t) vce(cluster c )
est store m3
reghdfe lnout_sum_unplan ln_cul_pdv heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19, absorb(c#ym t) vce(cluster c )
est store m4
esttab m1 m2 m3 m4 using table2.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
****Table 3. Impact of supply fluctuations on HDPV-induced power outages.
reghdfe lnoutage_hour c.ln_cul_pdv##c.pm25 heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19, absorb(c#ym t) vce(cluster c )
est store m1
reghdfe lnoutage_hour c.ln_cul_pdv##c.aqi heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19  , absorb(c#ym t) vce(cluster c )
est store m2
reghdfe lnoutage_hour c.ln_cul_pdv##cold_wave heatwave  rain wind wind_cap cepv_cap copv_cap COVID_19  , absorb(c#ym t) vce(cluster c )
est store m3
reghdfe lnoutage_hour c.ln_cul_pdv##c.rain heatwave cold_wave  wind wind_cap cepv_cap copv_cap COVID_19, absorb(c#ym t) vce(cluster c )
est store m4
esttab m1 m2 m3 m4  using table3.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
***Table 4. Impact of electrical consumption on HDPV-induced outages.
reghdfe lnoutage_hour c.ln_cul_pdv##c.ELE heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19, absorb(c#ym t) vce(cluster c )
est store m1
reghdfe lnoutage_hour c.ln_cul_pdv##c.Light heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19, absorb(c#ym t) vce(cluster c )
est store m2
reghdfe lnoutage_hour c.ln_cul_pdv##c.GDP heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19, absorb(c#ym t) vce(cluster c )
est store m3
esttab m1 m2 m3  using table4.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
***Fig. 3. The HDPV-induced hourly power outages.
destring month,replace
gen season=3 if month==7
replace season=3 if month==8
replace season=3 if month==9
forvalues i=0/23{
reghdfe lnoutage_hour`i' ln_cul_pdv heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19 if season!=3 , absorb(c#ym t) vce(cluster c)
est store m`i'
}
coefplot (m0, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) ))(m1, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m2,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m3, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m4,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m5, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m6,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m7, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m8,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m9, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m10,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) ))(m11, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m12,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m13, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m14,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m15, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m16,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m17, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m18,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m19, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m20,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) ))  (m21, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m22,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m23, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )), vertical nolabel graphregion(color(white)) ylabel(,labsize(*1))   mcolor(black) legend(off) graphregion(fcolor(white)) ytitle("Coefficient",size(4)) addplot(line @b @at, lcolor(gray) lpattern(solid)) xlabel(0.54 "0" 0.58 "1" 0.62 "2" 0.66 "3" 0.7 "4" 0.74 "5" 0.78 "6" 0.82 "7" 0.86 "8" 0.9 "9" 0.94 "10" 0.98 "11" 1.02 "12" 1.06 "13" 1.1 "14" 1.14 "15" 1.18 "16" 1.22 "17" 1.26 "18" 1.3 "19" 1.34 "20" 1.38 "21" 1.42 "22" 1.46 "23", nogrid labsize(*0.8))  yline(0,lc(gray) lp(dash))  xtitle("Hour") title("(b)", pos(11) size(4))
graph export "figure_3_1.png", as(png) replace width(2000) height(1500)
*****************
forvalues i=0/23{
reghdfe lnoutage_hour`i' ln_cul_pdv heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19 if season==3 , absorb(c#ym t) vce(cluster c)
est store m`i'
}
coefplot (m0, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) ))(m1, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m2,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m3, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m4,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m5, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m6,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m7, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m8,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m9, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m10,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) ))(m11, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m12,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m13, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m14,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m15, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m16,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m17, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m18,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m19, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m20,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) ))  (m21, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m22,keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )) (m23, keep(ln_cul_pdv) mc("0 114 178") lc("230 159 0")  ms(circle) ciopt(recast(ci) lcolor("230 159 0") lw(0.3) )), vertical nolabel graphregion(color(white)) ylabel(,labsize(*1))   mcolor(black) legend(off) graphregion(fcolor(white)) ytitle("Coefficient",size(4)) addplot(line @b @at, lcolor(gray) lpattern(solid)) xlabel(0.54 "0" 0.58 "1" 0.62 "2" 0.66 "3" 0.7 "4" 0.74 "5" 0.78 "6" 0.82 "7" 0.86 "8" 0.9 "9" 0.94 "10" 0.98 "11" 1.02 "12" 1.06 "13" 1.1 "14" 1.14 "15" 1.18 "16" 1.22 "17" 1.26 "18" 1.3 "19" 1.34 "20" 1.38 "21" 1.42 "22" 1.46 "23", nogrid labsize(*0.8))  yline(0,lc(gray) lp(dash)) xtitle("Hour")  title("(a)", pos(11) size(4))
graph export "figure_3_2.png", as(png) replace width(2000) height(1500)
**************SI part
***Table S2. The result of IV
use data_0928,clear
ivreghdfe lnoutage_hour (ln_cul_pdv= iv) heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19 temp_f, absorb(c#ym t)  first
est store m1
ivreghdfe lnoutage_hour (ln_cul_pdv= ivsun) heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19 temp_f, absorb(c#ym t)  first
est store m2
ivreghdfe lnoutage_hour (ln_cul_pdv= ivsun iv) heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19 temp_f, absorb(c#ym t)  first
est store m3
esttab m1 m2 m3 using s2.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
*******Table S3. The result of different spline knots
cd  D:\data\tdgx\
use data_0928,clear
centile ln_cul_pdv, centile(10  30  50  70 90)
mkspline cul_pdv1 2.493206  cul_pdv2 5.283204 cul_pdv3 7.378467 cul_pdv4 10.04254 cul_pdv5 = ln_cul_pdv
reghdfe lnoutage_hour cul_pdv1 cul_pdv2 cul_pdv3 cul_pdv4 cul_pdv5, absorb(c#ym t) vce(cluster c )
est store m1
reghdfe lnoutage_hour cul_pdv1 cul_pdv2 cul_pdv3 cul_pdv4 cul_pdv5 heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19, absorb(c#ym t) vce(cluster c )
est store m2
esttab m1  m2 using s3.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
******Table S4. Impact of grid investment on HDPV-induced outages.
use data_0928,clear
reghdfe lnoutage_hour c.ln_cul_pdv##c.INVEST1 heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19 , absorb(c#ym t) vce(cluster c )
est store m1
reghdfe lnoutage_hour c.ln_cul_pdv##c.INVEST2 heatwave cold_wave rain wind wind_cap cepv_cap copv_cap COVID_19  , absorb(c#ym t) vce(cluster c )
est store m2
esttab m1 m2   using s4.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
************Table S5. The impact of increased HDPV installed capacities on power outages in the United States
use D:\data_do\outage_pv\us,replace
reghdfe lnout_sum l2.lnCul_hdpv  , absorb(c#group t ) vce(cluster c)
est store m1
reghdfe lnout_sum l2.lnCul_hdpv heatwave cold_wave rain wind , absorb(c#group t ) vce(cluster c)
est store m2
reghdfe lnout_sum l2.lnCul_hdpv l2.lnOther   heatwave cold_wave rain wind , absorb(c#group t ) vce(cluster c)
est store m3
esttab m1 m2 m3 using s5.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
**************Figure S1. The impact of the proportion of the generating capacity of HDPV over electricity consumption on power outages
use proportion,clear
reg lnsum  bin2-bin10 sheatwave scold_wave srain swind swind_cap scepv_cap scopv_cap sCOVID_19 GDP Pop Urban INVEST2,r
coefplot, baselevels keep(bin1 bin2 bin3 bin4 bin5 bin6 bin7 bin8 bin9 bin10 bin11 bin12 bin13) vertical ///
addplot(line @b @at, lcolor(gray)) ///
yscale(range(0.05 0.2)) ///
yline(0,lc(gray) lp(dash)) ///
ytitle("Estimation") graphregion(fcolor(white)) ///
ciopts(recast(ci) lcolor("230 159 0") fcolor(gray)) xlabel( 1 "0.0001-0.0006%" 2 "0.0006-0.002%" 3 "0.002-0.004%" 4 "0.004-0.010%" 5 "0.010-0.024%" 6 "0.024-0.068%" 7 "0.068-0.220%" 8 "0.220-0.562%" 9 ">0.562%" , nogrid labsize(*0.46)) xtitle("Cul_pro_ele/ele_consumption") ytitle("Coefficient",size(3))  
graph export "D:\data\tdgx\figure_s1.png", as(png) name("Graph") replace
*******************Figure S3. Grid investment in Low HDPV and High HDPV groups
use data_0928,clear
gen j=1 if t==335
replace j=1 if t==729
keep if j==1
bys c: egen sum1=sum(INVEST1)
bys c: egen sum2=sum(INVEST2)
keep if t==729
gen group=1 if ln_cul_pdv<11.30261
replace group=2 if ln_cul_pdv>=11.30261
label define labelname 1 "Low HDPV" 2 "High HDPV" , replace
label values group labelname
graph box INVEST1, over(group) ///
ytitle("Grid investment weighting by the population") ///
legend(label(1 "Low HDPV") label(2 "High HDPV")) title("2020") 
graph save "image1.gph", replace
graph box INVEST2, over(group) ///
ytitle("Grid investment weighting by the county areas") ///
legend(label(1 "Low HDPV") label(2 "High HDPV")) title("2020") 
graph save "image2.gph", replace
graph use "image1.gph"
graph use "image2.gph"
graph combine image1.gph image2.gph, row(1) col(2) 
graph export "stata_s3.png", as(png) name("Graph") replace








