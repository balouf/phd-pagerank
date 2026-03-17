// =============================================================================
// Chapter 7: Fine Decomposition of PageRank
// =============================================================================

#import "../templates/prelude.typ": *

= Fine Decomposition of PageRank <pr-dpr>

#citation([Serge #smallcaps[Gainsbourg]])[I shall compose until decomposition]
#citation([_Mystery Men_])[It's a psychofrakulator. It creates a cloud of radically fluctuating free-deviant chaotrons which penetrate the synaptic relays. It's concatenated with a synchronous transport switch that creates a virtual tributary. It's focused onto a biobolic reflector. And what happens is that hallucinations become reality and the brain is literally fried from within.]

#v(1em)

#lettrine("The purpose")[ of this chapter, which is an extension of @mathieu03aspects and @mathieu04local, is to study how PageRank behaves with respect to the site structure presented in Part~I, @sec:structure-sites. We will show that there exists a natural decomposition of PageRank into two terms, internal PageRank and external PageRank. This decomposition provides a better understanding of the roles played by internal and external links. A first application is an algorithm for estimating the local PageRank within a website. We will also show some quantitative results on the possibilities available to a website for increasing its own PageRank.
]

More precisely, @sec:dpr-soa briefly presents the various existing contributions regarding the use of the Web's site structure to compute PageRank. @sec:dpr-cadre specifies the hypotheses and conventions that will be used. The notions of internal and external PageRank will be introduced in @sec:model, and applied to a theoretical decomposed PageRank algorithm in @sec:local. Finally, after taking advantage in @sec:alter of the study of local PageRank variations to introduce the _zap_ factor into our model, we will give in @sec:flowrank algorithms applicable to real-world graphs.

== Previous and contemporaneous work <sec:dpr-soa>

Among all published studies on PageRank, only a few attempt to take advantage of the site structure. @kamvar-exploiting gives a method for quickly computing a good approximation of PageRank using a partition into websites.

Bianchini _et al._ decompose PageRank into internal links, incoming links, outgoing links, and leaks @bianchini03inside @bianchini02pagerank. This decomposition allows, among other things, a certain understanding of how a website can change its own PageRank, while providing stability results for PageRank in the face of changes in the internal link structure of a website.

Finally, Arasu _et al._ showed that a PageRank computation on the quotient graph over servers converged faster than on pages, and even faster when taking into account link multiplicity (see @arasu01pagerank).

Compared to these works, our approach consists of using, as in @bianchini03inside @bianchini02pagerank, an exact flow decomposition of PageRank, with more flexible assumptions on the _zap_ distribution. From this decomposition, we derive an exact semi-distributed PageRank computation algorithm, which we hybridize with the algorithm proposed in @kamvar-exploiting in order to obtain a fast semi-distributed algorithm with few approximations.

== Hypotheses <sec:dpr-cadre>

We have seen that a structural definition of a website could be a set of pages tightly interconnected by hyperlinks. The block structure of the adjacency matrix (see #fref(<adja-fr>) and #fref(<adja>)) allows us to hope for many methods to decompose a Web graph into websites, and #fref(<sec:structure-sites>) gives us one. For the remainder of this chapter, we will therefore assume that our Web graph is equipped with a partition that allows it to be decomposed into websites, denoted $cal(S)=(S_1,...,S_k)$, with $k>1$.

As a first step, we will place ourselves in the ideal case where the Web graph $G=(V,E)$ under consideration is strongly connected and aperiodic. We will also assume the absence of self-loops.

As was seen in @sec:pr-ideal, if we consider the matrix $A$ defined by

$ A = (a_(v,w))_(v,w in V) "," quad "with" a_(v,w) = cases(
  frac(1, d(v)) & "if" v -> w,
  0 & "otherwise."
) $

we know that there exists a unique probability distribution, denoted $P$, satisfying

$ P = A^t P $ <eq:dpr-pr-ideal>

We will seek to highlight the connections between $P$ and $cal(S)$.

== Internal PageRank, external PageRank <sec:model>

=== Notation

For $v$ in $V$, we denote by $S(v)$ the element of $cal(S)$ such that $v in S(v)$. We also define $delta_(cal(S)) : V times V -> {0,1}$ as follows:

$ delta_(cal(S))(v,w) = cases(
  1 & "if" S(v) = S(w),
  0 & "otherwise."
) $

We will call $A_(cal(S))$ the restriction of $A$ to the elements internal to the components of $cal(S)$:

$ A_(cal(S)) = (a_(v,w) delta_(cal(S))(v,w))_(v,w in V) $

We also need to define the internal degree $d_i$ (resp. external degree $d_e$) of a vertex $v$ as its out-degree in the subgraph induced by $S(v)$ (resp. induced by ${v} union (V backslash S(v))$).

We are now in a position to define the notions of internal and external PageRank, and to relate them to the PageRank $P$ defined by @eq:dpr-pr-ideal.

- The *incoming internal PageRank* $P_(e i)$ (resp. *incoming external PageRank* $P_(e e)$) of a page $v$ in $V$ is the probability, when the random surfer is in steady state, of arriving at $v$ from a page in $S(v)$ (resp. from a page in $V backslash S(v)$). From this definition, @eq:pi and @eq:pe are derived:

  $ P_(e i) &= A_(cal(S))^t P $ <eq:pi>
  $ P_(e e) &= (A - A_(cal(S)))^t P = P - P_(e i) $ <eq:pe>

- The *outgoing internal PageRank* $P_(s i)$ (resp. *outgoing external PageRank* $P_(s e)$) of a page $v$ in $V$ is the probability, when the random surfer is in steady state, of going from $v$ to a page in $S(v)$ (resp. to a page in $V backslash S(v)$). @eq:poi and @eq:poe formalize this definition:

  $ P_(s i) &= (A_(cal(S)) dot un_n^t) times P $ <eq:poi>
  $ P_(s e) &= ((A - A_(cal(S))) dot un_n^t) times P = P - P_(s i) $ <eq:poe>

=== Conservation laws

One can define a PageRank (possibly internal, outgoing, ...) on a site $S$ as the sum of the PageRanks of its pages: $P(S) = sum_(v in S) P(v)$. With this convention, we can state the internal and external conservation laws of a site:

#theoreme[
  Let $S$ be a site. The incoming external and outgoing external PageRanks of $S$ are equal:

  $ P_(e e)(S) = P_(s e)(S) quad "(external conservation law)" $ <eq:cone>

  The same holds for the incoming internal and outgoing internal PageRanks:

  $ P_(e i)(S) = P_(s i)(S) quad "(internal conservation law)" $ <eq:coni>
] <thm:conservation>

