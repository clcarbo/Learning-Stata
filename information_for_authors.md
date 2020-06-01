---
author: Christopher Carbonaro
title: Information for Authors
layout: home
---

# How to write new pages

New pages on the website are made by creating new markdown files. Jekyll will automatically convert them into HTML pages for you.

Note: in order to publish any files, you will need to be granted permission to do so by one of the project owners. 

## Where to write new pages

Navigate to the folder on your computer which contains the website files. If you want to create a new markdown file with Stata examples, make a new `.domd` file in the `/stata_modules/stata_dyndocuments` directory. If you do not need to run any Stata commands, you can just make a `.md` file in the `/stata_modules` folder.

## How to format your file

### The header

*Your file must begin with the following lines:*

```
---
title: "My example title"
author: Joe Smith
layout: home
---
```

You can add any other header information you desire, but you must include the `layout: home** line if you want the page to be formatted correctly.

*N.B. Capitalizing the keywords in the header will prevent things from working properly.* In other words, DO NOT write `Title: My title`.

### The rest of the file.

Write your document with typical markdown syntax. Remember to surround your `<<dd_do>>` tags with markdown 'verbatim' ticks or tildes (`~`). They should look like this:

~~~~
```stata
<<dd_do>>
sysuse example.dta
<</dd_do>>
```

~~~stata
<<dd_do>>
sysuse example.dta
<</dd_do>>
~~~
~~~~

## Converting your `.domd` files

Once you have written the file, use Stata to transform the `.domd` file into a markdown file. To do this, run:

```stata
dyntext my_input_file.domd, saving(../my_output_file.txt)
```

**The `../` part of the `saving()` command is really important.** This tells Stata to save the output file in the `/stata_modules` folder, which will cause Jekyll to automatically update its dropdown menus and table of contents.

# How to publish new or changed pages

1. Open a terminal prompt:
   * If you are using a Mac, click on the search bar icon and type in "Terminal"
   * If you are using Windows, open either `cmd` or `PowerShell`. You will probably need to install `Git`. You can download the program and find lots of instructions [here](https://git-scm.com/).
   * If you are using Linux, there are a ton of options available to you and you probably already know how to do this
   
2. Navigate to the folder containing the website folders and `git` project by using the `cd` command.
   * `cd` stands for "Change Directory." If you are in a folder titled "folder-1" and there is a folder within it called "folder-1-a" you can switch to it by typing `cd folder-1-a`. If you need to go "up" a folder level, type `cd ..` (two periods).
   * You can type `ls` at any point to see what is in the directory/folder you are currently in.
   
3. (Optional) Type `git status` to see which files you have changed.
4. Type `git add stata_modules/myfile.md` to add just one file to the staging area, or type `git add .` to add all changed files to the staging area.
5. (Optional) Type `git status` to see which files have been staged.
6. When you are happy with your files, type `git commit` and hit enter.
   * When you do this, the text editor `Vi` will ask you to type in a message. The first line will be the title, and anything after that will be optional information. To type, press `i` or `a` to be able to type in text. A message might look like this:
   
     ```
     Added a new lesson about macros
     
     Here is an additional note.
     # Please enter the commit message for your changes. Lines starting
     # with '#' will be ignored, and an empty message aborts the commit.
     #
     # On branch master
     # Your branch is up to date with 'origin/master'.
     #
     # Changes to be committed:
     #    new file:   information_for_authors.md 
     #
     ```

   * When you have finished your message, hit `esc` (escape) and then type `:wq` to write and quit. Hit enter.

7. To put them online, type `git push origin master`. Enter your GitHub information, and if you have access to the project, your pages will automatically be published!
