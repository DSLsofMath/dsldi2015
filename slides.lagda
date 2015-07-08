% --*-Latex-*--

\documentclass[colorhighlight,coloremph]{beamer}
\usetheme{boxes}
\usetheme{Madrid} % Lots of space (good), but no section headings
%\usetheme{Hannover}% Sections heading but too much wasted space
%\usetheme{Dresden}
%\usetheme{Warsaw}
\usepackage{natbib}
\usepackage{color,soul}
\usepackage{graphicx}
\usepackage{hyperref} %% for run: links
\usepackage{commath} % for abs, norm, etc.
%include dslmagda.fmt
%include slides.format

%%\input{macros.TeX}

% Changing the way code blocks are presented:
% \renewcommand\hscodestyle{%
%    \setlength\leftskip{-1cm}%
%    \small
% }

\newenvironment{myquote}
  {\begin{exampleblock}{}}
  {\end{exampleblock}}

\newtheorem*{def*}{Definition}

\addheadbox{section}{\quad \tiny DSLDI, 2015-07-07}
\title[DSLs of Mathematics]{DSLs of Mathematics, Theorems and Translations}

\author[C. Ionescu and P. Jansson]
       {Cezar Ionescu \hspace{2.5cm} Patrik Jansson\\
        cezar@@chalmers.se \hspace{2cm} patrikj@@chalmers.se}
%       {Cezar Ionescu  \qquad {\small \texttt{cezar@@chalmers.se}} \and
%        Patrik Jansson \qquad {\small \texttt{patrikj@@chalmers.se}} }

\begin{document}
\setbeamertemplate{navigation symbols}{}
\date{}
\begin{frame}

\maketitle

\end{frame}



%% -------------------------------------------------------------------
%% -------------------------------------------------------------------

\begin{frame}
  \frametitle{The problem}
\vfill

\emph{Domain-Specific Languages of Mathematics}
\citep{dslmcourseplan}: is a course currently developed at Chalmers in
response to difficulties faced by third-year students in learning and
applying classical mathematics (mainly real and complex analysis)
\vfill

Main idea: encourage computing science students to apply software
engineering skills to learning mathematics.
\vfill

Secondary goal: encourage mathematics students to learn some software
engineering skills.

\vfill
\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
  \frametitle{The ``computing science'' style}

In \emph{Communicating mathematics: Useful ideas from computer
  science} \citep{wells1995communicating}, Charles Wells formulated a
number of recommendations for mathematics teachers, among which:

  \begin{itemize}

  \item give \emph{specifications} of new concepts,

  \item {\color<2>{red}{make the distinction between syntax and semantics explicit}},

  \item {\color<2>{red}{introduce informal parsing of mathematical expressions}},

  \item {\color<3>{red}begin proving a theorem by replacing the words that have
    definitions with the text of their definitions},

  \item {\color<3>{red}give calculational proofs in addition to traditional ones},

  \item use the concepts of type and polymorphism explicitly

  \end{itemize}

\vfill
\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Specification vs. implementation}
\vfill
Example: |(a, b)| vs. |{a, {a, b}}|

BNF-like representation of the syntax:

<  pair a b :=  '(' a ', ' b ')'

Specification:

< eval (a, b) = eval (c, d) <=> eval a = eval c && eval b = eval d

Haskell-like representation:

<  data Pair a b = MkPair a b

Semantics is given by evaluation to ZF sets:

<  eval                :  Pair a b -> ZFSet
<  eval (MkPair a b)   =  {a, {a, b}}

\vfill
\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Specification vs. implementation}
\vfill
Example: natural numbers.

BNF-like syntax:

< nat := 0 | 'S' nat

Specification: Peano axioms.

Haskell-like syntax:

> data Nat = Z | S Nat

Evaluation to sets:

> eval        :  Nat -> ZFSet
> eval Z      =  empty
> eval (S n)  =  eval n `join` { eval n }

\vfill
\end{frame}


%% -------------------------------------------------------------------

\begin{frame}
\frametitle{An algebra for Peano naturals}
\vfill

> data Nat  =  Z | S Nat

For evaluation we need something that corresponds to |Z| and something
that corresponds to |S|:

> type NatAlg a  =  (a, a -> a)

> eval                 :  Nat -> NatAlg a -> a
> eval  Z      (z, s)  =  z
> eval  (S n)  (z, s)  =  s (eval n (z, s))

The previous, ``canonical'' semantics:

< canonical  :  NatAlg ZFSet
< canonical  =  (empty, \ x -> x `join` {x})

\vfill
\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Syntax vs. semantics}
\vfill
Example: monoid.

Haskell-like representation of the syntax:

> data MonSyn var  =  Z | var | Plus (Mon var) (Mon var)

> type MonAlg a    =  (a, a -> a -> a)

> type Dict var a  =  var -> a -- partial!

> eval : MonSyn var -> MonAlg a -> Dict var a -> a
> eval Z (z, plus) dict  =  z
> eval x (z, plus) dict  =  dict x
> eval (Plus x1 x2)      =  (eval x1) `plus` (eval x2)

\vfill
\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Syntax vs. semantics}
\vfill
Example: interval extensions.

Let |IR| be the set of closed real intervals.

A rational function |f : Real -> Real| can be extended to intervals,
|ext f : IR -> IR|, by replacing each operation with the interval
counterparts.

Consider:

