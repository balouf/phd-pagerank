// =============================================================================
// Chapter 6: BackRank
// =============================================================================

#import "../templates/environments.typ": *
#import "../templates/math-macros.typ": *
#import "../templates/algorithms.typ": *
#import "../templates/acronyms.typ": *

= BackRank <pr-back>

#citation([_Back to the Future_])[
 -- You've got to come back with me!\
 -- Where?\
 -- Back to the future.
]
#citation([Edgar #smallcaps[Morin], _Amour, poésie, sagesse_])[True novelty always arises from a return to the sources.]

#v(1em)

#lettrine("We")[ have just seen the general theoretical principles governing the various PageRank algorithms. In particular, it has become apparent that the problem of stochastic completion and that of PageRank diffusion can, and indeed should, be treated independently. In this chapter, which is an extension of a series of articles co-authored with Mohamed Bouklit @mathieu03effet @mathieu04effect, we shall study a way of performing stochastic completion while refining the random surfer model: taking into account the user's ability to go back at any point during navigation using the _Back_ button of their browser#footnote[I apologize in advance to purists, but I confess to preferring the term _Back_ over more verbose alternatives.]. As we shall see, the PageRank algorithm resulting from this model has numerous advantages over classical PageRank variants.
]

== On the importance of the _Back_ button

In 1995, Catledge and Pitkow published a study showing that the _Back_ button accounted for $41%$ of all recorded navigation actions ($52%$ of actions being hyperlink usage) @catledge95characterizing. Another study, by Tauscher and Greenberg, dating from 1997, reported $50%$ hyperlinks and $30%$ _Back_ @tauscher97people. Finally, let us cite a more recent study (2004) by Milic _et al._ @milic04smartback, whose main results are presented in @tab:back-stats.