#preuve[
  Let us begin by proving the internal conservation law (@eq:coni):

  $
  P_(e i)(S) &= sum_(v in S) P_(e i)(v) = sum_(v in S) sum_(w -> v, w in S) frac(P(w), d(w)) \
  &= sum_(w in S) sum_(v <- w, v in S) frac(P(w), d(w)) = sum_(w in S) P_(s i)(w) \
  &= P_(s i)(S)
  $

  Next, @eq:pe and @eq:poe allow us to write:

  $ P = P_(e e) + P_(e i) = P_(s e) + P_(s i) $ <eq:con1>

  @eq:con1 combined with the internal conservation law @eq:coni gives us the external conservation law:

  $ P_(s e)(S) = P_(e e)(S) + P_(e i)(S) - P_(s i)(S) = P_(e e)(S) $
]

#figure(
  image("../figures/dpr-conserv.pdf", width: 10cm),
  caption: [External PageRank conservation law: $P_(e e)(S) = P_(s e)(S)$],
) <conserv>

The external conservation law @eq:cone shows us that a site returns, through the outgoing external PageRank, exactly the PageRank it receives (the incoming external PageRank). As Lavoisier said, _nothing is lost, nothing is created, everything is transformed_. If we consider the PageRank flow on the quotient graph $G\/cal(S)$, there is therefore conservation of flow (see @conserv). This observation is the basis of the decomposed PageRank computation.

#remarque[
  Another way, perhaps simpler, of proving @thm:conservation would have been to consider PageRank directly as a stationary flow. It is then obvious that the flow on any subset $S$ of $V$ is also stationary. We preferred the matrix approach because it is the one we will continue to use hereafter, even though we will always try to interpret the results in terms of flow whenever possible.
]

== Decomposition of the PageRank computation <sec:local>

=== Relationship between external PageRank and PageRank

Starting from @eq:pi and @eq:pe, we can write that $A^t_(cal(S)) dot P = P - P_(e e)$, and therefore that $P_(e e) = ("Id" - A_(cal(S))^t) P$, where $"Id"$ is the identity matrix.

#lemme[
  The matrix $("Id" - A_(cal(S))^t)$ is invertible.
] <inversible>

#preuve[
  It suffices to show that $A_(cal(S))$ is sub-irreducible. This will prove that its spectral radius is strictly less than $1$ (theorem @thm:sousstoch, remark @rem:quasireduc), and therefore that $("Id" - A_(cal(S))^t)$ is invertible.

  We proceed by contradiction: if $A_(cal(S))$ is not sub-irreducible, there exists at least one stochastic strongly connected component in the transition graph associated with $A_(cal(S))$. This component is necessarily internal to a site since there are no external links. It therefore also exists in $A$, which can then only be irreducible if the component is all of $V$, which is impossible (we assumed that $A$ was irreducible and that $cal(S)$ contained at least two sites).
]

Lemma @inversible then allows us to express $P$ as a function of the incoming external PageRank $P_(e e)$:

$ P = ("Id" - A_(cal(S))^t)^(-1) P_(e e) $ <eq:relation>

To compute the PageRank of a site $S$, it therefore suffices to know its internal structure, through the matrix $A_S$, and the incoming external PageRank it receives from the others.

#remarque[
  The matrix $("Id" - A_(cal(S))^t)^(-1) = sum_(k=0)^(infinity) (A^t_(cal(S)))^k$, which like $A_(cal(S))$ is a block diagonal matrix, can be interpreted as the transition matrix of all possible internal paths. Indeed, for $v,w in V$, $(A_(cal(S)))^k_(v,w)$ represents the probability of going from $v$ to $w$ via a path of length $k$ that follows only internal links (in particular, $(A_(cal(S)))^k_(v,w) = 0$ if $S(v) != S(w)$.)
]

=== Transition matrix of external PageRank

We want to formalize the intuition of a site-to-site PageRank propagation given by the external PageRank conservation law (see @conserv), and find a description of the relationships between the different components of $P_(e e)$. By combining @eq:pe and @eq:relation, we obtain:

$ P_(e e) = (A - A_(cal(S)))^t P = (A - A_(cal(S)))^t ("Id" - A_(cal(S))^t)^(-1) P_(e e) $ <eq:prpe>

We can thus define the transition matrix of external PageRank:

$ A_e^t = (A - A_(cal(S)))^t ("Id" - A_(cal(S))^t)^(-1) $

This matrix possesses some very interesting properties:

#lemme[
  The matrix $A_e$ is stochastic.
] <lemme:aestochast>

