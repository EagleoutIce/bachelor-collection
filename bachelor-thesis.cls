%% bachelor-thesis documentclass
%% Florian Sihler, Jun 2021 (based on koma-script)
\NeedsTeXFormat{LaTeX2e}
\def\LayoutName{bachelor-thesis}
\ProvidesClass{\LayoutName}[2021/04/04 documentclass for bachelor-thesis]
% First we setup the document options
\LoadClass[numbers=noenddot,fontsize=10pt,twoside=false,footnotes=nomultiple,a4paper,headings=big]{scrbook}
\KOMAoption{listof}{leveldown,chaptergapline,totocnumbered}

%% Options
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=bt,prefix=bt@}

\DeclareStringOption[GreenWater]{cpalette}
\DeclareStringOption[DeepInk]{tpalette}
\DeclareBoolOption{debug}
\DeclareBoolOption{draft}
\DeclareBoolOption{print}
\DeclareBoolOption{clever}
\ProcessKeyvalOptions*

\ifbt@debug
\errorcontextlines99999
\overfullrule3cm
\let\bt@debug\typeout
\else
\let\bt@debug\@gobble
\fi

%% Basic packages
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{lecture-coverpage}

\RequirePackage[ngerman,main=english]{babel}
\RequirePackage{etoolbox,calc,booktabs,scrhack,caption,wrapfig,tikz,tcolorbox,ragged2e,chngcntr}
\RequirePackage{uulm-logos}

\linespread{1.044}
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
% we do not want protrusion in table of*
\preto\tableofcontents{\microtypesetup{protrusion=false}}
\appto\tableofcontents{\microtypesetup{protrusion=true}}

%% Line handling
\RequirePackage[all]{nowidow}
\RequirePackage{cuted}

%% General Layout & Packages
\RequirePackage{relsize,lastpage,fontawesome,afterpage,xstring,graphicx}
\RequirePackage[en-US]{datetime2}
\RequirePackage[draft=false]{scrlayer-scrpage}

\newlength\bt@len@margin \bt@len@margin2.25cm
\RequirePackage[a4paper,margin=\bt@len@margin,bottom=\bt@len@margin-.75cm,includefoot,includemp,marginpar=4.15cm,marginparsep=.75cm]{geometry}
\flushbottom


%% Hyperlinks => Figures, Tables and refs
\RequirePackage[%
  unicode=true,pdfencoding=auto,psdextra,luatex,%
  backref, pagebackref=false,%
  bookmarks=true, bookmarksopen=false, pdfdisplaydoctitle,%
  pdfborder={0 0 0}, breaklinks=true,%
  colorlinks, hyperindex,%
  bookmarkstype=X@b@X% erase
]{hyperref}

\RequirePackage{amsmath}

\ifbt@clever
\RequirePackage{varioref}
\RequirePackage[noabbrev]{cleveref}% capitalise; before notecolumn so i can nest
\fi

\RequirePackage{hypcap,bookmark,nameref}

\ifbt@draft
\RequirePackage{marginnote}
\else
\RequirePackage[draft=false,autoclearnotecolumns]{scrlayer-notecolumn}
\setkomafont{notecolumn.marginpar}{\footnotesize\itshape\@declaredcolor{gray}}
\fi

% just erases color
\def\nohyper#1{\begingroup\bt@disablehyper#1\endgroup}
\AtEndPreamble{%
\@ifpackageloaded{lecture-links}{%
\def\bt@disablehyper{\DisableLinkStyle\hypersetup{allcolors=.}}}%
{\def\bt@disablehyper{\hypersetup{allcolors=.}}}%
\let\disablehyper\bt@disablehyper}

%% Lists
\PassOptionsToPackage{inline}{enumitem}
\RequirePackage{enumitem}

\setlist{leftmargin=1.25em,labelwidth=1.25em,font=\normalfont\slshape}
\newlist{inlist}{enumerate*}{1}
\setlist[inlist]{itemjoin={{, }},itemjoin*={{, and }},label=$\roman*$),mode=boxed}
\newlist{orlist}{enumerate*}{1}
\setlist[orlist]{itemjoin={{, }},itemjoin*={{, or }},label=$\alph*$),mode=boxed}
\newlist{baseinlist}{enumerate*}{1}
\setlist[baseinlist]{itemjoin={{, }},itemjoin*={{, }},label={},mode=boxed}
\newlength\bt@desc@sep@len \bt@desc@sep@len=\z@ \@plus 2\p@
\setlist[description]{labelwidth=*,topsep=\bt@desc@sep@len,partopsep=\bt@desc@sep@len}
\setlist[enumerate,1]{label=\arabic*.}
\setlist[enumerate,2]{label=\roman*.}
\setlist[enumerate,3]{label=\alph*.}
\setlist[enumerate,4]{label=\Alph*.}

%% Color-Palettes
\RequirePackage[enumitem,rect,lithieboxes,hyperref]{color-palettes}
\RequirePackage{tikz-palettes}
\UsePalette{\bt@cpalette}
\UseTikzPalette{\bt@tpalette}
\def\cplenumi#1{\textcolor{#1}{\smaller[3]\raisebox{.25ex}{$\blacksquare$}}}
% Note: smaller blocks :)

