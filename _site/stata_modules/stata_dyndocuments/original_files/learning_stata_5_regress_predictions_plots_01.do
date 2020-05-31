capture log close 
log using output/learning_stata_5_regress_predictions_plots_01.log, replace text

/*************************************************************************
	Do file: learning_stata_5_regress_predictions_plots_01.do 
	
	Note: 	Regression analysis. Making predictions and creating figures.  
 
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

sysuse nlsw88.dta

// Estimate two regressions (m1 and m2) and store the results 
eststo m1: reg wage i.race i.collgrad 
eststo m2: reg wage i.race i.collgrad tenure ttl_exp  i.married i.c_city i.union

/*******************************************************************************
COEFFICIENTS PLOT 'coefplot': A visual alternative to regression tables. ******
*******************************************************************************/

/* This is a good plot when you are interested in comparing the coefficients 
between different models. Note that the second is a better graph than the first. 
Typically, you don't want to include all of the coefficients (see the first graph) 
in one graph, since they often have very different scaling. Hence, the second 
graph is better because it includes before-and-after comparisons of variables that 
are in the same scale (0 vs. 1). 
*/

coefplot m1 m2, drop(_cons) xline(0, lcolor(red)) // not so good 
coefplot m1 m2, keep(1.collgrad 2.race 3.race) xline(0, lcolor(red)) // better 

/*******************************************************************************
********* ESTIMATING MARGINS AND USING MARGINSPLOT *****************************
********************************************************************************/

// Predicted means from the second model. Several ways to get the same predictions.
/* I want predicted wages at different levels of experience (starting at 5 yrs. 
and then intervals of 5 upto 20). Note -- all other variables are held constant 
at their means. */

margins, at(ttl=(5 10 15 20))
margins, at(ttl=(5(5)20)) // shorthand for the above predictions 

/* Now, I want the same predictions, but for non-college grads, 
and also college grads. There are three equivalent ways to do this, which are 
presented below. Notice that experience comes first, and college comes second in 
each case. That is important for making the graph (marginsplot), because the first 
variable in the margins command will become the x-axis. The subsequent variable
will be divided into different lines in the graph.  */

margins, at(ttl=(5(5)20)) over(collgrad)
margins, at(ttl=(5(5)20) coll=0) at(ttl=(5(2)15) coll=1) 
margins, at(ttl=(5(5)20) coll=(0 1)) 

// Marginsplot -- plot of predicted values (means) at the margins 
marginsplot // no options (boring!) 

marginsplot, ytitle("E(Wages)") xtitle("Total Yrs. of Experience") /// 
	title("Wages predicted by Total Experience and College Degree") /// 
	legend(rows(1) pos(6) size(small)) /// 
	plot(, label("No Coll. Deg." "Coll. Deg.")) /// 
	note("Note: Predicted means are from Model 2. All other predictors in the model are held at their mean.")

// Let's include a 3rd dimension -- union status -- in the mix. We can create 
// subgraphs by union status. 	
margins, at(ttl=(5(5)20)) over(collgrad union)  
marginsplot, bydimension(union) // subcommand controls which separate graphs are made. 
// Let's makes some changes, and create CI area plots rather than error bars. 
marginsplot, by(union, label("Non-Union " "Union")) byopts(title(" "))  /// 
	recast(line) recastci(rarea) ytitle("E(Wages)") ///
	ylabel(4 "$4" 6 "$6" 8 "$8" 10 "$10" 12 "$12") ///
	plot1opts(lwidth(thick) lcolor(gray))  ///
	plot2opts(lwidth(thick) lcolor(blue)) ///
	plot(, label("No Coll. Deg." "Coll. Deg.")) ///
	xtitle("Total Yrs. of Experience") 

/*******************************************************************************
********* COMBOMARGINSPLOT *****************************************************
********************************************************************************

'Combomarginsplot' 
Plotting predictions from two different models in the same graph. Since we have 
already stored the estimates from the two models, we can "restore" them before 
estimating the margins. Notice that you can saving the output from your 'margins' 
command. It is stored as a Stata dataset. 
*/ 

// Comparing the education effects for models 1 and 2. 
estimates restore m1 // restore estimates from m1 
margins, at(collgrad=(0 1)) saving(output/m1.dta, replace) 

estimates restore m2  
margins, at(collgrad=(0 1)) saving(output/m2.dta, replace) 

combomarginsplot output/m1 output/m2 // No options 

combomarginsplot output/m1 output/m2,  /// 
	labels("Unadjusted (M1)" "Adjusted (M2)") /// 
	ytitle("E(Wages)") xtitle("College Degree?") /// 
	xlabel( 0 "No" 1 "Yes", nogrid) xscale(range(-.05 1.05)) /// 
    title("Effects of College Education, before and after Controls") /// 
    file1opts(lcolor(black) lwidth(medthick) lpattern(solid) /// 
	msymbol(Dh) mcolor(black) msize(medlarge)) ///
	fileci1opts(lcolor(black) msize(med)) ///
    file2opts(lcolor(red) lwidth(medthick) lpattern(shortdash) msymbol(Oh) /// 
    mcolor(red) msize(medlarge))  ///
	fileci2opts(lcolor(red) msize(med)) ///
	note("Note: Error bands are 95% confidence intervals.")
	