#figure(
  table(
    columns: 4,
    stroke: 0.5pt,
    inset: 0.5em,
    align: (left, right, left, right),
    [*Navigation mode*], [*%*], [*Navigation mode*], [*%*],
    [Hyperlinks], [$42,5%$], [_Bookmarks_], [$2,9%$],
    [_Back_ button], [$22,7%$], [Manually typed #acr("URL")], [$1,6%$],
    [New session], [$11,2%$], [Start page], [$1,1%$],
    [Other methods#footnote[Dynamic loading, automatic redirections, address auto-completion...]], [$10,7%$], [_Refresh_ button], [$0,5%$],
    [Forms], [$6,6%$], [_Forward_ button], [$0,2%$],
  ),
  caption: [Statistical study of real surfers' navigation modes (after @milic04smartback)],
) <tab:back-stats>

From all these studies, a certain decline in the use of the _Back_ button between 1995 and 2004 seems to emerge, but according to @cockburn01empirical, one must take into account the changes that occurred during this interval#footnote[On the scale of the Web, if $9$ million pages represent a twig, $9$ years represent an eternity. During this interval, browser ergonomics evolved (_Bookmarks_, URL auto-completion, history browsing...), and user behavior was also modified by the omnipresence of search engines. Thus, rather than going back, some users prefer to re-enter in their search engine the query that led them to the page they came from.], as well as changes in the experimental protocols used.

The other interesting piece of information these figures give us is that in all cases, the use of the _Back_ button comes very clearly in second place, behind the use of hyperlinks which remains the preferred navigation mode. In particular, one should note that according to all studies, for every $2$ clicks on a hyperlink, there is at least $1$ use of the _Back_ button. Yet, the use of the _Back_ button has no equivalent in "classical" PageRank(s), whereas quantitatively less significant navigation modes such as manually typed URLs and _Bookmarks_ can be taken into account in the computation algorithms through the _zap_ vector.

Even though it is not really known to date whether a model closer to the real surfer necessarily yields a better PageRank, the importance of the _Back_ button in real users' behavior seemed to us a sufficient motivation to study the possibilities of incorporating it into a new PageRank model.

== Previous and contemporary work

Kleinberg, in the HITS algorithm @kleinberg98, also uses the inlink matrix, and thus works on a model where following hyperlinks backward is implicitly taken into account. Nevertheless, the purpose of the HITS algorithm is not to model the _Back_ button but to view the Web graph as a superposition of "hubs" and "authorities," the former pointing to the latter.

On the other hand, Fagin _et al._, in @fagin00random propose a very comprehensive study of the influence of introducing backward steps in a random walk, and propose a stochastic model of the random surfer that takes the _Back_ button into account. In this model, an initial _classical_ Markov chain is considered, to which an infinite-capacity history of visited pages is appended. To each page $v$ is associated a probability $alpha(i)$ of going back, provided the history is non-empty. The main results obtained are:
- Depending on the back probabilities, the process can be transient (asymptotically, the starting page is "forgotten" and eventually ceases to influence the probability distribution) or ergodic (backward steps bring the surfer infinitely often back to the starting page), with a phase transition between the two.
- In the particular case where the back probability $alpha$ does not depend on the page, if $alpha < 0,5$, the process converges to the same distribution as the _classical_ Markov chain (without the possibility of going back).
- The other cases are characterized, different types of convergence are considered, and the limit values (when they exist) are given.

The main drawback of Fagin _et al._'s model is the prohibitive cost#footnote[With Web graphs, any algorithm whose complexity exceeds $n$, or at most $n log n$, is considered prohibitive.] of computing asymptotic distributions.

In @sydow04random, Sydow proposes to reduce the complexity by limiting the history size. He thus introduces a model where only the last visited page is kept in memory (the _Back_ button cannot be used twice in a row), and where the _Back_ probability is uniform#footnote[Since the history is limited, the limit distribution is not necessarily equal to the distribution of the classical model, even for $alpha < 0,5$.]. The resulting algorithm exhibits performance comparable to that of a standard PageRank, in terms of convergence speed and resource requirements. The ranking obtained from the asymptotic probability distribution remains similar to that of a standard PageRank, with significant differences in the ranking of dominant pages.

Compared to Sydow's algorithm, our approach to incorporating the _Back_ button has the advantage of eliminating many problems associated with classical PageRank variants (stochastic completion, leaf trimming and restoration, convergence speed).

== Modeling the _Back_ button

Adopting an approach similar to @sydow04random#footnote[Unless it was Sydow who adopted an approach similar to ours, the research having been conducted independently, and each having discovered the other's work at the thirteenth _WWW_ conference.], we choose to introduce the possibility of going back with a limited history. Potentially, to reduce a stochastic process with memory $m$ to a memoryless Markov chain, one may need to consider the set of all paths of length $m$ in $G$. In the case where $m=1$, which is the one we shall study, the canonical working space is the set $E$ of hyperlinks. We shall introduce two intuitive models of the _Back_ button for the case where $m=1$, and show that for one of them, it is possible to reduce the working space from $E$ to $V$. We shall also see that this latter case is compatible with the use of a _zap_ factor.

=== Reversible model <sec:back-reversible>

In this model, we assume that at each step, the user can either choose an outgoing link from the current page, or press the _Back_ button, which will take them back to the previous step. The _Back_ button is treated as a hyperlink like any other. In particular, the probability of using the _Back_ button is the same as that of clicking on any given link, if at least $1$ exists, and equals $1$ in the absence of outgoing links. We believe this approach has two advantages over the uniform back probability chosen in @sydow04random:
- Intuitively, it seems logical that the use of the _Back_ button should depend on the available choices on the current page, that is, on the number of outgoing links. This is partially confirmed by the behaviors observed in @milic04smartback.
- Just like the virtual completion page introduced in @sec:pr-pagevirtuelle, the _Back_ button we have just modeled provides an escape even from pages without links, and creates a form of stochastic completion.

Let us finally note that the term _reversible_ is due to the fact that two consecutive uses of the _Back_ button cancel each other out.

Formally, the stochastic process we have just introduced can be described as follows: for each $v in V$, we define $P_n (v)$ as the probability of being at $v$ at time $n$. We also introduce the term $P_n^(r b)(w,v)$, for $w,v in V$, the probability of having moved from $w$ to $v$ between times $n-1$ and $n$. $P_n^(r b)(w,v)$ is nonzero whenever $(w,v)$ or $(v,w)$ is in $E$, and there is a very simple relationship between $P_n$ and $P_n^(r b)$:

$ P_n (v) = sum_(w arrow.l.r v) P_n^(r b)(w,v) $ <rev1>

where $w arrow.l.r v$ means _$w$ pointed to by or pointing to $v$_. One notes that the use of the _Back_ button requires working on the undirected graph induced by $G$.

Similarly, it is possible to write an equation describing the terms $P_(n+1)^(r b)(w,v)$: if $(w,v) in E$, to go from $w$ to $v$ between times $n$ and $n+1$, one can either follow the link from $w$ to $v$ (this requires being at $w$ at time $n$ and choosing among $d(w)+1$ possibilities), or use the _Back_ button (this requires having gone from $v$ to $w$ between times $n-1$ and $n$, and choosing among $d(w)+1$ possibilities). If $(w,v) in.not E$, but $(v,w) in E$, then the transition from $w$ to $v$ can only be performed _via_ the _Back_ button. There is no transition in other cases. We can therefore write:

$ P_(n+1)^(r b)(w,v) = cases(
  frac(1, d(w)+1)(P_n (w) + P_n^(r b)(v,w)) & "if" (w,v) in E,
  frac(P_n^(r b)(v,w), d(w)+1) & "if" (v,w) in E "and" (w,v) in.not E,
  0 & "otherwise."
) $ <rev2>

Using equations @rev1 and @rev2, it is possible to carry out an iterative computation of $P_n$, which can for example be initiated with the distribution

$ P_0^(r b)(w,v) = cases(
  frac(1, |E|) & "if" (w,v) in E,
  0 & "otherwise."
) $

If $G'=(V,E')$ is the undirected graph induced by $G$, it thus seems necessary to use $|V|+|E'|$ variables, compared to $|V|$ for standard PageRank. By substituting @rev1 into @rev2, it is possible to reduce the number of variables to $|E'|$, but this remains very large. This led us to consider the _irreversible Back_ model#footnote[It may be possible to reduce the number of variables to $|V|$, as we shall do with the irreversible model, but we have not yet formalized this reduction, and therefore leave the reversible _Back_ model at a purely descriptive stage.].

=== Irreversible model <sec:back-irreversible>

In this new model, we assume that it is not possible to use the _Back_ button twice in a row: it is grayed out after use, and one must first follow at least one real link before being able to use it again. Although more complex in appearance, this model has definite advantages over the reversible model:

- It is closer to the behavior of the _Back_ button in real browsers, which indeed becomes disabled when the history is exhausted. The use of the _Back_ button after history exhaustion in the reversible model is more akin to the use of the _Forward_ button in real browsers. And, if we are to believe @milic04smartback (see @tab:back-stats), the role of the _Forward_ button remains relatively negligible.
- It is compatible with the effective introduction of a _zap_ factor (see @backbuttonandcrossing).
- Computing the asymptotic distribution, even with a _zap_ factor, requires no more resources than in the case of a classical PageRank (see @sec:pr-back-optimisation).
- The use of the _Back_ button inevitably introduces a kind of "greenhouse effect" at dead-end pages, which can be problematic (an effect similar to that of recurrent strongly connected components described in the previous chapter). The irreversible model reduces this effect compared to the reversible model. Consider the example of @fig:back-greenhouse: a page $1$ has $2$ links, one to a dead-end page $2$, the other to an escape page from which the entire graph is reachable. If the random surfer ends up at $2$, they will necessarily return to $1$ via the _Back_ button. Going back to $2$ then creates the beginning of a greenhouse effect, and the return to $2$ occurs with probability $frac(2,3)$ in the reversible model (2 favorable outcomes out of 3), compared to $frac(1,2)$ in the irreversible case: the probability of remaining "stuck" at $2$ is lower in the irreversible model.

#figure(
  image("../figures/back-greenhouse.pdf", width: 50%),
  caption: [_Back_ button and greenhouse effect: role of (ir)reversibility],
) <fig:back-greenhouse>

