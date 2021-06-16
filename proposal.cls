%% proposal documentclass
%% Florian Sihler, 4 Mar. 2021
%% Based on koma-script
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{proposal}[2021/03/04 The proposal documentclass]
\def\LayoutName{proposal}
% First we setup the document options
\LoadClass[numbers=noenddot,english,%
fontsize=11pt,twoside=false,footnotes=nomultiple,a4paper]{scrartcl}

%% Options
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=bprop,prefix=bprop@}

\DeclareStringOption[GreenWater]{cpalette}
\DeclareStringOption[DeepInk]{tpalette}
\DeclareBoolOption{debug}
\ProcessKeyvalOptions*

\ifbprop@debug
\errorcontextlines99999
\let\bprop@debug\typeout
\else
\let\bprop@debug\@gobble
\fi

%% Basic packages
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{lecture-coverpage}

\RequirePackage[ngerman,main=english]{babel}
\RequirePackage{etoolbox,calc,booktabs,scrhack,caption,tikz,tcolorbox}
\RequirePackage{uulm-logos}


%% Fonts
\AtEndPreamble{%
\RequirePackage[sc,osf]{mathpazo}
\RequirePackage[euler-digits,small]{eulervm}%
\RequirePackage[tabular,lining]{montserrat}%
}

%% Microtype
\RequirePackage{ifluatex}
\ifluatex\else\PassOptionsToPackage{kerning=true,spacing=true}{microtype}\fi
\RequirePackage[activate={true,nocompatibility},final,babel]{microtype}
% we do not want protusion in table of*
\preto\tableofcontents{\microtypesetup{protrusion=false}}
\appto\tableofcontents{\microtypesetup{protrusion=true}}

%% Line handling
\RequirePackage[all]{nowidow}
\RequirePackage{cuted}

%% General Layout & Packages
\RequirePackage{relsize,lastpage,fontawesome,afterpage,xstring,graphicx}
\RequirePackage[en-US]{datetime2}
\RequirePackage[draft=false]{scrlayer-scrpage}

\newlength\bprop@len@margin \bprop@len@margin=2.25cm
\RequirePackage[a4paper,margin=\bprop@len@margin,bottom=\bprop@len@margin-.75cm,includefoot,vcentering]{geometry}
\flushbottom

%% Hyperlinks => Figures, Tables and refs
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
\let\disablehyper\bprop@disablehyper}

%% Lists
\PassOptionsToPackage{inline}{enumitem}
\RequirePackage{enumitem}

\setlist{leftmargin=1.25em,labelwidth=1.25em}
\newlist{inlist}{enumerate*}{1}
\setlist[inlist]{itemjoin={{, }},itemjoin*={{, and }},label=($\roman*$),mode=boxed}
\newlist{orlist}{enumerate*}{1}
\setlist[orlist]{itemjoin={{, }},itemjoin*={{, or }},label=($\alph*$),mode=boxed}
\setlist[description]{labelwidth=*,font=\normalfont\itshape,topsep=\z@ plus 2pt,partopsep=\z@ plus 2pt}
\setlist[enumerate,1]{label=\arabic*.}
\setlist[enumerate,2]{label=\roman*.}
\setlist[enumerate,3]{label=\alph*.}
\setlist[enumerate,4]{label=\Alph*.}

%% Color-Palettes
\RequirePackage[enumitem,rect,lithieboxes,hyperref]{color-palettes}
\RequirePackage{tikz-palettes}
\UsePalette{\bprop@cpalette}
\UseTikzPalette{\bprop@tpalette}
\def\cplenumi#1{\textcolor{#1}{\smaller[3]\raisebox{.25ex}{$\blacksquare$}}}
% Note: smaller blocks :)

%% Footnotes
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
\newlength\segskipamount
\segskipamount=.35\baselineskip
\def\segskip{\vspace\segskipamount}

\parindent\z@ \parskip\segskipamount

\def\arraystretch{1.2}
\linespread{1.085}
\hbadness=99999\vbadness=99999
\hyphenpenalty=275
\lefthyphenmin=2 \righthyphenmin=2
\abovecaptionskip=5pt \@plus \p@ \@minus \p@
\belowcaptionskip=5pt \@plus \p@ \@minus \p@

