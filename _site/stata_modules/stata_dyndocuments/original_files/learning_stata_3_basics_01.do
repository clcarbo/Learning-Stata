// You should always start every do-file with the following commands:

capture log close 
log using output/learning_stata_3_basics_01.log, replace text

/*************************************************************************
	Do file: learning_stata_3_basics_01.do 
	
	Note: 	Data manipulation and recoding. 
 
	Author: Bill Carbonaro
*************************************************************************/

// Always include the following commands in your do-files: 

version 15.1 		// Tells Stata which version to run 
clear all 			// Clears all saved scalars, locals, etc.  
macro drop _all		// Clears any saved macros from memory
set linesize 100 	// Formats the output 
set more off 		// Turns off the "-more-" option in the output window

**************************
***COMMANDS BEGIN HERE ***
**************************

sysuse auto.dta 

********************************
** DROPPING/KEEPING VARIABLES **
********************************

drop mpg price // drop these two variables 
keep foreign trunk // keep only these two variables 
keep if foreign==1 // keep only cases where the condition is met 

codebook 
tab foreign 
sum trunk 
clear // deletes the data set from memory 

sysuse auto.dta // load the data; note - we didn't save, so none of the 
				// above changes were kept!! 

******************************************
** RE-LABELING VARIABLES AND CATEGORIES **
******************************************

/* As a general rule, you should create a new variable when changing or recoding 
a variable, and leave the original intact. That way, you can always return 
to the original variable, if needed. Let's say we want to make some changes 
to the variable "foreign" in the data set. */

tabulate foreign // ''tabulate' can shorten to 'tab' 
generate foreign2 = foreign // 'generate'g can be shorted to 'gen' 
describe foreign2 
tab foreign2 
clonevar foreign3 = foreign // This will create an exact copy of the original variable 
desc foreign3 
tab foreign3 
tab foreign3, nolabel // this will show the numeric values assigned to each category
				  // without the labels attached. 

/* Let's change the variable 'foreign2' so that the values are increased by '1'. */ 
recode foreign2 (0=1) (1=2) // In parentheses, the original value comes first, 
						// and the new value comes 2nd. 
tab foreign2 // notice: there are no labels b/c we haven't added them yet. 

/* More interesting: let's create a variable that is focused on "domestic" cars 
as the reference category. */ 
recode foreign2 (2=0) // We make 'foreign' the lower category. 
					// Notice -- we keep domestic as is (equal to '1'). 
tab foreign2 

/* Now, let's relabel the variable and the categories. */ 
label variable foreign2 "Domestic Car" 
label define dom 0 "Foreign" 1 "Domestic" // defines a set of label values called 'dom' 
label values foreign2 dom // applies label 'dom' to the variable 'foreign2' 
tab foreign2 

// Let's rename our variable 'domestic', so we don't get confused. 
rename foreign2 domestic  
tab domestic 

/* Here is a more efficient way to create the "domestic" variable.  */ 
recode foreign (1=0 "Foreign") (0=1 "Domestic"), gen(domestic1) label(domlab) 
// Notice that we can include labels in this step! 
lab var domestic1 "Domestic Car"

 gr box mpg, over(domestic1) // notice labels carry over to graphs. 

/* An example with more categories, and ferwer steps. Let's condense the 
five category "repair record" variable into three categories. We will collapse 
the bottom two and top two categories.  */

recode rep78 /// 
		(1/2=1 "Poor") /// 
		(3=2 "Average") /// 
		(4/5=3 "Very Good"), ///
		gen(rep78_3cat) label(rep78_3cat) 
/* The slash indicates "# through #" (e.g., "1 through 2"). I could have also
written "recode rep78_3cat(2=1) (3=2) (4=3) (5=3)" and achieved the same result. */ 
la var rep78_3cat "Repair Record (3 category)" 
tab rep78_3cat

**************************************
** TRANFORMING CONTINUOUS VARIABLES **
**************************************

/* Use 'generate' to create new variables that are transformations of existing 
variables. */ 

gen wght_kgs = weight * 0.453592 // Transform 'weight' from pounds to kilograms
lab var wght_kgs "Weight (Kg.s)" 

gen price_2018 = price * 2.85 // Transform car from 1978 to 2018 dollars 
la var price_2018 "Price ($ 2018" 

gen price_lb = price/weight // Create a 'price per pound' variable 
la var price_lb "Price, per Lb." 

/* Let's recode a continuous variable in categories. Let's create a categorical 
"price" variable. In this case, let's create  quartiles (equally sized groups 
of 25%, from lowest to highest). */ 

xtile qprice = price, nq(4) 
la var qprice "Price (Quartiles)" 
la def qp 1 "Lowest Q." 4 "Highest Q." 
la value qprice qp 
tab qprice 

/* You can also create a variable that indicates the cut points between quartiles. */ 

pctile qprice_pct = price, nq(4) 
list qprice_pct if qprice_pct~=. 

/* Let's create a variable based on cutpoints that we find meaningful. */ 
gen price_cat = price 
replace price_cat=1 if price_cat<=5000
replace price_cat=2 if price_cat>5000 & price_cat<=10000
replace price_cat=3 if price_cat>10000
la var price_cat "Price (Categ.)" 
la define pcat  1 "Low Price (Less than $5K)" 2 "Med. Price ($5K to $10K)" ///
				3 "High Price ($10K+)" 
la val price_cat pcat 
tab price_cat 

/* We can also use properties of the distribution to recode variables, using scalars. 
Let's create a categorical variable of price that uses one-half standard deviation above 
and below the mean as the cutpoints for low and high price cars. */

gen price_hilo = price 
sum price 
return list 
scalar lo = r(mean)-(.5*(r(sd))) 
scalar hi = r(mean)+(.5*(r(sd)))
replace price_hilo=1 if price_hilo<= `=lo'
replace price_hilo=3 if price_hilo>= `=hi'
replace price_hilo=2 if price_hilo> `=lo' &  price_hilo< `=hi'
la var price_hilo "Price (3 categ.)" 
la define phl  1 "Low Price (1/2 S.D. below the mean)" 2 "Med. Price" ///
				3 "High Price (1/2 S.D. above the mean)" 
la val price_hilo phl 
tab price_hilo

log close
exit