In order to compute the evolution in such a model, we shall introduce:
/ $P_n^(h l)(w,v)$ : probability of going from page $w$ to page $v$ between times $n-1$ and $n$ using a hyperlink.
/ $P_n^(i b)(v)$ : probability of having arrived at page $v$ at time $n$ by using the _Back_ button.

It is possible to describe $P_(n+1)^(h l)(w,v)$ as a function of the situation at time $n$: to follow the link from $w$ to $v$, either one arrived at $w$ by following a real link, and must choose among $d(w)+1$ possibilities, or one arrived at $w$ via the _Back_ button, which grayed it out and limits the possibilities to $d(w)$. We thus have, for $(w,v) in E$,

$ P_(n+1)^(h l)(w,v) = frac(sum_(u -> w) P_n^(h l)(u,w), d(w)+1) + frac(P_n^(i b)(w), d(w)) $ <irr2>

One will note that since $w -> v$, there is no ambiguity in dividing by $d(w)$. One will also note that the destination vertex $v$ does not appear in any way in the expression for $P_(n+1)^(h l)(w,v)$. If $R$ is the set of pages with at least one link, and $S$ the set of dead-end pages, we shall therefore henceforth speak of $P_n^(h l)(w)$, with $w in R$, rather than $P_(n+1)^(h l)(w,v)$, with $(w,v) in E$.