%% Header and footer
\renewcommand*\sectionmark[1]{\markboth{#1}{}}

\DeclareNewLayer[%
topmargin,background,contents={%
\color{black!95!white}\rule[\baselineskip]{\layerwidth}{.2em}%
}]{bprop.digital.head.ruler}

\colorlet{bprop@headfoot}{gray}
\setkomafont{pageheadfoot}{\sffamily\footnotesize\color{bprop@headfoot}}

\def\bprop@getsubsecmark{\csname bprop@subsec@\thesection @\endcsname}
\def\ifbprop@subsecmark{\ifcsname bprop@subsec@\thesection @\endcsname\expandafter\bprop@firstoftwo\else\expandafter\bprop@secondoftwo\fi}

\def\bprop@copyright@notice@upper{\iflecture@er{authority}{}{\lecture@r{authority},\quad}\iflecture@er{supervisor}{}{Supervisor\ifnum\value{bprop@supervisor@count}>0\relax s\fi: \lecture@r{supervisor}}}
\def\bprop@copyright@notice@lower{\typesetAuthor\iflecture@er{copyright}{}{, \lecture@r{copyright}}}

\renewpairofpagestyles{scrheadings}{%
\ofoot{\strut\nohyper{\sbfamily\thepage}}%
\ihead{\begingroup\normalsize\normalfont\linespread{1.25}\begin{tikzpicture}[remember picture,overlay]
  \node[below left,yshift=-.25cm,xshift=-\bprop@len@margin,font=\usekomafont{pageheadfoot}\tiny,inner sep=\z@,outer sep=\z@,align=right] at(current page.north east) {\bprop@disablehyper\bprop@copyright@notice@upper\\\disablehyper\bprop@copyright@notice@lower};
\end{tikzpicture}\endgroup}%
\ifoot{%
  \parbox[t]{.85\linewidth}{\nohyper{%
  \lecture@rs{title}\iflecture@e{\leftmark}{}{\iflecture@er{title}{}{~\faAngleRight~}\leftmark\ifbprop@subsecmark{~\faAngleRight}{}~}\bprop@getsubsecmark
  }}}
}
\defpairofpagestyles[scrheadings]{bprop@title}{}
\AddLayersAtBeginOfPageStyle{scrheadings}{bprop.digital.head.ruler}
\AddLayersAtBeginOfPageStyle{plain.scrheadings}{bprop.digital.head.ruler}
\pagestyle{scrheadings}

%% Coverpage
\setkomafont{subtitle}{\mdseries\sffamily}
\setkomafont{author}{\bfseries\sffamily}
\setkomafont{dedication}{\mdseries\sffamily}

\@lecture@definereg{university}
\@lecture@definereg{institute}

\lecturecp@coverpagestyle{bachelor-proposal}{%
\def\lecture@coverpage@geometry{}%
\renewcommand*\maketitle{\begingroup
\setparsizes{\z@}{\z@}{\z@ \@plus 1fil}%
\thispagestyle{bprop@title}\null%
% First: Center top Type and title
\vspace*{-.33\bprop@len@margin}%
\begin{minipage}[t]{\linewidth}
  \raisebox{2.525pt}{\scalebox{.9}{\splogo}}\hfill\resizebox{73mm}!{\uulmlogo}
\end{minipage}\par
\begin{center}
  \vskip6em
  {\usekomafont{subject}{\lecture@r{subject}\par}}
  \vskip2em
  \sbox0{\pbox{\linewidth}{\centering\usekomafont{title}\Huge\lecture@r{title}}}%\par
  \textcolor{lightgray}{\rule{\linewidth}{\p@}}\medskip\par
  \usebox0\smallskip\par
  \textcolor{lightgray}{\rule{\linewidth}{\p@}}\smallskip\par
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
\addto\captionsngerman{\def\figurename{Abbildung}\def\figureautorefname{\figurename}\def\tablename{Tabelle}\def\tableautorefname{\tablename}}
\addto\captionsenglish{\def\figurename{Figure}\def\figureautorefname{\figurename}\def\tablename{Table}\def\tableautorefname{\tablename}}

\renewcommand*\captionformat{~~}

\def\bproplinkcolor{%
% we do not use paletteA if we are in a box. we use the box-color instead!
\ifcsname libx@boxid\endcsname\libx@get{BoxColor}\else paletteA\fi
}
\def\bproplinkcolorB{%
% we do not use paletteA if we are in a box. we use the box-color instead!
\ifcsname libx@boxid\endcsname\libx@get{BoxColor}\else paletteB\fi
}
\def\bproplinkfont{\relsize{-1}\sffamily}
\def\bprop@fig@style@nonbold#1{%
  {\hypersetup{allcolors=\bproplinkcolor}\bproplinkfont{#1}}%
}
\def\sbfamily{\fontseries{sb}\selectfont}
\def\bprop@fig@style#1{\bprop@fig@style@nonbold{{\sbfamily#1}}}

\DeclareCaptionLabelFormat{bprop-caption}{\bprop@fig@style{\paletteA{#1 #2:~~}}}
\captionsetup{format=plain,indention=1em,labelformat=bprop-caption,labelsep=none}

\RequirePackage{lecture-links}
\RequirePackage[outline]{contour}
\contourlength{1.2pt}

\AtBeginDocument{%
\@ifpackageloaded{lecture-links}{%
\SetAllLinkStyle{\bprop@fig@style@nonbold{#1}}%
\SetUrlLinkStyle{\bprop@fig@style@nonbold{#1}}%
\SetHrefLinkStyle{\bprop@fig@style@nonbold{#1}}%
\SetFootnoteLinkStyle{\bprop@fig@style@nonbold{#1}}%
\SetCiteColor{\bproplinkcolorB}%
}{% dirty patches
\let\bprop@autoref\autoref
\renewcommand*\autoref[1]{{\bprop@fig@style{\bprop@autoref{#1}}}}%
\let\bprop@nameref\nameref
\renewcommand*\nameref[1]{{\bprop@fig@style{\bprop@nameref{#1}}}}%
}}

%% Sections
\RequirePackage{lecture-remaining-space,needspace}
\newdimen\bprop@len@a
\colorlet{bprop@backgray}{gray!30!white}
\colorlet{bprop@numcol}{black}
\def\bprop@tx@section{section}
\def\bprop@tx@subsection{subsection}

\def\bprop@sectionbar@skp{.66ex}
% the bar
\def\bprop@sectionbar#1#2#3#4{%
\smash{%
\csname #1lap\endcsname{%
  \hskip\bprop@sectionbar@skp\relax
  \textcolor{#2}{\rule{\bprop@len@a-\bprop@sectionbar@skp}{#3}}#4%
  \hskip\bprop@sectionbar@skp\relax
}}}% #2#3

\newlength\bprop@len@over@shift \bprop@len@over@shift=.33em

% the numline
\def\bprop@secnumblock{%
  \hskip\dimexpr-\wd0-\bprop@len@over@shift\relax
  \usebox0\hskip\bprop@len@over@shift\relax
}

\def\bpropo@sectionbar@left{}
\def\bpropo@sectionbar@right{}

% left/right and content
\def\setsectionelement{%
  \@ifstar\bprop@setsectionelement\bprop@setsectionelement@center
}
\def\setsectionelementpar{%
  \@ifstar\bprop@setsectionelementpar\bprop@setsectionelementpar@center
}
\long\def\bprop@setsectionelementpar#1#2{\def\@tmpa{bpropo@sectionbar@#1}%
\expandafter\ifcsname\@tmpa\endcsname
  \expandafter\def\csname\@tmpa\endcsname{#2}%
\else\ClassError{proposal}{There is no sectionelement '#1'.}{Choose 'left' or 'right'.}\fi
}

\def\bprop@setsectionelementpar@center#1#2{\bprop@setsectionelementpar{#1}{%
\llap{%
  \parbox[t][\z@]{\bprop@len@margin}{\vspace*{\dimexpr\bprop@len@aftersec+.5\baselineskip+.3\p@}\par\noindent\centering#2}%
}}}

\long\def\bprop@setsectionelement#1#2{\def\@tmpa{bpropo@sectionbar@#1}%
\expandafter\ifcsname\@tmpa\endcsname
  \expandafter\def\csname\@tmpa\endcsname{#2}%
\else\ClassError{proposal}{There is no sectionelement '#1'.}{Choose 'left' or 'right'.}\fi
}

\def\bprop@setsectionelement@center#1#2{%
\bprop@setsectionelement{#1}{%
\llap{%
  \parbox[t][\z@]{\bprop@len@margin}{\centering#2}%
}}}

\def\bprop@sectionencap#1#2#3#4{%
\remainingleft\bprop@len@a
\bprop@sectionbar{l}{#3}{#4}{\bpropo@sectionbar@left}%
\@hangfrom{%
  \sbox0{\color{bprop@numcol}\contour{white}{#1}}%
  \bprop@secnumblock
}{\strut#2\strut}%
\remainingright\bprop@len@a
\bprop@sectionbar{r}{#3}{#4}{\bpropo@sectionbar@right}}

\def\bprop@subsectionencap#1#2{%
\@hangfrom{%
  \sbox0{\color{bprop@numcol}#1}%
  \bprop@secnumblock
}{#2}}

\renewcommand*\sectionlinesformat[4]{%
\hspace*{#2}\protected@edef\@tmpa{#1}%
\ifx\@tmpa\bprop@tx@section
  \bprop@sectionencap{#3}{#4}{bprop@backgray}{3pt}%
\else\ifx\@tmpa\bprop@tx@subsection
  \bprop@subsectionencap{#3}{#4}
\else\@hangfrom{#3}{#4}\fi\fi}
\renewcommand*\sectioncatchphraseformat[4]{%
\hskip#2\bprop@subsectionencap{#3}{#4}}

\def\bprop@len@aftersec{.3\baselineskip}
\RedeclareSectionCommand[%
runin=false,tocindent=1.85em,%
beforeskip=1\baselineskip plus .33\baselineskip minus .33\baselineskip,%
afterskip=\bprop@len@aftersec]{section}
\RedeclareSectionCommand[%
runin=false,tocindent=4.15em,%
beforeskip=1\baselineskip plus .33\baselineskip minus .33\baselineskip,%
afterskip=-.65\parskip]{subsection}
\RedeclareSectionCommand[%
runin=on,tocindent=7.15em,afterskip=1ex,%
beforeskip=1\baselineskip]{subsubsection}
\RedeclareSectionCommand[%
runin=false,beforeskip=.25\baselineskip plus .25\baselineskip,%
afterskip=-.65\parskip, font=\sffamily\sbfamily]{paragraph}

\def\@bprop@c@pre#1{\phantomsection\nobreak#1\nobreak}
\def\bprop@firstoftwo#1#2{#1}\def\bprop@secondoftwo#1#2{#2}

\DeclareRobustCommand*\bprop@subsecmark[1]{%
\begingroup\let\label\relax \let\index\relax \let\glossary\relax
\expandafter\protected@xdef\csname bprop@subsec@\thesection @\endcsname{#1}%
\endgroup\if@nobreak\ifvmode\nobreak\fi\fi}

\def\bprop@getsubsecmark{\csname bprop@subsec@\thesection @\endcsname}
\def\ifbprop@subsecmark{\ifcsname bprop@subsec@\thesection @\endcsname\expandafter\bprop@firstoftwo\else\expandafter\bprop@secondoftwo\fi}

\def\setsectionspace#1{\def\bprop@sec@spaceguard{\needspace{#1}}}
\setsectionspace{3\baselineskip}
\let\bprop@section\section
\def\section{\@ifstar{\bprop@star@section}{\@dblarg\bprop@nostar@section}}
\def\bprop@star@section#1{\bprop@section*{#1}}
\def\bprop@nostar@section[#1]#2{\bprop@sec@spaceguard\pdfbookmark[1]{\the\numexpr\value{section}+1\relax)\space#1}{bprop@sec@@id@\thesection}\nobreak\bprop@section[#1]{#2}}

\let\bprop@subsection\subsection
\def\subsection{\@ifstar{\bprop@star@subsection}{\@dblarg\bprop@nostar@subsection}}
\def\bprop@star@subsection#1{\bprop@subsection*{#1}\bprop@subsecmark{#1}}
\def\bprop@nostar@subsection[#1]#2{\pdfbookmark[2]{\arabic{section}.\the\numexpr\value{subsection}+1\relax)\space#1}{bprop@subsec@@id@\thesubsection}\nobreak\bprop@subsection[#1]{{\bprop@subsecmark{#1}}#2}}

\newcounter{bprop@paragraph}[subsection]
\let\bprop@paragraph\paragraph
\def\paragraph{\@ifstar{\bprop@star@paragraph}{\@dblarg\bprop@nostar@paragraph}}
\def\bprop@star@paragraph#1{\stepcounter{bprop@paragraph}\pdfbookmark[3]{#1}{bprop@paragr@@id@\thesubsection @\thebprop@paragraph}\bprop@paragraph*{#1}}
\def\bprop@nostar@paragraph[#1]#2{\stepcounter{bprop@paragraph}\@bprop@c@pre{\pdfbookmark[3]{\roman{bprop@paragraph})\space#1}{bprop@paragr@@id@\thesubsection @\thebprop@paragraph}}\bprop@paragraph[#1]{#2}}

%% Upper Segment
\def\bprop@supervisors{}
\newcounter{bprop@supervisor@count}
\newcommand*\addSupervisor[2][]{\@ifnextchar({\bprop@supervisors@add[#1]#2}{\bprop@supervisors@add[#1]#2(#2)}}
% TODO: reuse #2 :D
\def\bprop@supervisors@add[#1]#2(#3){
  \advance\c@bprop@supervisor@count\@ne
\ifx\bprop@supervisors\@empty
\def\bprop@supervisors{\ifx!#1!#3\else\href{mailto:#1}{#3}\fi}%
\else\g@addto@macro\bprop@supervisors{, \ifx!#1!#3\else\href{mailto:#1}{#3}\fi}\fi}
\supervisor{\bprop@supervisors}
% TODO: fix those hacks :D
\AtEndPreamble{\def\lecture@personal@defaultsuffix{}}
\newcommand*\NoBreakPar{\@afterheading}
\endinput