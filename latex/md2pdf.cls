%----------------------------------------------------------------------------------------
% Generate PDf for Markdown file via pandoc
%----------------------------------------------------------------------------------------

\ProvidesClass{md2pdf}[20.12 md2pdf]

% Base it on the standard article class

\LoadClassWithOptions{article}

%----------------------------------------------------------------------------------------
%	Packages and package configuration
%----------------------------------------------------------------------------------------
 
\RequirePackage[english]{babel}           % English language hyphenation
\RequirePackage{microtype}                % Better typography
\RequirePackage{amsmath,amsfonts,amsthm}  % Math packages for equations
\RequirePackage{array}                    % For markdown tables
\RequirePackage{currfile}
\RequirePackage[hang, small, labelfont=bf, up, textfont=it]{caption} % Custom captions under/above tables and figures
\RequirePackage{booktabs}                 % Horizontal rules in tables
\RequirePackage{lastpage}                 % Used to determine the number of pages in the document (for "Page X of Total")
\RequirePackage{graphicx}                 % Required for adding images
\RequirePackage{ifthen}
\RequirePackage{enumitem}                 % Required for customising lists
\RequirePackage[svgnames]{xcolor}         % Enabling colors by their 'svgnames'
\RequirePackage{sectsty}      			  % Enables custom section titles

%----------------------------------------------------------------------------------------
%	Margins and spacing
%----------------------------------------------------------------------------------------

\RequirePackage{geometry}

\geometry{
	top=.5in,
	bottom=.5in,
	left=.75in,
	right=.75in,
	includehead,
	includefoot,
	headsep=0.5in
	}
	
\setlist{noitemsep}                 % Remove spacing between bullet/numbered list elements
\setlength{\columnsep}{.5in}  		% Column separation width

%----------------------------------------------------------------------------------------
%	Fonts
%----------------------------------------------------------------------------------------

\RequirePackage{fontenc} 		% Output font encoding for international characters
\RequirePackage[utf8]{inputenc} % Required for inputting international characters

%----------------------------------------------------------------------------------------
%	Graphics
%----------------------------------------------------------------------------------------

\graphicspath{graphics/}

%----------------------------------------------------------------------------------------
%	Headers and footers
%----------------------------------------------------------------------------------------

% Specify the distribution statement as a variable in the document header
\newcommand{\diststmt}{}

\newcommand{\rulecolor}{DarkGoldenrod}

\newcommand{\HorRule}{    % Define a standard horizontal rule line
  \vbox to 0pt{\hbox to \headwidth{\color{\rulecolor} \rule{\headwidth}{1pt}}\vss}
}

\RequirePackage{fancyhdr} % Needed to define custom headers/footers

\pagestyle{fancy}         % Enables the custom headers/footers

\renewcommand{\footrule}{{\HorRule}}
\renewcommand{\headrule}{{\HorRule}}

\newcommand{\removelinebreaks}[1]{
  \begingroup\def\\{ }#1\endgroup
}