Similarly, to have arrived at a page $v$ via the _Back_ button, one must previously have gone from $v$ to a page $w$ pointed to by $v$ using a hyperlink, then have chosen the _Back_ button among the $d(w)+1$ possibilities. In particular, one cannot have arrived at a page in $S$ via the _Back_ button, and $P_n^(i b)(v)$ is zero for $v in S$. For $v in R$, we can write:

$ P_(n+1)^(i b)(v) = sum_(w <- v) frac(P_n^(h l)(v), d(w)+1) $ <irr1>

where $w <- v$ means _$w$ pointed to by $v$_.

If we define the _Back_-attractiveness of a vertex $v$ belonging to $R$ by

$ a(v) = sum_(w <- v) frac(1, d(w)+1) $

it is then possible to rewrite equations @irr1 and @irr2 as follows:

$ P_(n+1)^(i b)(v) = a(v) P_n^(h l)(v) $ <irr3>

$ P_(n+1)^(h l)(v) = frac(1, d(v)+1) sum_(w -> v) P_n^(h l)(w) + frac(P_n^(i b)(v), d(v)) $ <irr4>

By combining @irr3 and @irr4, we obtain @irr5

$ P_(n+1)^(h l)(v) = frac(1, d(v)+1) sum_(w -> v) P_n^(h l)(w) + frac(a(v), d(v)) P_(n-1)^(h l)(v) $ <irr5>

And what about PageRank in all this? The probability of being at a page $v$ is the sum of the probability of having arrived there via the _Back_ button and that of having arrived there by following a link. By setting, by convention, $P_n^(h l)(v)=0$ for $v in S$, we have:

$
P_n (v) &= P_n^(i b)(v) + sum_(w -> v) P_n^(h l)(w) \
&= a(v) P_(n-1)^(h l)(v) + sum_(w -> v) P_n^(h l)(w)
$

=== Incorporating the _zap_ factor <backbuttonandcrossing>

Adding the irreversible _Back_ button guarantees a stochastic process regardless of the initial graph, with the sole condition that the support of the initial distribution contains no dead-end page. The problem of short-distance dead ends, such as page $2$ in @fig:back-greenhouse, is solved, but irreducibility problems remain. Worse still, the _Back_ button transforms medium- and long-distance dead ends into rank sinks (see @fig:back-impasse).

#figure(
  image("../figures/back-impasse.pdf", width: 50%),
  caption: [Recurrent strongly connected component created by the _Back_ button],
) <fig:back-impasse>

