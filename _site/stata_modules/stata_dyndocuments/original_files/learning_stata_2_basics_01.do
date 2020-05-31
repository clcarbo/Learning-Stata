/* In our first do file, there was no record of our output. It appeared in our 
"Results" window, and then disappeared when we closed Stata. To save the output,
and the commands that we submitted, we can open a log file in Stata. Every do 
file should have a log file, because it will serve as a back-up record of the do-file 
as well as your results. Note -- graphs will not appear in the log file. More 
on that later. Do files should always begin by opening a log file. 

In Stata, there are two types of log files: "log" and "command." "Log" files 
save both your commands and your output (i.e., what appears in the output 
window). The "command" log file only stores your commands. This is very nice 
b/c it essentially creates a backup of your do file! Which -- trust me -- 
can be really helpful if something goes awry! You can include both in the same 
do file. That's what I do below. 

IMPORTANT! Log files can "opened" and "closed" (also suspended) in your do files.  
The simplest and safest approach is to open the log file at the beginning of the 
do file and then close it at the very end. That way, everything is saved. 

However -- you need to include the following lines (29 and 30) to start your do files. 
If you try to open a log file when one is already open, you will get an error. Thus -- 
'log close' takes care of that potential problem. However -- that command 
will give you an error if a log file is not open! GRR! Here -- 'capture' comes 
to the rescue! Entering this command at the beginning of the line tells Stata 
'if this command returns an error, just keep going!'

FINALLY -- I always give my log files the same names as my do files. That way, 
I always know which do file created a given log file.  */ 

capture log close 
capture cmdlog close
log using output/learning_stata_2_basics_01.log, replace text
cmdlog using output/learning_stata_2_basics_01cmd.log, append

sysuse census.dta, clear 

***********************
** GENERATING OUTPUT ** 
***********************

// Explore the data 
/* Let's learn about the variables in our data set. These two commands 
('describe' and 'codebook') will show us detailed information about 
each variable in the data set. */ 

describe // Provides information for all the variables in your data. 
describe death divorce  // describes a subset of variables. 

/* You can also describe data sets without opening them. This is especially 
handy with big data sets that take a long time to load and take up a lot of 
memory. */ 
desc using data/crime_states_1960.dta

/* Codebook gives you some summary statistics in addition to labels.  */ 
codebook // all variables 
codebook, compact // a more concise format
codebook death divorce, compact // limited to the variables that you list 

// Create a table 
tabulate region // basic cell counts 
tab region, nolabel // Reveals the numeric values assigned to the categories 

// Get basic descriptives 
summarize 
summarize pop, detail // more detailed output 

****************************
** CONDITIONAL STATEMENTS **  
****************************
/*  Stata will run commands that are specific to subgroups that are defined by 
logical statements. For example, let's say that we want to know which states 
have a population less than one million. We can tell Stata to list the names of 
those states that meet that condition by using an 'if' statement. */
list state pop if pop<1000000
 
/* We could ask for the average population for Southern states. "South" is 
assigned'3' Or, the average  deaths in small states (less than a 1 million in 
population). */
sum pop if region==3 // Notice "equals" is "==" in Stata. 
sum death if pop<1000000

/* We can also create joint conditions. */ 
sum pop if region==3 & medage>30 // Both conditions have to be met. 

/* Either/or conditional statements work too. For example, we can specify 
West or South. */
sum pop if region==3 | region==4

/* We can also exclude certain groups. In this case, we will include all states 
but Southern states. */ 
sum pop if region~=4 // ~= means "not equal to." != also means "not equal to."

****************
** BY GROUPS ***
****************
// We could do the following to get mean population by region. 
sum pop if region==1
sum pop if region==2
sum pop if region==3
sum pop if region==4

// Or we could ask Stata to do this for us in one command. 
by region, sort: sum pop
by region, sort: sum pop medage death divorce 

*******************
** USING SCALARS **
*******************

/* What if we want to estimate the number of deaths for states with that have 
populations that are above average? First, we estimate the mean population. Then, 
we can save that value as a scalar. Then, we can use an if statement to create 
a conditional command.  */

// STEP ONE: estimate the average population 
sum pop 

// STEP TWO: List stored values (optional), and save the estimate as a scalar. 
return list /* This will list the values from the prior command that Stata has 
stored in memory, and indicates how to reference them. We want 'r(mean)' which 
is the mean. */

display "The mean population of the 50 states is " r(mean) 

/* This value is stored temporarily. If we re-estimated 'sum' for a different variable, 
r(mean) will be overwritten. We can create a scalar in Stata that will permanently store 
this values in Stata, until we clear it from memory. */
 
scalar popmean = r(mean) // Stores the mean as a scalar called 'popmean' 
scalar popsd = r(sd) // Stores the SD as a scalar called 'popsd'
scalar dir // lists all stored scalars  

display "The mean population of the 50 states is " `=popmean' ///
" and the S.D. is " `=popsd'

// STEP THREE: Use scalar to select cases. 
sum death if pop>`=popmean'

// We can use stored scalars to do math!  
scalar hipop = `=popmean'+(.5*`=popsd') // State population that is 0.5 SD above the mean
scalar lopop = `=popmean'-(.5*`=popsd') // State population that is 0.5 SD below the mean

list state pop if pop>`=hipop' | pop<`=lopop'

sum death if pop>`=hipop' // Av. deaths for high population states 
sum death if pop<`=lopop' // Av. deaths for low population states 

/* Now we will close the log files and exit. All of our commands and output will 
be stored in the saved log file. */ 

log close 
cmdlog close 
exit 


