%
% Standard format for pdf export of Org mode notes files.
%

\ProvidesClass{OrgNotes}[18.09 Org Mode Notes Files Export Format]

% Base it on the standard article class

\LoadClassWithOptions{article}

\RequirePackage[left=.75in,right=.75in,top=1in,bottom=1in]{geometry}

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