< f x           =  x - x
< ext f [a, b]  =  [a, b] - [a, b] 
<               =  [a - b, b - a]

< g x           =  0
< ext g [a, b]  =  [0, 0]

We have that |f = g|, but |ext f neq ext g|.

\vfill
\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Same syntax, different semantics}
\vfill

Consider:

\begin{itemize}
\item limits of sequences: |limseq|

\item series: |series|

\item power series: |powseries|
\end{itemize}

The syntax is always given by a function |a : Nat -> X|, but the
evaluation (semantics) is very different.


\vfill
\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Same semantics, different syntax}
\vfill

Example: complex numbers.
\vfill
Different syntaxes:
\vfill
\begin{itemize}
\item algebraic: |a + bi|
  \begin{itemize}
  \item |i| is ``the square root of |-1|''
  \item multiplication is algebraic
  \end{itemize}
\item geometric: |r (cos theta + i sin theta)|
  \begin{itemize}
  \item |i| is ``rotate by 90°''
  \item rotations, translations, expansions
  \end{itemize}
\end{itemize}

\vfill
Yet the semantics is the same: |CC|
\vfill
Other examples: optimisation vs. equations, differentiability
vs. Taylor series in the complex plane.
\vfill
Non-mathematical example: *roff vs. tex vs. html

\vfill
\end{frame}

%% -------------------------------------------------------------------

\begin{frame}[fragile]
\frametitle{Abstraction barriers}
\vfill

Example: continuity defined in terms of limits.

\begin{def*}[\cite{adams2010calculus}, page 78]

We say that a function |f| is {\bfseries continuous} at an interior point
|c| of its domain if

< limxc (f x) = f c

If either |limxc (f x)| fails to exist or it exists but is not equal
to |f c|, then we will say that |f| is {\bfseries discontinuous} at |c|.

\end{def*}

\vfill
\end{frame}


%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Abstraction barriers}
\vfill
Differentiability defined in terms of limits.

\begin{def*}[\cite{adams2010calculus}, page 99]

The derivative of a function |f| is another function |f'| defined by

%%< f' x = limfrac (f(x + h) - f(x)) (h)

< f' x = limdiff

at all points |x| for which the limit exists (i.e., is a finite real
number). If |f' (x)| exists, we say that |f| is {\bfseries differentiable}
at |x|.

\end{def*}
\vfill
\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Abstraction barriers}
\vfill

Alternative: differentiability in terms of continuity.

\begin{def*}[Adapted from \cite{pickert1969einfuehrung}]

Let |X included Real, a elemOf X| and |f : X -> Real|.  If there
exists a function |phif : X -> X -> Real| such that, for all |x elemOf
X|

< f x = f a + (x - a) * phif a x 
  
\underline{such that |phif a : X -> Real| continuous at |a|}, then |f| is
{\bfseries differentiable} at |x|.  The value |phif a a| is called the
{\bfseries derivative} of |f| at |a| and is denoted |f' a|.
\end{def*}


\vfill
\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{A calculational proof}
\vfill
\small
\def\commentbegin{\quad\{\ }
\def\commentend{\}}
\newcommand{\gap}{\pause\vspace{-0.8cm}}
\begin{spec}
   (f x) * (g x)
\end{spec}
\gap
\begin{spec}
= {- differentiability -}

   (f a + (x - a) * phif a x) *
   (g a + (x - a) * phig a x) *
\end{spec}
\gap
\begin{spec}
= {- arithmetic -}

   f a * g a  +
   (x - a)  *  (g a  *  phif a x  + 
                        phig a x  *  (f a + (x - a) * phif a x)
\end{spec}
\gap
\begin{spec}
= {- differentiability of |f| -}

   f a * g a  +
   (x - a)    *  (g a  *  phif a x  +  phig a x  *  f x)
\end{spec}
\gap
\begin{spec}
= {- ``pattern-matching'': |h = f * g| and |phih| -}

   h a + (x - a) * phih a x
\end{spec}
\gap
\begin{spec}
=> {- continuity of composition, differentiability -}
  
   h' a = phih a a = g a * f' a + g' a * f a
 
\end{spec}

\vfill
\end{frame}

%% -------------------------------------------------------------------

\begin{frame}
\frametitle{Conclusions}
\vfill

Course materials developed on GitHub:
\url{https://github.com/DSLsofMath}

\vfill

Topics:

\begin{itemize}
\item limits, series, power series

\item Taylor expansion, elementary functions, simple differential equations

\item holomorphic functions, Cauchy-Riemann equations, holomorphic =
  analytic

\item Fourier, Laplace
\end{itemize}

\vfill

Feedback, criticism, etc., most welcome!
\vfill
\end{frame}


%% -------------------------------------------------------------------


\appendix
\section{Bibliography}
\begin{frame}
\frametitle{Bibliography}

\bibliographystyle{abbrvnat}
\bibliography{dslm}
\end{frame}

%% -------------------------------------------------------------------

\end{document}


\begin{def*}[\cite{rudin1976principles}, page 85]

Suppose |X| and |Y| are metric spaces, |E included X|, |p elemOf E|,
and |f : E -> Y|.  Then |f| is said to be \emph{continuous at |p|} if for every |epsilon > 0|
there exists a |delta > 0| such that:

< dY(f x, f p) < epsilon

for all points |x elemOf E| for which |dX(x, p) < delta|.

\end{def*}
