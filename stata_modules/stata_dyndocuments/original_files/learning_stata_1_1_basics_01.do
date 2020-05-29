/* This a "do file" (which has a '.do' file extension). Do files contain 
instructions (or "commands") for Stata to execute. The commands in a do 
file are inert. Typing commands in a do file does nothing, until you highlight 
them and run (or "do") them. At that point, they are submitted to the 
"command" prompt in Stata, and they are executed in the order that they are 
submitted. You should go ahead and run this do file. Just "select all" 
("ctrl" + "A" in Windows, or "command" + "A" in Mac O/S, then click the "do" icon
in the top right corner.  The results will appear in the "Results" window in 
Stata. 

To this point in the do file, none of the text is considered to be a command by 
Stata. It is just text. This is because I opened this do file (see line 1) 
with a "/" followed by a "*" (no space). This character combination tells 
Stata that the text that follows is not a command. To help the reader 
distinguish between non-exectuable text and commands, it makes the non-executable 
text green (in the do file editor). Within the do file editor, you will see that 
commands in a do file are presented in colors other than green. At the end 
of this sentence, I will turn off the commenting with an "*" and a "/", which 
will mean that Stata will treat the text on the next line as a command. */ 

sysuse auto.dta 

/* The text above is a command. Notice that the text appears as blue and black. 
It tells Stata to open data set that is stored internally within the program. 
'Sysuse' is the command, and 'auto.dta' is the name of the data set. Stata data 
sets are saved with a '.dta' extension. 

When you are finished with a command, you must include a carriage return ("enter"),
which ends the line and tells Stata the the command is complete. Note that empty 
lines (such as 20 and 22) can be included.

What is this "auto" data set? Let's find out. */ 

notes 

/* This command displays any notes about the data set that have been stored. 
If we look at the "Results" window in Stata, we will see that Stata returned 
some information regarding where the data come from. Let's add a note to remind
ourselves that the data was collected in 1978. */ 

note: The data are based on automobiles that were produced in 1978.

notes 

/* Notice how the new note has been added to our data set. This is useful to 
keep track of specific things that are important to document about your data. 
Keep in mind we would have to save our data set for new to be stored permanently. 
More about that later. Let's learn some more about our data set. */ 

codebook  

/* If we scroll through the "Results" window, we will see that this command 
returned detailed information about all of the variables in this data set. 
We can also get a more minimalist version of the codebook. */ 

codebook, compact 

/* This is much easier to process, IMHO! Notice that I inserted a comma before 
adding 'compact.' In Stata syntax, a comma denotes options that can be enacted 
within specific commands. We can also specify a subset of variables using the 
codebook. */ 

codebook mpg price trunk foreign, compact  

/* Finally, here a 3rd way to learn about the variables in your data set. */ 

describe 

/* What is the average mpg and price for cars in our data set? */ 
 
summarize mpg price // summary statistics for the 'mpg' variable 

/* Do you want to know more about the 'summarize' command? */ 

help summarize // Notice - a separate help window opens. 

// In Stata, you can leave notes in three ways. In the command above, we used 
// double backslashes after entering a command. Thus, a command and a note 
// can exist on the same line. But the command must always precede the comment.
// It is important to note that, when using "//" for comments, it is turned off 
// when you enter a carriage return and start a new line. That's why this section 
// has to start with "//" on each line (unlike using "/* . . .  */" 
// for commenting, which is much better for long notes like this).  

* Also - you can begin a line with one or more asterisk to start a note. 
** See! This is a note too! 
	*** So is this! Note how I used a tab to start the line -- that's OK. *** 
* But asterisks can only trigger comments when they BEGIN a line (unlike the "//").
* More on that later.   

/* Let's finish up by making a graph. */ 
scatter mpg price 

/* Notice that the graph does not appear in the "Results" window. Instead, there
is a separate window where graphs appear, and can be edited. More later. 

Finally -- we are done with our analyses. When we close Stata, our output 
in the "Results" window will not be saved, and our graph will disappear. That's 
OK -- we can just open our do file, and re-run it and get the same exact output. 
*/ 

exit 