#preuve[
  $A_e$ is obviously nonnegative, so it suffices to show that the sum of each column of $A_e^t$ equals $1$. To this end, we begin by rewriting $A_e^t$:

  $
  A_e^t &= sum_(k=0)^infinity (A^t (A^t_(cal(S)))^k - (A^t_(cal(S)))^(k+1)) \
  &= A^t + sum_(k=1)^infinity (A^t (A^t_(cal(S)))^k - (A^t_(cal(S)))^k) \
  &= A^t + A^t M - M, quad "with" M = sum_(k=1)^infinity (A^t_(cal(S)))^k
  $

  Consider the sum $s_w$ of the column of $A^t M$ associated with page $w$:

  $ s_w = sum_(u in V) sum_(v in V) A^t_(u,v) M_(v,w) = sum_(v in V) (sum_(u in V) A^t_(u,v)) M_(v,w) = sum_(v in V) M_(v,w) $

  Thus, the sum of each column of $A^t M - M$ is zero, which shows that $A_e$ is stochastic, since the sum of each column $w$ equals $sum_(v in V) A^t_(v,w) = 1$.
]

#lemme[
  Let $V_("int")$ be the set of pages with no incoming external link, and $V_("ext")$ the set of pages with at least one incoming external link. If we reorder the pages according to $(V_("int"), V_("ext"))$, then $A_e$ can be written as

  $ A_e = mat(0, T; 0, tilde(A)_e) $

  where $tilde(A)_e$ is an irreducible stochastic matrix.
]

#preuve[
  The columns of $(A - A_(cal(S)))$ corresponding to pages of $V_("int")$ are zero. The same is therefore true of those of $A_e$, which shows that $A_e$ can be written in the form

  $ A_e = mat(0, T; 0, tilde(A)_e) $

  $tilde(A)_e$ is stochastic, since $A_e$ is. It remains to show that it is irreducible. Consider two vertices $v$ and $w$ in $V_("ext")$, and a path $cal(C) = v,...,w$ leading from $v$ to $w$ in $G$. Let $i_0, i_1, ..., i_(k-1), i_k$ be the subsequence obtained by keeping in $cal(C)$ only the vertices of $V_("ext")$ ($i_0 = v$ and $i_k = w$). Then, $i_0, i_1, ..., i_(k-1), i_k$ is a path in the graph induced by $tilde(A)_e$. Indeed, between $i_(l-1)$ and $i_l$, there exists a subpath of $cal(C)$ consisting of an internal path within $S(i_(l-1))$, followed by an external jump leading to $i_l$. By the definition of $A_e$, we therefore have

  $ tilde(A)_e_((i_(l-1), i_l)) = A_e_((i_(l-1), i_l)) > 0 $

  $i_0, i_1, ..., i_(k-1), i_k$ is thus indeed a path in the graph induced by $tilde(A)_e$, which shows that $tilde(A)_e$ is irreducible.

  Q.E.D.
]

$A_e$ therefore has a unique PageRank, which is zero on $V_("int")$#footnote[This result is natural: a page with no incoming external link cannot receive incoming external PageRank.] and equals the PageRank of $tilde(A)_e$ on $V_("ext")$. Subject to aperiodicity, it can be computed iteratively. Only the coefficients of $tilde(A)_e$ are needed to compute this PageRank. Although we have not conducted extensive research to estimate the size of $V_("ext")$, the few analyses we have been able to perform, both on crawls and on server logs (in particular those of INRIA), seem to indicate that one can expect $|V_("ext")| <= 0.1 |V|$.

=== Theoretical decomposed PageRank computation <pdra>

From @eq:relation and @eq:prpe, we can establish a theoretical semi-distributed method for computing PageRank.

- Each site $S$ computes, from its block $A_S$ of the internal transition matrix $A_(cal(S))$, its block $("Id" - A_S^t)^(-1)$ of the matrix $("Id" - A_(cal(S))^t)^(-1)$.
- The different rows of $tilde(A)_e$ can then be reconstructed and centralized.
- The external PageRank $P'_e$ associated with $A_e$ is then computed (here an aperiodicity assumption on $tilde(A)_e$ is needed).
- Each site S obtains its own PageRank $P'(v)$, $v in S$, by applying $P'_e (v)$, $v in S$, to its matrix $("Id" - A_S^t)^(-1)$.

#lemme[
  The vector $P'$ thus obtained is homogeneous to the PageRank $P$ associated with $G$.
]

#preuve[
  Since $A$ is irreducible, it suffices to show that $A^t P'$ equals $P$:

  $
  A^t P' &= A^t ("Id" - A_(cal(S))^t)^(-1) P'_e \
  &= (A^t - A^t_(cal(S)))("Id" - A_(cal(S))^t)^(-1) P'_e + A_(cal(S))^t ("Id" - A_(cal(S))^t)^(-1) P'_e \
  &= A_e^t P'_e + (("Id" - A_(cal(S))^t)^(-1) - ("Id" - A_(cal(S))^t)("Id" - A_(cal(S))^t)^(-1)) P'_e \
  &= P'_e + (("Id" - A_(cal(S))^t)^(-1) - "Id") P'_e \
  &= P'_e + P' - P'_e = P'
  $

  Q.E.D.
]

== Intermezzo: modifying one's own PageRank <sec:alter>

Before tackling the central piece of this chapter, the FlowRank algorithm, we want to show that our decomposition of PageRank explains to what extent a website can modify its own PageRank, which will be an opportunity to gently introduce the _zap_ factor into our model.

