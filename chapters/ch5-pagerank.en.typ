// =============================================================================
// Chapter 5: PageRank, a way to estimate the importance of web pages
// (English translation)
// =============================================================================

#import "../templates/environments.typ": *
#import "../templates/math-macros.typ": *
#import "../templates/algorithms.typ": *
#import "../templates/acronyms.typ": *

= PageRank, a way to estimate the importance of web pages <pr-pagerank>

#citation([Michel #smallcaps[de Pracontal], _l'imposture scientifique_])[When a researcher wants to publish a paper in a specialized journal, he must go through review committees that evaluate the quality of his work according to precise criteria. To appear on television or in a newspaper, all one needs is a good story to tell.]
#citation([Tom #smallcaps[Fasulo]])[Surfing the internet is like sex: everyone brags about doing more than they actually do. But in the case of the Internet, they brag far more.]
#citation([])[Omnes Viae ad Googlem ducent]

#v(1cm)

#lettrine("This chapter")[will attempt to lay the intuitive, axiomatic, and theoretical foundations of _PageRank_-type ranking methods, brought to prominence by the famous _Google_ search engine @Google98. This painstaking _survey_ work was greatly facilitated by Mohamed Bouklit, who, with the help of Alain Jean-Marie, cleared the ground before me @bouklit01methodes @bouklit02analyse, providing me with all the necessary references.]

There already exist a number of _surveys_ on PageRank (cf @bianchini02pagerank @bianchini03inside @langville04deeper), but we deemed this chapter necessary because it presents all PageRanks from a single perspective, that of the stochastic interpretation, and highlights several convergence results that cannot be found elsewhere#footnote[At least not applied to PageRanks.].

== A needle in a haystack...

One can find (just about) anything on the web; virtually all network users agree on this. Whether the information I am looking for exists on the web is no longer the crucial question. Nowadays, the problem has become: _How do I find the page I am looking for?_

- By knowing, one way or another, the address in question. For instance, by reading on a bag of flour the address of a site offering cooking recipes, by receiving an email from a friend recommending a web address, or by having the address in one's _Bookmarks_...
- By navigating (surfing) the web, starting from a known address. If, for example, I am looking for a page about raccoons and I know of a zoology website, starting from that site may be a good way to find the page I am looking for.
- By using a search engine. In exchange for a _query_, that is, a set of words attempting to describe more or less precisely what I am looking for, the engine will return a list of pages likely to answer this query. According to @lawrence99accessibility, 85% of internet users rely on search engines.

#figure(
  table(
    columns: 3,
    stroke: 0.5pt,
    inset: 0.5em,
    align: (left, right, right),
    [*Query*], [*Google*], [*Yahoo*],
    [PageRank], [1 410 000], [807 000],
    [Raton laveur], [18 100], [25 300],
    [Amazon], [107 000 000], [66 600 000],
    [Pâte à crêpes], [46 300], [30 900],
    [Pâte à crêpe], [22 800], [47 000],
  ),
  caption: [Number of results returned by Google and Yahoo for selected queries (August 2004)],
) <gooyah-aout>

The whole challenge for search engines is to return the pages the user is actually looking for. However, the answers to a given query often number in the hundreds or even thousands#footnote[The problem is in fact less critical if duplicates are eliminated --- see #fref(<tab:pages-uniques>) --- but it remains significant.], as shown in @gooyah-aout. On the other hand, users quickly lose patience, and it is estimated that 90% of users do not go beyond the first page of results.

The goal of search engines is therefore to display within the first ten to twenty results the documents that best answer the question posed. In practice, no sorting method is perfect, but their variety gives search engines the possibility of combining them to better refine their results. The main sorting methods are the following:

/ Relevance ranking: Relevance ranking is the oldest and most widely used sorting method. It is based on the number of occurrences of the search terms in the pages, their proximity, their position in the text @salton89automatic @yuwono95... Unfortunately, this method has the drawback of being easy to manipulate by authors wishing to place their pages at the top of the list. To do so, it suffices to overload the page with important words, either in the header or in invisible text within the body of the page.

/ URL analysis: One can also assign importance to a page based on its #acr("URL"). For instance, depending on the context, #acrpl("URL") belonging to the _Top Level Domain_ `http:.com` might be more important than others, as might #acrpl("URL") containing the string `http:home` @li00defining. It has also been suggested that #acrpl("URL") at a low depth in the cluster tree are more important than others @cho98efficient.

/ Inbound links: Citation counting consists of assigning pages an importance proportional to the number of known links to that page. This method has been widely used in scientometrics to evaluate the importance of publications @price63little.

/ PageRank: As we shall see, PageRank is a kind of recursive generalization of citation counting.

== The two axioms of PageRank <sec:pr-axiomes>

PageRank, introduced by Brin _et al._ in 1998 @Page98, is the ranking method that made the _Google_ search engine @Google98 distinctive. It is in fact an adaptation to the Web of various methods introduced by scientometricians#footnote[For several decades now, a new field of research has emerged that is devoted to the study of human intellectual production. The main branches of this meta-science are:
/ Bibliometrics: defined in 1969 as "the application of mathematics and statistical methods to books, articles, and other means of communication."
/ Scientometrics: it can be considered as bibliometrics specialized to the field of Scientific and Technical Information (STI). However, scientometrics more generally refers to the application of statistical methods to quantitative data (economic, human, bibliographic) characterizing the state of science.
/ Informetrics: a term adopted in 1987 by the F.I.D. (International Federation of Documentation, IFD) to designate all metric activities related to information, covering both bibliometrics and scientometrics.
] since the 1950s. Two scientometric methods in particular should be mentioned:

/ Citation counting: In 1963, Price published _Little Science, Big Science_ @price63little. In this book, the first major work dealing with what would later become scientometrics, he proposed measuring the quality of scientific production through, among other things, a very simple technique, citation counting: one way to measure the quality of a publication is to count the number of times that publication is cited.