It is therefore necessary to introduce _zap_ into the process. We have chosen a classical _zap_, with a factor $d$ and a distribution $Z$. We require that "zapping" deactivates the _Back_ button: after a _zap_, it is not possible to go back. This has the practical advantage of not having to consider all the transitions implicitly generated by the _zap_, namely $(V times chi_Z) subset E$. This choice can also be interpreted at the surfer modeling level: according to @tab:back-stats, many real _zaps_ actually correspond to starting a new session, and therefore to a history reset to $0$.

Now that the framework is defined, it is possible to rewrite $P_n^(h l)(v)$, for $v in R$:

$ P_(n+1)^(h l)(v) = d (frac(1, d(v)+1) sum_(w -> v) P_n^(h l)(w) + frac(P_n^(i b)(v), d(v))) $ <damp2>

Similarly, we can rewrite the probability $P_n^(i b)(v)$ of being at time $n$ on a page $v$ with an empty history. By setting, by convention, $P_n^(h l)(v)=0$ for $v in S$, we have:

$ P_(n+1)^(i b)(v) = d dot a(v) P_n^(h l)(v) + (1-d) Z(v) $ <damp1>

And here, a problem arises: what happens if $chi_Z inter S != emptyset$? We will have a nonzero probability of being on a page in $S$ with no possibility of going back. In this situation, with probability $(1-d)$, our surfer will "zap" elsewhere, and with probability $d$... they will not know what to do!

We consider two methods to work around this problem:
- Choose $Z$ such that $chi_Z inter S != emptyset$. Since the only condition required of a _zap_ distribution is that it be covering, this is entirely possible. A distribution over home pages will suffice, provided no home page is a single dead-end page. One can also choose the uniform distribution over $R$ defined by
  $ Z(v) = cases(
    frac(1, |R|) & "if" v in R,
    0 & "otherwise."
  ) $
- Complete the stochastic process on the fly. We do know the probability of not knowing what to do between times $n$ and $n+1$: $d sum_(v in S) P_n^(i b)(v)$. It then suffices to redistribute this probability, for example as _zap_ according to $Z$. Equation @damp1 then becomes:
  $ P_(n+1)^(i b)(v) = d dot a(v) P_n^(h l)(v) + [1-d + d sum_(v in S) P_n^(i b)(v)] Z(v) $ <damp-compl>

== Practical algorithm: BackRank

We have just defined a stochastic process, which thanks to the _zap_ factor is irreducible and aperiodic. The Perron-Frobenius theorem therefore applies#footnote[Note in passing that we do not need to explicitly write the associated transition matrix, which is a square matrix of size $|V|+|E|$. It suffices to know that this matrix exists and that it implicitly governs our process.] and allows us to assert that successive iterations of equations @damp1 and @damp2 will converge to a unique fixed point (up to renormalization). The initial conditions can for example be a distribution according to $Z$ with an empty history ($P_0^(i b)=Z$ and $P_0^(h l)=0$).

=== Optimization <sec:pr-back-optimisation>

We shall assume here that we have chosen $Z$ such that $Z(v)=0$ if $v in S$.

From @damp1 and @damp2, $P_(n+1)^(h l)(v)$ can be defined recursively, for $v in R$, by:

$ P_(n+1)^(h l)(v) = frac(d, d(v)+1) sum_(w -> v) P_n^(h l)(w) + frac(d, d(v)) (d dot a(v) P_(n-1)^(h l)(v) + (1-d) Z(v)) $ <damp3>

@damp3 is a two-term recurrence, which is known to converge to a fixed point. Since only the fixed point is of interest, we can replace $P_(n-1)^(h l)$ with $P_n^(h l)$ while maintaining convergence to the same fixed point (Gauss-Seidel method). We thus obtain @damp4.

$ P_(n+1)^(h l)(v) = frac(d, d(v)+1) sum_(w -> v) P_n^(h l)(w) + frac(d, d(v)) (d dot a(v) P_n^(h l)(v) + (1-d) Z(v)) $ <damp4>

Note in passing that the iterations are performed over vertices with nonzero out-degree: there is an implicit leaf trimming, similar to what is done for standard PageRank (see @subsubsec:effeuilage).

