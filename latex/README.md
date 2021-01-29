---
title: LaTeX General Notes
numbersections: False
---

To Setup:

- `ln -s ~/SharedEnvironmment/latex/latexmkrc ~/.latexmkrc`

# Class Files

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

# Personal files

- On Mac they should be in ~/Library/texmf/tex/latex
- On Linux they should be in ~/texmf/tex/latex
- With `\\input`, extension should be .tex
- With `\\usepackage`, extension should be .sty
- https://tex.stackexchange.com/questions/91167/why-use-sty-files

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

# Zotero
- Output is biblatex format
- Example in: Documents/FY2018 ANTEX/2018-06-01 Cyber Shorelines/ShortPaper.tex

