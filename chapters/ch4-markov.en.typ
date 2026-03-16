// =============================================================================
// Chapter 4: Markov Chains (English version)
// =============================================================================

#import "../templates/environments.typ": *
#import "../templates/math-macros.typ": *
#import "../templates/acronyms.typ": *

= Markov Chains <pr-markov>

#citation([#smallcaps[Mr. Monopoly] Strategy Wizard])[Always buy an unowned property if it is an orange property (always block this group if you can).]

#v(1cm)

#lettrine("Before")[ tackling the central topic of this part, namely PageRank(s), it seems necessary to provide a theoretical review of the techniques that we will use throughout the following pages.
]

Andrey Markov (1856--1922), a Russian mathematician, is known for having defined and studied memoryless discrete stochastic processes, also known as _Markov chains_. This tool from the beginning of the last century is fundamental for understanding the idea of PageRank, which is why we will briefly recall the essential results#footnote[For more comprehensive information on Markov's work, the reader may refer to @sheynin88markov @Saloff96.].

== Definitions

A _discrete random, or stochastic, process_ is a set of random variables $X_k$, with $k in NN$. $X_k$ can for instance represent the position on the game board of a Monopoly player at time $k$.

Discrete Markov chains are special cases of discrete stochastic processes with discrete values whose future depends only on the present (not on the past): the states preceding the present state play no role. If we call $V$ the set of values (or states) that the variables $X_k$ can take, the mathematical characterization of a Markov chain is the equality, for all $j in V$,

$ forall k in NN, P(X_k = j | X_l = i_l, l in [| 0, k-1 |]) = P(X_k = j | X_(k-1) = i_(k-1)) $

In other words, the probability of being in state $j$ at time $k$ depends only on the value taken at time $k-1$, and not on earlier values. _A priori_, this probability may not be the same depending on the time $k$ considered. The Markov chain can therefore be defined by the transition probabilities between two states at time $k$:

$ p^k_(i,j) = P(X_k = j | X_(k-1) = i) $

Throughout this thesis, we will restrict ourselves to the case where the transition probabilities do not depend on the time $k$ considered. _The corresponding Markov chain is then said to be homogeneous._

If $V$ is finite (we will then take $V = [| 1,n |]$), it is convenient to consider the transition matrix $A = (p_(i,j))_(1 <= i,j <= n)$. $A$ is a row-stochastic matrix, meaning that $forall i in V, sum_(j=1)^n A_(i,j) = 1$. This is due to the fact that the process is completely closed, and that if one is in state $i$ at time $k-1$, then one will be in $V$ at time $k$.

The transition matrix $A$ allows one to obtain the evolution of our process. Indeed, if we call $x^k$ the vector representing the state distribution at time $k$ ($x^k_j = P(X_k = j)$), then the following proposition gives $x^k$ as a function of $x^0$ and $A$.

#proposition[
  $x^k = (A^t)^k x^0$, where $""^t$ is the transpose operator.#footnote[Throughout this thesis, we will make extensive use of the transpose operator. Why not work directly with the matrix $P^t$ and thus avoid introducing $""^t$? First, because it is more comfortable to consider that a coefficient $a_(i,j)$ represents the action of $i$ on $j$ rather than that of $j$ on $i$. Second, because my background from preparatory classes makes me prefer working with column vectors rather than row vectors. Finally, because this is generally the standard notation in the existing literature.]
] <eq:markov1>

#Preuve[
  It suffices to show that, for any $k >= 1$, we have $x^k = A^t x^(k-1)$; @eq:markov1 is then merely the application of a straightforward induction. The desired result follows from the fact that:

  $ (A^t x^(k-1))_j &= sum_(i=1)^n p_(i,j) x^(k-1)_i = sum_(i=1)^n P(X^k = j | X^(k-1) = i) P(X^(k-1) = i) \
  &= sum_(i=1)^n P(X^k = j, X^(k-1) = i) = P(X^k = j) = x^k_j $
]

== Graph side, matrix side

We have just seen that stochastic matrices are both an elegant and compact means of describing the evolution of a Markov chain, but this is not the only one. The representation in terms of a weighted directed graph is also very useful, and it is convenient to be able to switch from one to the other as needed.

To any matrix $M = (m_(i,j))_(1 <= i,j <= n)$ of size $n$, it is possible to associate a weighted directed graph $G(M)$ with $n$ vertices, whose edges are the set of pairs $(i,j)$ such that $m_(i,j) != 0$, each weighted by its associated coefficient $m_(i,j)$.

