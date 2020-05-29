---
author: 
    - Bill Carbonaro
    - Christopher Carbonaro
title: "4: Working with .do files and writing style"
layout: home
---

# What do you mean by 'writing style?'

When we write prose, we adhere to certain conventions which make our content easier for others to read. For example, we break up sentences with punctuation, separate ideas with paragraphs, etc. There are ways for you to make your `.do` files easier to read, too. This lesson will discuss several methods of doing this.

You may be wondering: "But who is going to read my `.do` files?" *You* will. If you ever want to use your methods from your previous work in your future work, you will want to know quick and reliable ways of accomplishing your objectives. However, if your code is incomprehensible, you will find yourself wasting time. Consequently, it is important to properly organize your information and make it easy to understand.

# The start of your file

## Logging your output

We will discuss `.log` files in more detail in a future lesson. However, you should get in the habit of starting all of your `.do` files with the following commands:

```stata
capture log close 
log using output/the_name_of_my_do_file_01.log, replace text
```

These commands will ensure that your output is saved after your commands are run.

## Recording personal information

You should create a pseudo-header at the top of your file to record information about the file. This will help you remember its purpose and give you credit if you distribute it to others. I recommend the following template.

```stata
/*************************************************************************
	Do file: my_do_file_name_01.do 
	
	Note: 	Data manipulation and recoding. 
 
	Author: Bill Carbonaro
*************************************************************************/
```

## Setting your initial preferences

Stata does not remember most previous settings you may have specified in previous sessions. Consequently, I recommend including the following settings beneath your log commands and personal information:

```stata
// Always include the following commands in your do-files: 

version 15.1 		// Tells Stata which version to run 
clear all 			// Clears all saved scalars, locals, etc.  
macro drop _all		// Clears any saved macros from memory
set linesize 100 	// Formats the output 
set more off 		// Turns off the "-more-" option in the output window
```

## Start of commands

Finally, for visual clarity, I recommend including a pseudo header which indicates the 'true' start of your `.do` file. An example might look like this:

```stata
**************************
***COMMANDS BEGIN HERE ***
**************************
```

# Using headers to divide content

Just as you used a header to specify where your commands began, use headers to specify groups of commands within your document. This will make it easier to see which commands relate to each other. For example:

```stata
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
```

## Comments as commands

I will violate this maxim in these lessons for didactic purposes, but *in general*, your comments should specify *what* you are doing. You can think of this as writing commands, or beginning with verbs: "Create a new variable," "Regress X on Y," "Save the graphic," etc.
