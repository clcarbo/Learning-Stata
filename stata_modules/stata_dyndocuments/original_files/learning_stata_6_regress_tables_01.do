capture log close 
log using output/learning_stata_6_regress_tables_01.log, replace text

/*************************************************************************
	Do file: learning_stata_6_regress_tables_01.do 
	
	Note: 	Regression analysis. Making tables using "esttab" commands.   
 
	Author: Bill Carbonaro
*************************************************************************/

// Always include the following commands in your do-files: 

version 15.1 		 
clear all 			 
macro drop _all		
set linesize 100 	
set more off 		

**************************
***COMMANDS BEGIN HERE ***
**************************

sysuse nlsw88.dta

// Estimate a regression (model 1) and store the results in memory  
reg wage hours i.race i.collgrad 
eststo // stores the estimates of the model. Shorthand for "estimates store."  

ereturn list // return list of stored information
di "The R-squared for the model is " e(r2)
di "The R-squared for the model is " round(e(r2), .001) // I used the round function 

regress, coeflegend  // return legend for regression coefficients 

// Save coefficient as a scalar 
// Notice how I used the absolute value and rounding functions below. 
scalar bhrs = _b[hours] 
di bhrs
di "We predict that an increase of 10 hours " /// 
"increases a worker's expected wages by $" abs(round(10*`=bhrs'), .01) " (net of controls)."

esttab // this will create a table using the stored estimates from above

estimates clear // clear the estimates from memory 

// Estimate model 2 and store it. This time --  give it a name (m2).  
eststo m2: reg wage hours i.race i.collgrad tenure ttl_exp  i.married i.c_city i.union
/* Notice: 'qui' means "run the regression, but do not show the results." */
gen flag = e(sample) /* Indicator variable denoting which cases are included in 
					the regression. This will allow us to re-estimate model 1
					using the same cases that were used in model 2. */  

// Re-estimate model 1, but this time with the same cases as model 2
// And -- let's store the results 
eststo m1: reg wage hours i.race i.collgrad if flag==1

// Let's see how much the "hours" coefficient changes from M1 to M2
scalar bhrs1 = _b[hours] 

/* We need to get the coefficients for model 2, but those got overwritten when we 
estimated model 1. Fortunately, we can restore the estimates without re-running 
the model. */ 
estimates restore m2 // 
scalar bhrs2 = _b[hours] 

// Now -- we can perform our calculation. 
scalar diffhrs =bhrs2/bhrs1
di diffhrs
 
di "The hours coefficients decreases by " 100 - abs(round(100*`=diffhrs'), .01) ///
"% from model 1 to model 2." 

// Now, let's estimate a new model 1 that has only demographics, which can then 
// compare to the full model. Note -- it will save over the old "m1" results. 
eststo m1: qui reg wage i.race i.collgrad i.married i.c_city if flag==1

// Making tables 
esttab // notice the stored two models are included, in the order they were saved. 

esttab m1 m2 // Changing the order of how the models appear in the table 

// SE's instead of T-stats; changing column names
esttab m1 m2, se mtitle("Model 1" "Model 2") nonumber 

// Wide Format 
esttab m1 m2, se mtitle("Model 1" "Model 2") nonumber wide 

// Dropping the base categories, and using the variable labels
esttab m1 m2, se mtitle("Model 1" "Model 2") nonumber nobase label 

// Keeping only certain variables 
esttab m1 m2, se mtitle("Model 1" "Model 2") nonumber nobase label /// 
		keep(_cons 2.race 3.race) 
		
// Dropping certain variables 
esttab m1 m2, se mtitle("Model 1" "Model 2") nonumber nobase label /// 
		drop(1.c_city 1.married) 
		
// Adding fit statistics 
esttab m1 m2, se mtitle("Model 1" "Model 2") nonumber nobase label ///
	r2 ar2 
	
// Re-formatting the numerical fields that are presented (slopes and the fit statistics) 
esttab m1 m2, b(%8.2f ) se mtitle("Model 1" "Model 2") nonumber nobase label ///
	stats(r2 r2_a N, fmt(%8.3f %8.3f %8.0fc)) 
	
// Adding Titles and notes
// Adding more fit statistics, and changing their labels  
esttab m1 m2, se mtitle("Model 1" "Model 2") nonumber nobase label ///
	stats(r2 r2_a F rmse N , fmt(%8.3f %8.3f %8.3f %8.3f %8.0fc) ///
	label("R Sq." "Adj. R Sq." "F Test" "RMSE" "n=")) ///
	title("Table 1: Wages Predicted by Demographics and Work Characteristics") ///
	note("Note: Standard errors in parentheses. Coefficients are unstandardized.") 
 
// Reordering, renaming variables, and adding lines to the table  
esttab m1 m2, se mtitle("Model 1" "Model 2") nonumber nobase  ///
	stats(r2 r2_a F rmse N , fmt(%8.3f %8.3f %8.3f %8.3f %8.0fc) ///
	label("R Sq." "Adj. R Sq." "F Test" "RMSE" "n=")) ///
	title("Table 1: Wages Predicted by Demographics and Work Characteristics") ///
	note("Note: Standard errors in parentheses. Coefficients are unstandardized.") ///
	varwidth(25) /// /* increases the variable column so that labels don't wrap */ 
	varlabel( ///
	hours  "  Hours Wrk." ///
	2.race "  Black" /// 
	3.race  "  Other Race" /// 
	1.collgrad "  College Graduate" ///      
	tenure "  Job Tenure (Yrs.)"    ///       
	ttl_exp "  Total Experience" ///         
	1.married  "  Married"  ///             
	1.c_city "  Central City" ///
	1.union "  Union Worker" ///          
	_cons "Intercept") ///
	order(2.race 3.race 1.collgrad 1.married 1.c_city tenure ttl_exp hours /// 
	1.union _cons) ///
	refcat(2.race "Race (White Omitted)" 1.collgrad "Other Demog." /// 
	tenure "Worker and Job Traits", nolabel)  
	/* Added lines in the table */ 
								
// Saving as an .rtf file (which can be opened in Word) 
esttab m1 m2 using table1.rtf, replace /// 
	se mtitle("Model 1" "Model 2") nonumber nobase  ///
	stats(r2 r2_a F rmse N , fmt(%8.3f %8.3f %8.3f %8.3f %8.0fc) ///
	label("R Sq." "Adj. R Sq." "F Test" "RMSE" "n=")) ///
	title("Table 1: Wages Predicted by Demographics and Work Characteristics") ///
	note("Note: Standard errors in parentheses. Coefficients are unstandardized.") ///
	varwidth(25) /// /* increases the variable column so that labels don't wrap */ 
	varlabel( ///
	hours  "  Hours Wrk." ///
	2.race "  Black" /// 
	3.race  "  Other Race" /// 
	1.collgrad "  College Graduate" ///      
	tenure "  Job Tenure (Yrs.)"    ///       
	ttl_exp "  Total Experience" ///         
	1.married  "  Married"  ///             
	1.c_city "  Central City" ///
	1.union "  Union Worker" ///          
	_cons "Intercept") ///
	order(2.race 3.race 1.collgrad 1.married 1.c_city tenure ttl_exp hours /// 
	1.union _cons) ///
	refcat(2.race "Race (White Omitted)" 1.collgrad "Other Demog." /// 
	tenure "Worker and Job Traits", nolabel) 
	
/* Note: the 'replace' command will overwrite this file, if it already exists. 
You can also save the output as an Excel file by simply using the .csv or .xls 
extension (i.e.,  ... using table1.csv, replace ... ). A hyperlink will appear in 
the viewer window in Stata when an external file is created. If you want to 
open an .rtf file as a Word document, just open the file directly in Word. 
The hyperlink will likely use a text editor. */

// A few more things 
// What estimates are currently stored in memory? 
estimates dir 

// Notice you can clear on the link in the "command" window and "replay" them.
// Or you could replay them with the following syntax: 
estimates replay m1  

// Troubleshooting 
/* Adding to option "noisily" in your esttab command (e.g., esttab, noisily) will prompt
Stata to print the "under the hood" syntax for your table. This is a good way 
to figure out how to get what you want for your table, without spending hours 
searching on the web for the code. */ 

// How do I clear the estimates in stored in memory? 
// -->  The command "estimates clear" will delete your estimates from memory. 

/* In closing, there is a lot more to learn about how to edit regression tables 
with 'esttab.' Hopefully, this should be enough to get you started. 
I should note there are other user written programs for creating tables in 
Stata: e.g., putdoc, asdoc, outreg2, etc. I suggest picking one program 
and focus on becoming an expert in that particular one. Personally -- I like 
'esttab' b/c that's what I learned and it works very well (in most contexts). 
But it couldn't hurt to explore the others too, if you are new to Stata. */ 

log close 
exit