/ Markovian modeling: Markov chains, described in @pr-markov, not only allow one to play Monopoly (registered trademark), but also to model the evolution of a population distributed among several states, provided one can estimate the transition probabilities between states. For example, Goffman proposed in 1971 the study of the evolution of research in various subfields of logic using Markov chains @goffman71mathematical.

Let us now see how Brin _et al._ adapted these concepts to estimating the importance of Web pages.

=== An important page is pointed to by important pages

Transposed directly to Web graphs, the citation counting method amounts to saying that the importance of a page is proportional to its in-degree, that is, to the number of pages that cite it through a hyperlink:

$ I(v) = sum_(w -> v) 1 $

where $w -> v$ means _$w$ points to $v$_.

Although this measure can indeed be used to estimate the importance of pages @cho98efficient, it is partly undermined by the absence of quality control. Indeed, when a researcher wants to publish a paper in a specialized journal, he must go through review committees that evaluate the quality of his work according to precise criteria. Because of this, the mere fact of being published gives a minimum level of importance to the articles in question, and there is some guarantee that the citations a paper receives are not entirely spurious. In the case of the Web, this safeguard does not exist: because of the low intellectual and material cost of a web page, anyone can link to anything without it necessarily having any real meaning#footnote[After all, is it not said that _you can find anything on the Web_?]. For instance, why not create a multitude of meaningless pages that cite me through hyperlinks, in order to inflate my own importance at will?

Brin _et al._ propose to counter this problem with a recursive description of importance: What is an important page? It is a page pointed to by important pages. Concretely, if a page $v$ is pointed to by $k$ pages $v_1, ..., v_k$, the importance of $v$ should be defined by:

$ I(v) = f_v (I(v_1), ..., I(v_k)) $ <eq:importance>

It remains to define $f_v$ and solve @eq:importance.

=== The random surfer: chance does things well <subsec:random-surfer>

A romanticized view of the Web is the principle of hyperlink navigation: to find what he is looking for, the user navigates from page to page and click to click until reaching his destination. Of course, this is not what happens in practice, for both technical reasons (it is not always possible to reach a page $p$ from a page $q$) and social reasons (use of search engines, user fatigue...)#footnote[Cf @catledge95characterizing @tauscher97people @cockburn01empirical @wang04behaviour @milic04smartback.].

Brin _et al._ had the idea of modeling the behavior of the clicking user by a Markov chain. All that was needed was to find the transition probabilities from one page to another. One of the simplest ways of looking at things is to consider that once on a given page, the user will click uniformly at random on one of the links contained in that page:

$ p_(v,w) = cases(
  1/(d(v)) "if" v -> w,
  0 "otherwise"
) quad "where" d "is the out-degree" $

This is the basis of the random surfer model. For Brin _et al._, given that Web graphs reflect a deliberate and thoughtful architecture, interesting pages should be structurally easy to access, just as a city is all the more accessible by the road network the more important it is. Therefore, since the random surfer lets himself be guided by the hyperlink network, statistically, he should land on a page all the more frequently the more important it is. Hence the idea of defining the importance of a Web page by the asymptotic probability of being on that page in the random surfer model.

=== Consistency of the two interpretations

Now that we have defined two ways of considering the importance of a page, let us observe that they coincide and describe the same phenomenon: indeed, in the random surfer model, it is possible to estimate the asymptotic probability of being on a page $v$ as a function of those of the pages $w$ that point to $v$:

$ P(v) = sum_(w -> v) 1/(d(w)) P(w) $ <eq:naouaque>

One can see that we indeed have an importance transfer relation like the one defined by @eq:importance, and that @eq:naouaque additionally obeys a conservation principle: a given page transmits all of its importance, which is equally distributed among the different pages it points to. Probability, viewed as importance, is thus transmitted through hyperlinks in the manner of a flow.

== The classical models <sec:pr-modele>

Although PageRank is often referred to in the singular, there actually exists a multitude of PageRank(s). We shall see here how, starting from the theoretical random surfer model that we have just described, several variations have been introduced in order to adapt to the reality of Web graphs. This _survey_ work has already been carried out for all PageRank(s) arising from explicitly stochastic processes @bianchini02pagerank @bianchini03inside @langville04deeper, but we also wish to take into account sub-stochastic models here.

=== Ideal case <sec:pr-ideal>

In the case where the Web graph $G = (V, E)$ that we wish to study is aperiodic and strongly connected, the principles seen in @sec:pr-axiomes apply directly: indeed, the task is to find a probability distribution on $V$ satisfying:

$ forall v in V, P(v) = sum_(w -> v) (P(w))/(d(w)) $ <eq:prank>

This amounts to finding the asymptotic distribution of the homogeneous Markov chain whose transition matrix is:

$ A = (a_(i,j))_(i,j in V) quad "with" a_(i,j) = cases(
  1/(d(i)) "if" i -> j,
  0 "otherwise"
) $ <eq:def-a>

As seen in @sec:markov-evolution, the distribution sequence

$ P_(n+1) = A^t P_n $

initiated by an arbitrary probability distribution $P_0$#footnote[Very often, the initial probability vector is taken to be a _zap_ distribution $Z$ --- see @sec:pr-completion.], converges geometrically to the unique distribution $P$ satisfying

$ P = A^t P $

that is, satisfying relation @eq:prank.

This probability distribution $P$ is called the PageRank.

#remarque[
  As specified in our definition of a Web graph, links from a page to itself are not counted. According to @Page98, this allows the PageRank computation to be "smoothed out."
]

#remarque[
  If the graph is not strongly connected, by theorem @thm:reductible, convergence still occurs, but there is neither uniqueness (the dimension of the solution space equals the number of recurrent strongly connected components) nor a guarantee that the support of the solution equals $V$ (in particular if transient components exist). The existence of periodicity, on the other hand, may prevent convergence, but theorem @thm:periodique indicates how the problem can be circumvented.
]