%% Footnotes
\LetLtxMacro\bt@makefnmark\@makefnmark
\AtBeginDocument{\LetLtxMacro\@makefnmark\bt@makefnmark}

% footnote handling NOTE: we know there is a chapter!
\deffootnote{2em}{1em}{%
  \makebox[2em][r]{\nohyper{\hyperref[bt@fn:\thesection:\csname bt@footnoteref@\@mpfn\endcsname]{\thefootnotemark}}}~}
\renewcommand*\thefootnote{$\langle$\arabic{footnote}$\rangle$}
\renewcommand*\thempfootnote{$\langle$\alph{mpfootnote}$\rangle$}

\def\bt@footnoteref@footnote{fn@\arabic{footnote}}
\def\bt@footnoteref@mpfootnote{fn@\alph{mpfootnote}}

\preto\@footnotemark{\phantomsection\label{bt@fn:\thesection:\csname bt@footnoteref@\@mpfn\endcsname}\disablehyper}

%% (non) Rectangular paragraphs & hyphenation
\newlength\segskipamount
\segskipamount=.35\baselineskip
\def\segskip{\vspace\segskipamount}

\parindent\z@ \parskip\segskipamount

\def\arraystretch{1.2}
\linespread{1.085}
\hbadness99999 \vbadness99999
\hyphenpenalty275
\lefthyphenmin2 \righthyphenmin2
\abovecaptionskip5\p@ \@plus \p@ \@minus \p@
\belowcaptionskip5\p@ \@plus \p@ \@minus \p@

%% Header and footer
\let\chaptermark\@gobble
\let\sectionmark\@gobble

\DeclareNewLayer[%
topmargin,background,contents={%
\@declaredcolor{black!95!white}\rule[\baselineskip]{\layerwidth}{.2em}%
}]{bt.digital.head.ruler}

\colorlet{bt@headfoot}{gray}
\setkomafont{pageheadfoot}{\sffamily\footnotesize\@declaredcolor{bt@headfoot}}

\def\bt@getsubsecmark{\csname bt@subsec@\thesection @\endcsname}
\def\ifbt@subsecmark{\ifcsname bt@subsec@\thesection @\endcsname\expandafter\bt@firstoftwo\else\expandafter\bt@secondoftwo\fi}

\def\bt@copyright@notice@upper{\iflecture@er{authority}{}{\lecture@r{authority},\quad}\iflecture@er{supervisor}{}{Supervisor\ifnum\value{bt@supervisor@count}>0\relax s\fi: \lecture@r{supervisor}}}
\def\bt@copyright@notice@lower{\typesetAuthor\iflecture@er{copyright}{}{, \lecture@r{copyright}}}

\renewpairofpagestyles{scrheadings}{%
\ohead{\begingroup\normalsize\normalfont\linespread{1.25}\tikzpicture[remember picture,overlay]
  \node[below left,yshift=-.25cm,xshift=-\bt@len@margin,font=\usekomafont{pageheadfoot}\tiny,inner sep=\z@,outer sep=\z@,align=right] at(current page.north east) {\bt@disablehyper\bt@copyright@notice@upper\\\disablehyper\bt@copyright@notice@lower};
\endtikzpicture\endgroup}%
\ihead{\parbox{.85\linewidth}{\strut\raggedright\leftmark\iflecture@e{\leftmark}{}{\iflecture@e{\rightmark}{}{~\textbullet~}}\rightmark\strut}}%
\cfoot{\bt@runningpage}
}

\defpairofpagestyles[scrheadings]{bt@title}{}
\AddLayersAtBeginOfPageStyle{scrheadings}{bt.digital.head.ruler}
\AddLayersAtBeginOfPageStyle{plain.scrheadings}{bt.digital.head.ruler}
\pagestyle{scrheadings}

\def\bt@runningpage{\strut\nohyper{\hyperref[toc]{\usekomafont{pageheadfoot}\textbf{\thepage}}}}
\defpairofpagestyles[scrheadings]{bt@chapter}{%
\cfoot{\bt@runningpage}%
}

\AddLayersAtBeginOfPageStyle{bt@chapter}{bt.digital.head.ruler}

\defpairofpagestyles[scrheadings]{bt@frontmatter}{%
\ihead{\parbox{.85\linewidth}{\strut\raggedright\leftmark\iflecture@e{\leftmark}{}{\iflecture@e{\rightmark}{}{~\textbullet~}}\rightmark\strut}}%
\cfoot{\bt@runningpage}%
}

\AddLayersAtBeginOfPageStyle{bt@frontmatter}{bt.digital.head.ruler}

\defpairofpagestyles[scrheadings]{bt@chapter@frontmatter}{%
\cfoot{\bt@runningpage}%
}

\AddLayersAtBeginOfPageStyle{bt@chapter@frontmatter}{bt.digital.head.ruler}

\appto\frontmatter{\pagestyle{bt@frontmatter}\renewcommand{\chapterpagestyle}{bt@chapter@frontmatter}}
\appto\mainmatter{\pagestyle{scrheadings}\renewcommand{\chapterpagestyle}{bt@chapter}}