The results we are about to present make sense if one accepts the idea that a website can only modify its external PageRank with great difficulty, whereas the situation is entirely different for internal PageRank. Indeed, PageRank exchanges between websites are closely monitored by Google, which does not hesitate to penalize websites that exchange links for the sole purpose of increasing their external PageRank. Such PageRank factories, called _link farms_ or _nurseries_, are generally assigned a PageRank of zero, and thus end up ranked behind all other pages#footnote[Note that this policy has been the subject of numerous lawsuits between Google and search engine optimization companies. Despite suspicions regarding Google's impartiality when it comes to defining a nursery, Google has never been found guilty: a search engine ranks its results as it sees fit.].

=== Amplification coefficient <subsec:amplifact>

Consider a site $S in cal(S)$, its PageRank $P(S)$ and its incoming external PageRank $P_(e e)(S)$. We define the amplification coefficient $alpha$ of $S$ as the ratio between PageRank and incoming external PageRank:

$ alpha(S) = frac(P(S), P_(e e)(S)) $

Since $P = ("Id" - A^t_(cal(S)))^(-1) P_(e e)$, $alpha(S)$ depends only on the internal structure of $S$ and on the distribution of external PageRank over $S$#footnote[Note that this distribution can to some extent be influenced by modifications to the structure of $S$. But as we have seen, overly large variations can be a sign of a link farm.].

Knowledge of $S$ alone gives us an estimate of $alpha(S)$:

#lemme[
  A bound on the amplification coefficient $alpha(S)$ is

  $ frac(1, 1-omega) <= alpha(S) <= frac(1, 1-Omega) $ <amp>

  with $omega = min_(v in S) frac(d_i (v), d(v))$ and $Omega = max_(v in S) frac(d_i (v), d(v))$.
] <lemme:ampli1>

#preuve[
  If we consider the vector space associated with $S$, for every elementary vector $e_v$, $v in S$, we have $||A_S (e_v)||_1 = frac(d_i (v), d(v))$, and therefore $omega ||X||_1 <= ||A_(cal(S)) X||_1 <= Omega ||X||_1$ for every vector $X > 0$ defined on $S$.

  We deduce the first inequality of @amp:

  $ P(S) = sum_(v in S) P(v) = ||sum_(k in NN) (A_S^t)^k (P_(e e))||_1 >= sum_(k=0)^infinity omega^k ||P_(e e)||_1 = frac(1, 1-omega) P_(e e)(S) $

  as well as the second:

  $ P(S) = sum_(v in S) P(v) = ||sum_(k in NN) (A_S^t)^k (P_(e e))||_1 <= sum_(k=0)^infinity Omega^k ||P_(e e)||_1 = frac(1, 1-Omega) P_(e e)(S) $
]

The consequence of @amp is that as soon as $Omega = 1$, nothing prevents a site from amplifying PageRank arbitrarily. In the limiting case where $omega = 1$ (a site with no outgoing external link, for example a commercial site that does not want the user to go elsewhere), there is infinite amplification and a short-circuit phenomenon. We recover the well-known rank sink phenomenon (see @Page98), seen this time from the perspective of amplification: a set of pages with no outgoing link will absorb and accumulate all the incoming external PageRank until the flow is exhausted.

Fortunately, over-amplification is controlled by the _zap_ factor.

=== Introduction of the _zap_ factor <amor-flot>

From now on, we will leave the ideal setting where $G$ is strongly connected and aperiodic to consider an arbitrary Web graph $G$. In particular, we must choose which PageRank model to adopt, and our choice naturally fell on the non-compensated PageRank with _zap_ factor. Thanks to theorem @thm:nonc-mu, we know that this is a model strictly equivalent to the $mu$-compensated PageRank generally used, with the difference that it allows working with a constant _zap_ flow.

$P$ is therefore now the unique vector satisfying $P = d A^t P + (1-d) Z$, where $Z$ is a covering distribution and $d$ is the _zap_ factor.

We also need to label the _zap_ flow. We could split it into external and internal flow, depending on whether the _zap_ takes us out of our current site or not, but we judged it more appropriate to consider the _zap_ flow as entirely external, and to separate the external flow into external click flow and external _zap_ flow. We will continue to reserve the terms incoming external PageRank and outgoing external PageRank for the external click flow, and by analogy with electricity we will define two new PageRank flows related to _zap_: the *induced PageRank*, denoted $P_("ind")$, which is the probability#footnote[Even though the non-compensated model means that we should no longer speak of probability, we will sporadically allow ourselves to continue using this term, even though it is more correct to speak of flow.] <ftn:proba-flot> of arriving at a page by _zap_, and the *dissipated PageRank*, denoted $P_("dis")$, which is the probability#footnote[See preceding footnote.] of leaving a page by _zap_.

We now have a bestiary of six PageRanks, or rather six flows, which are summarized in @tab:sixflow (recall: $s$ is the stochastic defect, defined by $s = un^t - A dot un^t$).

#figure(
  table(
    columns: 3,
    stroke: 0.5pt,
    inset: 0.5em,
    align: center,
    [*flow*], [*incoming*], [*outgoing*],
    [internal], [$P_(e i) = d A_(cal(S))^t P$], [$P_(s i) = d (A_(cal(S)) un^t) times P$],
    [external (click)], [$P_(e e) = d (A - A_(cal(S)))^t P$], [$P_(s e) = d ((A - A_(cal(S))) un^t) times P$],
    [external (_zap_)], [$P_("ind") = (1-d) Z$], [$P_("dis") = (1-d) P + d s times P$],
  ),
  caption: [The six PageRank flows in the non-compensated model],
) <tab:sixflow>

Note in passing that $P = P_(e i) + P_(e e) + P_("ind") = P_(s i) + P_(s e) + P_("dis")$.

