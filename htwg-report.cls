\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{htwg-report}[2018/04/27 v1. HTWG Konstanz report class]

\newif\if@german
\newif\if@english
\DeclareOption{german}{\@germantrue\@englishfalse}
\DeclareOption{english}{\@germanfalse\@englishtrue}
\newif\if@nativefonts
\DeclareOption{nativefonts}{\@nativefontstrue}
\newif\if@print
\DeclareOption{print}{\@printtrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ExecuteOptions{english}
\ProcessOptions\relax

\LoadClass[10pt]{book}

\RequirePackage{amsmath}
\RequirePackage{amssymb}
%% English is the default language, but this can be changed to German by
%% specifying the 'german' option to the document class.
\if@german
    \RequirePackage[ngerman]{babel}
\else
    %% Even for English reports, some sections might be in german, for example on
    %% the title page.
    \RequirePackage[ngerman,english]{babel}
\fi
\RequirePackage[nooneline,footnotesize]{caption}
\RequirePackage{fancyhdr}
\RequirePackage[flushmargin,hang]{footmisc}
\RequirePackage{ifpdf}
\RequirePackage{ifxetex}

%%%%%%%%%%%%
%% HTWG
%%%%%%%%%%%%
% 'background' includes 'graphicx' as well
\RequirePackage[firstpage=true]{background}

\ifxetex
    \RequirePackage[xetex]{geometry}
    \RequirePackage[xetex]{hyperref}
    \RequirePackage{fontspec}
    \RequirePackage{xltxtra}
    \defaultfontfeatures{Ligatures=TeX}
\else
    \ifpdf
        \RequirePackage[pdftex]{geometry}
        \RequirePackage[pdftex]{hyperref}
    \else
        \RequirePackage[dvips]{geometry}
        \RequirePackage[hypertex]{hyperref}
    \fi
\fi
\RequirePackage{metalogo}
\RequirePackage[numbers,sort&compress]{natbib}
\RequirePackage{tikz}
\RequirePackage[noindentafter]{titlesec}
\RequirePackage{titletoc}
\RequirePackage[nottoc]{tocbibind}
\RequirePackage{xcolor}
\RequirePackage{xkeyval}

\ifxetex
    %% If the document is compiled with XeLaTeX, we load the
    %% HTWG CI style font: swis721 Regular and Bold (sans serif)
    %%
    %% As serif font we load: Georgia Regular and Bold and Italic (serif)
    \newfontfamily\htwgsffamily[
        Path = fonts/,
        Extension = .ttf,
        BoldFont = *-Bold,
        ItalicFont = *,
        BoldItalicFont = *
    ]{swis721}
    \newfontfamily\htwgrmfamily[
        Path = fonts/,
        Extension = .ttf,
        BoldFont = *-Bold,
        ItalicFont = *-Italic,
        BoldItalicFont = *-Bold-Italic
    ]{Georgia}
\else
    %% If the document is not compiled with XeLaTeX, we need to use the native
    %% fonts.
    \@nativefontstrue
    \newcommand*\htwgrmfamily{\rmfamily}
    \newcommand*\htwgsffamily{\sffamily}
\fi

\if@nativefonts
    %% As a fallback, we use Arial
    %% The native font is Utopia Regular with Fourier math. We use Latin Modern
    %% as a fallback, since Utopia lacks support for sans-serif and monospace.

    \RequirePackage{helvet}
    \renewcommand{\familydefault}{\sfdefault}
\else
    %% swis721 for sans serif [main font]
    %% Georgia for sans
    %% Courier New for monospace
    %% Cambria for math
    \RequirePackage{unicode-math}
    \setmainfont[
        Path = fonts/,
        Extension = .ttf,
        BoldFont = *-Bold,
        ItalicFont = *,
        BoldItalicFont = *
    ]{swis721}
    \setsansfont[
        Path = fonts/,
        Extension = .ttf,
        BoldFont = *-Bold,
        ItalicFont = *-Italic,
        BoldItalicFont = *-Bold-Italic
    ]{Georgia}
    \setmonofont[
        Path = fonts/,
        Extension = .ttf,
        UprightFont = *MT,
        BoldFont = *-BoldMT,
        ItalicFont = *-ItalicMT,
        BoldItalicFont = *-BoldItalicMT
    ]{CourierNewPS}
    \setmathfont[
        Path = fonts/,
        Extension = .ttf
    ]{CambriaMath}
    %% The default style for text
    \renewcommand*\familydefault{\rmdefault}
\fi


%%%%%%%%%%%%
%% HTWG CI Colors
%%%%%%%%%%%%
\definecolor{htwg-white}{cmyk}{0.0,0.0,0.0,0.0}
\definecolor{htwg-black}{cmyk}{0.0,0.0,0.0,1.0}
\definecolor{htwg-black-90}{cmyk}{0.0,0.0,0.0,0.9}
\definecolor{htwg-black-80}{cmyk}{0.0,0.0,0.0,0.8}
\definecolor{htwg-black-70}{cmyk}{0.0,0.0,0.0,0.7}
\definecolor{htwg-black-60}{cmyk}{0.0,0.0,0.0,0.6}
\definecolor{htwg-black-50}{cmyk}{0.0,0.0,0.0,0.5}
\definecolor{htwg-black-40}{cmyk}{0.0,0.0,0.0,0.4}
\definecolor{htwg-black-30}{cmyk}{0.0,0.0,0.0,0.3}
\definecolor{htwg-black-20}{cmyk}{0.0,0.0,0.0,0.2}
\definecolor{htwg-black-10}{cmyk}{0.0,0.0,0.0,0.1}
\definecolor{htwg-soft-blue}{cmyk}{0.1,0.0,0.0,0.1}
\definecolor{htwg-dark-blue}{cmyk}{0.8,0.62,0.42,0.45}
\definecolor{htwg-teal}{cmyk}{1.0,0.0,0.5,0.0}

%% Use HTWG Teal as the color for titles, unless the 'print' option is
%% specified.
\if@print
    \colorlet{title}{black}
\else
    \colorlet{title}{htwg-teal}
\fi

%% We use A4 paper with slightly smaller margins than the default (scale = 0.7).
\geometry{a4paper,hscale=0.75,vscale=0.8}

%% Redefine the title command to accept an optional subtitle.
\renewcommand*\title[2][]{%
    \def\@subtitle{#1}%
    \def\@title{#2}%
    %% Add the title to the PDF meta data.
    \hypersetup{pdftitle=#2}%
}
%% Redefine the author command to add the name to the PDF meta data.
\renewcommand*\author[1]{%
    \def\@author{#1}%
    \hypersetup{pdfauthor=#1}%
}

%%%%%%%%%%%%
%% HTWG
%%%%%%%%%%%%

%%% Report-Type
% 'bachelor'
% 'master'
% [other]
\newcommand\reporttype[1]{\def\@report@type{#1}}
\newcommand\reporttypetext[1]{\def\@report@typetext{#1}}
\def\bachelor{bachelor}
\def\master{master}

%%% Student
\newcommand\studentnumber[1]{\def\@student@number{#1}}
\newcommand\studentemail[1]{\def\@student@email{#1}}

%%% Document
\newcommand\doclocation[1]{\def\@doc@location{#1}}
\newcommand\docdate[1]{\def\@doc@date{#1}}



%% The cover image is scaled to fill the width of the front cover.
\newlength\@cover@imagewidth
%% The width of the spine if a back cover is present.
\newlength\@cover@spinewidth
\setlength\@cover@spinewidth{0.375in}
%% Width and height of the boxes on the front and back cover.
\newlength\@cover@frontboxwidth
\setlength\@cover@frontboxwidth{4.375in}
\newlength\@cover@frontboxheight
\setlength\@cover@frontboxheight{2.1875in}
\newlength\@cover@fronttextwidth
\newlength\@cover@fronttextheight
\newlength\@cover@backboxwidth
\setlength\@cover@backboxwidth{4.375in}
\newlength\@cover@backboxheight
\setlength\@cover@backboxheight{2.1875in}
\newlength\@cover@backtextwidth
\newlength\@cover@backtextheight
%% Position on the front cover where the corner of both boxes meet.
\newlength\@cover@x
\setlength\@cover@x{0.8125in}
\newlength\@cover@y
\setlength\@cover@y{3in}
%% The margin around text boxes.
\newlength\@cover@margin
\setlength\@cover@margin{12pt}

%% Define the options for the makecover command.
\define@boolkey{cover}{back}[true]{}
\define@boolkey{cover}{nospine}[true]{}
\define@boolkey{cover}{frontbottom}[true]{}
\define@key{cover}{spinewidth}{\setlength\@cover@spinewidth{#1}}
\define@key{cover}{frontboxwidth}{\setlength\@cover@frontboxwidth{#1}}
\define@key{cover}{frontboxheight}{\setlength\@cover@frontboxheight{#1}}
\define@key{cover}{backboxwidth}{\setlength\@cover@backboxwidth{#1}}
\define@key{cover}{backboxheight}{\setlength\@cover@backboxheight{#1}}
\define@key{cover}{x}{\setlength\@cover@x{#1}}
\define@key{cover}{y}{\setlength\@cover@y{#1}}
\define@key{cover}{margin}{\setlength\@cover@margin{#1}}










\newcommand*\makecover[1][]{%
    \setkeys{cover}{#1}%
    %% Create a purple empty page without margins.
    \clearpage%
    \newgeometry{margin=0pt}%
    \thispagestyle{empty}%

    %%%%%%%%%%%%
    %% HTWG
    %%%%%%%%%%%%
    \backgroundsetup{
        scale = 1, angle = 0, opacity = 1,
        contents = {\includegraphics[width = \paperwidth,
        height = \paperheight, keepaspectratio]
        {report_cover_empty.pdf}}
    }

    %% We need the this to perform coordinate calculations in TikZ.
    \usetikzlibrary{calc}%
    \begin{tikzpicture}[remember picture,overlay]
        \ifKV@cover@nospine
            \setlength\@cover@spinewidth{0pt}
        \fi


        %% Calculate the coordinate of the top left corner of the front cover.
        \ifKV@cover@back
            \coordinate (top left) at ($(current page.north)+(0.5\@cover@spinewidth,0pt)$);
        \else
            \coordinate (top left) at (current page.north west);
        \fi


        \ifKV@cover@back\ifKV@cover@nospine\else
            %% If a back cover is present, calculate the coordinates of the
            %% spine box.
            \coordinate (spine top left) at ($(top left)-(\@cover@spinewidth,0pt)$);
            \coordinate (spine bottom right) at ($(top left)+(0pt,-\@cover@y)$);
            \ifKV@cover@frontbottom
                \coordinate (spine bottom right) at ($(spine bottom right)+(0pt,\@cover@backboxheight)$);
            \fi
            \coordinate (spine bottom center) at ($(spine bottom right)+(-0.5\@cover@spinewidth,0pt)$);

            %% Extend the spine box by 1pt to the left to ensure it completely
            %% covers the cover image.
            \coordinate (spine top left) at ($(spine top left)-(1pt,0pt)$);

            %% Draw a black box on the spine.
            \fill[fill=htwg-black](spine top left) rectangle (spine bottom right);

            %% Print the title on the center right of the spine box.
            \node at (spine bottom center)[rotate=-90,anchor=east,inner sep=\@cover@margin]{
                \htwgrmfamily\color{htwg-white}\LARGE\@title
            };
        \fi\fi


        %% Calculate the coordinate of the corner where the front and back boxes
        %% meet.
        \coordinate (corner) at ($(top left)+(\@cover@x,-\@cover@y)$);

        %% Calculate the top left and bottom right coordinates of the front and
        %% back boxes.
        \ifKV@cover@frontbottom
            \coordinate (front top left) at (corner);
            \coordinate (back top left) at ($(corner)+(-\@cover@backboxwidth,\@cover@backboxheight)$);
        \else
            \coordinate (front top left) at ($(corner)+(0pt,\@cover@frontboxheight)$);
            \coordinate (back top left) at ($(corner)+(-\@cover@backboxwidth,0pt)$);
        \fi
        \coordinate (front bottom right) at ($(front top left)+(\@cover@frontboxwidth,-\@cover@frontboxheight)$);
        \coordinate (back bottom right) at ($(back top left)+(\@cover@backboxwidth,-\@cover@backboxheight)$);

        %% Calculate the width and height of the front text box.
        \setlength\@cover@fronttextwidth{\@cover@frontboxwidth}
        \addtolength\@cover@fronttextwidth{-2\@cover@margin}
        \setlength\@cover@fronttextheight{\@cover@frontboxheight}
        \addtolength\@cover@fronttextheight{-2\@cover@margin}


        %%%%%%%%%%%%
        %% HTWG
        %%%%%%%%%%%%
        %% Create the background elements.
        \begingroup
            \ifx\@report@type\bachelor
                \node at (15.8mm,-82.1mm)[anchor=center]{
                    \includegraphics[scale=0.165]{cover/B_black}
                };
                \node at (36.8mm,-250.1mm)[anchor=center]{
                    \includegraphics[scale=0.17]{cover/S_black}
                };
                \node at (162.8mm,-124.1mm)[anchor=center]{
                    \includegraphics[scale=0.15]{cover/C_black}
                };
            \else\ifx\@report@type\master
                \node at (15.8mm,-82.1mm)[anchor=center]{
                    \includegraphics[scale=0.165]{cover/M_black}
                };
                \node at (36.8mm,-250.1mm)[anchor=center]{
                    \includegraphics[scale=0.17]{cover/S_black}
                };
                \node at (162.8mm,-124.1mm)[anchor=center]{
                    \includegraphics[scale=0.15]{cover/C_black}
                };
            \else
              %nothing%
            \fi\fi
        \endgroup




        %% Create the titel text box.
        \node at (14.5mm,-174.5mm)[anchor=north west, fill=htwg-dark-blue]{
            \begin{minipage}[t]{145mm}
                \begin{flushleft}
                    %% Print Report Type Text
                    \color{htwg-white}\Huge\textbf{\@report@typetext}
                    \\
                    %% Print Report Title
                    \color{htwg-white}\Huge{\@title}
                \end{flushleft}
            \end{minipage}
        };

        %% Create the author text box.
        \node at (140.5mm,-37mm)[anchor=north west, fill=htwg-dark-blue]{
            \begin{minipage}[t]{55mm}
                \begin{flushleft}
                    \color{htwg-white}\footnotesize\textbf{Submitted by}
                    \linebreak
                    \color{htwg-white}\footnotesize{\@author}
                    \linebreak 
                    \color{htwg-white}\footnotesize{Student Number \@student@number}
                    \linebreak
                    \linebreak
                    \color{htwg-white}\footnotesize{\@student@email}
                \end{flushleft}
            \end{minipage}
        };

        %% Create the date text box.
        \node at (140.5mm,-268mm)[anchor=north west, fill=htwg-dark-blue]{
            \begin{minipage}[t]{55mm}
                \begin{flushleft}
                    \color{htwg-white}\footnotesize\textbf{\@doc@location,}
                    \color{htwg-white}\footnotesize\textbf{\@doc@date}
                \end{flushleft}
            \end{minipage}
        };

    \end{tikzpicture}%
    %% Restore the margins and turn the page white again.
    \restoregeometry%
    \pagecolor{white}%
}

%% Remove the header and page number on empty pages.
\def\cleardoublepage{%
    \clearpage%
    \if@twoside%
        \ifodd\c@page%
        \else%
            \thispagestyle{empty}%
            \vspace*{\fill}%
            \newpage%
        \fi%
    \fi%
}

%% Page style for title pages.
\fancypagestyle{plain}{%
    \fancyhf{}
    \renewcommand*\headrulewidth{0pt}
    \renewcommand*\footrulewidth{0pt}
    \fancyfoot[C]{\thepage}
}

%% Fancy style for the main matter.
\fancypagestyle{mainmatter}{%
    \fancyhf{}
    %% Page numbers on the top left and top right.
    \fancyhead[LE,RO]{\thepage}
    %% Chapter name on the left (even) page.
    \fancyhead[RE]{\nouppercase{\leftmark}}
    %% Section name on the right (odd) page.
    \fancyhead[LO]{\nouppercase{\rightmark}}
}

%% The mainmatter style is default for normal pages.
\pagestyle{mainmatter}

%% Print the current chapter and section at the top of the page in cyan.
\renewcommand*\chaptermark[1]{\markboth{\thechapter.\ \color{title}#1}{}}
\renewcommand*\sectionmark[1]{\markright{\thesection.\ \color{title}#1}}

%% The setheader command can be used to print the title of unnumbered chapters
%% in the page header.
\newcommand*\setheader[1]{\markboth{\color{title}#1}{\color{title}#1}}

%% Change the headrule command (from fancyhdr.sty) to draw the line below the
%% header in the title color.
\renewcommand*\headrule{%
    \if@fancyplain%
        \let\headrulewidth\plainheadrulewidth%
    \fi%
    {\color{title}\hrule\@height\headrulewidth\@width\headwidth}%
    \vskip-\headrulewidth%
}

%% Draw the line above a footnote in the title color as well.
\renewcommand*\footnoterule{%
    \vspace*{-3pt}%
    {\color{title}\hrule width 0.5\textwidth height 0.4pt}%
    \vspace*{2.6pt}%
}

%% A part title starts with a huge (96pt) bold black number, flushed to the
%% right, followed by the part name on the next line in the title color.
\titleformat{\part}[display]
    {\flushright}
    {\fontsize{96pt}{96pt}\selectfont\bfseries\thepart}
    {0pt}
    {\Huge\color{title}}
%% Separate the title from the text by two empty lines.
\titlespacing{\part}{0pt}{0pt}{2\baselineskip}
%% In the table of contents, the part name is preceded by an empty line, printed
%% in bold, and not followed by a line of dots.
\dottedcontents{part}[0em]{\vspace{\baselineskip}\bfseries}{1.5em}{0pc}

%% Chapter titles have the same layout as parts.
\titleformat{\chapter}[display]
    {\flushright}
    {\fontsize{96pt}{96pt}\selectfont\bfseries\thechapter}
    {0pt}
    {\Huge\color{title}}
\titlespacing{\chapter}{0pt}{0pt}{2\baselineskip}
%% In the table of contents, a chapter is similar to a part, except that it is
%% preceded by half an empty line.
\dottedcontents{chapter}[1.5em]{\vspace{0.5\baselineskip}\bfseries}{1.5em}{0pc}

%% Section titles start with the number in bold, followed by the name printed
%% in the title color.
\titleformat{\section}
    {\Large}
    {\bfseries\thesection.\ }
    {0pt}
    {\color{title}}
%% Sections are preceded by an empty line.
\titlespacing{\section}{0pt}{\baselineskip}{0pt}
%% In the table of contents, section names are followed by a line of dots 8pt
%% apart.
\dottedcontents{section}[3.8em]{}{2.3em}{8pt}

%% Subsection titles have the same layout as section titles, except in a smaller
%% font.
\titleformat{\subsection}
    {\large}
    {\bfseries\thesubsection.\ }
    {0pt}
    {\color{title}}
\titlespacing{\subsection}{0pt}{\baselineskip}{0pt}
\dottedcontents{subsection}[7em]{}{3.2em}{8pt}

%% Subsubsections have the same font and color as sections and subsections, but
%% are not preceded by a number.
\titleformat{\subsubsection}
    {}
    {}
    {0pt}
    {\color{title}}
%% Subsubsections are preceded by an empty line and do not appear in the table
%% of contents.
\titlespacing{\subsubsection}{0pt}{\bigskipamount}{0pt}

%% Color the bullets of the itemize environment and make the symbol of the third
%% level a diamond instead of an asterisk.
\renewcommand*\labelitemi{\color{title}\textbullet}
\renewcommand*\labelitemii{\color{title}--}
\renewcommand*\labelitemiii{\color{title}$\diamond$}
\renewcommand*\labelitemiv{\color{title}\textperiodcentered}

%% Use a custom bibliography style based on apsrev4-1.
\bibliographystyle{htwg-report}

%% Hyperlinks are cyan, except in print mode, when they are all black.
\hypersetup{
    colorlinks = true,
    citecolor = title,
    linkcolor = title,
    urlcolor = title
}

