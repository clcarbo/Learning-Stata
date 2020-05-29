capture log close 
log using output/learning_stata_4_plots_01.log, replace text

/*************************************************************************
	Do file: learning_stata_4_plots_01.do 
	
	Note: 	Making plots using the 'twoway' command.  
 
	Author: Bill Carbonaro
*************************************************************************/

version 15.1 		 
clear all 			 
macro drop _all		
set linesize 100 	
set more off 		

**************************
***COMMANDS BEGIN HERE ***
**************************

use data/crime_states_1960.dta, clear 

la define south 0 "Non-South" 1 "South" 
la val south south 

// Scatterplot 
twoway (scatter crimerat educ) 

// Linear fit 
twoway (lfit crimerat educ)

// Scatterplot with a linear fit 
twoway (scatter crimerat educ) (lfit crimerat educ) 

// Scatterplot with a linear and quadratic fit 
twoway (scatter crimerat educ) (lfit crimerat educ) (qfit crimerat educ)

// Scatterplot with a linear fit, marker options 
twoway 	(scatter crimerat educ, msymbol(Oh) mcolor(red) msize(large)) ///
		(lfit crimerat educ) 
		/* "Oh" is a large hollow (h) circle (O) 
		msymbol(o) would be small filled circles */ 
		
// Scatterplot with a linear fit, marker options -- TRANSPARENCY (avoids overplotting)! 
twoway 	(scatter crimerat educ, msymbol(O) mcolor(red%30) msize(medium)) ///
		(lfit crimerat educ) 
		/* %30 = 30% fill.  */ 		
		
// Scatterplot with a linear fit, marker and line options 
twoway 	(scatter crimerat educ, msymbol(Dh) mcolor(red%50) msize(medlarge)) ///
		(lfit crimerat educ, lpattern(dash) lwidth(thick) lcolor(green)) 
		/* (Dh) produces large hollow diamonds 
		Notice that marker options go with the "scatter" plot. 
		Line options go with the "linear fit" plot. */

// Scatterplot with a linear fit, marker and line options. Titles added. 
twoway 	(scatter crimerat educ, msymbol(Dh) mcolor(red%40) msize(small)) ///
		(lfit crimerat educ, lpattern(dash) lwidth(thick) lcolor(green)), ///
		legend(off) ///
		title("Figure 1: State Crime Rate predicted by Years of Education (1960)") ///
		ytitle("Crime Rate" "(per 1 million)", size(small)) ///
		xtitle("Average Yrs. of Educ.") /// 
		note("Source: FBI, Uniform Crime Statistics and U.S Census Bureau.", ///
		size(small)) 
		/* Notice that graph options are (not specific to a given plot) 
		are included after the comma for the last plot. */	
		
// Adding reference lines, using scalars. 
// Create scalars: the mean for y and x. 
sum crimerat
scalar cr_rate = r(mean)
sum educ 
scalar yrsed = r(mean) 