The internal and external conservation laws still hold. This time we will not attempt to prove them by matrix calculation, and will content ourselves with justifying them by the fact that we are dealing with a stationary flow. In particular, the external conservation law on a site $S$ now reads:

$ P_(e e)(S) + P_("ind")(S) = P_(s e)(S) + P_("dis")(S) $ <eq:cone2>

This equation gives us an interesting result: if a site $S$ has a PageRank greater than $Z(S)$, its outgoing external PageRank is less than its incoming external PageRank, with equality if, and only if, $P(S) = Z(S)$ and $s(S) = 0$. This means that a site $S$ can only hope to have a PageRank greater than the default PageRank $Z(S)$ on condition that it gives less than what it receives.

=== _Zap_ and amplification coefficient <amor-ampli>

With the introduction of the _zap_ factor, @eq:relation now becomes

$ P = ("Id" - d A_(cal(S))^t)^(-1) (P_(e e) + P_("ind")) $

The bound seen in @subsec:amplifact still holds upon replacing $A$ by $d A$ and $P_(e e)$ by the total incoming external PageRank $P_(e e) + P_("ind")$, and setting by convention $frac(d_i (v), d(v)) = 0$ if $d(v) = 0$. We thus obtain @lemma:amp.

#lemme[
  The amplification factor $alpha'$ defined by $alpha'(S) = frac(P(S), P_(e e)(S) + P_("ind")(S))$ satisfies

  $ frac(1, 1 - d omega) <= alpha'(S) <= frac(1, 1 - d Omega) $ <amp2>
] <lemma:amp>

#preuve[
  We proceed exactly as in the proof of @lemme:ampli1. If we consider a fixed site $S$, and if we restrict $P_(e e)$ and $P_("dis")$ to their values on $S$, the first inequality is obtained by writing

  $
  P(S) &= sum_(v in S) P(v) = ||sum_(k in NN) (d A^t_S)^k (P_(e e) + P_("ind"))||_1 \
  &>= sum_(k=0)^infinity (d omega)^k (||P_(e e)||_1 + ||P_("ind")||_1) \
  &>= frac(1, 1 - d omega) (P_(e e)(S) + P_("ind")(S))
  $

  and the second similarly:

  $
  P(S) &= sum_(v in S) P(v) = ||sum_(k in NN) (d A^t_S)^k (P_(e e) + P_("ind"))||_1 \
  &<= sum_(k=0)^infinity (d Omega)^k (||P_(e e)||_1 + ||P_("ind")||_1) \
  &<= frac(1, 1 - d Omega) (P_(e e)(S) + P_("ind")(S))
  $
]

==== Numerical value

For a real website, it is entirely possible to have $omega = Omega = 0$ (a site with no internal link), or on the contrary $omega = Omega = 1$ (a site with no external link, and all of whose pages have at least one link). Thus, the amplification coefficient can vary between $1$ (the site derives no benefit from the PageRank it receives) and $frac(1, 1-d)$ (maximum utilization of received PageRank). Since $d$ is a universal constant equal to $0,85$, we conclude that for a fixed total incoming external PageRank, a site's PageRank can vary depending on its structure by a factor of $frac(20,3)$. For example, a very poorly structured site can, by restructuring itself, achieve a new PageRank equal to approximately $666%$#footnote[This lovely number is further proof of the necessity of having $0,85$ as the value of $d$.] of the former PageRank.

==== Robustness of PageRank

Bianchini _et al._ @bianchini02pagerank @bianchini03inside show that the effect a site can produce on the Web is controlled by the PageRank of that site. More precisely, if we consider a dynamic graph between two instants $t$ and $t+1$, they proved that:

$ sum_(v in V) |P_t (v) - P_(t+1)(v)| <= frac(2d, 1-d) sum_(s in S) P_t (s) $ <eq:bianchini-robust>

This result can also be deduced from lemma @lemma:amp: if a site $S$ changes between $t$ and $t+1$, the largest possible relative variation is the one where we go from $alpha'(S) = 1$ to $alpha'(S) = frac(1, 1-d)$. This modification of the site's structure, which corresponds to creating a rank sink, can only be done at the expense of external PageRank, and therefore of incoming external PageRank, so we necessarily have $P_(e e)_t >= P_(e e)_(t+1)$, giving a variation of at most $frac(d, 1-d) P(S)$. Since Bianchini _et al._ work here in a compensated model (the sum of PageRanks is constant), a variation of $frac(d, 1-d) P(S)$ in $S$ generates the same variation outside $S$, which gives us inequality @eq:bianchini-robust.

=== Amplification of a given page <ampli-page>

For a website, the interest of PageRank is above all to be visible to users. In particular, the administrator of a site will probably be less interested in a high PageRank across the entire site than in a very high PageRank on a few pages, or even on a single page. It is therefore better to concentrate one's PageRank on a general homepage rather than distribute it among several specialized pages. We will therefore consider the following problem: consider a site $S$ of $n+1$ pages fed by an incoming external PageRank $P_(e e)$. How can we maximize the PageRank of a given page $v_0 in S$?

The answer is not difficult once one notices that the optimal structure is the one where all pages of $S$ other than $v_0$ point to $v_0$ (and only $v_0$) and $v_0$ points to at least one other page of $S$. $v_0$ thus recovers, up to dissipation, all the PageRank of the other pages, and recovers its own PageRank up to a factor of $d^2$, which is the maximum possible in a graph where, let us recall, self-loops are not taken into account. We then have

$ P(v_0) = frac(P_(e e)(v_0), 1 - d^2) + frac(Z(v_0), 1 + d) + d sum_(v in S, v != v_0) (frac(P_(e e)(v), 1 - d^2) + frac(Z(v), 1 + d)) $