Conversely, any weighted directed graph can correspond to the matrix $M$ defined by:

$ m_(i,j) = cases(
  "the weight of edge" (i,j) "if it exists",
  0 "otherwise"
) $

In the case of a graph whose edges are unweighted, by considering them as implicitly having weight $1$, one recovers the adjacency matrix.

Sometimes, the passage from the matrix viewpoint to the graph representation amounts to a simple rewriting: thus, if the characterization of a stochastic matrix#footnote[When not otherwise specified, by stochastic matrix we mean a row-stochastic matrix, that is, a nonnegative matrix such that the sum of each of its rows equals $1$.] $M = (m_(i,j))_(1 <= i,j <= n)$ is

$ forall i in [| 1,n |], sum_(j=1)^n m_(i,j) = 1 $

that of a graph $G = (V,E)$ representing a homogeneous Markov chain is

$ forall v in V, sum_(w <- v) e_(v,w) = 1 $

However, it sometimes happens that the two approaches correspond to genuinely two subtly different views of the same problem. Thus, saying that a nonnegative matrix $M$ is irreducible amounts to saying that

$ forall (i,j) in [| 1,n |]^2, exists k in NN, (M^k)_(i,j) > 0 $

At the graph level, for the corresponding graph $G$, this amounts to saying that for every pair of vertices $(i,j)$, there exists a path (of length $k$) connecting $i$ to $j$. In other words, the irreducibility of the matrix translates into the strong connectivity of the graph.

Finally, let us mention that a Markov chain is said to be _ergodic_ if the corresponding matrix is irreducible and aperiodic.

== Evolution of a homogeneous Markov chain <sec:markov-evolution>

In order to study the long-term evolution of a Markov chain, one may ask whether convergence properties can be obtained. This is indeed guaranteed by the following theorem.

#Thm[
  Let $A$ be a stochastic matrix.

  + The spectral radius of $A$ is $1$, and it is an eigenvalue.
  + If $A$ is irreducible, then there exists a unique probability vector $P$ that is a right eigenvector of $A^t$ for the eigenvalue $1$, and $P$ is strictly positive, meaning that all its components are strictly positive.
  + If $A$ is irreducible and aperiodic, then all eigenvalues other than $1$ have modulus strictly less than $1$.
] <thm:stoch>

#Preuve[
  + $1$ is an eigenvalue, associated with the eigenvector $vec(1, dots.v, 1)$.

    Moreover, if one considers an arbitrary vector $x = (x_i)_(1 <= i <= n)$, we always have

    $ norm(A x)_infinity <= norm(A abs(x))_infinity <= norm(x)_infinity $

    with the convention $abs(x) = (abs(x_i))_(1 <= i <= n)$.

    This implies that every eigenvalue of $A$ is at most $1$.

  + If $A$ is irreducible, then we are within the framework of the Perron-Frobenius theorem (see #fref(<perron>)), which ensures that there exists, up to scaling, a unique eigenvector#footnote[In fact, there are two eigenvectors, a right one and a left one, the left one of $A$ being the right one of $A^t$ and vice versa.] of $A^t$ for the eigenvalue $1$. Since this vector is strictly positive, after normalization it can be considered as a probability vector.

  + By the Perron-Frobenius theorem, if $lambda$ is an eigenvalue of $A$ satisfying $abs(lambda) = 1$, then $lambda$ is a $d$-th root of unity, where $d$ is the cyclicity of $A$. If $A$ is aperiodic, then necessarily $lambda = 1$. All eigenvalues of $A$ other than $1$ therefore have modulus strictly less than 1.
]

By @thm:stoch, it is now possible to determine the asymptotic behavior of a homogeneous Markov chain.

#Thm[
  Let $A$ be an irreducible aperiodic stochastic matrix of size $n$ representing a homogeneous Markov chain. If we call $P$ the right probability eigenvector of $A^t$ for the eigenvalue $1$ (whose existence and uniqueness are guaranteed by the Perron-Frobenius theorem), then

  $ (A^t)^k arrow.long_(k -> infinity) P dot un_n $

  where $un_n$ is the row vector of size $n$ consisting entirely of $1$s.
]