=== Simple renormalization <sec:pr-renormalisation>

Most of the time, a Web graph is not strongly connected. In particular, there exists a non-negligible number of dangling pages, which are either pages that actually contain no links, or simply pages that are known but not indexed. The rows of $A$ corresponding to these dangling pages therefore contain only $0$s, and $A$ is thus strictly sub-stochastic. Consequently, the sequence of $P_n$ will converge#footnote[Subject to aperiodicity. See #fref(<markov:patho:aperiodique>) for possible periodicities.] to a vector that is zero outside any recurrent strongly connected components on which $A$ is stochastic#footnote[Given the way the graph is constructed, any recurrent strongly connected component not reduced to a single element induces a stochastic process.]. To avoid this problem, one could consider recursively removing all dangling pages until a stochastic matrix is obtained, with the drawback of considering a smaller graph than the original. Another approach, proposed by @Page98, consists in renormalizing $P_n$ at each iteration:

$ P_(n+1) = 1/(norm(A^t P_n)_1) A^t P_n $

This iterative procedure is a power method (@stewart94introduction), so it is known to converge to an eigenvector associated with the largest eigenvalue of $A$. Two cases must then be considered:

- If the matrix $A$ is sub-irreducible, then its maximum eigenvalue is strictly less than 1. By theorem @thm:sousfiltre#footnote[See #fref(<thm:sousfiltre>).], the associated eigenspace has dimension $d$, where $d$ is the number of pseudo-recurrent components, and its support is that generated by the union of the filters of the pseudo-recurrent components. In the particular case where $A$ is pseudo-irreducible, the eigenspace is a line, and there exists an associated strictly positive eigenvector: thanks to renormalization, everything proceeds as in the case of an irreducible stochastic matrix.

- If the matrix $A$ is not sub-irreducible, $G$ contains at least one recurrent strongly connected component on which $A$ is stochastic. The maximum eigenvalue of $A$ is therefore $1$, which means that renormalization will not change the initial result: the eigenvector will be a linear combination of the eigenvectors on the different strongly connected components on which $A$ is stochastic#footnote[In other words, the recurrent strongly connected components.].

==== Equivalent stochastic process

The use of sub-stochastic matrices means that we lose the natural interpretation of the random surfer. However, it is sometimes possible to complete the matrix into an equivalent stochastic matrix, that is, to find a stochastic matrix $B$ satisfying:
- $A <= B$
- if $A^t P = lambda P$, with $lambda$ maximal, then $P = B^t P$

If there exists a unique maximal probability vector $P$ for $A^t$, the simplest way to define such a matrix $B$ is to consider the stochastic defect of $A$: if $A$ is sub-stochastic, the stochastic defect of $A$ is defined as the vector $s = un_n^t - A dot un_n^t$. The matrix

$ B = A + s dot P^t $

is indeed a stochastic matrix#footnote[If $A$ is sub-stochastic and $D$ a probability distribution on $V$, by construction, $(A + s dot D^t)$ is always a stochastic matrix.] greater than $A$, and it is easy to see that $B^t P$ is a probability distribution homogeneous to $P$, hence equal to $P$.

The matrix $B$ has the advantage of giving a stochastic interpretation to the simple renormalization procedure: asymptotically, the random surfer follows at each step a link according to the probabilities given by $A$. When he does not know what to do, he _zaps_ to another page according to the probability distribution that is the maximal eigenvector of $A$.

On the other hand, as soon as the maximal eigenspace has dimension greater than $1$, the problem is delicate, even very delicate in the case of pseudo-recurrent components whose filters have a non-zero intersection. We will therefore limit our study of equivalent stochastic processes to cases where the maximal eigenvector is unique.

=== Stochastic completion <sec:pr-completion>

In order to replace $A$ with a stochastic matrix, and to avoid establishing an uncontrolled equivalent stochastic process through simple renormalization, a natural idea is to add transitions to dangling pages. One possible method consists in modeling the use of the _Back_ button, and will be the subject of @pr-back. Another method, proposed#footnote[Unknowingly? See remark @rem:bourde-bp.] initially by @Page98 (in the form of @alg:pr-completion) and studied among others by @langville04deeper, consists in defining a _default_ probability distribution $Z$ on $V$, and using it to model the behavior of the random surfer when he arrives on a dangling page. Concretely, each zero row in $A$ (which therefore corresponds to a dangling page) is replaced by the row $Z^t$.

#alg(caption: [PageRank: stochastic completion model (after @Page98)])[
Data
- a sub-stochastic matrix $A$ with no periodicity;
- a covering _zap_ distribution $Z$;
- a real number $epsilon$.
Result\
A (the #no-emph("if") $A$ is sub-irreducible) probability eigenvector $P$ of $overline(A)^t$ associated with eigenvalue $1$.\
begin\
$n<-0$, $P_n <- Z$, $delta <- 2 epsilon$\
while $delta > epsilon$ #i:\
$P_(n+1) <- A^t P_n$\
$mu <- norm(P_n)_1 - norm(P_(n+1))_1$\
$P_(n+1) <- P_(n+1) + mu Z$\
$delta <- norm(P_n - P_(n+1))_1$\
$n <- n+1$ #d\
return $P_n$
] <alg:pr-completion>

This procedure can be generalized to complete any sub-stochastic matrix: The completion of $A$ by $Z$ is then the stochastic matrix

$ overline(A) = A + s dot Z^t $

==== Choice of $Z$ and interpretation

$Z$ represents the behavior of the random surfer when $G$ does not specify where he should go, that is, all page changes that are not due to the use of hyperlinks (manually typed address, _Bookmarks_, search engine query...). Generally, the uniform distribution is chosen for $Z$:

$ forall v in V, Z(p) = 1/n $

which represents a _zap_ anywhere at random on the known Web.

