%% proposal documentclass
%% Florian Sihler, 4 Mar. 2021
%%
%% Based on koma-script

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{proposal}[2021/03/04 The proposal documentclass]
\def\LayoutName{proposal}

% First we setup the document options
\LoadClass[%
  numbers=noenddot,ngerman,%
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

\RequirePackage[english,main=ngerman]{babel}

\RequirePackage{etoolbox,calc,booktabs,scrhack,caption,tikz}


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

\RequirePackage[a4paper,total={0.85\paperwidth,0.85\paperheight},centering]{geometry}
\flushbottom

%% Hyperlinks => Figures, Tables and refs
%% -----------------------------------------------------------------------------
\RequirePackage[%
    unicode=true,pdfencoding=auto,psdextra,pdftex, %
    backref, pagebackref=false, %
    bookmarks=true, bookmarksopen=false, pdfdisplaydoctitle, %
    pdfborder={0 0 0}, breaklinks=true, %
    colorlinks, hyperindex, %
    bookmarkstype=X@bprop@X% erase
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

\LetLtxMacro\lecture@makefnmark\@makefnmark
\AtBeginDocument{\LetLtxMacro\@makefnmark\lecture@makefnmark}

% footnote handling NOTE: we know there is a chapter!
\deffootnote{2em}{1em}{%
    \makebox[2em][r]{\nohyper{\hyperref[lecture@fn:\thesection:\csname lecture@footnoteref@\@mpfn\endcsname]{\thefootnotemark}}}~}

\renewcommand*\thefootnote{$\langle$\arabic{footnote}$\rangle$}
\renewcommand*\thempfootnote{$\langle$\alph{mpfootnote}$\rangle$}

\def\lecture@footnoteref@footnote{fn@\arabic{footnote}}
\def\lecture@footnoteref@mpfootnote{fn@\alph{mpfootnote}}

\preto\@footnotemark{\phantomsection\label{lecture@fn:\thesection:\csname lecture@footnoteref@\@mpfn\endcsname}\disablehyper}

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

\colorlet{lecture@headfoot}{gray}
\setkomafont{pageheadfoot}{\sffamily\footnotesize\color{lecture@headfoot}}

\def\bprop@getsubsecmark{\csname bprop@subsec@\thesection @\endcsname}
\def\ifbprop@subsecmark{\ifcsname bprop@subsec@\thesection @\endcsname\expandafter\bprop@firstoftwo\else\expandafter\bprop@secondoftwo\fi}

\renewpairofpagestyles{scrheadings}{%
\ohead{\strut\nohyper{{\sbfamily\thepage}\thinspace}}%
\ihead{\strut\nohyper{\lecture@rs{title}\iflecture@e{\leftmark}{}{~\faAngleRight~\leftmark\ifbprop@subsecmark{~\faAngleRight}{}~}\bprop@getsubsecmark}\strut}%
}

\AddLayersAtBeginOfPageStyle{scrheadings}{mepro.digital.head.ruler}
\AddLayersAtBeginOfPageStyle{plain.scrheadings}{mepro.digital.head.ruler}

\pagestyle{scrheadings}

%% Coverpage
%% -----------------------------------------------------------------------------
\selectcoverpage{sp-half}

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
\pagecolor{gray!1!white}

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

\RedeclareSectionCommand[%
  runin=false,tocindent=1.85em,%
  beforeskip=1\baselineskip plus .33\baselineskip minus .33\baselineskip,%
  afterskip=.15\baselineskip
]{section}

\RedeclareSectionCommand[%
  runin=false,tocindent=4.15em,%
  beforeskip=1\baselineskip plus .33\baselineskip minus .33\baselineskip,%
  afterskip=\z@
]{subsection}

\RedeclareSectionCommand[%
  runin=on,tocindent=7.15em,%
  beforeskip=1\baselineskip,%
  afterskip=1ex%
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
\def\bprop@nostar@section[#1]#2{\bprop@section[#1]{%
  {\pdfbookmark[1]{\thesection)\space#1}{bprop@sec@@id@\thesection}}#2}}

\let\bprop@subsection\subsection
\def\subsection{\@ifstar{\bprop@star@subsection}{\@dblarg\bprop@nostar@subsection}}
\def\bprop@star@subsection#1{\bprop@subsection*{#1}\bprop@subsecmark{#1}}
\def\bprop@nostar@subsection[#1]#2{\bprop@subsection[#1]{%
  {\pdfbookmark[2]{\thesubsection)\space#1}{bprop@subsec@@id@\thesubsection}\bprop@subsecmark{#1}}#2}}

\newcounter{bprop@paragraph}[subsection]
\let\bprop@paragraph\paragraph
\def\paragraph{\@ifstar{\bprop@star@paragraph}{\@dblarg\bprop@nostar@paragraph}}
\def\bprop@star@paragraph#1{\stepcounter{bprop@paragraph}\pdfbookmark[3]{#1}{bprop@paragr@@id@\thesubsection @\thebprop@paragraph}\bprop@paragraph*{#1}}
\def\bprop@nostar@paragraph[#1]#2{\stepcounter{bprop@paragraph}\@bprop@c@pre{\pdfbookmark[3]{\roman{bprop@paragraph})\space#1}{bprop@paragr@@id@\thesubsection @\thebprop@paragraph}}\bprop@paragraph[#1]{#2}}
% \llap{\paletteA{\textbullet}\quad}

%% Upper Segment
%% -----------------------------------------------------------------------------

\def\bprop@supervisors{}
\newcommand*\addSupervisor[2][]{\g@addto@macro\bprop@supervisors{\item \ifx!#1!#2\else\href{mailto:#1}{#2}\fi}}

\def\UpperSegment{\begingroup
\microtypesetup{protrusion=false}%
\sbox0{\begin{minipage}[t]{0.45\linewidth}
  \ifx\bprop@supervisors\@empty\else
  {\sbfamily Anwesende:}\par
  \bprop@disablehyper\begin{itemize}[nosep]
    \bprop@supervisors
  \end{itemize}
  \fi
  \end{minipage}}\usebox0\hfill\begin{minipage}[t][\ht0+\dp0]{0.45\linewidth}
  \raggedleft\bprop@topic\vfill
  \textcolor{gray}{\lecture@r{date}\ifx\bprop@time@from\@empty \hbox{}\else,\quad\bprop@time@from\,--\,\bprop@time@to\\*\fi}%
  \end{minipage}\bigskip\par
\endgroup}

\endinput