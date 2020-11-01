%
% Setup for Notability Class Notes
%

\ProvidesClass{ClassNotes}[20.11 Class Notes]

% Base it on the standard article class

\LoadClassWithOptions{article}

\RequirePackage[
    left=.5in,
    right=.5in,
    top=.75in,
    bottom=.75in,
    headheight=14pt
]{geometry}

\RequirePackage{lastpage}
\RequirePackage{currfile}
\RequirePackage[svgnames]{xcolor}

\RequirePackage{fancyhdr}

\fancypagestyle{stdpage}{
  \fancyhf{}
  \fancyhead[L]{\small \color{Maroon} \textsf \@date}
  \fancyhead[C]{\large \color{Maroon} \textsf \@title}
  \fancyhead[R]{\small \color{Maroon} \textsf \@author}
  \fancyfoot[L]{\small \color{Maroon} \textsf \currfilepath}
  \fancyfoot[R]{\small \color{Maroon} \textsf{\thepage\ of \pageref{LastPage}}}
  \renewcommand{\headrulewidth}{0.4pt}
  \renewcommand{\footrulewidth}{0.4pt}
}

\pagestyle{stdpage}

\renewcommand\maketitle{}

\usepackage{amssymb}
\usepackage{amsmath}
\usepackage[utf8]{inputenc}
\usepackage{tikz}

\def\width{29}

\newcommand\makegrid[1]{
    \noindent
    \begin{tikzpicture}[x=.25in, y=.25in, semitransparent]
        \draw[step=.25in, line width=0.2mm, blue!40!white] (0,0) grid (\width,#1);
    \end{tikzpicture}
}

\newcommand\pagehead[1]{
    {
        \noindent
        \large
        \textsf{#1}
    }
}