It has also been proposed to "personalize" $Z$, notably by @Page98. For instance, it is possible to restrict to the home pages of sites. On the one hand, this avoids implicitly giving sites a partial importance measure proportional to the number of crawled pages (see #fref(<sec:alter>)). On the other hand, this obeys a certain natural intuition: when one breaks hyperlink navigation to _zap_ to something else, it is likely that one will start from a home page. This intuition is confirmed by numerous studies that demonstrate the existence of pages that play the role of "hubs" for actual users @catledge95characterizing @kleinberg98 @wang04behaviour @milic04smartback.

==== Irreducibility of $overline(A)$

A probability distribution $Z$ is said to be covering if its support $chi_Z$ satisfies $arrow.t.double chi_Z = V$. This is a natural condition to impose on any _zap_ distribution, since it guarantees that all known pages are potentially accessible after a _zap_. The uniform distribution is obviously covering. The same holds for the distribution on home pages if all known pages of a site are accessible from the home page. It is also the case for the importance distribution if, and only if, all pages in $V$ have a non-zero in-degree.

#Thm[
  Let $Z$ be a covering probability distribution, and $A$ a strictly sub-stochastic matrix. The completion of $A$ by $Z$ is irreducible if, and only if, $A$ is sub-irreducible.
] <thm:completion-irreductible>

#Preuve[
  If $A$ is sub-irreducible, then from any page $v$ of $V$, it is possible to access a page with a stochastic defect $w in chi_s$. Indeed, let $B$ be an irreducible stochastic matrix such that $A < B$, and consider a path connecting $v in V$ to $w in chi_s$ in the graph induced by $B$. Either this path exists in $G$, and we have what we need, or it does not exist, which implies that at least one of the pages $w'$ on the path has a stochastic defect, and therefore $w' in chi_s$.

  $overline(A)$ is therefore irreducible, since any pair of pages is connected in the induced graph by at least one path passing through $chi_s$.

  Conversely, if $A$ is not sub-irreducible, there exists at least one stochastic strongly connected component strictly smaller than $V$. This component remains unchanged in $overline(A)$, which proves that $overline(A)$ is not irreducible.

  Q.E.D.
]

=== Rank source: _zap_ factor <subsec:zap-ideal>

In order to resolve the irreducibility problem, Brin _et al._ @Page98 propose another incorporation of the _zap_ distribution $Z$. They replace $A$ by $(A + alpha dot (Z dot un)^t)$, and seek to solve:

$ P = c (A^t + alpha dot Z dot un) dot P $ <eq:pr-sourcederang>

If $chi_Z = V$, one then has the guarantee of operating on a positive, irreducible, and aperiodic matrix, since the underlying graph is a clique#footnote[If $Z$ is merely covering, irreducibility is still guaranteed, since one can go from any page to any other page _via_ a page of $chi_Z$. However, aperiodicity is no longer necessarily guaranteed (there exist simple counterexamples, for instance a branch-tree completed on its root), even if empirically, the problem does not arise for Web graphs.]. The Perron-Frobenius theorem therefore ensures convergence of the iterative process to the eigenvector associated with the maximal eigenvalue. However, unless $alpha dot Z dot un <= Z dot s^t$, the new matrix is neither stochastic nor even sub-stochastic, which makes the interpretation in terms of a random surfer problematic. In order to more easily give an interpretation to the iterative process, Brin and Page normalize the matrix by taking the weighted average by $d$ of A and $(Z dot un)^t$:

$ A -> hat(A) = d dot A + (1-d) dot (Z dot un)^t $

The resulting matrix $hat(A)$ preserves the (sub-)stochasticity of $A$, and it is irreducible and aperiodic. If $A$ is stochastic, $hat(A)$ corresponds to the ideal case of @sec:pr-ideal#footnote[The cases where $A$ is strictly sub-stochastic will be studied in detail in @sec:source-sous.]. The maximal eigenvector, which we shall call PageRank with _zap_ factor, is then obtained by @alg:pr-zap. This vector represents the last academic version of PageRank presented by Brin and Page before Google's ranking methods became an industrial secret. It is what is generally referred to when one speaks of PageRank.

#alg(caption: [PageRank: model with added _zap_ factor (after @brin98anatomy)])[
Data\
- a stochastic matrix $A$;
- a covering _zap_ distribution $Z$;
- a _zap_ coefficient $d in ]0, 1[$;
- a real number $epsilon$.
Result\
The probability eigenvector $P$ of $hat(A)^t$ associated with the maximal eigenvalue.\
begin\
$n<-0$, $P_n <- Z$, $delta <- 2 epsilon$\
while $delta > epsilon$ #i:\
$P_(n+1) <- d dot A^t P_n + (1-d) dot Z$\
$delta = norm(P_n - P_(n+1))_1$\
$n<- n+1$#d\
return $P_n$
] <alg:pr-zap>


#remarque[
  As an aside, let us note in the founding PageRank paper (@Page98) a slight confusion: @alg:pr-completion is proposed to solve @eq:pr-sourcederang. Although it is specified that the introduction of $mu$ may have a slight impact on the influence of $Z$#footnote["The use of [$mu$] may have a small impact on the influence of [$Z$].", _op. cit._], the qualifier "slight" may be an understatement: in @eq:pr-sourcederang, $Z$ ensures an aperiodic irreducible matrix. One therefore has the guarantee of a unique strictly positive eigenvector. In contrast, in @alg:pr-completion, one implicitly works on the completion of $A$ by $Z$, and we have just seen that the influence of $Z$ is negligible as soon as $A$ is not sub-irreducible#footnote[Recall that it suffices for this to have two pages that point only to each other.] (theorem @thm:completion-irreductible). Fortunately, the confusion was resolved in subsequent articles, notably with the normalization of the _zap_ factor @brin98anatomy.
] <rem:bourde-bp>

==== Interpretation

When $A$ is stochastic, the dual interpretation of $hat(A)$ is fairly straightforward:

/ Importance transfer: with the _zap_ factor, pages transmit only a fraction $d$ of their importance. In return, each page $p$ is assigned a Minimum Insertion PageRank (MIPR) equal to $(1-d) dot Z(p)$.

