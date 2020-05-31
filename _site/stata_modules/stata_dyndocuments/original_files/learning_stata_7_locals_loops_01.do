capture log close 
log using output/learning_stata_7_locals_loops_01.log, replace text

/*************************************************************************
	Do file: learning_stata_7_locals_loops_01.do 
	
	Note: Tips on how to use locals and loops to make your code less 
	error-prone, more parsimonious, and easier to edit/troubleshoot.  
 
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

*****************
*** LOCALS ******
*****************

/* Locals: A local is a macro, which is a shortcut that assigns a number or a 
text string to substitute where the abbreviation appears. A local can be a 
number, or a string of text (which can go in parentheses, if you want to include
spaces).   

Locals are defined with the command 'local', and then can be inserted later in 
the do file, between single quotes. IMPORTANT! The left single quoute is the 
character (`) that appears with the tilda (~) key on your keyboard. The right 
single quote is the apostrophe ('), which appears with the double quoute (") key 
on your keyboard.   
*/

// Locals with numbers 
local x 1 // Defines x as the number 1. 
di `x' // whatever x is defined is substituted inside the open apostrophes. 
di 1 + `x' 
di `x'^2

local x = `x'+1 // Redefining x 
di `x' 
di `x'^3 

// Locals with text strings (inside parentheses) 
local x "statistics!!" 
di "I love `x'" 

// Notice how I extend the local by repeatedly inserting it within itself! 
local x "I" 
local x "`x' love" 
local x "`x' statistics" 
local x "`x' -- A LOT!!"  
di "`x'"

use data/crime_states_1960.dta, clear 

// Using locals to define variables for a regression
local y "crimerat" 
local x "educ police59 males i.south"

reg `y' `x' 

/* 
** A CAVEAT ABOUT LOCALS ** 

It is important to note that locals stop working when your do file has 
finished running. Thus, if I run this do file, and then typed "reg `y' `x' " in
the command line in Stata, I would get an error message. That's b/c Stata has 
nothing to insert for the two locals, and would think that I simply typed "reg" 
which would produce an error. 

** MACROS ** 

You can define macros are more permanent than a local, which is called a global. 
Globals work the same as locals, except that they don't dissappear after the 
do file has been run. Here is an example: 

global y "crimerat" 
global x "educ police59 males i.south"

reg $y $x 

The dollar sign ($) tells Stata to insert a global. 

Now,if I run this do file, and then typed "reg $y $x " in the command line in 
Stata, it would work! That's because globals don't disappear when the do file is 
finished. This can create problems when working with multiple do files, so I
generally avoid globals, and use locals. To clear all of the macros (locals 
and globals) from memory, type 'macro drop _all' (see line 15 above).  
*/ 

*****************
*** LOOPS  ******
*****************

/* Loops: Loops tell Stata to repeat a set of operations multiple times, 
while each time substituting a new piece of information from a list. It works 
similarly to a local, in how it is defines and substitutes numbers and text 
strings. */ 

foreach x in 1 2 3  { 
di `x' 
	} 

foreach x in "1 2 3" "4 5 6" "Woohoo!" { 
di "`x'" 
	} 

// Loops within loops 
foreach x in 1 2 3 { // start loop 1 
foreach p in 1 2 3 { 
di `x'^`p' // Raising x to p power 
	}
	}
	
// Combining locals and loops 
// Estimating 3 regressions in one loop, storing the results for a table 
local n 1 
foreach x in "educ" "educ police59" "educ police59 males" { 
eststo m`n': quietly reg crimerat `x'
local n = `n'+1 
	}  
esttab 

eststo clear 
local x "educ police59 males maleteen nonwhite i.south "
local n 1 
foreach y in crimerat labor unemp1 median { 
eststo m`n': quietly reg `y' `x'
local n = `n'+1 
	}  
esttab 

// Loops within loops 
// Estimating two sets of regressions, one for non-South, one for South 
eststo clear 
local n 1 
foreach f in 0 1 { // start loop 1 
foreach x in "educ" "educ police59" "educ police59 males" { // start loop 2 
eststo m`f'_`n': qui reg crimerat `x' if south==`f'
local ++ n // This command increases "n" from its current value by one. 
	}  // end loop 2 
	}  // end loop 1 
esttab m0_* // Non-south table 
esttab m1_* // South table 

// Saving graphs 
local n 1
foreach x in educ labor unemp1 median { 
twoway (scatter crimerat `x') (lfit crimerat `x'), ///
saving(output/g`n'.gph, replace) 
local ++ n 
	} 

// Using if statements to define locals within a loop
// This nifty trick allows you to change things as you go through your loops. 
// I will change the title for the graph that I create with my loops.
local n 4
foreach x in educ labor unemp1 median { 
if "`x'"=="educ" local t "Education" 
if "`x'"=="labor" local t "Labor Force Participation"
if "`x'"=="median" local t "Median Fam. Income" 
twoway (scatter crimerat `x') (lfit crimerat `x'), ///
title("Crime Rate and `t'") ///
saving(output/g`n'.gph, replace) 
local ++ n 
	} 
	
/* Note: I could have accomplished the same results above by using if statements
conditional on "n" instead of "x" -- can you figure out how? */ 
	
/* Why use loops? Because a loop provides fewer chances for errors (since there 
is less code), and it is easier to edit. Let's say that I want to alter the 
independent variables in the regression in line 145 above. I can easily do that 
by editing line 144. Without a loop, I would have to change a lot more lines 
of code, and introduce the chance for more errors. 
	
log close 
exit