In the particular case where $Z$ is the uniform distribution, we thus obtain

$ P(v_0) <= frac(P_(e e)(S), 1 - d^2) + frac(1 + n d, (1 + d)|V|) $ <amp-page>

with equality if, and only if, all the incoming external PageRank is concentrated on $v_0$, that is, $P_(e e)(S) = P_(e e)(v_0)$.

From all this, we deduce some strategies for improving the PageRank of a page $v_0$, which corroborate the recommendations found on many websites devoted to PageRank improvement:
- Ask the administrators of other sites to always point, as far as possible, to the main page rather than to a specific page. Optionally, set up scripts that redirect to the homepage any access from a page external to the site#footnote[This recommendation should be taken with caution: the way Google handles redirections is not very clear. Moreover, this can make navigation less ergonomic for the user.].
- Always remember to include links back to the homepage, and limit the depth of the site (and thus the dissipation) as much as possible. In the particular case of frame-based sites, include `<noframe>` tags inside which the star structure is explicitly represented.

Let us conclude with a few remarks valid when $Z$ is the uniform distribution:

- With the optimal strategy, a site consisting simply of two pages pointing to each other has a PageRank that is at least equal to the average PageRank, even if the incoming external PageRank is zero: $P(v_0) >= frac(1, |V|)$.
- If $1 << n <= |V|$ (for example a site that dynamically generates pages pointing to $v_0$, such as a database query site with links other than forms), the ratio $frac(P(v_0), P_("moyen"))$ is approximately $frac(d, 1+d) n$. It is therefore possible to increase one's PageRank on $v_0$ linearly. In practice, this is valid provided that Google's robots take the trouble to explore all the pages#footnote[To my great regret, Google has not yet finished exploring the _page that points to all pages_ (see @lpqpvtlp page @lpqpvtlp), which explains why it does not yet have a maximal PageRank...], and that the sole purpose of all these pages is not to increase one's PageRank#footnote[Otherwise, beware the penalty.].

== Real-world case: FlowRank and BlowRank <sec:flowrank>

The objective of this section is to adapt the theoretical computation seen in @pdra to real-world situations.

=== Equilibrium relations with the _zap_ factor

Now that we have had time to become familiar with the induced and dissipated flows, we can rewrite the equations seen in the course of @sec:local.

With the introduction of the _zap_ factor, @eq:relation, which describes the link between incoming external PageRank and PageRank, becomes as we have seen

$ P = ("Id" - d A_(cal(S))^t)^(-1) (P_(e e) + (1-d) Z) $ <eq:relation-zap>

The equilibrium relation for external PageRank, the equivalent of @eq:prpe, is obtained by combining @eq:relation-zap with the definition of $P_(e e)$. We thus obtain:

$
P_(e e) &= d A^t_e P_(e e) + Z_e, quad "with" \
A^t_e &= (A - A_(cal(S)))^t ("Id" - d A^t_(cal(S)))^(-1) quad "and" \
Z_e &= d(1-d) A^t_e Z
$ <eq:nonc-externe>

#lemme[
  The spectral radius of $A_e$ is less than $1$.
] <lemme:conv-nonc-externe>

#preuve[
  The proof is similar to that of @lemme:aestochast: we show indeed that $A_e$ is substochastic (in the broad sense). We will show for this that the spectral radius of $d A_e$ is less than $d$. Since $A_e$ is nonnegative, it suffices, by the Perron-Frobenius theorem, to show that for every nonnegative vector $X$, $||d A^t_e X||_1 <= d ||X||_1$. To this end, we begin by rewriting $d A_e^t$:

  $
  d A_e^t &= sum_(k=0)^infinity (d A^t (d A^t_(cal(S)))^k - (d A^t_(cal(S)))^(k+1)) \
  &= d A^t + sum_(k=1)^infinity (d A^t (d A^t_(cal(S)))^k - (d A^t_(cal(S)))^k) \
  &= d A^t + d A^t M - M, quad "with" M = sum_(k=1)^infinity (d A^t_(cal(S)))^k
  $

  Now consider a nonnegative vector $X$. Since $d A_e^t X$, $d A^t X$, $d A^t M X$, and $M X$ are all nonnegative vectors, we have

  $ 0 <= ||d A_e^t X||_1 = ||d A^t X||_1 + ||d A^t M X||_1 - ||M X||_1 $

  Since the spectral radius of $A^t$ is less than $1$, we have $||d A^t M X||_1 <= ||M X||_1$, hence

  $ ||d A_e^t X||_1 <= ||d A^t X||_1 <= d ||X||_1 $

  Q.E.D.
]

#remarque[
  The inequality $||d A^t M X||_1 <= ||M X||_1$ used in the proof of lemma @lemme:conv-nonc-externe is very crude. In practice, one can therefore legitimately expect the spectral radius of $A_e$ to be smaller than $1$, and thus that @eq:nonc-externe allows finding $P_(e e)$ with a convergence rate smaller than $d$. The results presented by Arasu _et al._ (see @arasu01pagerank) support this and allow us to hope for very fast convergence in practice.
]

==== Application: estimating the PageRank of a website <estimation>

For the administrator of a website $S$, being able to estimate the importance of its pages without calling on external help or crawling the indexable Web can be of considerable interest. For example, this importance could be incorporated into an internal search engine. Now, according to @eq:relation-zap, it suffices for this to be able to estimate the incoming external PageRank on $S$.

Indeed, if we define the function $"SpeedRank"(M, X)$, inspired by algorithm @alg:speedrank, as a function that returns, for $M$ nonnegative with spectral radius strictly less than $frac(1,d)$ and $X$ nonnegative, the vector $P$ satisfying $P = d M^t P + X$, with precision $epsilon$, then