/ Random surfer: at each step of the stochastic process described by $hat(A)$, the random surfer will click at random on one of the outgoing links, with probability $d$, or _zap_ with probability $(1-d)$ somewhere on the graph according to the distribution $Z$.

=== Choice of $d$ <subsec:choix_d>

Before going further, it is appropriate to discuss the choice of the parameter $d$ and the reasons that led to this choice. To begin with, let us state a universal and unalterable empirical reality: $d$ equals $0,85$, give or take $0,05$. Since the beginnings of PageRank, $0,85$ has always been the reference value, and to my knowledge, practical PageRank computations following the rank source model seen in @subsec:zap-ideal always use a $d$ between $0,8$ and $0,9$.

==== Convergence/graph alteration tradeoff

By theorem @thm:vp-secondaires, if $A$ is stochastic, which can be assumed by performing a completion if necessary, the eigenvalues of $hat(A)$ other than $1$ are less than $d$ in absolute value#footnote[If $A$ has more than one recurrent strongly connected component, $d$ is an eigenvalue.]. This guarantees algorithms @alg:pr-zap and @alg:pr-hybride a geometric convergence with ratio at most $d$. One therefore has an interest in choosing $d$ as small as possible... except that the smaller $d$ is, the greater the influence of the _zap_, which is a component external to the intrinsic Web graph. A small $d$ alters, or even distorts, the underlying graph. Choosing the largest $d$ that guarantees reasonable convergence therefore seems like a good tradeoff. Now, technical limitations mean that the number of iterations achievable by a search engine like _Google_ is on the order of a hundred#footnote[Indeed, PageRank must be recomputed periodically, and with several billion pages to process, each iteration takes a non-negligible amount of time.]. $d = 0,85$ offers a precision of $10^(-8)$ after $114$ iterations, $10^(-11)$ after $156$ iterations, and therefore appears to be heuristically the desired tradeoff. Indeed, as we shall see in @sec:kemeny, $10^(-8)$ corresponds to the differentiation threshold for a Web graph of one million pages, while $10^(-11)$ is the differentiation threshold for one billion pages.

#Thm[
  Let $A$ be a stochastic matrix. If $x$ is an eigenvector of $hat(A)^t$ associated with $lambda != 1$, then $x$ is an eigenvector of $A^t$ and $hat(A)^t x = d A^t x$. In particular, $abs(lambda) <= d$.
] <thm:vp-secondaires>

#Preuve[
  Since $un$ is a left eigenvector of $hat(A)^t$ associated with $1$, we have

  $ un hat(A)^t x &= un dot x \
  &= lambda un dot x $

  Since $lambda != 1$, $un dot x = 0$, hence

  $ hat(A)^t x &= lambda x \
  &= (d dot A^t + (1-d) dot (Z dot un)) x \
  &= d A^t x $
]

#remarque[
  In @kamvar03extrapolation there is a proof of the fact that every eigenvalue other than $1$ (which is simple for $hat(A)$) is less than $d$. In @langville04deeper, it is additionally shown that the secondary eigenvalues of $hat(A)$ are equal to $d$ times those of $A$ (the multiplicities of $1$ being counted as secondary), and the authors claim that their proof is more compact than that of @kamvar03extrapolation. Theorem @thm:vp-secondaires additionally shows that the secondary eigenvectors of $hat(A)^t$ are those of $A^t$, and we claim that our proof is more compact than that of @langville04deeper. All that remains is to find a theorem more precise than theorem @thm:vp-secondaires, with an even more compact proof...
]

== Rank source and sub-stochastic matrices <sec:source-sous>

In the rank source model seen in @subsec:zap-ideal, we saw that while adding a _zap_ factor associated with a covering distribution $Z$ guarantees the irreducibility of $hat(A)$, the stochasticity of $hat(A)$ remains that of $A$. When $A$ is sub-stochastic, one must therefore adapt, and we shall see in this section the main possible solutions.

=== Hybrid model: _zap_ factor and renormalization

$hat(A)$ is pseudo-irreducible (since it is irreducible). A first possible method for obtaining a fixed point is therefore to apply the simple renormalization method (cf @sec:pr-renormalisation) to the matrix $hat(A)$.

The interpretation in terms of a random surfer is the same as in the case where $A$ is stochastic, except that the stochastic defect of $hat(A)$ must be completed by a zap according to the distribution defined by the maximal probability eigenvector associated with $hat(A)$.

=== Completion and rank source: $mu$-compensation

Since stochastic completion is a relatively simple way of assimilating any sub-stochastic matrix to a stochastic matrix, it is interesting to hybridize the stochastic completion method with a _zap_-type method or virtual page addition (see @sec:pr-pagevirtuelle). This avoids having to renormalize at each iteration, and provides greater consistency in terms of stochastic interpretation. Moreover, if one chooses a completion distribution equal to the _zap_ distribution $Z$, one obtains a very simple algorithm (@alg:pr-hybride): the $mu$-compensation algorithm. The interpretation is equally simple: at each step of the stochastic process described by $hat(overline(A))$, the random surfer will click at random on one of the outgoing links (if any exist), with probability $d$. In all other cases, he will zap according to $Z$.

#alg(caption: [PageRank: $mu$-compensation (after @kamvar-exploiting)])[
Data
- a (sub-)stochastic matrix $A$;
- a _zap_ and completion distribution $Z$ that is covering;
- a _zap_ coefficient $d in ]0, 1[$;
- a real number $epsilon$.
Result\
The probability eigenvector $P$ of $hat(overline(A))^t$ associated with the maximal eigenvalue.\
begin\
$n<-0$, $P_n <- Z$, $delta<- 2 epsilon$\
while $delta > epsilon$ #i:\
$P_(n+1) <- d dot A^t P_n$\
$mu <- norm(P_n)_1 - norm(P_(n+1))_1$\
$P_(n+1) <- P_(n+1) + mu Z$\
$delta <- norm(P_n - P_(n+1))_1$\
$n<- n+1$#d\
return $P_n$
] <alg:pr-hybride>