/*******************************************************************************
********* PLOTTING INTERACTION EFFECTS *****************************
********************************************************************************

Let's see whether the effect of a college education varies by race. We can 
re-estimate M2 with an interaction, which we will call model 3. 
IMPORTANT! Always use the single or double hashtag notation to estimate 
interaction effects. Otherwise -- margins will not properly estimate the 
predictions. */ 

eststo m3: reg wage i.race i.collgrad##i.union tenure ttl_exp i.married i.c_city 

// Calculate predictions for each model and make a comparative plot
estimates restore m2  
margins, at(union=(0 1) coll=(0 1)) 
marginsplot, title("Additive Model") /// 
		ytitle("E(Wages)") xtitle("Union Member?") /// 
		xlabel( 0 "No" 1 "Yes", nogrid) xscale(range(-.05 1.05)) ///
		legend(rows(1) pos(6)) plot(, label("No Coll. Deg." "Coll. Deg.")) ///
		saving(output/g1.gph, replace)

estimates restore m3  
margins, at(union=(0 1) coll=(0 1))   
marginsplot, title("Multiplicative Model") ///
		ytitle(" ") xtitle("Union Member?") /// 
		xlabel( 0 "No" 1 "Yes", nogrid) xscale(range(-.05 1.05)) ///
		legend(rows(1) pos(6)) plot(, label("No Coll. Deg." "Coll. Deg.")) ///
		saving(output/g2.gph, replace)

gr combine output/g1.gph output/g2.gph, ycommon

/* USING 'marginscontplot' (or 'mcp') to graph continuous variables. 
Especially useful when you are ploting continuous interactions, by a category. 
Does total labor market experience vary for union and non-union workers? 
First, we estimate the regression.  */

eststo m4:reg wage c.ttl_exp##i.union 

/* 'mcp' allows us to estimate the marginal predictions and to create the graph
in a single step.  */ 

mcp tenure union, at1(0 20) at2(0 1) ci sh /// 
	plotopts(ycommon  l1title("E(Wages)") b1title("Total Exper. (Yrs.)"))
	//  Not much of an interaction. :-( 
	// A caveat: 'mcp' can be hard to customize. 

/* Continuous by continuous interations: These can be hard to plot because a 
there are so many values on each variable to choose from, when generating your
predicted means. */

/* Q: Does the effect of job tenure (how long you hold a job) depend on a worker's 
 labor market experience (how long you have worked)? Perhaps a worker's job 
 tenure pays off more when they are less experienced (when they have fewer 
 options to change jobs based on their limited experience)? */ 

reg wage c.ttl##c.tenure 

// We estimated the regression. Now let's get some predictions and save it as a 
// Stata data file. 
margins, at(ttl=(0(5)25) tenure=(0(5)25)) saving(marg1, replace) 

use marg1, clear /* Open the Stata data file, with the saved predicted margins, 
					into memory. */ 

/* Now, let's create a "contour" plot to display the results. */ 
					
twoway contour _marg _at1 _at2, legend(position(3)) ccuts(3(1)12) /// 
	xtitle("Job Tenure (Yrs.)") ytitle("Total Work Experience") ///
	ztitle("Expected Wages") 
	
/* The curvature of the "bands" in the graph tells you where the interaction is 
the strongest. --> More change in the bands as you move across the x-axis at 
a given value on the y-axis means a stronger effect of the variable on the 
x-axis on the outcomes.  In this case, job tenure matters most for less 
experienced workers and it matters less for more experienced workers.  */ 

/* Calcuating AVERAGE MARGINAL EFFECTS (AME) 
Perhaps rather than estimating the predicted means, we want to predict the 
effects of being a college graduate for union and nonunion members? That 
means we want the average marginal effects (AME). Margins will do that for us. 
*/ 

estimates restore m3 
margins union, dydx(collgrad)
marginsplot
// We don't really need that line connecting the two point estimates, do we? 
marginsplot, /// 
	title("Average Marginal Effect of the College Premium on Wages, by Union Status", size(med)) /// 
	ytitle("Change in Wages") xtitle("Union Worker?", size(med)) ///
	ylabel(1.5 "$1.50" 2 "$2.00" 2.5 "$2.50" 3 "$3.00" 3.5 "$3.50") ///
	xlabel(0 "No" 1 "Yes",  nogrid) xscale(range(-.2 1.2)) /// 
	recast(scatter) plotopts(msize(large)) ciopts(lwidth(medthick)) /// 
	note("Notes: Error bars are 95% C.I.s.")  
	
capture log close 
exit