$ P_S = "SpeedRank"(A_S, ((P_(e e))_S + (1-d) Z_S)) $

To estimate this incoming external PageRank, two local approaches are possible:

- We have seen that PageRank is supposed to, to a certain extent, try to represent the behavior of real users (see @subsec:random-surfer). One can then take, as an estimate of the incoming external PageRank, the number of real clicks from outside the site to a page of the site, measured from the analysis of the Web server logs.
- Thanks to, or because of, the factor $d$, the ranking by in-degree is an approximation of the ranking by PageRank (see @subsec:choix_d). By counting the number of external references associated with each page, obtained again through an analysis of the Web server logs, one obtains another estimate of $P_(e e)$.

Once one has an estimate of $(P_(e e))_S$, it must be balanced against $Z_S$. One way, among many others, to achieve this balancing is to take a weighted average of the two vectors. For example, one could return as a normalized estimate of PageRank on $S$

$ P_S = "SpeedRank"(A_S, (d frac((P_(e e))_S, ||(P_(e e))_S||_1) + (1-d) frac(Z_S, ||Z_S||_1))) $

Note in passing that the rank source is then normalized to $1$ regardless of the size of the site $S$ under consideration. Since the goal is merely to estimate the relative importance of pages within $S$, this poses no problem.

=== A first approach: FlowRank

We now have all the data in hand to construct the FlowRank algorithm. Let us first observe that thanks to the _zap_ factor, $P_(e e)$ is completely defined by @eq:nonc-externe, whereas @eq:prpe only guaranteed obtaining a vector up to a scalar multiple. In order to avoid explicitly inverting the matrices $("Id" - d A_S)$, for $S in cal(S)$, we will resort to the function $"SpeedRank"$ defined previously. Thanks to this function, all the values we need to know can be computed:

- $(A - A_(cal(S)))^t "SpeedRank"(A_(cal(S)), e_v)$, where $e_v$ is the vector equal to $1$ on $v$, $0$ elsewhere, gives the column of $A^t_e$ associated with $v$. This computation can be limited, in both input and output, to the pages of $V_("ext")$. We thus obtain the $V_("ext") times V_("ext")$ matrix that we previously called $tilde(A)_e$, and which we will continue by abuse of notation to call $A_e$. Note also that this computation can be performed locally within each site $S(v) in cal(S)$.
- $Z_e$ equals $d(1-d)(A - A_(cal(S)))^t "SpeedRank"(A_(cal(S)), Z)$. This computation can also be distributed across all sites. Note that $Z_e$ is zero outside $V_("ext")$, so we can restrict ourselves to considering $tilde(Z)_e$, the restriction of $Z_e$ to $V_("ext")$.
- Once $tilde(A)_e$ and $tilde(Z)_e$ have been computed, it is possible to compute $tilde(P)_(e e)$, the restriction of $P_(e e)$ to $V_("ext")$: $tilde(P)_(e e) = "SpeedRank"(tilde(A)_e, tilde(Z)_e)$.
- The non-compensated PageRank is then given by $P = "SpeedRank"(A_(cal(S)), (P_(e e) + (1-d) Z))$. Once again, this step can be performed at the site level.

All these operations are summarized in algorithm @alg:flowrank.

#alg(
  caption: [FlowRank: decomposed computation of non-compensated PageRank],
)[
*Data*
- a Web graph $G=(V,E)$;
- a site partition of $G$, $cal(S) = (S_1, ..., S_k)$;
- a covering probability distribution $Z$;
- a _zap_ coefficient $d in ]0, 1[$;
- a real number $epsilon$;
- a function $"SpeedRank"$, inspired by @alg:speedrank, such that $P = "SpeedRank"(M, X)$ satisfies $P = d M^t P + X$, with precision $epsilon$.
Result\
The non-compensated PageRank vector associated with $(G, Z, d)$.\
begin\
$A_e <- 0_(|V_("ext")| times |V_("ext")|)$\
for each site $S$ in $cal(S)$:#i\
Compute $A_S$, the $|S| times |S|$ submatrix of $A_(cal(S))$\
    Compute $overline(A)_S$, the $|S| times |V_("ext")|$ submatrix of $(A - A_(cal(S)))$\
    $Z_(S_e) <- d(1-d) overline(A)_S^t "SpeedRank"(A_S, Z_S)$\
    for each page $v$ in $S inter V_("ext")$:#i\
    $(A_e^t)_(*, v) <- overline(A)_S^t "SpeedRank"(A_S, e_v)$#d\
  $Z_e <- sum_(S in cal(S)) Z_(S_e)$\
  $P_(e e) <- "SpeedRank"(A_e, Z_e)$\
for each site $S$ in $cal(S)$:#i\
$P_S <- "SpeedRank"(A_S, (P_(e e))_S + (1-d) Z_S)$#d#d\
return $(P_S)_(S in cal(S))$
] <alg:flowrank>

The FlowRank algorithm has numerous advantages:

- By breaking down the SpeedRank computations at the site level, it becomes possible to store the matrix in RAM, which allows extremely fast computation, all the faster since SpeedRank performs no norm computation.
- Apart from the computation of $P_(e e)$, which is global, all other computations can be performed in a decentralized manner at the site level. It is thus possible to parallelize a large portion of the computations.
- To take into account the update of a given site, it is not necessary to rerun the entire algorithm (unlike the case of a fully centralized algorithm). It suffices to rerun the SpeedRank computations at the level of the site in question, and to update $P_(e e)$. Using the previous values as initial values for SpeedRank can make the operation very fast.