After the vector $P_n^(h l)$ has converged to a vector $P^(h l)$, it remains to perform the "restoration" to obtain the asymptotic presence distribution $P$:

$
P(v) &= sum_(w -> v) P^(h l)(w) + P^(i b)(v) \
&= sum_(w -> v) P^(h l)(w) + d dot a(v) dot P^(h l)(v) + (1-d) Z(v)
$ <eq:backrank-remplumage>

We now have all the building blocks of _BackRank_ (@alg:pr-back). Note in passing that there is no need to perform renormalization, since there is convergence to a fixed point.

#alg(
  caption: [BackRank: PageRank model with irreversible _Back_ button],
)[
Input
- an adjacency matrix $M$ of an arbitrary graph $G=(V,E)$, with $V=(R union S)$, where $R$ is the set of pages with links, $S$ that of dead-end pages;
- a covering _zap_ distribution $Z$ over $R$;
- a _zap_ coefficient $d in ]0, 1[$;
- a real number $epsilon$.
Output\
The PageRank vector $P$ of the irreversible _Back_ model with _zap_.\
begin\
$D <- M un_n^t$\
$T <- 1 .\/ (D + un_n^t)$#comment[$1\/dot $ : element-wise inverse]\
$A <- M dot T$\
$T <- T_R$\
$D <- D_R$\
$C <- 1 .\/ D$\
$B <- d dot C times.o A_R$ #comment[$times.o$ : element-wise product]\
$Y <- d(1-d) C times.o Z$\
$N <- M_R$\
$R_0 = d C times.o Z$\
$delta <- 2 epsilon$, $n <- 0$\
while $delta > epsilon$#i:\
$R_(n+1) <- T times.o (N^t R_n) + B times.o R_n$\
$R_(n+1) <- d R_(n+1)$\
$R_(n+1) <- R_(n+1) + Y$\
$delta <- ||R_(n+1) - R_n||_1$\
$n<- n+1$#d\
$R_(n) <- R_(n)$ over $V$ (zero on $S$)\
return $P=M^t R_n + d A times.o R_n + (1-d) Z$
] <alg:pr-back>

=== Results <subsec:backrank-results>

Once an algorithm is completely defined, it must be put to the test. In order to make comparisons, we needed a baseline $X$, and we chose the $mu$-compensated PageRank defined in algorithm @alg:pr-hybride. It is indeed the simplest PageRank guaranteeing full stochastic control, apart from the uncompensated PageRank of course#footnote[We kept the compensation to make comparisons simpler, since both competitors thus produce a probability distribution.]. The leaf trimming and restoration technique was added for fairness toward BackRank, which performs it implicitly, and also for realism (this is the method that appears to be used in practice for _off-line_ computations on very large graphs, and BackRank is designed to handle very large graphs). For both algorithms, we used $d=0.85$ (unless stated otherwise) and $Z$ is the uniform distribution over the rake $R$.

The test was conducted on a crawl of 8 million URLs which, for technical reasons#footnote[The algorithms run under Matlab.], is split into two samples of $4$ million URLs.

==== Convergence

One of the first viability criteria for a PageRank-type algorithm is its convergence speed. @fig:backrank-convergence compares, on a semi-logarithmic scale, the value of the convergence parameter $delta$ after $n$ iterations. For BackRank, the condition $delta < 10^(-10)$ is reached after $87$ iterations in both samples, whereas for PageRank, it takes between $126$ and $127$ iterations. We measured the ratio of the observed geometric decrease at $10^(-10)$, and found $0.844$ for standard PageRank (convergence is always less than $d$, but tends asymptotically toward $d$) compared to $0.809$ for BackRank. We conjecture that this gap, which explains BackRank's performance, is due to the fact that unlike PageRank, BackRank implicitly uses a partial Gauss-Seidel method. It has been shown that using a Gauss-Seidel-type method considerably improves PageRank convergence @arasu01pagerank.

