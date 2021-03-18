%% proposal documentclass
%% Florian Sihler, 4 Mar. 2021
%%
%% Based on koma-script

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{proposal}[2021/03/04 The proposal documentclass]
\def\LayoutName{proposal}

% First we setup the document options
\LoadClass[%
  numbers=noenddot,english,%
  fontsize=11pt,oneside,%
  footnotes=nomultiple,a4paper%
]{scrartcl}

%% Options
%% -----------------------------------------------------------------------------
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=MEPRO,prefix=bprop@}

\DeclareBoolOption{userip}
\DeclareComplementaryOption{norip}{userip}

\DeclareStringOption[GreenWater]{cpalette}
\DeclareStringOption[DeepInk]{tpalette}

\ProcessKeyvalOptions*

%% Basic packages
%% -----------------------------------------------------------------------------

\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{lecture-coverpage}

\RequirePackage[ngerman,main=english]{babel}
\RequirePackage{etoolbox,calc,booktabs,scrhack,caption,tikz,tcolorbox}

\RequirePackage{uulm-logos}


%% Fonts
%% -----------------------------------------------------------------------------

\AtEndPreamble{%
\RequirePackage[charter,expert]{mathdesign}
\RequirePackage[scaled=.96,sups,osf]{XCharter}%
\RequirePackage[tabular,lining]{montserrat}%
}

%% Microtype
%% -----------------------------------------------------------------------------

\RequirePackage[activate={true,nocompatibility},final,kerning=true,spacing=true,stretch=20,factor=1042,shrink=20,babel]{microtype}
\SetTracking{encoding={*}, shape=sc}{42}

% we do not want protusion in table of*
\preto\tableofcontents{\microtypesetup{protrusion=false}}
\appto\tableofcontents{\microtypesetup{protrusion=true}}

%% Line handling
%% -----------------------------------------------------------------------------

\RequirePackage[all]{nowidow}
\RequirePackage{cuted}

%% General Layout & Packages
%% -----------------------------------------------------------------------------
\RequirePackage{relsize,lastpage,fontawesome,afterpage,xstring,graphicx}
\RequirePackage[en-US]{datetime2}
\RequirePackage[draft=false]{scrlayer-scrpage}

\newlength\bprop@len@margin \bprop@len@margin=2cm
\RequirePackage[a4paper,margin=\bprop@len@margin,includefoot,vcentering]{geometry}
\flushbottom

%% Hyperlinks => Figures, Tables and refs
%% -----------------------------------------------------------------------------
\RequirePackage[%
    unicode=true,pdfencoding=auto,psdextra,pdftex, %
    backref, pagebackref=false,%
    bookmarks=true, bookmarksopen=false, pdfdisplaydoctitle, %
    pdfborder={0 0 0}, breaklinks=true,%
    colorlinks, hyperindex, %
    bookmarkstype=X@b@X% erase
]{hyperref}

\RequirePackage{bookmark}

% just erases color
\def\nohyper#1{\begingroup\bprop@disablehyper#1\endgroup}
\AtEndPreamble{%
\@ifpackageloaded{lecture-links}{%
\def\bprop@disablehyper{\DisableLinkStyle\hypersetup{allcolors=.}}}%
{\def\bprop@disablehyper{\hypersetup{allcolors=.}}}%
\let\disablehyper\bprop@disablehyper
}

%% Lists
%% -----------------------------------------------------------------------------
\PassOptionsToPackage{inline}{enumitem}
\RequirePackage{enumitem}

\setlist{leftmargin=1.25em,labelwidth=1.25em}
\newlist{inlist}{enumerate*}{1}
\setlist[inlist]{itemjoin={{, }},itemjoin*={{and }},label=($\roman*$),mode=boxed}
\newlist{orlist}{enumerate*}{1}
\setlist[orlist]{itemjoin={{, }},itemjoin*={{or }},label=($\alph*$),mode=boxed}
\setlist[description]{labelwidth=*,font=\normalfont\itshape,topsep=\z@ plus 2pt,partopsep=\z@ plus 2pt}

%% Color-Palettes
%% -----------------------------------------------------------------------------
\RequirePackage[enumitem,rect,lithieboxes,hyperref]{color-palettes}
\RequirePackage{tikz-palettes}
\UsePalette{\bprop@cpalette}
\UseTikzPalette{\bprop@tpalette}

%% Footnotes
%% -----------------------------------------------------------------------------

\LetLtxMacro\bprop@makefnmark\@makefnmark
\AtBeginDocument{\LetLtxMacro\@makefnmark\bprop@makefnmark}