#Preuve[
  This is a simple application of the power method, or Jacobi method. Indeed, since $1$ is an eigenvalue of dimension $1$, one can decompose $A^t$ on the eigenspace spanned by $P$ on one hand and on the space associated with the other eigenvalues on the other hand (which is not necessarily an eigenspace). Thus, there exists an invertible change-of-basis matrix $T$ such that

  $ A^t = T dot mat(
    1, 0, dots, 0;
    0, "", "", "";
    dots.v, "", Q, "";
    0, "", "", ""
  ) T^(-1) $

  where $Q$ is a matrix with spectral radius strictly less than 1 (the eigenvalues of $Q$ are those of $A$ except $1$). The spectral radius of $Q$ implies that $Q^k$ converges geometrically to $0$. $(A^t)^k$ therefore converges geometrically to:

  $ lim_(k -> infinity) T dot mat(
    1, 0, dots, 0;
    0, "", "", "";
    dots.v, "", Q^k, "";
    0, "", "", ""
  ) T^(-1) = T dot mat(
    1, 0, dots, 0;
    0, "", "", "";
    dots.v, "", 0, "";
    0, "", "", ""
  ) T^(-1) $

  This matrix, which we will call $A^t_infinity$, is in fact a projection, since $(A^t_infinity)^2 = A^t_infinity$. The projection space is one-dimensional, as the matrix has rank $1$. Since by passing to the limit, we have $A^t_infinity P = P$, the projection line is the one spanned by $P$. $A^t_infinity$ is also a stochastic matrix (as a limit of stochastic matrices). In particular, if $e_i$ is the certain probability vector at $i$, defined by $(e_i)_k = delta^k_i$, then

  $ A^t_infinity e_i = vec((A^t_infinity)_(1,i), dots.v, (A^t_infinity)_(n,i)) = P $

  hence $A^t_infinity = P dot un$.
]

The asymptotic behavior of the associated homogeneous Markov chain is then given by @cor:markov-iter:

#corollaire[
  Let $P_0$ be an arbitrary initial probability distribution.
  The state distribution at time $k$, $P_k = (A^t)^k P_0$, converges, as $k$ tends to infinity, to $P$.
] <cor:markov-iter>

#Preuve[
  For any probability distribution $P_0$, we have $(A^t)^k P_0 arrow.long_(k -> infinity) (A^t_infinity) P_0 = P dot un dot P_0 = P$.
]

For the reader wishing to become familiar with the applications of the asymptotic study of Markov chains, the following section is devoted to a brief analysis of probabilities in the game of Monopoly (registered trademark).

== Intermezzo: Monopoly\u{2122} According to Markov <sec:monopoly>

Sources: @stewart96monopoly @monopoly @gaucher96monopoly

#figure(
  grid(
    columns: (6cm, 1fr),
    gutter: 1em,
    [#image("../figures/plateau.gif", width: 5cm)],
    align(left)[Nearly everyone knows the game of Monopoly (registered trademark), a board game in which the goal is to acquire properties, build monopolies called color groups (sets of properties of the same color), build houses, then hotels, and ultimately bankrupt all one's opponents.

    There is a certain strategy to Monopoly. As in real financial life, everything is a matter of negotiations, risk-taking, and return on investment. What is the role of Markov chains in Monopoly? One of the sources of income (and of ruin!), the main one in the late game, is the obligation at each turn to pay rent to the owner (if there is one) of the property where one's token lands.],
  ),
  caption: [Monopoly board (registered trademark)],
) <fig:monopoly-plateau>

#figure(
  table(
    columns: 6,
    stroke: 0.5pt,
    inset: 0.4em,
    align: (right, left, left, right, left, left),
    [*No.*], [*Name*], [*Group*], [*No.*], [*Name*], [*Group*],
    [0], [Go], [], [21], [Matignon], [red],
    [1], [Belleville], [brown], [22], [Chance Card], [],
    [2], [Community Chest], [], [23], [Malesherbes], [red],
    [3], [Lecourbe], [brown], [24], [Henri-Martin], [red],
    [4], [Income Tax], [], [25], [Gare du Nord], [],
    [5], [Gare Montparnasse], [], [26], [Saint-Honoré], [yellow],
    [6], [Vaugirard], [light blue], [27], [Bourse], [yellow],
    [7], [Chance Card], [], [28], [Water Works], [],
    [8], [Courcelles], [light blue], [29], [La Fayette], [yellow],
    [9], [République], [light blue], [30], [Go to Jail], [],
    [10], [Just Visiting], [], [31], [Breteuil], [green],
    [11], [La Villette], [purple], [32], [Foch], [green],
    [12], [Electric Company], [], [33], [Community Chest], [],
    [13], [Neuilly], [purple], [34], [Capucines], [green],
    [14], [Paradis], [purple], [35], [Gare Saint-Lazare], [],
    [15], [Gare de Lyon], [], [36], [Chance Card], [],
    [16], [Mozart], [orange], [37], [Champs-Élysées], [dark blue],
    [17], [Community Chest], [], [38], [Luxury Tax], [],
    [18], [Saint-Michel], [orange], [39], [Rue de la Paix], [dark blue],
    [19], [Pigalle], [orange], [40], [Jail], [],
    [20], [Free Parking], [], [], [], [],
  ),
  caption: [List of Monopoly squares (registered trademark)],
) <tab:ListesDesCasesDuMonopoly>

