---
title: Using Stata and Markdown with Atom
author: Christopher Carbonaro
toc: True
layout: home
---

# Quickstart (or, 'Help, I dropped my computer in a cement mixer and I need this setup back! How do I get everything working?')

## Things You Need to Have Installed

- A working version of Stata
- To have [Python3](https://www.python.org/downloads/) installed on your computer
  - To have the [Jupyter Stata Kernel](https://kylebarron.dev/stata_kernel/getting_started/) installed on your computer
    - To do this (the link above also gives you instructions), open Terminal if you are using a Mac (you can look for it in the search bar) or Powershell if your are using Windows and enter the following commands:

      ~~~~{.bash}
      pip3 install stata_kernel
      python3 -m stata_kernel.install
      ~~~~

      Easy as that!
- [The text editor Atom](https://atom.io/)
  - To install the [language-stata](https://atom.io/packages/language-stata) package (Install packages by clicking on `Packages > Settings View > Install Packages/Themes`)
  - To install the [hydrogen](https://atom.io/packages/Hydrogen) package
  - Note: There ARE other solutions for text editors, but I won't dwell on that too much here. [Emacs](https://www.gnu.org/software/emacs/) (and my eldest son's favorite implementation of it, [Spacemacs](https://www.spacemacs.org/)) has a fantastic ecosystem for working with Stata. However, the learning curve for Emacs is much steeper. [RStudio](https://rstudio.com/) and its reproducible research tool, [RMarkdown](https://rmarkdown.rstudio.com/), also work with Stata; however, it implements a slightly different workflow. For those of you who want to get up and running with Stata as quickly as possible, Atom is the best solution.
- To have [Pandoc](https://pandoc.org/installing.html#macos) installed on your computer

## How to Produce Your Documents

Open Stata and use `cd` to change to the directory containing your `.domd` file. Run:

~~~{.stata .numberLines}
dyntext yourFileName.domd, saving(yourOutputFileName.md) replace
~~~

Now, open Terminal or Powershell and use `cd` to change to the same directory. It should now contain a `.md` file. For the most basic conversion, run:

```bash
pandoc -s -o yourOutputFileName.docx yourInputFileName.md
```

Remember, when working with Pandoc, you can reference any file on your computer. If you do not specify a directory, it will use the files in the directory within which you are currently working (you can always check which this is with the command `pwd`). However, you can also specify any file by writing the directory and file path e.g. `/User/SomeFolder/SomeFolder/YourFile.md`.

### Rendering Citations

You will need a [BibTex](http://www.bibtex.org/) or BibLaTeX file containing your citations. If you are using a different tool for citations, most let you easily export your entries to BibTex format. I recommend using [JabRef](https://www.jabref.org/) to easily manage your entries. See [Pandoc's section on citations](https://pandoc.org/MANUAL.html#citations) for including references in your document. Then, find the citation style file on [Zotero's repository](https://www.zotero.org/styles) and run:

```bash
pandoc -s -o --bibliography="the/Path/To/YourBibliographyFile.bib" --csl="/the/Path/To/YourCSLFile.csl" yourOutputFilePath.docx yourInputFilePath.md
```

### Producing Nice Webpages

Once you have processed your `.domd` file with Stata and produced a Markdown file, you can turn this file into a webpage. However, you will need to give Pandoc some custom CSS as well to style your content; otherwise, your content will not look very nice. You can either write your own CSS (which is beyond the scope of this primer), or download a simple one from the web. I use several which are [hosted on GitHub](http://markdowncss.github.io/). Once you have this file downloaded, run the following:

```bash
pandoc -s -o yourOutputFilePath.html yourInputFilePath.md --css="the/Path/To/YourCSSFile.css"
```

# Introduction (So, You're Sick of Copying and Pasting?)

I can't blame you.  But fear not: there is a better way. Stata now lets you combine the prose describing your research with your Stata commands via Markdown. This is similar to how RMarkdown enables reproducible research with [R](https://www.r-project.org/), but the implementation is slightly different. In this document, I'll give you an overview of Atom, Markdown, and how you can use these in conjunction with Stata. I will also include references to resources in case you ever want to dig a bit deeper or if I don't explain something very well.

# Welcome to Atom: Your New Text Editor

Wait, what even *is* a text editor? Good question. A text editor is just a program which lets you write files which people can read. They can write any kind of file, too; for example, you can create files which end in `.md` (which are Markdown files), but you can also create:

- `.do` files (Stata instructions)
- `.domd` files (Stata's file extension for Markdown files with Stata code)
- `.py` files (the file extension for Python files)
- `.R` files (files for R)
- `.C` files (source code for programs written in C)
- Pretty much anything else you can imagine

Although some text editors may be tied to another program, such as the text editor in Stata or RStudio, others are standalone programs. Popular standalone editors include Notepad++, Sublime Text, Vim, Emacs, Micro, and Atom. These editors are all extremely powerful and customizable. Additionally, they're all supported by communities of individuals who would rather die than use anything other than their favorite (my son refuses to write in any program which doesn't have a Vim emulator). Many of these editors are open source, which allows tech-savy individuals to extend what these editors are capable of doing. Note that these are distinct from word processors like Microsoft Word or Google Docs, which are frequently refered to as WYSIWYG (What You See Is What You Get) processors.

![Atom and Stata (taken from [the language-stata webpage](https://atom.io/packages/language-stata))](atom_stata_demo.gif)

## Working with Atom

If you open Atom, you should be greeted by the Welcome screen and the Welcome Guide. Most of the time, you'll want to open a project or install a package. You can do either of these things with the bar at the top as well. To open a file, use `File > Open...` or `File > Reopen Project`. For packages, use `Packages > Settings View > Install Packages/Themes`.

Most of the keyboard shortcuts you're familiar with should work similarly within Atom.

- Cmd-x cuts text
- Cmd-v pastes
- Cmd-c copies
- Cmd-z undoes whatever you just did

... etc. It has a robust find-and-replace feature too.

In addition, Atom can do lots of cool things which Word and Stata's editor *cannot* do. For example, Atom already organizes your open files like tabs on your web-browser, but it also lets you have multiple "Panes" open at once. You can think of panes as groups of tabs which you might want to view side-by-side. It also has autocompletion for your Stata code built-in.

At the *bare minimum*, you should have the following installed at this point:

- Python 3
- The Stata Jupyter Kernel
- The language-stata Atom package
- The hydrogen Atom package

If you do not have any of these installed, go back to the [Things You Need to Have Installed] section and install them now.

## Working with Pure Stata Code in Atom

You can write and execute code contained within your `.do` files in Atom. In addition, Atom will automatically give you syntax highlighting, auto complete, and more. Run your commands by highlighting sections of text (to run several lines of code) or placing your cursor within a line (to run a single line of code) and hitting `Shift-Enter`.

## Writing Markdown and Stata Code in Atom

To write a file which contains Markdown prose and Stata code, create a file in Atom with the extension `.domd` (i.e. "do-markdown"). When you open this file in Atom, you will see that any markdown you write will be colored so its elements are distinct and any Stata code you write will be syntax highlighted. Atom will also offer to complete your Stata commands for you.

### Executing Stata Code within `.domd` Files in Atom
To write Stata code in your `.domd` file, surround your Stata code with these tags:

```stata
<<dd_do>>
***WRITE YOUR COMMANDS HERE***
<</dd_do>>
```

You can then highlight your code and hit `Shift-Enter` to run the code automatically. Atom will display any output for you. You can use the `:quietly` option to prevent Stata from including the source code in the final document, like so:

```stata
<<dd_do: quietly>>
***WRITE YOUR COMMANDS HERE***
<</dd_do>>
```

Also, I **highly** suggest you surround your `<<dd_do>>` blocks with markdown blocks. This will prevent Pandoc from thinking text from your Stata output is being used to markup your document. To do this, write the following:

````markdown
```stata
<<dd_do>>
***WRITE YOUR COMMANDS HERE***
<</dd_do>>
```
````

If you write the word `stata` after your series of three back-ticks, Pandoc will highlight the final output with syntax highlighting in a similar manner to how Atom color-codes your commands. If you do not want the content to be highlighted, just omit the word `stata` (note that Pandoc can highlight *many* kinds of coding languages, not just Stata commands; see [Pandoc's section on code blocks](https://pandoc.org/MANUAL.html#verbatim-code-blocks) for more details). However, I strongly recommend you keep the back-ticks to avoid serious headaches down the line.

## Basics of Markdown

### Headers
A pound sign or hashtag (this symbol: `#`) at the beginning of a line demarcates a header. You can add subheadings by writing multiple hashtags at the beginning of a line (e.g. `## Heading 2`).

### Italics, Bold, Subscript, and Superscript

- *Italics* are surrounded by astrisks, like \*this\*
- **Bold text** is surrounded by two astrisks, like \*\*this\*\*
- Subscripts~like\ this~ are surrounded by tildes, like \~this\~
- Superscripts^like\ this^ are surrounded by carets, like \^this\^

### Paragraphs
New paragraphs are seperated by a blank line.
This is in the same paragraph as the previous line, even though it is on the next line in the original markdown file.

### Links
Links are easy: [here's a link to google](www.google.com). Links are written like this: \[Here's the text\]\(www.example.link\). You can also link to files.

### Section Links
[This should take you to the Basics of Markdown section][Basics of Markdown]. These are written with two pairs of brackets, like so: \[Here's the link\]\[Section name here\]

### Lists
You can write unordered lists like this:

~~~
* Item 1
* Item 2
  * Item 2.a
  * Item 2.b
* Item 3
~~~

You can also begin list items with a `-` or a `+`.

Ordered lists will be numbered automatically, so this:

~~~
1. Item 1
1. Item 2
1. Item 3
~~~

... will be printed like this:

1. Item 1
1. Item 2
1. Item 3

### Images
You can include images with the following syntax: `![](www.image.png)`. You can also link to images on your computer: `![Here's a caption](/sample_picture.png)`.

### ... And lots more
Markdown supports all kinds of other stuff:

- Term and definition pairs
- Custom tables
- LaTeX math equations (Writing in LaTeX is usually miserable, but writing math equations in LaTeX is amazing)
- Footnotes

For the sake of brevity, I'll stop here. When in doubt, check [Pandoc's](https://pandoc.org/MANUAL.html) section on Markdown. It will tell you anything and everything you want to know.

# Including Graphics in Your Files

Stata has several different tags which you can use within markdown files. For an exhaustive list, see their [introductory article](https://www.stata.com/features/overview/markdown/) and their [full reference manual](https://www.stata.com/manuals/rpt.pdf). However, I have found their `dd_graph` tag to be a bit unreliable. Another way of including any graphic you produce in Stata is to create the graphic, save it, export it, and then include the image with a link to it through Markdown. The following code shows how this might work.

```stata
<<dd_do>>
sysuse auto.dta

sum mpg price trunk
scatter mpg price, saving("graph.gph", replace)
graph export graph.png, replace
<</dd_do>>
```

Then, a link like this will include the graphic: `![](graph.png)`

![Our Example Graph](graph.png)

# What about Spell Checking?

Erm... yeah. So, Atom has many spell checking packages. However, I don't think any are currently set up to work with `.domd` files. But, I think getting one to work with these files should be pretty straightforward; we just need to have it behave like this is a Markdown file so it isn't spell checking your Stata code (which would be annoying).

In short: it should be doable, but I'll need to sit down and look at it. And I'm much too tired to do that right now. I'll get there.

# Extra: Putting Your Content on GitHub

[GitHub](https://github.com/) will host entire static websites for you (meaning you cannot power the website with a server) via [GitHub Pages](https://pages.github.com/).