=== Non-compensated PageRank

The non-compensated PageRank algorithm consists in computing $P_(n+1) = d A^t P_n + (1-d) Z$, exactly as in @alg:pr-zap, without worrying about renormalization. This yields a strictly positive vector, which can be used to define a PageRank, as shown by @thm:non-compense and the interpretation that follows.

#Thm[
  Let $A$ be a sub-stochastic matrix, $d$ a _zap_ factor, $0 < d < 1$, and $Z$ a covering probability distribution for the graph induced by $A$.

  The sequence $P_(n+1) = d A^t P_n + (1-d) Z$ converges geometrically, with ratio less than or equal to $d$, to a unique fixed point $P$, regardless of the initial vector $P_0$. $P$ is a strictly positive vector, and for any completion $overline(A)$ of $A$, if $overline(P)$ is the probability distribution associated with $hat(overline(A))$, then $P <= overline(P)$, with a totally strict inequality unless $A$ is stochastic (i.e. $A = overline(A)$).
] <thm:non-compense>

#Preuve[
  Since $forall X in RR^n$, $norm(A^t X)_1 <= norm(X)_1$, the mapping $X -> d A^t X + (1-d) Z$ is $d$-Lipschitz. It therefore has a unique fixed point toward which any sequence $X_(n+1) = d A^t X_n + (1-d) Z$ converges geometrically, with ratio less than or equal to $d$#footnote[Note in passing that in the case where $A$ is stochastic, we have here a very simple proof of convergence with ratio $d$, but theorem @thm:vp-secondaires nonetheless provides more information...].

  This fixed point $P$ satisfies $P = d A^t P + (1-d) Z$, and is therefore equal to:

  $ P = (1-d) sum_(k=0)^infinity (d A^t)^k Z $ <eq:p-noncompense>

  In particular, it is strictly positive, since as $Z$ is covering, for every $w$ in $V$, there exists $v$ in $chi_Z$, $k$ in $NN$ such that $((d A)^k)_(v,w) > 0$, and therefore

  $ P(w) >= (1-d) ((d A)^k)_(v,w) Z(v) > 0 $
]

=== Comparison: $mu$-compensated or non-compensated algorithms?

There is a very strong link between the $mu$-compensated algorithm and the non-compensated algorithm: they yield the same result, as shown by @thm:nonc-mu.

#Thm[
  Let $A$ be a sub-stochastic matrix, $Z$ a covering distribution. If $overline(P)$ is the PageRank obtained by $mu$-compensation (cf algorithm @alg:pr-hybride), and $P$ the non-compensated PageRank, fixed point of the mapping $X -> d A^t X + (1-d) Z$, then $P$ is homogeneous to $overline(P)$.
] <thm:nonc-mu>

#Preuve[
  By passing to the limit, it is easy to see that $overline(P)$ satisfies

  $ overline(P) = d A^t overline(P) + mu Z quad "where" mu = 1 - norm(d A^t overline(P))_1 $

  We deduce

  $ overline(P) = mu sum_(k=0)^infinity (d A^t)^k Z $ <eq:p-compense>

  @eq:p-noncompense and @eq:p-compense give us $(1-d) overline(P) = mu P$.
]

==== Convergence

The tests we have been able to perform show that with the choice of $Z$ as the initial distribution, there is no significant difference between the convergence of the $mu$-compensation algorithm and the non-compensated one. In both cases, convergence is very fast during the first iterations, and then stabilizes toward a convergence with ratio $d$ (cf main loop of @fig:remplumage).

==== Iteration speed

The $mu$-compensation must compute the parameter $mu$ at each iteration, while the non-compensated version does not. Does this have a significant influence on performance?

- If the matrix $A$ does not fit in memory, the limiting factor in computing an iteration is the multiplication of $A^t$ by $P_n$. The time used for compensation is then negligible, and the iteration speed has no influence on the choice between the two algorithms.
- On the other hand, if $A$, or even simply the adjacency matrix, fits in memory, the computation and incorporation of $mu$ takes a duration comparable to that of computing $A^t P$. In fact, any norm computation adds a non-negligible overhead to the computation of an iteration, and even the computation of the convergence parameter $delta$ considerably reduces performance. This leads to the SpeedRank algorithm (algorithm @alg:speedrank), which computes the non-compensated PageRank by roughly estimating the number of iterations needed for good convergence. Our experiments revealed a speed gain of more than $300%$ on iterations between SpeedRank and algorithm @alg:pr-hybride, which more than compensates for the slight overestimation of the number of iterations needed to converge.

In terms of performance, the $mu$-compensated algorithm is therefore to be avoided when working on "small" graphs. One may be surprised in passing that Kamvar _et al._ use $mu$-compensation in their BlockRank algorithm @kamvar-exploiting, which is precisely based on the decomposition of PageRank on small graphs. For specialists in PageRank computation optimization (cf @kamvar03extrapolation), it is curious to overlook a speed gain of $300%$...