A question to ask is: what are the chances of landing on a given square? If certain squares are more likely than others, one can easily see that they will be of greater strategic interest. The evolution of a player's position over successive dice rolls can be viewed as a Markov chain. Ian Stewart @stewart96monopoly associates to each square-state 11 possible transitions corresponding to the possible outcomes of a dice roll, from 2 to 12. The probability of each transition is that of obtaining the result with two dice. Ian Stewart concludes that the stochastic matrix representing the Markov chain is circulant, and that the asymptotic probability distribution is the uniform distribution. In fact, if one looks more closely at the rules, one notices that not all states are equivalent, and that the limiting probability distribution is not necessarily uniform.

=== Brief Reminder of the Rules and Notation

By convention, we consider that there are 41 squares: from the _Go_ square (number 0) to the _Rue de la Paix_ square (number 39), with the _Jail_ square having number 40 and the _Just Visiting_ square having number 10. Table @tab:ListesDesCasesDuMonopoly summarizes the different squares, with the name and possible color group.

A game begins on the _Go_ square. At each turn, the player rolls two dice. After three consecutive doubles, the player goes to jail. If the player lands on a _Chance_ or _Community Chest_ square, they draw a card from the corresponding pile, and this draw is possibly followed by an immediate effect on their position. When in jail, one can get out for free by rolling doubles within the three turns following imprisonment; otherwise, one must pay to get out. One can also pay to get out before the end of the three turns.

Here is the detailed list of _Chance_ cards: 1 sends to jail, 1 sends to Avenue Henri-Martin, 1 sends to Boulevard de la Villette, 1 sends to Rue de la Paix, 1 sends to Gare de Lyon, 1 sends to the Go square, 1 _Go back three spaces_. There are 9 other _Chance_ cards that have no effect on position.

Here is the detailed list of _Community Chest_ cards: 1 _Return to Belleville_, 1 sends to jail, 1 sends to the Go square, 1 option to draw a _Chance_ card (alternative with a fine). There are 12 other _Community Chest_ cards that have no effect on position.

=== Transition Matrix

Because of the rules, not all states have the same transitions: thus, any transition to square 30 (_Go to Jail_) must in fact be replaced by a transition to square 40 (_Jail_). Similarly, for any transition to the _Chance_ or _Community Chest_ squares, the possible redirections must be considered. There is also the problem of doubles: the stochastic process uses memory (number of turns in jail or number of consecutive doubles already rolled) and is therefore not a true Markov process. But since the memory is finite (3 rolls), one can reduce it to a memoryless process by considering a space with 123 states#footnote[An alternative solution, proposed by @monopoly, consists of estimating for each square the probability of having arrived there by 2 consecutive doubles.]: 120 states of the form $(i,j)_(i in [0, 40], j in [0, 2])$ representing _being on square $i$ having already rolled $j$ consecutive doubles_, and 3 _jail_ states representing the three turns one can spend in jail. It should also be noted that if one pays, as one often has an interest in doing early in the game, one spends only one turn in jail, and the transitions are therefore modified. One must therefore consider the transitions for a _jail_ strategy and those for a _freedom_ strategy#footnote[Other factors can also alter the transition probabilities:
- The _Draw a Chance Card or Pay a Fine of..._ card, which offers two strategies.
- The _Get Out of Jail Free_ cards, which, if kept by the players, slightly increase the probabilities of drawing a displacement card.
The effect of these variations being relatively small, we allow ourselves not to take them into account here.].

#figure(
  image("../figures/monopoly-matrice.pdf", width: 100%),
  caption: [$123 times 123$ Monopoly transition matrix. Transition matrix (_jail_ strategy) in the _(square, number of doubles) + (jail, number of turns)_ space],
) <monopoly-matrice>

One thus arrives at writing, for each of the 2 strategies considered, a stochastic matrix describing the strategy in question. @monopoly-matrice thus graphically represents the matrix corresponding to the _jail_ strategy.

=== Asymptotic Probabilities and Conclusion