But it also has drawbacks. Indeed, $2k + 1 + |V_("ext")|$ SpeedRank computations must be performed. Even though SpeedRank, as its name suggests, is very fast, this number remains high. Likewise, the computation of $P_(e e)$ is a SpeedRank on a $|V_("ext")| times |V_("ext")|$ matrix. If this matrix does not fit in RAM, much of the practical benefit of the decomposed computation is lost. To solve these problems, we will draw inspiration from a competing algorithm, the _BlockRank_ algorithm.

=== Distributed algorithm of Kamvar _et al._: BlockRank

In parallel with our work on the block structure of Web graphs @mathieu02structure @mathieu03local and the possible applications to PageRank @mathieu03aspects @mathieu04local, Kamvar _et al._ carried out very similar research. In @kamvar-exploiting, they use a site decomposition to propose a semi-distributed algorithm for computing an estimate of PageRank: BlockRank. This algorithm is based on the computation of a local PageRank, which in our notation is the PageRank on $A_(cal(S))$, and of a site PageRank, based on a substochastic BlockRank matrix, denoted $B$, defined on the quotient graph $G\/cal(S)$. The estimate of the PageRank of a page $v$ is then given by the product of the local PageRank of $v$ by the PageRank of $S(v)$, also called BlockRank#footnote[For full details, see @kamvar-exploiting.]. Although FlowRank and BlockRank resemble each other at first glance, there are important differences that we wish to highlight:

- Up to the errors introduced by $epsilon$, FlowRank gives the non-compensated PageRank#footnote[Let us recall once again that from a theoretical standpoint, there is strictly no difference between non-compensated PageRank and the $mu$-compensated PageRank traditionally used.], and not an approximation. Thus, the problem of underestimation of the PageRank of main pages encountered with the BlockRank algorithm @kamvar-exploiting does not arise. There is of course a price to pay in terms of algorithm complexity.
- The keystone of FlowRank is non-compensated PageRank, and the SpeedRank algorithm that follows from it, whereas BlockRank stays with the idea of $mu$-compensated PageRank, which is three times slower on "small" graphs.
- While the local PageRank within a site $S$ equals, up to normalization, $"SpeedRank"(A_S, Z_S)$, the global FlowRank matrix, $tilde(A)_e$, and the BlockRank one, $B$, have almost nothing in common. For example, $B$ has transitions from a site to itself. One will also note that whereas FlowRank uses an external _zap_ $Z_e$ adapted to $G$, the PageRank on $B$ uses a uniform _zap_.

=== Hybrid algorithm: BlowRank

The main advantage of BlockRank over FlowRank is the reduction from $|V_("ext")|$ to $k = |cal(S)|$ made possible by the approximations. This gain applies both to the number of local computations and to the size of the global matrix. We are therefore tempted to reduce $tilde(A)_e$ to a $k times k$ matrix. To do this, we must reduce the external flow information to a scalar per site $S$, for example by replacing $(P_(e e))_S$ with $P_(e e)(S)$. We must then define how the incoming external PageRank is injected inside each site. We will therefore assume that each site $S$ is equipped with a probability distribution that estimates the distribution of incoming external PageRank. This distribution, which we denote $D_S$, may be the uniform distribution on $S$, or more finely a distribution on the entry pages of the site, which are the most likely to be pointed to.

We can now consider the hybrid BlowRank algorithm (algorithm @alg:blowrank), which differs from FlowRank by an imposed reorganization of the external flow at the entrance of each site: everything happens as if at the entrance of each site, the incoming external PageRank (by click) were collected and redistributed according to $D_S$.

#alg(
  caption: [BlowRank: BlockRank-style approximation of the FlowRank algorithm],
)[
Data
- a Web graph $G=(V,E)$;
- a site partition of $G$, $cal(S) = (S_1, ..., S_k)$, each site $S$ being associated with a probability distribution $D_S$;
- a covering probability distribution $Z$;
- a _zap_ coefficient $d in ]0, 1[$;
- a real number $epsilon$;
- a function $"SpeedRank"$, inspired by @alg:speedrank, such that $P = "SpeedRank"(M, X)$ satisfies $P = d M^t P + X$, with precision $epsilon$.
Result\
An estimate of the non-compensated PageRank vector associated with $(G, Z, d)$.\
begin\
$B_e <- 0_(k times k)$\
for each site $S$ in $cal(S)$:#i\
  $A_S <- (A_(v,w))$, #no-emph[for] $v$ and $w$ in $S$\
  $(overline(A)_S)_(v,T) <- sum_(w <- v,\ w in T) A_(v,w)$, #no-emph[for] $v in S$ and $T != S$\
  $Z_(S_i) <- "SpeedRank"(A_S, (1-d) Z_S)$\
  $Z_(S_e) <- d overline(A)_S^t Z_(S_i)$\
  $B_S <- "SpeedRank"(A_S, D_S)$\
  $(B_e^t)_(*, S) <- overline(A)_S^t B_S$ #d\
  $Z_e <- sum_(S in cal(S)) Z_(S_e)$\
  $P_(e e) <- "SpeedRank"(B_e, Z_e)$\
  for each site $S$ in $cal(S)$:#i\
  $P_S <- P_(e e)(S) B_S + Z_(S_i)$#d\
  return $(P_S)_(S in cal(S))$
] <alg:blowrank>

We thus obtain an algorithm that requires only $2 dot k$ local calls to $"SpeedRank"$, plus one global call on a $k times k$ matrix, which places it in terms of performance at the same level as BlockRank, while the approximations made are smaller, yielding a PageRank less perturbed relative to the global model.