We should clarify that the algorithms used are, up to rewriting#footnote[Algorithm @alg:pr-hybride was rewritten following the model of algorithm @alg:pr-virtuelle.], exactly those described in this work. In particular, the power methods employed are truly power methods. For a more complete study of BackRank's convergence performance, one would need to investigate how it behaves under the many convergence acceleration methods that exist @arasu01pagerank @Haveliwala99efficient @kamvar03extrapolation.

To conclude this convergence study, let us note that on the samples considered, one iteration of BackRank takes on average $2$ seconds compared to $3$ seconds for PageRank. This difference is due to the fact that all computation constants, including the adjacency matrix, fit in memory. The $mu$-compensation thus has a non-negligible cost within an iteration. In fact, even compared to an uncompensated PageRank with $delta$ estimation, BackRank incurs only a small overhead, on the order of $5%$.

#figure(
  image("../figures/backrank-convergence.pdf", width: 80%),
  caption: [Compared convergence of BackRank and a standard PageRank],
) <fig:backrank-convergence>

==== Restoration

The finalization of the PageRank computation, which we call restoration, is a phase that is rather poorly described. According to @Page98, after convergence of PageRank on the graph restricted to vertices with nonzero out-degree, dead-end pages are added back to the process, _without affecting things significantly_#footnote["without affecting things significantly," _op. cit._]. But in order to assign an importance to these new pages, at least one PageRank iteration must be performed, which requires modifying most of the constants. In our experiment, we chose to perform four iterations on the full graph after convergence on the trimmed graph. Besides slower iterations ($6$ seconds, given that approximately $50%$ of the pages in the samples were dead-end pages), we observe, as in @subsubsec:effeuilage page @subsubsec:effeuilage, the reinitialization of the $delta$ parameter (see @fig:backrank-convergence): after four iterations, we are at the same level as after eight iterations of the main loop, that is, far from a stationary state...

For BackRank, restoration is much less problematic, since it reduces to applying @eq:backrank-remplumage _once and only once_. There is therefore no need to start a new series of iterations. Let us nonetheless specify, for honesty's sake, that since $delta$ refers to $P^(h l)$ and not $P$, the variations in $P$ can be larger than $delta$. Experimentally, it indeed appears that when $delta$ is around $10^(-10)$, the variations at the level of $P$ are on the order of $10^(-9)$ (slightly lower in fact). This result is nevertheless more than acceptable, especially in light of the variations of $10^(-1)$ generated by the PageRank restoration.

#figure(
  image("../figures/backrank-overlap.pdf", width: 80%),
  caption: [Overlap measurements between the top $n$ pages of BackRank and PageRank],
) <fig:backrank-overlap>

==== Ranking

Technical performance is only half of the evaluation criteria for a PageRank-type algorithm. One must also test the relevance of the importance ranking induced by the obtained probability distribution. A first approach consists of quantitatively comparing the results returned by BackRank and those returned by the reference PageRank. @fig:backrank-overlap presents such a comparison, showing the percentage of pages common to the top $n$ pages returned by BackRank and PageRank respectively. We observe significant fluctuations among the very top pages. As the number of pages considered increases, the overlap stabilizes, reaching a relatively stable value of $0.845$ when the number of pages considered approaches $1%$ of the sample size ($40000$ pages). This tends to prove that BackRank yields results fairly close to those returned by PageRank, with some specificities.

This $1%$ stabilized overlap of $0.845$ for both samples intrigued us. Upon closer examination, we noticed that the $1%$ overlap rate is a variable that depends only on $d$ (at least on our samples). @fig:backrank-d shows this relationship between $d$ and the $1%$ overlap for $0 <= d <= 1$. One will note in particular that:
- The overlap is a decreasing function of $d$. This echoes the idea, discussed in @subsec:choix_d, of the smoothing role of the _zap_ factor.
- In particular, the overlap tends toward $1$ as $d$ tends toward $0$, meaning that BackRank tends, just like PageRank, toward the in-degree distribution (see @subsec:choix_d).
- The overlap tends toward $50%$ as $d$ tends toward $1$, which seems to indicate that BackRank is intrinsically half different from (or half similar to?) standard PageRank. One should however not forget that when $d=1$, the ranking is ossified by rank sinks and no longer necessarily meaningful. Upon verification of a few URLs, this $50%$ overlap indeed only means that BackRank does not get trapped in exactly the same sinks as PageRank.