#alg(caption: [SpeedRank: fast PageRank computation when the adjacency matrix fits in main memory])[
Data
- The adjacency matrix $M$ of an arbitrary graph $G = ((R union S), E)$, $R$ being the set of vertices with non-zero out-degree;
- a covering probability distribution $Z$;
- a _zap_ coefficient $d in ]0, 1[$;
- a real number $epsilon$.
Result\
With a precision of at least $epsilon$, a vector $P$ homogeneous to the $mu$-compensated PageRank on $G$.\
begin\
$P <- Z$, $Y <- (1-d) Z$\
$C : v -> cases(d/(d(v)) #no-emph("if") v in R, 0 "otherwise")$\
for $i$ ranging from $1$ to $ln(epsilon)/ln(d)$ #i:\
$P <- M^t (C times.o P) + Y$ #comment[$times.o$: element-wise product]#d\
return $P$
] <alg:speedrank>

==== Leaf-stripping and re-pluming <subsubsec:effeuilage>

In practice, PageRank algorithms are rarely applied to the entire graph $G = (V, E)$. A technique known as "leaf-stripping and re-pluming" is very often used: the PageRank is first computed on the graph $(R, E_R)$, where $R$ is the set of vertices of $V$ having at least one outgoing link. $(R, E_R)$ is called the stripped graph, or rake. Once good convergence is achieved, "re-pluming" is performed: we return to the graph $G$ and carry out a few PageRank iterations with the PageRank on $R$ as the initial estimate.

The problem is that the PageRank on the stripped graph is not necessarily a good estimate of the PageRank on $G$, as shown in @fig:remplumage: because of re-pluming, the convergence factor $delta$ is virtually reset. If one wants to once again reach the convergence condition ($delta < epsilon$), almost as many iterations are needed as starting from the distribution $Z$.

#figure(
  image("../figures/remplumage.pdf", width: 80%),
  caption: [Convergence of $mu$-compensated and non-compensated PageRanks; the re-pluming problem],
) <fig:remplumage>

The leaf-stripping and re-pluming method is nonetheless useful if one limits the number of iterations in the re-pluming phase: since the main loop operates on the rake, the iterations are faster. As for the final vector, although it is not a stationary vector, it lies halfway between the PageRank on the rake and that on $G$, and the fact that this vector is used in practice seems to indicate that the ranking it produces is worthy of interest.

== Convergence in $1$-norm and convergence of the ranking <sec:kemeny>

In all the PageRank algorithms we have presented, as in all those we are about to present, we use as a convergence criterion the convergence in $1$-norm of a sequence $P_n$ of positive vectors. Thus, when a rank source associated with a _zap_ factor $d$ is used and the convergence criterion $epsilon$ is met, we know that the error with respect to the limit vector is at most $epsilon/(1-d)$. However, only the ranking induced by $P$ is of _a priori_ interest, since the main purpose of PageRank is to provide an importance ordering on the Web pages under consideration#footnote[In reality, things are slightly different. The ranking returned for a given query is presumably the result of combining several importance estimates, with relevance and PageRank being the main ones. Knowing the quantitative PageRank of pages can then be of interest.].

=== Normalized Kendall distance

A first solution is to compare at each iteration the induced rankings, and to stop when there is no more change. One can also define a distance on rankings and replace convergence in $1$-norm with convergence on rankings. A fairly classical distance on rankings is the symmetric difference distance, or Kendall distance#footnote[Thanks to François Durand and his master's thesis report @durand007experience for introducing me to the Kendall distance.]: if $sigma_1$ and $sigma_2$ are two rankings, presented as permutations, then the Kendall distance between these two permutations is the minimum number of inversions of two adjacent elements needed to go from one to the other. It can be shown that this distance is translation-invariant and that the distance from a permutation $sigma$ to the identity is:

$ "dist"(sigma, "id") = sum_(i < j) chi_(sigma(i) > sigma(j)) $

The distance between two permutations $sigma_1$ and $sigma_2$ is therefore $"dist"(sigma_1, sigma_2) = "dist"(sigma_1 compose sigma_2^(-1), I d)$.

Since the greatest possible distance $"dist"_"max"$ between two permutations of size $n$ is that between two reversed rankings, namely $(n(n-1))/2$, one may, if one wants a convergence criterion independent of the size of the ranking, consider the Kendall distance normalized by $"dist"_"max"$.

=== PageRank density

By a simple order-of-magnitude argument, it is possible to establish a link between $epsilon$ and the convergence of the ranking. The starting point is the study of the relationship between a page's rank and its PageRank. @fig:classvspage shows this relationship for two PageRank models that we shall study in more detail: the standard $mu$-compensated PageRank with uniform _zap_ over $V$, and the $mu$-compensated PageRank with leaf-stripping/re-pluming technique and uniform _zap_ over $R$. The _zap_ factor $d$ is of course $0,85$.

#figure(
  image("../figures/classementvspagerank.pdf", width: 80%),
  caption: [Relationship between a page's rank and its PageRank],
) <fig:classvspage>

The regularity of the curves#footnote[For each of the two PageRanks studied here, we have plotted only a single curve, but experimentally, the other samples studied generate extremely similar curves.] leads us to consider the mesoscopic density of pages at a given PageRank: we seek to know what is the number $d N$ of pages whose PageRank lies between $p$ and $p + d p$. We place ourselves at the mesoscopic scale, that is, we assume $d p << p$ and $d N >> 1$. Experimentally, we found that the mesoscopic hypothesis was entirely realistic on graphs with more than one million vertices. We also observed that there exists, for each PageRank model, a function $rho$, relatively independent of the Web graph under consideration#footnote[In the case of PageRank with leaf-stripping/re-pluming, this holds for a given proportion of dangling pages. Empirically, this constant is often a crawl invariant.], such that, if $n$ is the number of pages in the graph,

$ (d N)/(d p) approx n^2 rho(n p) $

$rho$ is the normalized mesoscopic density (independent of the graph size $n$) typical of the PageRank model under consideration. @fig:prdensity shows experimental measurements of $rho$ corresponding to the two models studied here.

#figure(
  image("../figures/pagerankdensity.pdf", width: 80%),
  caption: [Normalized mesoscopic page density as a function of PageRank],
) <fig:prdensity>

== Models with virtual page <sec:pr-pagevirtuelle>

Adding a _zap_ factor is sometimes called the maximal irreducibility method, in the sense that if $chi_Z = V$, then the underlying graph becomes a clique. This method is often criticized for being too intrusive and distorting the structure of the Web graph. The completion method, by adding $abs(chi_Z) dot abs(chi_s)$ fictitious links, can also be considered intrusive.

