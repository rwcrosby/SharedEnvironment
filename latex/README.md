---
title: LaTeX General Notes
numbersections: False
---

# Working

- Setup symlink for local working cls and sty files

    ```shell
    ln -s ~/Projects/md2pdf ~/Library/texmf/tex/generic
    ```

# Overview

The primary script is `md2pdf.sh` which is intended to invoke `pandoc` to render a markdown file to pdf. 

Three configuration files are used by this script (all of which can be overridden with environment variables):

- `Default_PandocConfig.yaml`

    This contains pandoc parameters specifying the document class, style sheet, and other packages.

- `Default_Pandoc.template`

    A pandoc template used to reformat the markdown into LaTeX.

- `ShortenFilename.py`

    A python program that takes the name of the markdown file and products a short version for inclusion in the footer.

# Setup:

```shell
ln -s ~/SharedEnvironmment/latex ~/Library/texmf/tex/latex
ln -s ~/SharedEnvironmment/latex/latexmkrc ~/.latexmkrc
```

Or see `dotbot` setup instructions in the root directory


# Class Files

The class file specifies the overall set of packages to be used as well as some default style info. In general, the majority of the style information (headers, fonts, etc.) should be in `.sty` file.

- `md2pdf.cls`

    Default class file.

# Style Files

- `Default.sty`

    Default stylesheet for personal documents. TAMU pallet is used.

- `Camgian.sty`

    Style sheet to render with the Camgian logo and branding.

- `CofC.sty`

    Style sheet to render with the College of Charleston logo and branding.

- `CofCGrading.sty`

    For grading College of Charleston assignments.

# Old stuff

## `ClassNotes.cls`

Generate lecture notes.

## `Markdown.cls`

Used with `md2pdf.sh` script to format a markdown file.

## `NIWCBeamer.cls`

## `OrgNodes.cls`

Format an EMACS .org file for printing.

# Font Handling

> This needs work

See examples/FontHandling.tex

- /usr/local/texlive/2020/texmf-dist/doc/latex/psnfss/psnfss2e.pdf

- http://ctan.math.washington.edu/tex-archive/macros/unicodetex/latex/fontspec/fontspec.pdf
- https://www.tug.org/pracjourn/2006-1/schmidt/schmidt.pdf
- https://www.latex-project.org/help/documentation/fntguide.pdf

# Style Files

## `CofCGrading.sty`

## `WhitePaper,sty`

Generic replacement for abstract. Should probably be converted into a class file.

# Utility Scripts

## `md2pdf.sh`

Convert a markdown file into a pdf.

Parameters:

1. filename
2. title (Default assumed to be in document)
3. author (default Me)
4. date (Default current date)

# Personal files

- On Mac they should be in ~/Library/texmf/tex/latex
- On Linux they should be in ~/texmf/tex/latex
- With `\\input`, extension should be .tex
- With `\\usepackage`, extension should be .sty
- https://tex.stackexchange.com/questions/91167/why-use-sty-files

# Zotero
- Output is biblatex format
- Example in: Documents/FY2018 ANTEX/2018-06-01 Cyber Shorelines/ShortPaper.tex

