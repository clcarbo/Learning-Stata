---
title: Learning Stata Website README
author: Christopher Carbonaro
---

# What is this Project?
Learning-Stata is a website conceived for teaching others how to use Stata.

# Info for Authors

## Writing new modules
To write new modules, write a new markdown file and save it in the stata_modules folder. The article will automatically be added and linked into the dropdown menu on the site's header.

If you want to use Stata's dyndoc tools, you'll need to create a .domd file, then use Stata to generate the markdown file. Save the resulting file in the stata_modules folder.

## Images and other media
Make sure you save all media in the same folder. If you direct the link in your Markdown file to the files within that folder, Jekyll will automatically include your graphics on the page.

# Info for Site Maintainers

Above all else, **DO NOT CHANGE THE DIRECTORY NAMES FOR ANY DIRECTORY WHICH BEGINS WITH `_`**. Jekyll needs these directories to be named as they currently are to properly generate the site.

## How was the project built?
The site was primarily built with Jekyll, which is a framework which lets authors write Markdown files and easily convert them to standardized HTML templates.

## How can I create new content layouts?
If you want to change what *kind* of content is contained on the page (e.g. you want a page which has different content within the header), you should write a new `.html` template in the `_layouts` folder. If you want to *rearrange or alter the style* of the content which is already present, you should alter the `.css` files in the `assets` folder. `modest.css` provides the foundation for much of the current styles, and `extra_styles.css` touches most other elements up.

## How can I create reusable elements?
Look at Jekyll's documentation on `includes`. This is how the current nav and footer are included.