An alternative is to employ so-called minimal irreducibility methods#footnote[Cf @tomlin03paradigm.], that is, to add a virtual page that will play the role of a "hub." This type of method is used among others by @abiteboul03adaptative @tomlin03paradigm.

=== Virtual _zap_ page

The principle of the virtual _zap_ page is simple: add an $(n+1)$#super[th] page, pointed to by and pointing to all other pages, and controlled by $d$ and $Z$.

Formally, if $A$ is a stochastic matrix (possibly completed), one considers the matrix

$ tilde(A) = mat(d A, (1-d) un^t; Z^t, 0) $

The corresponding asymptotic probability vector is obtained by algorithm @alg:pr-virtuelle.

#alg(caption: [PageRank: model with virtual page])[
Data
- a stochastic matrix $A$;
- a covering _zap_ distribution $Z$;
- a _zap_ coefficient $d in ]0, 1[$;
- a real number $epsilon$.
Result\
The probability eigenvector $(P, v)$ of $tilde(A)^t$ associated with the maximal eigenvalue.\
begin\
Choose a positive vector $P_0$ and a positive real number $v_0$\
$n<- 0$, $delta <- 2 epsilon$\
while $delta > epsilon$ #i:\
$P_(n+1) = d dot A^t P_n + v_n dot Z$\
$v_(n+1) = (1-d) norm(P_n)_1$\
$delta = norm(P_n - P_(n+1))_1$\
$n<- n+1$ #d\
return $P_n$
] <alg:pr-virtuelle>

=== On the usefulness of the virtual page

@thm:vp-virtuelle shows that _a priori_, as soon as $d > 0,5$, the use of a virtual _zap_ page changes strictly nothing compared to adding a _zap_ factor, both in terms of the asymptotic vector#footnote[Indeed, up to a weight of $(1-d)$ on the virtual page, the maximal eigenvectors are identical.] and of convergence (the eigenvalues other than $1$ are less than $max(d, 1-d)$ in absolute value).

#Thm[
  Let $A$ be a stochastic matrix. Since $tilde(A)$ is stochastic, irreducible, and aperiodic, we know that $1$ is a singular and dominant eigenvalue. More precisely, if $(lambda, (P, v))$ satisfies $tilde(A)^t (P, v) = lambda (P, v)$, then one of the following 3 cases holds:
  - Either $lambda = 1$, and $(P, v)$ is then homogeneous to $(hat(P), (1-d))$, where $hat(P)$ is the probability distribution such that $hat(P) = hat(A)^t hat(P)$.
  - Or $lambda = d - 1$.
  - Or $lambda$ is neither $1$ nor $d - 1$. $P$ is then an eigenvector of $A^t$, $v$ is zero, and we have $tilde(A)^t (P, 0) = (d A^t P, 0)$. In particular, $abs(lambda) <= d$.
] <thm:vp-virtuelle>

== Managing physical resources <sec:pr-ressources>

Before closing this chapter, I would like to highlight some fundamental technical considerations. The reader may have noticed that none of the presented algorithms ever explicitly involves the matrices whose maximal eigenvector is being computed ($overline(A)$, $hat(A)$, $hat(overline(A))$, and $tilde(A)$). This is a general phenomenon: if one wants all the algorithm's constants to fit in main memory#footnote[It is possible, even necessary for very large graphs, to perform PageRank computations without loading all constants into main memory and with optimized disk accesses @abiteboul03adaptative, but seeking to minimize the size of constants remains very important when one wants to implement a PageRank algorithm.], a minimum of thought is required. Indeed, one must remember that $A$ is a sparse matrix containing $n dot overline(d)$ non-zero elements, where $overline(d)$ is the average degree. $overline(d)$ being relatively constant (between $7$ and $11$ depending on whether unvisited pages are taken into account and whether link filtering is applied), this amounts to approximately linear size in $n$, which is both a lot given the sizes of the graphs under consideration, and a minimum if one wants to use the structure of the Web. The implicit matrices generated by completion and use of the _zap_ factor are far from sparse, and their size can be $n^2$. We see here the value of using rewriting tricks in PageRank algorithms so as to never involve a matrix less sparse than $A$.

Personally, I perform my PageRank experiments with simply the adjacency matrix, stored as a logical sparse matrix (_logical sparse matrix_) and a few vectors of size $n$: $D : i -> d(i)$, $Z$, $s$, $T$... Algorithms @alg:speedrank and @alg:pr-effectif give examples of the effective treatment of the algorithms. It is thus possible to handle up to 8 million vertices on a home PC with 1 GB of main memory, while keeping all constants in memory and performing a minimum of operations#footnote[This may seem modest when one knows that one GB of main memory can store the PageRank of $125$ million pages in double-precision floating point. However, one should always remember the colossal gain obtained when the adjacency matrix is in main memory.]. To go further, one must use transparent graph compression techniques#footnote[See for instance the Webgraph project @Webgraph.].

#alg(caption: [Hybrid algorithm: virtual completion page and $mu$-compensation])[
Data
- an adjacency matrix $M$ of an arbitrary graph;
- a covering probability distribution $Z$;
- a _zap_ coefficient $d in ]0, 1[$;
- a real number $epsilon$.
Result\
The probability eigenvector $P$ of $hat(overline(underline(A)))^t$ associated with the maximal eigenvalue.\
begin\
$n<- 0$, $P_n <- Z$, $delta <- 2 epsilon$\
$T<- 1 / (M un_n^t + un_n^t)$ #comment[$1\/dot$: element-wise inverse]\
while $delta > epsilon$ #i:\
$P_(n+1) <- d dot M^t (T times.o P_n)$ #comment[$times.o$: element-wise product]\
$mu <- norm(P_n)_1 - norm(P_(n+1))_1$\
$P_(n+1) <- P_(n+1) + mu Z$\
$delta <- norm(P_n - P_(n+1))_1$\
$n<- n+1$#d\
return $P_n$
] <alg:pr-effectif>
