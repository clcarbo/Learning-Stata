/* WORKING DIRECTORIES and FILE PATHS 
In our first do file, we used a data set that is stored internally in Stata. 
We can load it by using the "sysuse" command. The following command will 
list all of the stored data sets that are installed with Stata. */ 

sysuse dir 

/* What if we want to use our own data file that is not installed with Stata? 
We employ the "use" command to load it, but first we need to be sure that Stata 
knows where to find this file. 

Every time you open Stata, you must be aware of what the "working directory" is. 
I guarantee that the most common error that will arise when running do files! 

Let's say that my computer has one folder on my desktop, 
which contains three folders: 

C:/Desktop
C:/Desktop/myfiles
C:/Desktop/myfiles/data
C:/Desktop/myfiles/do_files
C:/Desktop/myfiles/output

Let's say that I have stored a data file (data1.dta) in my "data" folder. 
How do I open it when writing my do file? 

I could type: 

use data1.dta  

That could work, but ONLY IF the working directory is set to the right location. 
If your working directory is set to "C:/Desktop" then Stata will return an error 
message saying it can't find the file. Why? Because you asked it to find 
"C:/Desktop/data1.dta" but that path is invalid. The correct path and file name
is: "C:/Desktop/myfiles/data/data1.dta", which is not what you entered. 

If you had typed the following, you would not have received an error message: 

use "C:/Desktop/myfiles/data/data1.dta"

Great! But . . . this approach will probably not work if you use multiple computers 
(i.e., you use cloud storage, you get a new computer every few years, or you are 
working with collaborators). Thus -- using the full file path and file name is not 
a foolproof approach. 

Instead - you should create a directory structure with a common "root" and then
set that root directory as your "working directory" when you open Stata.   
Looking at my directory structure above, you can see that I have a root directory, 
which serves as the main folder that holds all of subfolders for retrieving 
and storing files: "C:/Desktop/myfiles". If I set my working directory to that 
folder, then I can access and save to the subfolders that are nested within it. 

How do you know what your working directory is in Stata? The WD is listed on the 
bottom bar of the screen (below the command line). The easiest way to set your 
working directory is to use the drop down menu -- the only time I will ever 
advocate using it Stata! 

File -> Change working directory. [Select the correct working directory.] 

It is easy and foolproof. 

Now that my working directory is set to the root directory, I can open my data 
file by specifying the correct folder and file name. I include the following 
command in my do file: 

use data/data.dta // Notice - 'use' not 'sysuse' 

If I want to save a graph, I can save it to the "output" file 
(in my root directory) by including the correct path (from the working directory).
For example:

graph mpg, saving(output/graph1.gph) 

If I hadn't specified the "output" folder as the destination for the file, 
Stata would have saved the graph in the working directory 
("C:/Desktop/myfiles"). 

For these tutorials, I have created a dir structure for you that resembles
the one above: 

learning_stata
learning_stata/data
learning_stata/do_files
learning_stata/output

You need to copy and paste the "learning_stata" directory to your hard drive. 
The root directory is "learning_stata" so you will need to set Stata to that 
as the working directory for all of the do files to run without errors. */ 