% footnote handling NOTE: we know there is a chapter!
\deffootnote{2em}{1em}{%
    \makebox[2em][r]{\nohyper{\hyperref[bprop@fn:\thesection:\csname bprop@footnoteref@\@mpfn\endcsname]{\thefootnotemark}}}~}

\renewcommand*\thefootnote{$\langle$\arabic{footnote}$\rangle$}
\renewcommand*\thempfootnote{$\langle$\alph{mpfootnote}$\rangle$}

\def\bprop@footnoteref@footnote{fn@\arabic{footnote}}
\def\bprop@footnoteref@mpfootnote{fn@\alph{mpfootnote}}

\preto\@footnotemark{\phantomsection\label{bprop@fn:\thesection:\csname bprop@footnoteref@\@mpfn\endcsname}\disablehyper}

%% (non) Rectangular paragraphs & hyphenation
%% -----------------------------------------------------------------------------

\newlength\segskipamount
\segskipamount=.35\baselineskip minus .1\baselineskip
\def\segskip{\vspace\segskipamount}

\parindent=\z@
\parskip=\segskipamount

\renewcommand*{\arraystretch}{1.2}
\linespread{1.15}
\hbadness=99999
\vbadness=99999

\hyphenpenalty=275
\lefthyphenmin=2 \righthyphenmin=2

%% Header and footer
%% -----------------------------------------------------------------------------