%% Coverpage
\setkomafont{subtitle}{\mdseries\sffamily}
\setkomafont{author}{\bfseries\sffamily}
\setkomafont{dedication}{\mdseries\sffamily}

\@lecture@definereg{university}
\@lecture@definereg{institute}

\lecturecp@coverpagestyle{bachelor-proposal}{%
\def\lecture@coverpage@geometry{}%
\renewcommand*\maketitle{\begingroup
\newgeometry{margin=\bt@len@margin,includemp=false}%
\setparsizes\z@\z@{\z@ \@plus 1fil}%
\thispagestyle{bt@title}\null
% First: Center top Type and title
\vspace*{-.33\bt@len@margin}%
\minipage[t]{\linewidth}
  \raisebox{2.525pt}{\scalebox{.9}{\splogo}}\hfill\resizebox{73mm}!{\uulmlogo}
\endminipage\par
\center
  \vskip6em
  {\usekomafont{subject}{\lecture@r{subject}\par}}
  \vskip2em
  \sbox0{\pbox{\linewidth}{\centering\usekomafont{title}\Huge\lecture@r{title}}}%\par
  \textcolor{lightgray}{\rule\linewidth\p@}\medskip\par
  \usebox0\smallskip\par
  \textcolor{lightgray}{\rule\linewidth\p@}\smallskip\par
  \vskip.5em
  \parbox{\wd0-1em}{\centering\usekomafont{subtitle}{\lecture@r{subtitle}\par}}
\endcenter
\vfill\lecture@r{titleimage}
\vfill\null
\raggedleft
\minipage{.45\linewidth}
  \raggedleft\disablehyper
  {\usekomafont{author}\typesetAuthors\par}
  {\usekomafont{dedication}\lecture@r{date}\par}
  {\usekomafont{dedication}\lecture@r{institute}\par}
\endminipage\vspace{-.66\bt@len@margin}\par
\endgroup\clearpage}}

\selectcoverpage{bachelor-proposal}

%% Figures, Tables and refs
\addto\captionsngerman{\def\figurename{Abbildung}\def\figureautorefname{\figurename}\def\tablename{Tabelle}\def\tableautorefname{\tablename}}
\addto\captionsenglish{\def\figurename{Figure}\def\figureautorefname{\figurename}\def\tablename{Table}\def\tableautorefname{\tablename}}

\renewcommand*\captionformat{~~}

\def\@primarylinkcolor{paletteA}
\def\btlinkcolor{\@primarylinkcolor}%
\def\@secondarylinkcolor{paletteB}
\def\btlinkcolorB{\@secondarylinkcolor}
\def\bt@fig@style@nonbold#1{%
  {\hypersetup{allcolors=\btlinkcolor}#1}%
}
\def\sbfamily{\fontseries{sb}\selectfont}
\def\bt@fig@style#1{\bt@fig@style@nonbold{{\sbfamily#1}}}