#figure(
  image("../figures/monopoly-prob.pdf", width: 100%),
  caption: [Asymptotic probabilities of the Monopoly game (registered trademark)],
) <fig:monopoly-prob>

Once the transition matrix $A$ is computed, thanks to @cor:markov-iter, we know that it suffices to iterate $P_n = A^t P_(n-1)$ ($P_0$ being for example the uniform distribution) to obtain convergence to the asymptotic distribution. One then only needs to return to the space of $40+1$ squares to have usable results, which are shown in @fig:monopoly-prob. To complete this study, one would now need to take into account the sale prices and rents to obtain a mean time to return on investment, without forgetting to consider purchasing power, but this is no longer within the scope of Markov matrices#footnote[For an idea of the results obtained, see @monopoly. Note that the results correspond to the international Monopoly game, which has different cards from the French version.]. Let us conclude with just these few remarks:

- The _Go to Jail_ square has zero probability, since one does not stay there.
- Similarly, the _Chance_ and _Community Chest_ squares have fairly low probability, because of the immediate displacement cards.
- The second and third quarters of the board generally have higher probabilities, because of the exit from jail. This confers a definite interest to the properties located there (the orange and red groups in particular).
- Paradoxically, one is more likely to land on the _Electric Company_ by choosing to stay in jail. Why this counterintuitive result? With the _freedom_ strategy, the probability of landing on it upon leaving jail is $1\/36$. With the _jail_ strategy, this probability becomes $1\/36 + 5/6 dot 1\/36 + 25/36 dot 1\/36$...

== (Sub-)Stochastic Matrices: General Case

In the following chapters, we will sometimes deal with matrices exhibiting periodicity, or that are non-irreducible, or even sub-stochastic#footnote[In this case, one can no longer _a priori_ speak of an associated Markov chain.], where the _or_ is not necessarily exclusive. We therefore propose to study the viability of @cor:markov-iter under these different hypotheses.

=== Non-Irreducible Matrices

Let us first consider the case where $A = (a_(i,j))_(1 <= i,j <= n)$ is stochastic but not irreducible. This means that the corresponding graph $G = (V,E)$ is not strongly connected. Let us then consider the decomposition into strongly connected components of $G$: $G = ((C_1, ..., C_k), E)$. Each component $C_c$ has exactly one of the two following properties:

#figure(
  image("../figures/markov-transit-cfc.pdf", width: 50%),
  caption: [Example of a non-strongly-connected graph],
) <fig:markov-transit-cfc>

- Either $exists i in C_c, j in.not C_c, a_(i,j) > 0$. The component and its states are then called transient.
- Or $forall i in C_c, j in.not C_c, a_(i,j) = 0$. The component and its states are then called recurrent.

If one quotients $G$ by its strongly connected components, the reduced graph gives a partial order on the components (since there are no circuits) whose recurrent components are the maxima.

For example, in the graph of @fig:markov-transit-cfc, there are four strongly connected components, $C_1$, $C_2$, $C_3$, and $C_4$. $C_1$ and $C_3$ are transient, while $C_2$ and $C_4$ are recurrent.

We will now reorder the states $V$ as follows: first the $k_t$ transient states (all components combined), then the $k_1$ states of a first recurrent strongly connected component, ..., up to the $k_d$ states of the last recurrent strongly connected component. In this rearrangement of states, the associated stochastic matrix (which we will continue to call $A$) can now be written:

$ A = mat(
  T, E;
  0, mat(R_1, 0, dots, 0; 0, dots.down, dots.down, dots.v; dots.v, dots.down, dots.down, 0; 0, dots, 0, R_d)
) $

where $T$ is a sub-stochastic, non-stochastic matrix of size $k_t$, $E$ is a nonnegative nonzero matrix of size $k_t times sum_(i=1)^d k_i$, and the $R_i$ are irreducible stochastic matrices of size $k_i$.

#Thm[
  Let $A$ be a stochastic matrix reduced according to its transient and recurrent strongly connected components. $A$ is of the form

  $ A = mat(T, E; 0, R) $

  where $T$ is a sub-stochastic, non-stochastic matrix of size $k_t$, $E$ is a nonnegative nonzero matrix of size $k_t times sum_(i=1)^d k_i$, and

  $ R = mat(R_1, 0, dots, 0; 0, dots.down, dots.down, dots.v; dots.v, dots.down, dots.down, 0; 0, dots, 0, R_d) $

  the $R_i$ being irreducible stochastic matrices of size $k_i$.

  If all the matrices $R_i$ are aperiodic, then the iterated powers of $A$ converge. More precisely, we have:

  $ A^k arrow.long_(k -> infinity) mat(0, F; 0, R_infinity) $

  with

  $ R_infinity = mat(R_(1 infinity), 0, dots, 0; 0, dots.down, dots.down, dots.v; dots.v, dots.down, dots.down, 0; 0, dots, 0, R_(d infinity)) $

  $ R_(i infinity) = lim_(k -> infinity) R_i^k = P_(i infinity) dot un_(k_i) $

  where $P_(i infinity)$ is the probability vector of size $k_i$ satisfying $R_i^t P_(i infinity) = P_(i infinity)$, and

  $ F = (I d_(k_t) - T)^(-1) E R_infinity $
] <thm:reductible>