\renewcommand*\sectionmark[1]{\markboth{#1}{}}

\DeclareNewLayer[%
topmargin,background,contents={%
\color{black!95!white}\rule[\baselineskip]{\layerwidth}{0.2em}%
}%
]{mepro.digital.head.ruler}

\colorlet{bprop@headfoot}{gray}
\setkomafont{pageheadfoot}{\sffamily\footnotesize\color{bprop@headfoot}}

\def\bprop@getsubsecmark{\csname bprop@subsec@\thesection @\endcsname}
\def\ifbprop@subsecmark{\ifcsname bprop@subsec@\thesection @\endcsname\expandafter\bprop@firstoftwo\else\expandafter\bprop@secondoftwo\fi}


\def\bprop@copyright@notice@upper{\iflecture@er{authority}{}{\lecture@r{authority},\quad}\iflecture@er{supervisor}{}{Supervisor\ifnum\value{bprop@supervisor@count}>0\relax s\fi: \lecture@r{supervisor}}}
\def\bprop@copyright@notice@lower{\iflecture@er{copyright}{}{\lecture@r{copyright}}}

%
\renewpairofpagestyles{scrheadings}{%
\ofoot{\strut\nohyper{\sbfamily\thepage}}%
\ihead{\begingroup\normalsize\normalfont\linespread{1.25}\begin{tikzpicture}[remember picture,overlay]
  \node[below left,yshift=-.25cm,xshift=-\bprop@len@margin,font=\usekomafont{pageheadfoot}\tiny,inner sep=\z@,outer sep=\z@,align=right] at(current page.north east) {\bprop@disablehyper\bprop@copyright@notice@upper\\\disablehyper\bprop@copyright@notice@lower};
\end{tikzpicture}\endgroup}%
\ifoot{\parbox[t]{.85\linewidth}{\nohyper{\lecture@rs{title}\iflecture@e{\leftmark}{}{\iflecture@er{title}{}{~\faAngleRight~}\leftmark\ifbprop@subsecmark{~\faAngleRight}{}~}\bprop@getsubsecmark}}}
}


\defpairofpagestyles[scrheadings]{bprop@title}{}

\AddLayersAtBeginOfPageStyle{scrheadings}{mepro.digital.head.ruler}
\AddLayersAtBeginOfPageStyle{plain.scrheadings}{mepro.digital.head.ruler}

\pagestyle{scrheadings}

%% Coverpage
%% -----------------------------------------------------------------------------
\setkomafont{subtitle}{\mdseries\sffamily}
\setkomafont{author}{\bfseries\sffamily}
\setkomafont{dedication}{\mdseries\sffamily}

\@lecture@definereg{university}
\@lecture@definereg{institute}

\lecturecp@coverpagestyle{bachelor-proposal}{%
\def\lecture@coverpage@geometry{}%
\renewcommand\maketitle{\begingroup
\microtypesetup{protrusion=false}%
\setparsizes {\z@ }{\z@ }{\z@ \@plus 1fil}%
\thispagestyle{bprop@title}%
%
% First: Center top Type and title
%
\begin{minipage}[t]{\linewidth}
  \null\splogo\hfill\scalebox{.9}{\uulmlogo}%
\end{minipage}\par
\begin{center}
  \vskip6em
  {\usekomafont{subject}{\lecture@r{subject}\par}}
  \vskip2em
  \sbox0{\pbox{\linewidth}{\usekomafont{title}\Huge\lecture@r{title}}}%
  \textcolor{lightgray}{\rule{\linewidth}{.866pt}}\bigskip\par
  \usebox0\smallskip\par
  \textcolor{lightgray}{\rule{\linewidth}{.866pt}}\smallskip\par
  \vskip.5em
  \parbox{\wd0-1em}{\centering\usekomafont{subtitle}{\lecture@r{subtitle}\par}}
\end{center}
\vfill\lecture@r{titleimage}
\vfill\null
\raggedleft
\begin{minipage}{.45\linewidth}
  \raggedleft\disablehyper
  {\usekomafont{author}\typesetAuthors\par}
  {\usekomafont{dedication}\lecture@r{date}\par}
  {\usekomafont{dedication}\lecture@r{institute}\par}
\end{minipage}\vspace{-.66\bprop@len@margin}\par
\endgroup\clearpage}
}

\selectcoverpage{bachelor-proposal}

%% Figures, Tables and refs
%% -----------------------------------------------------------------------------

\addto\captionsngerman{\def\figurename{Abbildung}\def\figureautorefname{\figurename}\def\tablename{Tabelle}\def\tableautorefname{\tablename}}
\addto\captionsenglish{\def\figurename{Figure}\def\figureautorefname{\figurename}\def\tablename{Table}\def\tableautorefname{\tablename}}

\renewcommand*\captionformat{~~}

\def\meprolinkcolor{%
% we do not use paletteA if we are in a box. we use the box-color instead!
\ifcsname libx@boxid\endcsname\libx@get{BoxColor}\else paletteA\fi
}
\def\meprolinkfont{\relsize{-1}\sffamily}
\def\bprop@fig@style@nonbold#1{%
  {\hypersetup{allcolors=\meprolinkcolor}\meprolinkfont{#1}}%
}
\def\sbfamily{\fontseries{sb}\selectfont}
\def\bprop@fig@style#1{\bprop@fig@style@nonbold{{\sbfamily#1}}}

\DeclareCaptionLabelFormat{mepro-caption}{\bprop@fig@style{\paletteA{#1 #2:~~}}}
\captionsetup{format=plain,indention=1em,labelformat=mepro-caption,labelsep=none}

\RequirePackage{lecture-links}

\AtBeginDocument{%
\@ifpackageloaded{lecture-links}{%
\SetAllLinkStyle{\bprop@fig@style{#1}}%
\SetUrlLinkStyle{\bprop@fig@style@nonbold{#1}}%
\SetHrefLinkStyle{\bprop@fig@style@nonbold{#1}}%
\SetFootnoteLinkStyle{\bprop@fig@style@nonbold{#1}}%
\SetCiteColor{\meprolinkcolor}%
}{% dirty patches
\let\bprop@autoref\autoref
\renewcommand*\autoref[1]{{\bprop@fig@style{\bprop@autoref{#1}}}}%
\let\bprop@nameref\nameref
\renewcommand*\nameref[1]{{\bprop@fig@style{\bprop@nameref{#1}}}}%
}%
}

%% Sections
%% -----------------------------------------------------------------------------
\RequirePackage{lecture-remaining-space,needspace}

\newdimen\bprop@len@a
\colorlet{bprop@backgray}{gray!30!white}
\colorlet{bprop@backcol}{paletteA!42!bprop@backgray}
\def\bprop@tx@section{section}

% the bar
\def\bprop@sectionbar#1#2#3#4{%
  \smash{%
    \csname #1lap\endcsname{%
      \def\pdfbookmark[##1]##2##3{}%
      \hskip1ex
      \colorbox{bprop@backgray}{%
        \parbox\bprop@len@a{\phantom{#4}}%
      }%
      \hskip1ex
    }%
  }%
}% #2#3

\newlength\bprop@len@over@shift \bprop@len@over@shift=.33em

% the numline
\def\bprop@secnumline#1#2{%
  \sbox0{#1}%
  % \hskip\dimexpr\wd0+\bprop@len@over@shift\relax
  \llap{%
    \color{bprop@backcol}%
    \rule[-2.5pt]{\bprop@len@a}{#2}%
    \space\hskip\dimexpr\wd0+\bprop@len@over@shift\relax
  }\hskip\dimexpr-\wd0-\bprop@len@over@shift\relax
  \usebox0%
}

\def\bprop@sectionencap#1#2#3#4{%
  \remainingleft\bprop@len@a
  \bprop@sectionbar{l}{#1}{#2}{#4}%
  \@hangfrom{%
    \bprop@secnumline{#1}{#3}%
  }{#2}%
  \remainingright\bprop@len@a
  \bprop@sectionbar{r}{#1}{#2}{#4}%
}

\renewcommand*\sectionlinesformat[4]{%
  \protected@edef\@tmpa{#1}%
  \ifx\@tmpa\bprop@tx@section
    \bprop@sectionencap{#3}{#4}{1em}{Ay}%
  \else\@hangfrom{#3}{#4}\fi
}

\RedeclareSectionCommand[%
  runin=false,tocindent=1.85em,%
  beforeskip=1\baselineskip plus .33\baselineskip minus .33\baselineskip,%
  afterskip=.55\baselineskip
]{section}

\RedeclareSectionCommand[%
  runin=false,tocindent=4.15em,%
  beforeskip=1\baselineskip plus .33\baselineskip minus .33\baselineskip,%
  afterskip=\z@
]{subsection}

\RedeclareSectionCommand[%
  runin=on,tocindent=7.15em,afterskip=1ex,%
  beforeskip=1\baselineskip
]{subsubsection}

% \setkomafont{paragraph}{\mdseries\sffamily}
\RedeclareSectionCommand[%
  runin=false,%
  beforeskip=.25\baselineskip plus .25\baselineskip,%
  afterskip=-\parskip, font=\mdseries\itshape\rmfamily
]{paragraph}

\def\@bprop@c@pre#1{\phantomsection\nobreak#1\nobreak}

\def\bprop@firstoftwo#1#2{#1}
\def\bprop@secondoftwo#1#2{#2}

\DeclareRobustCommand*\bprop@subsecmark[1]{%
\begingroup
\let\label\relax \let\index\relax \let\glossary\relax
\expandafter\protected@xdef\csname bprop@subsec@\thesection @\endcsname{#1}%
\endgroup\if@nobreak\ifvmode\nobreak\fi\fi}

\def\bprop@getsubsecmark{\csname bprop@subsec@\thesection @\endcsname}
\def\ifbprop@subsecmark{\ifcsname bprop@subsec@\thesection @\endcsname\expandafter\bprop@firstoftwo\else\expandafter\bprop@secondoftwo\fi}

\let\bprop@section\section
\def\section{\@ifstar{\bprop@star@section}{\@dblarg\bprop@nostar@section}}
\def\bprop@star@section#1{\bprop@section*{#1}}
\def\bprop@nostar@section[#1]#2{\needspace{3\baselineskip}\pdfbookmark[1]{\the\numexpr\value{section}+1\relax)\space#1}{bprop@sec@@id@\thesection}\nobreak\bprop@section[#1]{#2}}

\let\bprop@subsection\subsection
\def\subsection{\@ifstar{\bprop@star@subsection}{\@dblarg\bprop@nostar@subsection}}
\def\bprop@star@subsection#1{\bprop@subsection*{#1}\bprop@subsecmark{#1}}
\def\bprop@nostar@subsection[#1]#2{\pdfbookmark[2]{\arabic{section}.\the\numexpr\value{subsection}+1\relax)\space#1}{bprop@subsec@@id@\thesubsection}\nobreak\bprop@subsection[#1]{%
  {\bprop@subsecmark{#1}}#2}}

\newcounter{bprop@paragraph}[subsection]
\let\bprop@paragraph\paragraph
\def\paragraph{\@ifstar{\bprop@star@paragraph}{\@dblarg\bprop@nostar@paragraph}}
\def\bprop@star@paragraph#1{\stepcounter{bprop@paragraph}\pdfbookmark[3]{#1}{bprop@paragr@@id@\thesubsection @\thebprop@paragraph}\bprop@paragraph*{#1}}
\def\bprop@nostar@paragraph[#1]#2{\stepcounter{bprop@paragraph}\@bprop@c@pre{\pdfbookmark[3]{\roman{bprop@paragraph})\space#1}{bprop@paragr@@id@\thesubsection @\thebprop@paragraph}}\bprop@paragraph[#1]{#2}}
% \llap{\paletteA{\textbullet}\quad}

%% Upper Segment
%% -----------------------------------------------------------------------------

\def\bprop@supervisors{}
\newcounter{bprop@supervisor@count}
\newcommand*\addSupervisor[2][]{\stepcounter{bprop@supervisor@count}%
\ifx\bprop@supervisors\@empty
\def\bprop@supervisors{\ifx!#1!#2\else\href{mailto:#1}{#2}\fi}%
\else\g@addto@macro\bprop@supervisors{, \ifx!#1!#2\else\href{mailto:#1}{#2}\fi}\fi}
\supervisor{\bprop@supervisors}

\AtEndPreamble{\def\lecture@personal@defaultsuffix{}}

\endinput