%----------------------------------------------------------------------------------------
% Generate PDf for Markdown file via pandoc
%----------------------------------------------------------------------------------------

\ProvidesClass{Markdown}[20.12 Markdown]

% Base it on the standard article class

\LoadClassWithOptions{article}

%----------------------------------------------------------------------------------------
%	PACKAGES AND OTHER DOCUMENT CONFIGURATIONS
%----------------------------------------------------------------------------------------
 
\RequirePackage[english]{babel} % English language hyphenation
\RequirePackage{microtype} % Better typography
\RequirePackage{amsmath,amsfonts,amsthm} % Math packages for equations
\RequirePackage{currfile}

\@ifpackageloaded{xcolor}
{
  \definecolors{DarkGoldenrod}
  \definecolors{DarkRed}
}
{
  \RequirePackage[svgnames]{xcolor} % Enabling colors by their 'svgnames'
}

\RequirePackage[hang, small, labelfont=bf, up, textfont=it]{caption} % Custom captions under/above tables and figures

\RequirePackage{booktabs} % Horizontal rules in tables

\RequirePackage{lastpage} % Used to determine the number of pages in the document (for "Page X of Total")

\RequirePackage{graphicx} % Required for adding images

\RequirePackage{enumitem} % Required for customising lists
\setlist{noitemsep} % Remove spacing between bullet/numbered list elements

\RequirePackage{sectsty} % Enables custom section titles
\allsectionsfont{\usefont{T1}{phv}{b}{n}} % Change the font of all section commands (Helvetica)

%----------------------------------------------------------------------------------------
%	MARGINS AND SPACING
%----------------------------------------------------------------------------------------

\RequirePackage{geometry} % Required for adjusting page dimensions

\geometry{
	top=.5in, % Top margin
	bottom=.5in, % Bottom margin
	left=.75in, % Left margin
	right=.75in, % Right margin
	includehead, % Include space for a header
	includefoot, % Include space for a footer
}

\setlength{\columnsep}{7mm} % Column separation width

%----------------------------------------------------------------------------------------
%	FONTS
%----------------------------------------------------------------------------------------

\RequirePackage{fontenc} % Output font encoding for international characters
\RequirePackage[utf8]{inputenc} % Required for inputting international characters

%----------------------------------------------------------------------------------------
%	HEADERS AND FOOTERS
%----------------------------------------------------------------------------------------

% Create a distrubution statement with 
% \renewcommand{\diststmt{Blah}}
\newcommand{\diststmt}{}

\newcommand{\HorRule}{    % Define a standard horizontal rule line
  \vbox to 0pt{\hbox to \headwidth{\color{DarkGoldenrod} \rule{\headwidth}{1pt}}\vss}
}

\RequirePackage{fancyhdr} % Needed to define custom headers/footers

\pagestyle{fancy}         % Enables the custom headers/footers

\renewcommand{\sectionmark}[1]{\markboth{#1}{}} % Removes the section number from the header when \leftmark is used

\newcommand{\removelinebreaks}[1]{
  \begingroup\def\\{ }#1\endgroup
  }
  
\renewcommand{\footrule}{{\HorRule}}

\fancypagestyle{firstpage}{
  \renewcommand{\headrule}{}
  \fancyhf{}    % Just eliminate the header, not the footer so the distribution statement prints
  \fancyfoot[L]{\small \textsf \sourcefile}
  \fancyfoot[C]{\hspace{1pt} \\ \small \textsf \diststmt}
  \fancyfoot[R]{\small \textsf{\thepage\ of \pageref{LastPage}}}
  \renewcommand{\footrule}{\HorRule}
}

\fancypagestyle{stdpage}{
  \fancyhf{}
  \fancyhead[C]{\large \color{Maroon} \textsf \@title}
  \fancyfoot[L]{\small \textsf \sourcefile}
  \fancyfoot[C]{\hspace{1pt} \\ \small \textsf \diststmt}
  \fancyfoot[R]{\small \textsf{\thepage\ of \pageref{LastPage}}}
  \renewcommand{\headrule}{{\HorRule}}
}

\pagestyle{stdpage}

%----------------------------------------------------------------------------------------
%	TITLE SECTION
%----------------------------------------------------------------------------------------

\RequirePackage{titling} % Allows custom title configuration

\pretitle{
  \vspace{-70pt}            % Move the entire title section up
  \HorRule
  \vskip 5pt 
  \fontsize{20}{24}\usefont{T1}{phv}{b}{n}\selectfont % Helvetica
  \color{DarkRed}           % Text colour for the title and author(s)
  \centering
}
  
\posttitle{
  \par
  \vskip 5pt
}
  
\preauthor{
  \centering
  \fontsize{14}{17}\usefont{T1}{phv}{m}{n}\selectfont % Helvetica
}
    
\postauthor{
  \par
}

\predate{
  \centering
  \fontsize{14}{17}\usefont{T1}{phv}{m}{n}\selectfont % Helvetica
}

\postdate{
  \HorRule
  \vskip 5pt
}