#corollaire[
  For any probability distribution $P_0$ on $V$, $(A^t)^k P_0$ converges as $k$ tends to infinity, and the limit vector is a probability distribution belonging to the $d$-dimensional space spanned by the canonical embedding of the $P_(i infinity)$ into $V$.
]

#remarque[
  When not all the $R_i$ are aperiodic, there is _a priori_ no convergence. The technique that we will see in @markov:patho:aperiodique nevertheless allows one to ensure convergence at low cost.
] <rem:periodique>

#Preuve[
  We first observe that

  $ A^k = mat(T, E; 0, R)^k = mat(T^k, sum_(i=0)^k T^i E R^(k-i); 0, R^k) $

  #lemme[
    $ T^k arrow.long_(k -> infinity) 0 $ and the convergence is geometric.
    Moreover, $(I d_(k_t) - T)$ is invertible, and its inverse equals $sum_(k=1)^infinity T^k$.
  ]

  Indeed, let us examine the structure of $T$ more closely. We will reorder the states by strongly connected components, starting with those that, in the quotient graph $G\/C$, have no incoming edges (ultra-transient components), and sorting by distance from the ultra-transient components. The matrix $T$ is then of the form:

  $ T = mat(T_1, G_(1,2), dots, G_(1,l); 0, dots.down, G_(i,j), dots.v; dots.v, dots.down, dots.down, G_(l-1,l); 0, dots, 0, T_l) $

  where the $T_i$ are irreducible sub-stochastic, non-stochastic matrices (by convention, the one-dimensional matrix $0$ is considered irreducible). By @markov:patho:sous, each matrix $T_i$ on the main diagonal has a spectral radius $rho(T_i)$ strictly less than $1$. Since the structure of $T$ is block upper triangular, the spectral radius of $T$ is $rho(T) = max_(1 <= i <= l) rho(T_i) < 1$. This ensures that $T^k$ converges geometrically to $0$.

  Since $1$ is not an eigenvalue of $T$, $(I d_(k_t) - T)$ is invertible. Now, for all $k$, we have:

  $ (I d_(k_t) - T) sum_(j=0)^k T^j = I d_(k_t) - T^(k+1) $

  hence

  $ sum_(j=0)^k T^j = (I d_(k_t) - T)^(-1) (I d_(k_t) - T^(k+1)) $

  We deduce that

  $ lim_(k -> infinity) sum_(j=0)^k T^j = (I d_(k_t) - T)^(-1) $

  which completes the proof of the lemma.

  Let us return to our proof. It is now established that $T^k arrow.long_(k -> infinity) 0$. With the aperiodicity hypothesis on the $R_i$, we also have $R^k arrow.long_(k -> infinity) R_infinity$.

  It remains to prove that

  $ sum_(i=0)^k T^i E R^(k-i) arrow.long_(k -> infinity) (I d_(k_t) - T)^(-1) E R_infinity $

  Now, we have

  $ sum_(i=0)^k T^i E R^(k-i) = sum_(i=0)^k T^i E R_infinity + sum_(i=0)^k T^i E (R^(k-i) - R_infinity) $

  The first term converges to $(I d_(k_t) - T)^(-1) E R_infinity$. As for the second, we have:

  $ abs(sum_(i=0)^k T^i E (R^(k-i) - R_infinity)) <= abs(sum_(i=0)^(floor(k\/2)) T^i E (R^(k-i) - R_infinity)) + abs(sum_(i=floor(k\/2)+1)^k T^i E (R^(k-i) - R_infinity)) $

  The first of the two right-hand terms tends to $0$ because of the geometric convergence of $R^k$ to $R_infinity$, the second because of the (also geometric) convergence of $sum_(i=0)^k T^k$. This ensures the convergence to $0$ of the left-hand term. Q.E.D.
]

=== Periodic Matrices <markov:patho:aperiodique>