\DeclareCaptionLabelFormat{bt-caption}{\bt@fig@style{\itshape\paletteA{#1 #2:~~}}}
\DeclareCaptionLabelFormat{bt-caption-theorems}{\bt@fig@style{\itshape\paletteD{#1 #2:~~}}}
\captionsetup{format=plain,indention=1ex,textfont={color=gray,rm,sl,footnotesize},labelformat=bt-caption,labelsep=none,hypcapspace=.66\baselineskip,aboveskip=.5\baselineskip,justification=RaggedRight,singlelinecheck=false,font={footnotesize}}

\setcounter{tocdepth}{1}

\RequirePackage{lecture-links}
\RequirePackage[outline]{contour}
\contourlength{1.2pt}

\AtBeginDocument{%
\@ifpackageloaded{lecture-links}{%
\SetAllLinkStyle{\bt@fig@style@nonbold{#1}}%
\SetUrlLinkStyle{\bt@fig@style@nonbold{#1}}%
\SetHrefLinkStyle{\bt@fig@style@nonbold{#1}}%
\SetFootnoteLinkStyle{\bt@fig@style@nonbold{#1}}%
\SetCiteColor{\btlinkcolorB}%
}{% dirty patches
\let\bt@autoref\autoref
\renewcommand*\autoref[1]{{\bt@fig@style{\bt@autoref{#1}}}}%
\let\bt@nameref\nameref
\renewcommand*\nameref[1]{{\bt@fig@style{\bt@nameref{#1}}}}%
}}

%% Sections
\RequirePackage{lecture-remaining-space,needspace}
\newdimen\bt@len@a
\colorlet{bt@backgray}{gray!30!white}
\colorlet{bt@numcol}{black}
\def\bt@tx@section{section}
\def\bt@tx@subsection{subsection}

\def\bt@sectionbar@skp{.66ex}
% the bar
\def\bt@sectionbar#1#2#3#4{%
\smash{%
\csname #1lap\endcsname{%
  \hskip\bt@sectionbar@skp\relax
  \textcolor{#2}{\rule{\bt@len@a-\bt@sectionbar@skp}{#3}}#4%
  \hskip\bt@sectionbar@skp\relax
}}}% #2#3

\newlength\bt@len@over@shift \bt@len@over@shift=.33em

% the numline
\def\bt@secnumblock{%
  \hskip\dimexpr-\wd0-\bt@len@over@shift\relax
  \usebox0\hskip\bt@len@over@shift\relax
}

\def\bto@sectionbar@left{}
\def\bto@sectionbar@right{}

% left/right and content
\def\setsectionelement{%
  \@ifstar\bt@setsectionelement\bt@setsectionelement@center
}
\def\setsectionelementpar{%
  \@ifstar\bt@setsectionelementpar\bt@setsectionelementpar@center
}
\long\def\bt@setsectionelementpar#1#2{\def\@tmpa{bto@sectionbar@#1}%
\expandafter\ifcsname\@tmpa\endcsname
  \expandafter\def\csname\@tmpa\endcsname{#2}%
\else\ClassError{proposal}{There is no sectionelement '#1'.}{Choose 'left' or 'right'.}\fi
}

\def\bt@setsectionelementpar@center#1#2{\bt@setsectionelementpar{#1}{%
\llap{%
  \parbox[t][\z@]{\bt@len@margin}{\vspace*{\dimexpr\bt@len@aftersec+.5\baselineskip+.3\p@}\par\noindent\centering#2}%
}}}

\long\def\bt@setsectionelement#1#2{\def\@tmpa{bto@sectionbar@#1}%
\expandafter\ifcsname\@tmpa\endcsname
  \expandafter\def\csname\@tmpa\endcsname{#2}%
\else\ClassError{proposal}{There is no sectionelement '#1'.}{Choose 'left' or 'right'.}\fi
}

\def\bt@setsectionelement@center#1#2{%
\bt@setsectionelement{#1}{%
\llap{%
  \parbox[t][\z@]{\bt@len@margin}{\centering#2}%
}}}

\def\bt@sectionencap#1#2#3#4{%
\remainingleft\bt@len@a
\bt@sectionbar{l}{#3}{#4}{\bto@sectionbar@left}%
\@hangfrom{%
  \sbox0{\color{bt@numcol}\contour{white}{#1}}%
  \bt@secnumblock
}{\strut#2\strut}%
\remainingright\bt@len@a
\bt@sectionbar{r}{#3}{#4}{\bto@sectionbar@right}}

\def\bt@subsectionencap#1#2{%
\@hangfrom{%
  \sbox0{\color{bt@numcol}#1\thinspace}%
  \bt@secnumblock
}{#2}}

\renewcommand*\sectionlinesformat[4]{%
\hspace*{#2}\protected@edef\@tmpa{#1}%
\ifx\@tmpa\bt@tx@section
  \bt@sectionencap{#3}{#4}{bt@backgray}{3pt}%
\else\ifx\@tmpa\bt@tx@subsection
  \bt@subsectionencap{#3}{#4}
\else\@hangfrom{#3}{#4}\fi\fi}
\renewcommand*\sectioncatchphraseformat[4]{%
\hskip#2\bt@subsectionencap{#3}{#4}}


%% Table of contents & sectioning

\let\old@tableofcontents\tableofcontents
\preto\tableofcontents{\begingroup}
\appto\tableofcontents{\endgroup}

\deftocheading{toc}{\chapter*{\contentsname}\label{toc}\pdfbookmark[0]{\contentsname}{bt@toc@@id@toc}}

\CloneTOCEntryStyle{tocline}{bt@toc@section}
\TOCEntryStyleStartInitCode{bt@toc@section}{%
    \expandafter\renewcommand%
    \csname scr@tso@#1@entryformat\endcsname[1]{\nohyper{##1}}%
}

\newlength\bt@chapnumberboxwd
\bt@chapnumberboxwd=2.25em
\def\bt@chapnumberbox#1{\makebox[\bt@chapnumberboxwd][r]{#1}}
\RedeclareSectionCommands[tocpagenumberbox=\bt@chapnumberbox]
  {part,chapter,section,subsection,subsubsection,paragraph,subparagraph}

\DeclareTOCStyleEntry[]{bt@toc@section}{section}
\DeclareTOCStyleEntry[]{bt@toc@section}{subsection}

\def\bt@len@aftersec{.3\baselineskip}

\RedeclareSectionCommand[%
runin=false,tocindent=1.85em,%
beforeskip=1.25\baselineskip \@plus .33\baselineskip minus .33\baselineskip,%
afterskip=\bt@len@aftersec]{section}
\RedeclareSectionCommand[%
runin=false,tocindent=4.15em,%
beforeskip=1.125\baselineskip \@plus .33\baselineskip minus .33\baselineskip,%
afterskip=-.5\parskip]{subsection}
\RedeclareSectionCommand[%
runin=on,tocindent=7.15em,afterskip=1ex,%
beforeskip=1.125\baselineskip]{subsubsection}
\RedeclareSectionCommand[%
runin=false,beforeskip=.4\baselineskip \@plus .25\baselineskip,%
afterskip=-.6\parskip, font=\sffamily\sbfamily]{paragraph}


\def\@bt@c@pre#1{\phantomsection\nobreak#1\nobreak}
\def\bt@firstoftwo#1#2{#1}\def\bt@secondoftwo#1#2{#2}

\DeclareRobustCommand*\bt@subsecmark[1]{%
\begingroup\let\label\relax \let\index\relax \let\glossary\relax
\expandafter\protected@xdef\csname bt@subsec@\thesection @\endcsname{#1}%
\endgroup\if@nobreak\ifvmode\nobreak\fi\fi}

\def\bt@getsubsecmark{\csname bt@subsec@\thesection @\endcsname}
\def\ifbt@subsecmark{\ifcsname bt@subsec@\thesection @\endcsname\expandafter\bt@firstoftwo\else\expandafter\bt@secondoftwo\fi}

\let\bt@chapter\chapter
\def\chapter{\@ifstar{\bt@star@chapter}{\@dblarg\bt@nostar@chapter}}
\long\def\bt@star@chapter#1{\bt@chapter*{#1}}
\newif\ifappendix
\newif\ifdisableside
\def\disableside{\disablesidetrue}
\preto\appendix{\appendixtrue}

\def\@nextchap{\ifappendix\expandafter\@Alph\expandafter{\the\numexpr\c@chapter+1}\else\the\numexpr\c@chapter+1\fi}
\long\def\bt@nostar@chapter[#1]#2#3{\clearpage
% csummary as contents:
\ifx\\\detokenize{#3}\\\else
% cheat the next addtocontents declaration; currently not patching for argument failure
% note: we do not re-store by group so spaces are calculated correctly
\let\oldaddcontentsline\addcontentsline
\long\def\addcontentsline##1##2##3{\begingroup \let \label \@gobble \ifx \@currentHref \@empty \Hy@Warning {No destination for bookmark of \string \addcontentsline ,\MessageBreak destination is added}\phantomsection \fi \expandafter \ifx \csname toclevel@##2\endcsname \relax \begingroup \def \Hy@tempa {##1}\ifx \Hy@tempa \Hy@bookmarkstype \Hy@WarningNoLine {bookmark level for unknown ##2 defaults to 0}\else\Hy@Info {bookmark level for unknown ##2 defaults to 0}\fi \endgroup \expandafter \gdef \csname toclevel@##2\endcsname {0}\fi \edef \Hy@toclevel {\csname toclevel@##2\endcsname }\Hy@writebookmark {\csname the##2\endcsname }{##3}{\@currentHref }{\Hy@toclevel }{##1}\ifHy@verbose \begingroup \def \Hy@tempa {##3}\@onelevel@sanitize \Hy@tempa \let \temp@online \on@line \let \on@line \@empty \Hy@Info {bookmark\temp@online :\MessageBreak thecounter {\csname the##2\endcsname }\MessageBreak text {\Hy@tempa }\MessageBreak reference {\@currentHref }\MessageBreak toclevel {\Hy@toclevel }\MessageBreak type {##1}}\endgroup \fi \addtocontents {##1}{\protect \contentsline {##2}{##3\protect\csummary{#3}{\thechapter}}{\thepage }{\@currentHref }\protected@file@percent }\endgroup}%
\fi
\pdfbookmark[0]{\@nextchap)\space#1}{bt@chap@@id@\thechapter}\nobreak\bt@chapter[\strut#1]{#2\label{bt@chp@\thechapter}}%
\let\addcontentsline\oldaddcontentsline
\expandafter\gdef\csname bt@chaptersummary@\thechapter\endcsname{#3}\def\leftmark{#1}\def\rightmark{}\minitoc}

\def\bt@sum@prechap#1{\vspace*{-\baselineskip}\par\begingroup\RaggedLeft\color{gray}\itshape\let\cvsep\newline#1\par\endgroup\bigskip\par}

\def\setsectionspace#1{\def\bt@sec@spaceguard{\needspace{#1}}}
\setsectionspace{3\baselineskip}
\let\bt@section\section
\def\section{\@ifstar{\@dblarg\bt@star@section}{\@dblarg\bt@nostar@section}}
\def\bt@star@section[#1]#2{\bt@section*[#1]{#2}}
\def\bt@nostar@section[#1]#2{\bt@sec@spaceguard\pdfbookmark[1]{\the\numexpr\value{section}+1\relax)\space#1}{bt@sec@@id@\thesection}\nobreak\bt@section[#1]{#2}\def\rightmark{#1}}

\let\bt@subsection\subsection
\def\subsection{\@ifstar{\@dblarg\bt@star@subsection}{\@dblarg\bt@nostar@subsection}}
\def\bt@star@subsection[#1]#2{\bt@subsection*[#1]{#2}\bt@subsecmark{#2}}
\def\bt@nostar@subsection[#1]#2{\bt@sec@spaceguard\pdfbookmark[2]{\arabic{section}.\the\numexpr\value{subsection}+1\relax)\space#1}{bt@subsec@@id@\thesubsection}\nobreak\bt@subsection[#1]{{\bt@subsecmark{#1}}#2}}

\newcounter{bt@paragraph}[subsection]
\let\bt@paragraph\paragraph
\def\paragraph{\@ifstar{\bt@star@paragraph}{\@dblarg\bt@nostar@paragraph}}
\def\bt@star@paragraph#1{\stepcounter{bt@paragraph}\pdfbookmark[3]{#1}{bt@paragr@@id@\thesubsection @\thebt@paragraph}\bt@paragraph*{#1}}
\def\bt@nostar@paragraph[#1]#2{\bt@sec@spaceguard\stepcounter{bt@paragraph}\@bt@c@pre{\pdfbookmark[3]{\roman{bt@paragraph})\space#1}{bt@paragr@@id@\thesubsection @\thebt@paragraph}}\bt@paragraph[#1]{#2}}

%% Upper Segment
\def\bt@supervisors{}
\newcounter{bt@supervisor@count}
\newcommand*\addSupervisor[2][]{\@ifnextchar({\bt@supervisors@add[#1]#2}{\bt@supervisors@add[#1]#2(#2)}}
% TODO: reuse #2 :D
\def\bt@supervisors@add[#1]#2(#3){
  \advance\c@bt@supervisor@count\@ne
\ifx\bt@supervisors\@empty
\def\bt@supervisors{\ifx!#1!#3\else\href{mailto:#1}{#3}\fi}%
\else\g@addto@macro\bt@supervisors{, \ifx!#1!#3\else\href{mailto:#1}{#3}\fi}\fi}
\supervisor{\bt@supervisors}
% TODO: fix those hacks :D
\AtEndPreamble{\def\lecture@personal@defaultsuffix{}}
\newcommand*\NoBreakPar{\@afterheading}
\def\InputFrom#1{\def\input@path{#1}}


% garbage mp figures
\def\bt@cpstart@hook#1{\def\@captype{#1}\capstart}

\RequirePackage{xparse}% used for environ collection
\usepackage{environ}% should be removed in the future

\NewDocumentEnvironment{sidefig}{%
  O{#2}     % shortcation
  m         % normal caption
  D()\relax % optional label
  +b        % bodiiiiii of ma auuuuun
}{%
  \sidenote{\protect\bt@cpstart@hook{figure}#4\protect\captionof{figure}[#1]{#2}\ifx#3\relax\else\protect\label{#3}\fi}}
  {}% empty endings

\protected\def\bt@fco#1#2{\ifx!#1!#2\else#1\fi} % legacy

% starred variant will use tha detokinizing sidenote-variant
\long\def\bt@sidefigre@cntnt#1#2#3#4{\sidenote*{\bt@cpstart@hook{figure}#1\captionof{figure}[\ifx!#2!#3\else#2\fi]{#3}#4}}
% expand body once; #3 is currently a sloppy way to pass a label or other stuff below the caption
\NewEnviron{sidefig*}[3][]{\expandafter\bt@sidefigre@cntnt\expandafter{\expandafter\strip@prefix\meaning\BODY}{#1}{#2}{#3}}

\def\widecustomraise{\z@} % TODO: MAKE THIS MORE FLEXIBLE AND ELEGANT
\NewEnviron{widefig}[2][]{\hfuzz=\dimexpr\marginparsep+\marginparwidth\relax\begin{minipage}{\linewidth+\marginparsep+\marginparwidth}\protect\bt@cpstart@hook{figure}\sbox0{\BODY}\vb@xt@\z@{\usebox0}\par\vspace*{\dimexpr\ht0+\dp0-\widecustomraise}\sidenote[1.33\baselineskip]{\protect\captionof{figure}[\bt@fco{#1}{#2}]{#2}}\vspace*{\widecustomraise}\end{minipage}\par}

\NewEnviron{fig}[2][]{\begin{figure}\sidenote{\protect\disablesidetrue\protect\captionsetup{aboveskip=\z@}\protect\captionof{figure}[\bt@fco{#1}{#2}]{#2}}\BODY\end{figure}}

\NewEnviron{rawfig}[2][]{\sidenote{\protect\disablesidetrue\protect\captionsetup{aboveskip=\z@}\protect\captionof{figure}[\bt@fco{#1}{#2}]{#2}}\BODY}

\NewEnviron{sidetbl}[2][]{\sidenote{\BODY\protect\captionof{table}[\bt@fco{#1}{#2}]{#2}}}

\NewEnviron{widetbl}[2][]{\hfuzz=\dimexpr\marginparsep+\marginparwidth\relax\begin{minipage}{\linewidth+\marginparsep+\marginparwidth}\vbox{\BODY}\vskip3.5pt\par\sidenote{\protect\captionof{table}[\bt@fco{#1}{#2}]{#2}}\end{minipage}\par}

\NewEnviron{tbl}[2][]{\begin{table}\sidenote{\protect\disablesidetrue\protect\captionsetup{aboveskip=\z@}\protect\captionof{table}[\bt@fco{#1}{#2}]{#2}}\BODY\end{table}}

\NewEnviron{rawtbl}[2][]{\sidenote{\protect\disablesidetrue\protect\captionsetup{aboveskip=\z@}\protect\captionof{table}[\bt@fco{#1}{#2}]{#2}}\BODY}

\newenvironment{abstract}{\chapter*{Abstract}}{\vskip4em\par\flushright
  \nohyper{\typesetAuthor}{\footnotesize\\*
  \textcolor{gray}{\today}\par}%
\endflushright\par}

\LetLtxMacro\basefootnote\footnote
\newcounter{side@fn}[chapter]
%
\def\side@fn@lb#1{\protect\label{bt@sfn@#1}}
\long\def\footnote#1{\phantomsection\stepcounter{side@fn}\label{bt@side@fn@tar:\thesection:\arabic{side@fn}}\textsuperscript{$\langle$\hyperref[bt@side@fn@side:\thesection:\arabic{side@fn}]{\@arabic\c@side@fn}$\rangle$}\sidenote{\protect\bt@fnte{\thesection}{\arabic{side@fn}}{#1}}}
% #1 section; #2 fn; #3 text
\def\bt@fnte#1#2#3{\protect\phantomsection\protect\label{bt@side@fn@side:#1:#2}$\langle$\protect\hyperref[bt@side@fn@tar:#1:#2]{\protect\sbfamily#2}$\rangle$~#3}
%
\long\def\bt@csum@sitem#1{\@hangfrom{\textbullet~}{\ignorespaces#1}\par}
% #1 is text #2 is chapter
\long\def\csummary#1#2{\sidenote[\z@]{\textbf{\protect\nohyper{\protect\hyperref[bt@chp@#2]{Chapter #2:}}}\smallskip\newline#1}}

\long\def\smallcsummary#1{\protect\sidenote*[\z@]{\let\cvsep\item\itemize[label=\textbullet~,nosep,labelwidth=.75ex,labelsep=.75ex,leftmargin=*,itemsep=\smallskipamount]\item#1\enditemize}}

\def\bt@disabled@hyperlink#1#2{\bt@disablehyper\hyperlink{#1}{#2}}
\AtBeginDocument{\let\hjs@hyperlink\bt@disabled@hyperlink}

\ifbt@print
\PassOptionsToPackage{disable}{hierarchy-jumpers}
\fi
\usepackage[usefa]{hierarchy-jumpers}

\def\chapterextra{}
\renewcommand*\chapterformat{%
  \sbox0{\scalebox{2.33}{\color{bt@numcol}\hjs@linkedchapter}\thinspace}%
  \hskip\dimexpr-\wd0-\bt@len@over@shift\relax
  \usebox0\hskip\bt@len@over@shift\relax\chapterextra}

\def\sidenote{\@ifstar\@sidenote\@@sidenote}
\long\def\bt@sn@gd#1#2{\raisebox{#1}{\bt@sn@gd@{#2}}}
\long\def\bt@sn@gd@#1{\parbox\linewidth{\RaggedRight#1\vskip5pt}}
\def\@sidenote{\@ifnextchar[{\s@sidenote}{\s@sidenote[\z@]}}
\def\@@sidenote{\@ifnextchar[{\s@@sidenote}{\s@@sidenote[\z@]}}
\ifbt@draft
\long\def\s@sidenote[#1]#2{\marginnote{\normalfont\scriptsize\itshape\color{gray}\bt@sn@gd{#1}{#2}}}
\long\def\s@@sidenote[#1]#2{\marginnote{\normalfont\scriptsize\itshape\color{gray}\bt@sn@gd{#1}{#2}}}
\else
\long\def\s@sidenote[#1]#2{\ifx#1\z@ \makenote*{\bt@sn@gd@{#2}}\else\makenote*{\bt@sn@gd{#1}{#2}}\fi}
\long\def\s@@sidenote[#1]#2{\ifx#1\z@ \makenote{\protect\bt@sn@gd@{#2}}\else\makenote{\protect\bt@sn@gd{#1}{#2}}\fi}
\fi
\def\cvsep{\smallskip\newline}
\robustify\cvsep

\RequirePackage[tight,k-tight,undotted]{minitoc}
\AtBeginDocument{\dominitoc[n]}
\mtcsetrules{*}{off}
\def\mtcSfont{\small\rmfamily\upshape}
\mtcindent\z@
\def\mtcoffset{0pt}
\let\bt@mtc@numberline\@gobble
\def\bt@thirdofthree#1#2#3{#3}% gobble mtc fonts :) they are hacked into the pagenum and destroy hyperpage :)
\newif\if@bt@mtc@nxt@
\def\@mtcstyles{\normalfont\global\@bt@mtc@nxt@false\vspace*{\dimexpr-4.75\baselineskip-\parskip}\par\let\numberline\bt@mtc@numberline\def\l@section##1##2{\unskip\if@bt@mtc@nxt@~~\textbullet~~\else\global\@bt@mtc@nxt@true\fi\mbox{\nohyper{##1},~\thinspace\expandafter\hyperpage\expandafter{\bt@thirdofthree##2}}}}
\preto\minitoc{\unskip\minipage{\dimexpr\linewidth+\marginparsep+\marginparwidth-2\fboxsep}\parskip\z@\par\@mtcstyles}\appto\minitoc{\endminipage\bigskip\par}

% deny minitoc the filtering of subsections and lower
\def\MTC@contentsline#1#2#3#4{%
  \gdef\themtc{\arabic{mtc}}%
  \expandafter\ifx\csname #1\endcsname\chapter
    \stepcounter{mtc}%
    \if@mtc@longext@%
      \mtcPackageInfo[I0033]{minitoc}%
        {Writing\space\jobname.mtc\themtc\@gobble}%
      \def\mtcname{\jobname.mtc\themtc}%
    \else
      \mtcPackageInfo[I0033]{minitoc}%
        {Writing\space\jobname.M\themtc\@gobble}%
      \def\mtcname{\jobname.M\themtc}%
    \fi
    \immediate\closeout\tf@mtc
    \immediate\openout\tf@mtc=\mtcname
  \fi
  \mtc@toks{\noexpand\leavevmode #2}%
  \expandafter\ifx\csname #1\endcsname\appendix
    \stepcounter{mtc}%
    \if@mtc@longext@%
      \mtcPackageInfo[I0033]{minitoc}%
         {Writing\space\jobname.mtc\themtc\@gobble}%
      \def\mtcname{\jobname.mtc\themtc}%
    \else
      \mtcPackageInfo[I0033]{minitoc}%
         {Writing\space\jobname.M\themtc\@gobble}%
      \def\mtcname{\jobname.M\themtc}%
    \fi
    \immediate\closeout\tf@mtc
    \immediate\openout\tf@mtc=\mtcname
  \fi
  \expandafter\ifx\csname #1\endcsname\section
    \MTC@WriteContentsline{#1}{mtcS}{#3}{#4}%
  \fi
  % \expandafter\ifx\csname #1\endcsname\subsection
  %   \MTC@WriteContentsline{#1}{mtcSS}{#3}{#4}%
  % \fi
  % \expandafter\ifx\csname #1\endcsname\subsubsection
  %   \MTC@WriteContentsline{#1}{mtcSSS}{#3}{#4}%
  % \fi
  % \expandafter\ifx\csname #1\endcsname\paragraph
  %   \MTC@WriteContentsline{#1}{mtcP}{#3}{#4}%
  % \fi
  % \expandafter\ifx\csname #1\endcsname\subparagraph
  %   \MTC@WriteContentsline{#1}{mtcSP}{#3}{#4}%
  % \fi
  % \expandafter\ifx\csname #1\endcsname\coffee
  %   \MTC@WriteCoffeeline{#1}{#3}%
  % \fi
  % \expandafter\ifx\csname #1\endcsname\starchapter
  %   \stepcounter{mtc}%
  %   \if@mtc@longext@
  %     \mtcPackageInfo[I0033]{minitoc}%
  %        {Writing\space\jobname.mtc\themtc\@gobble}%
  %     \def\mtcname{\jobname.mtc\themtc}%
  %   \else
  %     \mtcPackageInfo[I0033]{minitoc}%
  %        {Writing\space\jobname.M\themtc\@gobble}%
  %     \def\mtcname{\jobname.M\themtc}%
  %   \fi
  %   \immediate\closeout\tf@mtc
  %   \immediate\openout\tf@mtc=\mtcname
  % \fi
  % \expandafter\ifx\csname #1\endcsname\starsection
  %   \MTC@WriteContentsline{#1}{mtcS}{#3}{#4}%
  % \fi
  % \expandafter\ifx\csname #1\endcsname\starsubsection
  %   \MTC@WriteContentsline{#1}{mtcSS}{#3}{#4}%
  % \fi
  % \expandafter\ifx\csname #1\endcsname\starsubsubsection
  %   \MTC@WriteContentsline{#1}{mtcSSS}{#3}{#4}%
  % \fi
  % \expandafter\ifx\csname #1\endcsname\starparagraph
  %   \MTC@WriteContentsline{#1}{mtcP}{#3}{#4}%
  % \fi
  % \expandafter\ifx\csname #1\endcsname\starsubparagraph
  %   \MTC@WriteContentsline{#1}{mtcSP}{#3}{#4}%
  % \fi
}
\hfuzz=\dimexpr\marginparsep+\marginparwidth

\c@topnumber\tw@
\c@bottomnumber\@ne
\c@totalnumber\thr@@
\def\floatpagefraction{.75}% 0.2
\def\topfraction{.5}% 0.7
\g@addto@macro\end@float{%
\ifnum\@floatpenalty<0 \ifnum\@floatpenalty<-\@Mii
\else\ifhmode\if@ignore\penalty\@M \hskip\z@skip\fi\fi
\fi\fi}

\newlength\bt@lo@numwidth \bt@lo@numwidth=2em
\def\bt@lotlof@base#1#2{\@tempdima=\bt@lo@numwidth\relax\nohyper{#1}\dotfill\hb@xt@\@pnumwidth{\hss\hyperpage{#2}\kern-\p@\kern\p@}\par}
\def\bt@lotlof@xchap#1#2{}
\def\@loflotstyles{\begingroup\let\l@figure\bt@lotlof@base \let\l@table\bt@lotlof@base \let\l@xchapter\bt@lotlof@xchap}
\preto\listoffigures\@loflotstyles \appto\listoffigures\endgroup
\preto\listoftables\@loflotstyles \appto\listoftables\endgroup

\@addtoreset{footnote}{chapter}
\endinput