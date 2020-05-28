---
author: Bill Carbonaro
title: "Learning Stata 1-2: Basics"
layout: home
---

# Working directories and file paths 

In our first do file, we used a data set that is stored internally in Stata. We can load it by using the `sysuse` command. The following command will list all of the stored data sets that are installed with Stata. 

```stata
sysuse dir 
```

What if we want to use our own data file that is not installed with Stata? We employ the `use` command to load it, but first we need to be sure that Stata knows where to find this file. 





## What are directories?

You can think of directories as places on your computer where you store information. Most people tend to navigate through their computer's directories by clicking on folders in a file explorer. Directories are also sometimes called "paths" because they tell your computer how to find a file.

For example, say that my computer has one folder on my desktop, which contains three folders. The paths, or directories, might look like this: 

```
C:/Desktop
C:/Desktop/myfiles
C:/Desktop/myfiles/data
C:/Desktop/myfiles/do_files
C:/Desktop/myfiles/output
```

If you are using a Unix-based computer (e.g. a Mac or a Linux device), your directories probably begin with a forward slash instead of `C:`, like this:

```
/Desktop
/Desktop/myfiles
/Desktop/myfiles/data
/Desktop/myfiles/do_files
/Desktop/myfiles/output
```




## Working directories

Your "working directory" can be understood as the de facto location on your computer from which Stata will begin to look for files. Every time you open Stata, you must be aware of what the working directory is. I guarantee that the most common error that will arise when running do files!

Let's say that I have stored a data file (data1.dta) in my "data" folder. How do I open it when writing my do file? I could type: 

```stata
use data1.dta  
```

That could work, but ONLY IF the working directory is set to the right location. If your working directory is set to "C:/Desktop" then Stata will return an error message saying it can't find the file. Why? Because you asked it to find "C:/Desktop/data1.dta" which is not where the file is. The correct path and file name is: "C:/Desktop/myfiles/data/data1.dta", which is not what you entered. 

One solution is to describe the "absolute path" for Stata. An absolute path describes *exactly* where the file is on your computer. For example, if you had typed the following, you would not have received an error message: 

```stata
use "C:/Desktop/myfiles/data/data1.dta"
```

Great! But . . . this approach probably will not work if you use multiple computers (e.g. you use cloud storage, you get a new computer every few years, you are working with collaborators, etc). Thus -- using the full file path and file name is not a foolproof approach. 

Instead, you should create a directory structure with a common "base" and then set that base directory as your "working directory" when you open Stata. Looking at my directory structure above, you can see that I have a base directory, which serves as a main folder that holds several subfolders used to organize my files: "C:/Desktop/myfiles". If I set my working directory to that folder, then I can access and save to the subfolders that are nested within it. 



### What is my current working directory?

How do you know what your working directory is in Stata? The WD is listed on the bottom bar of the screen (below the command line). You can also print the directory by using the command `pwd`, which stands for "print working directory."



### How do I change my working directory?

The easiest way to set your working directory is to use the drop down menu -- the only time I will ever advocate using it in Stata! 

```
File -> Change working directory. [Select the correct working directory.] 
```

It is easy and foolproof. You can also use the command `cd`, which stands for "change directory." For example, you might type the following:

```stata
cd "C:/Desktop/myfiles"
```






## Using your own data

Now that my working directory is set to my desired location, I can open my data file by specifying the correct folder and file name. I include the following command in my do file: 

```stata
use data/data.dta // Notice - 'use' not 'sysuse' 
```

If I want to save a graph, I can save it to the "output" folder (in my base directory) by including the correct path (from the working directory). Note that you could label this folder anything you want, such as "graphics". For example:

```stata
graph mpg, saving(output/graph1.gph) 
```

If I hadn't specified the "output" folder as the destination for the file, Stata would have saved the graph in the working directory (`C:/Desktop/myfiles`). 

For these tutorials, I have created a dir structure for you that resembles the one above: 

```
learning_stata
learning_stata/data
learning_stata/do_files
learning_stata/output
```

You need to copy and paste the `learning_stata` directory to your hard drive. The base directory is `learning_stata`, so you will need to set Stata to that as the working directory for all of the do files to run without errors. 
