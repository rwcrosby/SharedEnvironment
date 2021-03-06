%
% Standard format for NIWC Beamer Presentations
%

\PassOptionsToPackage{table,svgnames*}{xcolor}

\ProvidesClass{NIWCBeamer}[20.01 NIWC Atlantic Beamer Class]

% Base it on the standard beamer class

\LoadClassWithOptions{beamer}

\usetheme{default}

% A bunch of other packages

\RequirePackage{pgfpages}
\RequirePackage[nodayofweek]{datetime}
\RequirePackage{multicol}
\RequirePackage{tikz}
\RequirePackage{amsmath}

% Font will depend on latex processor used

\RequirePackage{ifxetex}
\ifxetex
  \usepackage{fontspec}
  \setmainfont{Arial Narrow}
\else
  \usepackage{helvet}
  \renewcommand{\familydefault}{\sfdefault}
\fi

% 2 up handouts

\mode<handout>{
  \setbeamercolor{background canvas}{bg=black!5}
  \pgfpagesuselayout{2 on 1}[letterpaper,border shrink=2.5mm]
}

\beamertemplatenavigationsymbolsempty

% Setup the title page

\defbeamertemplate*{title page}{customized}[1][]
{
  \begin{tikzpicture}[remember picture,overlay]
    \node[anchor=north west, yshift=-2mm, xshift=1mm] at (current page.north west) {\includegraphics[scale=.20]{NIWCLANT.png}};
    \node[anchor=north east, xshift=1mm] at (current page.north east) {\includegraphics[scale=.5]{NIWC_header.png}};
    \node[anchor=south east, yshift=-2mm, xshift=1mm] at (current page.south east) {\includegraphics[scale=.5]{NIWC_footer.png}};
    \node[white, anchor=south east, yshift=-1mm, xshift=-45mm] at (current page.south east) {\tiny\diststmt};   % Set this up as a parameter
  \end{tikzpicture}

  \begin{center}
    \usebeamerfont{title}\LARGE\textbf\inserttitle\par
    \bigskip
    \usebeamerfont{subtitle}\Large\insertsubtitle\par
    \bigskip
    \begin{multicols}{2}
      \usebeamerfont{institute}\insertinstitute\par
      \usebeamerfont{date}\insertdate\par
      \columnbreak
      \usebeamerfont{author}\insertauthor\par
    \end{multicols}
  \end{center}
}

% Default frame title

\geometry{top=7mm, left=7mm, right=7mm}

\setbeamertemplate{frametitle}{
  \begin{tikzpicture}[remember picture,overlay]
    \node[anchor=north west, yshift=-1mm, xshift=1mm] at (current page.north west) {\includegraphics[scale=.15]{NIWCLANT.png}};
    \node[anchor=north west, yshift=-5mm, xshift=16mm] at (current page.north west) {\LARGE\textbf\insertframetitle\par};
    \node[anchor=north west, yshift=-13mm, xshift=-1.25mm] at (current page.north west) {\includegraphics[scale=.5]{NIWC_header_line.png}};
  \end{tikzpicture}
}

% Blocks

\providecolors{LightGray}
\providecolors{DarkGreen}
\providecolors{DarkRed}
\providecolors{Navy}
\providecolors{White}

\setbeamercolor{block title}{bg=Navy,fg=White}
\setbeamercolor{block body}{bg=LightGray}

\setbeamercolor{block title example}{bg=DarkGreen,fg=White}
\setbeamercolor{block body example}{bg=LightGray}

\setbeamercolor{block title alerted}{bg=DarkRed,fg=White}
\setbeamercolor{block body alerted}{bg=LightGray}


\setbeamertemplate{blocks}[rounded][shadow=true]


% Other utility commands

\newcommand{\old}[1]{{}}

\newcommand{\diststmt}{{Dist A: Approved for Public Release}}

\newcommand{\closing}[1]{
  \begin{frame}
  \frametitle{#1}

  \centering
  \includegraphics[width=\textwidth]{NIWC_Closing.png}

\end{frame}

}