#figure(
  image("../figures/backrank-d.pdf", width: 80%),
  caption: [Influence of the _zap_ factor on the $1%$ overlap],
) <fig:backrank-d>

We are aware that we are only providing here a few indicators of the quality of BackRank's ranking. Strictly speaking, a complete validation would require incorporating BackRank into a search engine and conducting a series of satisfaction tests on a control population. In lieu of this, we shall use the reader as a control population, who can compare in lists @liste:xba, @liste:xha, @liste:xbb, and @liste:xhb the top 10 pages returned by BackRank and PageRank on the two samples considered. One will note for example that the main page of CNRS is ranked by BackRank, but not by PageRank (in fact, it is 16#super[th]), whereas for the Ministry of Education, the opposite is true (page also ranked 16#super[th], but by BackRank this time).

#figure(
  raw(block: true, lang: none, "
http://messagerie.business-village.fr:80/svc/jpro/search
http://server.moselle.cci.fr:80/Fichier/index.html
http://messagerie.business-village.fr:80/svc/jpro/aide
http://backstage.vitaminic.fr:80/add_artist.shtml
http://backstage.vitaminic.fr:80/
http://vosdroits.service-public.fr:80/Index/IndexA.html
http://emploi.cv.free.fr:80/index.htm
http://server.moselle.cci.fr:80/Fichier/listenaf.html
http://ec.grita.fr:80/isroot/fruitine/blank.html
http://www.adobe.fr:80/products/acrobat/readstep.html"),
  caption: [Sample 1: the 10 most important pages according to BackRank],
) <liste:xba>

#figure(
  raw(block: true, lang: none, "
http://backstage.vitaminic.fr:80/
http://backstage.vitaminic.fr:80/add_artist.shtml
http://forums.grolier.fr:8002/assemblee/nonmembers/
http://server.moselle.cci.fr:80/Fichier/listenaf.html
http://server.moselle.cci.fr:80/Fichier/index.html
http://messagerie.business-village.fr:80/svc/jpro/search
http://www.adobe.fr:80/products/acrobat/readstep.html
http://mac-texier.ircam.fr:80/index.html
http://mac-texier.ircam.fr:80/mail.html
http://bioscience.igh.cnrs.fr:80//current/currissu.htm"),
  caption: [Sample 1: the 10 most important pages according to PageRank],
) <liste:xha>

#figure(
  raw(block: true, lang: none, "
http://www.fcga.fr:80/
http://www.moselle.cci.fr:80/Fichier/index.html
http://www.lhotellerie.fr:80/Menu.htm
http://www.ima.uco.fr:80/
http://www.info-europe.fr:80/europe.web/document.dir/actu.dir/
http://www.moselle.cci.fr:80/Fichier/listenaf.html
http://www.machpro.fr:80/sofetec.htm
http://www.cnrs.fr:80/
http://www.quartet.fr:80/ce/
http://www.gaf.tm.fr:80/espace-pro.htm"),
  caption: [Sample 2: the 10 most important pages according to BackRank],
) <liste:xbb>

#figure(
  raw(block: true, lang: none, "
http://www.moselle.cci.fr:80/Fichier/index.html
http://www.moselle.cci.fr:80/Fichier/listenaf.html
http://www.lhotellerie.fr:80/Menu.htm
http://www.machpro.fr:80/sofetec.htm
http://www.education.gouv.fr:80/default.htm
http://www.infini.fr:80/cgi-bin/lwgate.cgi
http://www.proto.education.gouv.fr:80/cgi-bin/ELLIB/Lire/Q1
http://www.dma.utc.fr:80/~ldebraux/Genealogie/Whole_File_Report.html
http://www.ldlc.fr:80/
http://www.ldlc.fr:80/contact.shtml"),
  caption: [Sample 2: the 10 most important pages according to PageRank],
) <liste:xhb>