If a stochastic matrix $A$ is periodic, there is _a priori_ no convergence. One can for example think of the circulant matrix

$ C = (c_(i,j))_(1 <= i,j <= n) quad "with" c_(i,j) = cases(1 "if" j equiv (i+1) [n], 0 "otherwise") $

The successive iterates of $C$ describe an orbit of size $n$ corresponding to the $n$-th roots of unity, and in particular there is no convergence in the classical sense, although there exists convergence in the Cesaro sense ($1/k sum_(i=0)^k C^i$ converges).

Cesaro convergence could allow us to recover the eigenvector direction associated with the maximal positive eigenvalue, but this is not necessary: as shown by @thm:periodique, it is possible to reduce to "classical" convergence.

#Thm[
  Let $A$ be an irreducible stochastic matrix of size $n$, possibly periodic. Let $P$ be the unique probability vector such that $A^t P = P$. For all $alpha in ]0,1[$, we have

  $ (alpha A^t + (1-alpha) I d)^k arrow.long_(k -> infinity) P dot un_n $
] <thm:periodique>

#corollaire[
  Let $P_0$ be an arbitrary probability vector. If we set $B = (alpha A + (1-alpha) I d)$, then

  $ (B^t)^k P_0 arrow.long_(k -> infinity) P $
]

#Preuve[
  The matrix $B$ defined by $B = (alpha A + (1-alpha) I d)$ is stochastic, irreducible, and aperiodic, due to the presence of self-loops of length $1$. $(B^t)^k$ therefore converges to $Q dot un_n$, where $Q$ is the unique probability distribution satisfying $B^t Q = Q$. Since $B^t P = (alpha A^t + (1-alpha) I d) P = alpha P + (1-alpha) P = P$, we have $P = Q$.

  Q.E.D.
]

=== Sub-Stochastic Matrices <markov:patho:sous>

The case of strictly sub-stochastic matrices seems _a priori_ simple to resolve:

#Thm[
  Let $A$ be a sub-stochastic, non-stochastic, irreducible matrix of size $n$. Then the iterated powers of this matrix tend to $0$:

  $ A^k arrow.long_(k -> infinity) 0 $
] <thm:sousstoch>

#Preuve[
  $A$ is dominated by and not equal to an irreducible stochastic matrix. By part (d) of the Perron-Frobenius theorem (see #fref(<perron>)), its spectral radius is strictly less than $1$, which ensures the result, namely, if we call $rho$ the spectral radius, convergence dominated by a geometric sequence with ratio $rho$.
]

#remarque[
  A sub-stochastic but non-stochastic matrix corresponds to an ill-defined Markov chain, in the sense that not all possible transitions have been specified. By analogy with automata, we will speak of an incomplete Markov chain#footnote[Indeed, just as with automata, it is possible to complete our Markov chain by adding a _sink_ state receiving the _stochastic deficiency_ of the other states, and pointing surely to itself.]. In this case, for any probability distribution $P_0$, $(A^t)^k P_0 arrow.long_(k -> infinity) 0$, a result that is unsatisfactory in terms of useful information. This problem is crucial in the context of PageRank computations, and the solutions for "completing" a sub-stochastic matrix will be given in more detail in @pr-pagerank.
]

#remarque[
  Theorem @thm:sousstoch can in fact be applied to any sub-stochastic matrix $A$ that is dominated by and not equal to an irreducible stochastic matrix. We will call such matrices sub-irreducible matrices.
] <rem:quasireduc>

However, as we will see in @pr-pagerank, the study of the maximal eigenvalue of a sub-irreducible matrix and its associated eigenspace is important for the study of PageRank, which is why we will develop this a bit further.

==== Maximal Eigenvalue and Associated Eigenspace of a Nonnegative Matrix <foot:sousfiltre>