// Include the mean of y and x as reference lines in the graph (using scalars). 
twoway 	(scatter crimerat educ, msymbol(Dh) mcolor(red%50) msize(small)) ///
		(lfit crimerat educ, lpattern(dash) lwidth(thick) lcolor(green)), ///
		legend(off) ///
		yline(`=cr_rate', lpattern(shortdash) lcolor(black)) ///
		text(100 9.5 "Avg. Crime Rate", size(small))  ///
		xline(`=yrsed', lpattern(shortdash) lcolor(black)) ///
		text(190 10.4 "Avg." "Educ.", size(small)) ///
		title("Figure 2: State Crime Rate predicted by Years of Education (1960)") ///
		ytitle("Crime Rate" "(per 1 million)", size(small)) ///
		xtitle("Average Yrs. of Educ.") /// 
		note("Source: FBI, Uniform Crime Statistics and U.S Census Bureau.", ///
		size(small))
		/* Notice I also included text to label each reference line. The text is 
		placed at values of y and x (which included first in the command), 
		followed by the text.  */	
	
// Same plot, subdivided by southern and non-southern states  
twoway 	(scatter crimerat educ if south==0, msymbol(Oh) mcolor(red) msize(small)) ///
		(scatter crimerat educ if south==1, msymbol(Dh) mcolor(green) msize(small)) ///
		(lfit crimerat educ if south==0, lpattern(dash) lwidth(medium) lcolor(red)) ///
		(lfit crimerat educ if south==1, lpattern(dash) lwidth(medium) lcolor(green)), ///
		legend(label(1 "Non-South") label(2 "South") order(1 2) position(3) cols(1)) ///
		title("Figure 3: State Crime Rate predicted by Years of Education (1960)") ///
		ytitle("Crime Rate" "(per 1 million)", size(small)) ///
		xtitle("Average Yrs. of Educ.") /// 
		note("Source: FBI, Uniform Crime Statistics and U.S Census Bureau.", ///
		size(small))
		
// Same plot, subdivided by south and non-south -- labeling specific cases

twoway 	(scatter crimerat educ if south==0, msymbol(Oh) mcolor(red) msize(small)) ///
		(scatter crimerat educ if south==1, msymbol(Dh) mcolor(green) msize(small)) ///
		(scatter crimerat educ if state=="California", msize(tiny) mcolor(red) mlabel(state) /// 
		mlabcolor(red)) ///
		(scatter crimerat educ if state=="Texas", msize(tiny) msymbol(D) /// 
		mcolor(green) mlabel(state) mlabcolor(green)) ///
		(lfit crimerat educ if south==0, lpattern(dash) lwidth(medium) lcolor(red)) ///
		(lfit crimerat educ if south==1, lpattern(dash) lwidth(medium) lcolor(green)), ///
		legend(label(1 "Non-South") label(2 "South") order(1 2) position(3) cols(1)) ///
		title("Figure 4: State Crime Rate predicted by Years of Education (1960)") ///
		ytitle("Crime Rate" "(per 1 million)", size(small)) ///
		xtitle("Average Yrs. of Educ.") /// 
		note("Source: FBI, Uniform Crime Statistics and U.S Census Bureau.", ///
		size(small))		
		
// Separate plots, subdivided by south and non-South 
// (OPTION #1 -- Less preferable; Harder to make changes) 
twoway 	(scatter crimerat educ, msymbol(Dh) mcolor(green) msize(small)) ///
		(lfit crimerat educ, lpattern(dash) lwidth(medium) lcolor(green)), ///
		by(south,  ///
		title("Figure 4: Crime Rate by Yrs. of Education") ///
		note("Source: FBI, Uniform Crime Statistics and U.S Census Bureau.", ///
		size(small)) legend(rows(1) pos(6)) )  ///
		ytitle("Crime Rate" "(per 1 million)", size(small)) ///
		xtitle("Average Yrs. of Educ.") 
		
		
// Separate plots, subdivided by south and non-south; then combined into one graph  
// (OPTION #2 -- More preferable; better control) 
// STEP 1: create non-south graph
twoway 	(scatter crimerat educ if south==0, msymbol(Oh) mcolor(black) msize(small)) ///
		(scatter crimerat educ if state2=="CA", msize(tiny) mcolor(black) mlabel(state2) /// 
		mlabcolor(black)) ///
		(lfit crimerat educ if south==0, lpattern(dash) lwidth(medium) lcolor(black)), ///
		legend(label(1 "Non-South") label(2 "South") order(1 2) position(3) cols(1)) ///
		title("Non-South") ///
		ytitle("Crime Rate (per 1,000)", size(small)) ///
		xtitle("Avg. Yrs. of Educ.") legend(off) /// 
		saving(output/g1.gph, replace)

// STEP 2: create south graph		
twoway 	(scatter crimerat educ if south==1, msymbol(Dh) mcolor(black) msize(small)) ///
		(scatter crimerat educ if state2=="TX", msize(tiny) msymbol(D) /// 
		mcolor(black) mlabel(state2) mlabcolor(black)) ///
		(lfit crimerat educ if south==1, lpattern(dash) lwidth(medium) lcolor(black)), ///
		title("South") ///
		ytitle(" ", size(small)) ///
		xtitle("Avg. Yrs. of Educ.") legend(off)	///
		saving(output/g2.gph, replace) 

// STEP 3: Combine the two graphs 
graph combine output/g1.gph output/g2.gph, ycommon xcommon /// 
		title("Figure 4: Crime Rate by Yrs. of Education (1960)") ///
		note("Source: FBI, Uniform Crime Statistics and U.S Census Bureau.", ///
		size(small)) 

// Confidence intervals on a fit line 
twoway (lfitci crimerat educ) (scatter crimerat educ) // Yes! 
twoway (scatter crimerat educ) (lfitci crimerat educ) // Um, no!! 
// Notice the difference due to the ordering! 
// Graphs are always layered on top of each other! 

		
// Confidence intervals on fit line
set scheme plotplain 

twoway 	(lfitci crimerat educ if south==0, fcolor(%50) nofit ) ///
		(lfitci crimerat educ if south==1, fcolor(%50) nofit )   ///
		(lfit crimerat educ if south==0, color(red)) ///
		(lfit crimerat educ if south==1, color(green) lpattern(solid)) ///
		(scatter crimerat educ if south==0, msymbol(Oh) mcolor(red%50) msize(small)) ///
		(scatter crimerat educ if south==1, msymbol(Dh) mcolor(green%50) msize(small)) ///
		, ///
		legend(label(5 "Non-South") label(6 "South") order(5 6) position(3) cols(1)) ///
		title("Figure 4: State Crime Rate predicted by Years of Education (1960)") ///
		ytitle("Crime Rate" "(per 1 million)", size(small)) ///
		xtitle("Average Yrs. of Educ.") /// 
		note("Source: FBI, Uniform Crime Statistics and U.S Census Bureau." ///
		"Error bands are 95% Confidence Intervals." , ///
		size(small))	

// Using weights with a scatterplot and linear fit 
twoway 	(scatter crimerat educ [fweight=pop], mcolor(green%40) ) ///
		(lfit crimerat educ [fweight=pop], lpattern(dash) lwidth(thick) lcolor(green)), ///
		legend(off)  ///
		title("Figure 4: State Crime Rate predicted by Years of Education (1960)") ///
		ytitle("Crime Rate" "(per 1 million)", size(small)) ///
		xtitle("Average Yrs. of Educ.") /// 
		note("Note: Data are weighted by each state's population." ///
		"Source: FBI, Uniform Crime Statistics and U.S Census Bureau.")
	
log close 
exit