#Thm[
  Let $A$ be a nonnegative matrix#footnote[Although the study we are about to undertake is primarily of interest from the point of view of sub-irreducible matrices, it is in fact valid for any nonnegative matrix.].

  Let $(C_1, ..., C_k)$ be the decomposition into strongly connected components of the graph $G$ associated with $A$.

  We define the spectral radius $rho(C_i)$ of a component $C_i$ as the spectral radius of $A_(C_i)$. We will call a pseudo-recurrent component of $G$ any component $C_i$ satisfying:
  - $rho(C_i)$ is maximal: $forall 1 <= j <= k$, $rho(C_j) <= rho(C_i)$.
  - the components accessible from $C_i$ have a strictly smaller spectral radius: $forall C_j subset arrow.t.double C_i$#footnote[For $C subset V$, the filter of $C$, denoted $arrow.t.double C$, is the set of vertices of $V$ accessible from $C$.], $rho(C_j) = rho(C_i) => C_j = C_i$.

  Then:
  + The spectral radius of $A$ is equal to the maximum spectral radius of the strongly connected components of $G$.
  + There exists a maximal eigenvalue that is positive (it is the only one if the pseudo-recurrent components are aperiodic). The dimension of the associated eigenspace is then equal to the number $d$ of pseudo-recurrent components.
  + If $C_i$ is a pseudo-recurrent component of $G$, there exists a nonnegative eigenvector with support $arrow.t.double C_i$ associated with the maximal eigenvalue.
] <thm:sousfiltre>

#corollaire[
  If there exists a single pseudo-recurrent component $C_p$, and if all vertices are accessible from this component ($arrow.t.double C_p = V$), then the eigenspaces associated with the maximal eigenvalues#footnote[The plural is used here for possible periodicities. In the aperiodic case, there is of course only one maximal eigenvalue.] are one-dimensional, and there exists a nonnegative eigenvector with support $V$ associated with the maximal positive eigenvalue. We then say that $A$ is pseudo-irreducible.
]

#Preuve[
  The proof is in fact very similar to that of @thm:reductible for non-irreducible stochastic matrices, even though it is no longer possible to have a convergence result for the powers of $A$. Thanks to the partial order induced by the quotient graph of the strongly connected components, it is possible to make $A$ block upper triangular according to the strongly connected components: up to choosing the right permutation, one can write

  $ A = mat(A_(C_1), T_(1 2), dots, T_(1 k); 0, dots.down, dots.down, dots.v; dots.v, dots.down, dots.down, T_((k-1) k); 0, dots, 0, A_(C_k)) $

  where the $T_(i j)$ are the transition matrices between components $i$ and $j$.

  This triangular decomposition ensures that the spectral radius of $A$ is equal to the maximum spectral radius of the different components $C_i$. In fact, by applying the Perron-Frobenius theorem to each of the strongly connected components, it turns out that there exists an eigenvalue $lambda > 0$ equal to the spectral radius, and that its multiplicity equals the number of components with maximal radius.

  If $C_i$ is pseudo-recurrent, then the multiplicity of $lambda$ in $A^t_(arrow.t C_i)$ is $1$. There therefore exists, up to scaling, a unique eigenvector $x$ associated with $lambda$ in $A^t_(arrow.t C_i)$. Since $arrow.t.double C_i$ is stable under $A^t$, the embedding of $x$ into $V$ is an eigenvector of $A^t$. By construction, we also have $A^t_(C_i) x_(C_i) = lambda x_(C_i)$. By the Perron-Frobenius theorem applied to $A_(C_i)$, the components of $x_(C_i)$ are strictly positive up to scaling. Step by step, the equality $A^t_(arrow.t C_i) x = lambda x$ shows that $x$ is strictly positive.

  For each pseudo-recurrent component of $G$, there therefore exists a nonnegative eigenvector with support $arrow.t.double C_i$ associated with $lambda$.

  It remains to show that there is no eigenvector associated with $lambda$ outside of the space spanned by the $d$ eigenvectors associated with the pseudo-recurrent components. For this, it suffices to observe that any non-pseudo-recurrent component $C_i$ with maximal radius generates a triangular structure in the space associated with $lambda$: if there exists a pseudo-recurrent component $C_j$ with $C_j subset arrow.t.double C_i$, then $A_(arrow.t C_i)$ contains (in a suitable basis) a block of the form $mat(lambda, mu; 0, lambda)$, with $mu != 0$, which shows that it is not possible to associate an eigenvector of $lambda$ to $C_i$.

  Q.E.D.
]

=== General Case: Conclusion

We have just seen that one can arrange to find a convergence algorithm even if the matrix is neither aperiodic nor irreducible. Let us simply note that in the latter case, there is no uniqueness. On the other hand, if the matrix is sub-stochastic but not stochastic, the asymptotic vector will be zero everywhere except on possible recurrent strongly connected components within which the matrix is stochastic. The canonical completion, which consists of adding a "sink" state, is not satisfactory because it does not fundamentally change the result: the "sink" state absorbs the probabilities lost at the sub-stochastic components, but the values on the states other than the _sink_ state are not modified. Fortunately, the various PageRank computation algorithms that we will now study will provide us with other completion methods to reliably find a vector having all the desired properties, which will be called the PageRank vector.
