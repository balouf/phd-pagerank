// Appendix A: Perron-Frobenius Theorem

#import "../templates/environments.typ": *
#import "../templates/math-macros.typ": *

= Théorème de Perron-Frobenius <perron>

In 1907, Oskar Perron (1880-1975) published a theory of strictly positive matrices, which Georg Ferdinand Frobenius (1849-1917) extended in 1908, 1909, and 1912 to the case of nonnegative matrices#footnote[Helmut Wielandt -- 1910-2001 -- presented a simpler approach to the problem in 1950, which is the one used nowadays.]. The Perron-Frobenius theorem, which summarizes this theory, is in a sense the cornerstone of most convergence algorithms for stochastic matrices, and in particular of PageRank algorithms. We therefore thought it worthwhile to include a proof in the appendix, since in addition to guaranteeing the convergence of the algorithms, the concept of flow is inherent to the proof (strict inequality propagation lemma).

#annexe_theoreme("Perron-Frobenius")[
Let $A=(a_(i,j))_(1 <= i,j <= n)$ be a nonnegative square matrix of size $n$, irreducible. Then, there exists an eigenvalue of $A$, denoted $r$, strictly positive, which has the following properties:

#set enum(numbering: "(a)")
+ There exist a left eigenvector and a right eigenvector associated with $r$ that are strictly positive.
+ For any eigenvalue $lambda$ of $A$, $abs(lambda) <= r$.
+ The eigenspace associated with $r$ has dimension $1$.
+ For any nonnegative matrix $B$ less than or equal to $A$, and for any eigenvalue $beta$ of $B$, $abs(beta) <= r$, with equality only if $A=B$.
+ If $1/r A$ has cyclicity $d$, then the eigenvalues of $A$ with modulus $r$ are exactly $r dot omega^j, j=1,...,d$, where $omega=e^((2 pi i)/d)$, and the associated eigenspaces have dimension $1$.
]

#preuve[
  To prove the Perron-Frobenius theorem, we will need the following lemma, which we shall call the strict inequality propagation lemma.

  #annexe_lemme[
    If $A$ is a nonnegative irreducible matrix of size $n$, and if $x$ and $y$ are two nonnegative vectors such that $x <= y$, with at least one component for which there is strict inequality, then $sum_(k=0)^(n-1) A^k x < sum_(k=0)^(n-1) A^k y$.
  ] <lemme:propainegal>

  Indeed, let $i$ be a component for which there is strict inequality. Since the matrix $A$ is irreducible, for each component $j$, there exists $k in [0, n-1] inter NN$ such that $(A^k)_(j,i) > 0$. We deduce that $A^k x <= A^k y$, with strict inequality at component $j$. By using the operator $sum_(k=0)^(n-1) A^k$, we ensure that each component will "benefit" by propagation from the strict inequality present at $i$. In other words, $sum_(k=0)^(n-1) A^k x < sum_(k=0)^(n-1) A^k y$.

  With this lemma in hand, we can now proceed to the proof itself.
  #set enum(numbering: "(a)")

  + Consider the set $Gamma$ of nonnegative vectors in $RR^n$ with norm $1$ (we use the $1$-norm: if $x=(x_i)_(1 <= i <= n)$, $norm(x)_1 = sum_(i=1)^n abs(x_i)$).

    For each $gamma$ in $Gamma$, we set
    $ mu_gamma = sup{x in RR : x gamma <= (A gamma)} $

    Clearly, $mu_gamma$ is a nonnegative real number, since it is bounded below by $0$ and above by $n norm(A gamma)_infinity$. Now consider $r = sup_(gamma in Gamma) mu_gamma$. $r$ is a (finite) strictly positive real number, since we have the bound:

    $ 0 < (min_(1 <= i <= n) sum_(1 <= j <= n) a_(i,j)) / n <= r <= n norm(A)_infinity $

    To show that $r$ is an eigenvalue, consider a sequence $(gamma_n)_(n in NN)$ of elements of $Gamma$ such that $mu_(gamma_n)$ converges to $r$. Since $Gamma$ is compact, it is possible (by the Bolzano-Weierstrass theorem) to extract a subsequence $(gamma_(phi(n)))_(n in NN)$ that converges to a vector $gamma_infinity in Gamma$.

    $gamma_infinity$ is a (right) eigenvector of $A$, associated with the eigenvalue $r$. Indeed, we have $r gamma_infinity <= A gamma_infinity$. If equality does not hold, then by @lemme:propainegal,
    $ r ((sum_(k=0)^(n-1) A^k) gamma_infinity) < A ((sum_(k=0)^(n-1) A^k) gamma_infinity) $
    which contradicts#footnote[Up to normalizing $(sum_(k=0)^(n-1) A^k) gamma_infinity$...] the maximality of $r$.

    We therefore have $r gamma_infinity = A gamma_infinity$, which proves that $gamma_infinity$ is a (right) eigenvector of $A$, associated with $r$. The strict positivity of $gamma_infinity$ is guaranteed by the strict inequality propagation lemma.

    By reasoning with $A'$, we find an eigenvalue $s$ associated with a strictly positive left eigenvector of $A$. To prove (a), it suffices to show that $r=s$. Without loss of generality, by possibly interchanging $A$ and $A'$, assume $r <= s$. It then suffices to take $x != 0$ such that $A x = s x$#footnote[$s$ is an eigenvalue of $A$, so there exists an associated right eigenvector.] and to observe that $s abs(x) = abs(A x) <= A abs(x)$, which forces $s <= r$, hence equality.

  + The proof is the same as for showing that $r=s$. If $lambda x = A x$, with $x != 0$, then $abs(lambda) abs(x) = abs(lambda x) = abs(A x) <= A abs(x)$, hence $abs(lambda) <= r$.

  + The fact that $r$ is a simple eigenvalue is also proved using the strict inequality propagation lemma. Indeed, if the eigenspace has dimension greater than or equal to 2, there exists an eigenvector $gamma_diamond$ not collinear with $gamma_infinity$. The vector $gamma_diamond + (max_(1 <= i <= n) (-gamma_(diamond i) / gamma_(infinity i))) gamma_infinity$ is also an eigenvector associated with $r$. By construction, it is nonzero, nonnegative, and at least one of its components is zero. By propagation of strict inequality, $n-1$ iterations of $A$ will make this component strictly positive, which is a contradiction and proves that $r$ is a simple root.

  + Same proof as (b): if $beta x = B x$, with $x != 0$, then $abs(beta) abs(x) = abs(beta x) = abs(B x) <= B abs(x) <= A abs(x)$, hence $abs(beta) <= r$.

    Equality case: $abs(beta) = r$ forces $abs(beta) abs(x) = r abs(x) = B abs(x) = A abs(x)$. $abs(x)$ is therefore strictly positive, since it is collinear with $gamma_infinity$. $(A-B)$ is a nonnegative matrix satisfying $(A-B) abs(x) = 0$, hence $(A-B) = 0$.

  + Without loss of generality, by considering $1/r A$, we may assume that $r=1$. Consider the following equivalence relation on the components: two components $i$ and $j$ are equivalent if there exists a component $k$ such that $a_(k,i)$ and $a_(k,j)$ are strictly positive, or a component $l$ such that $a_(i,l)$ and $a_(j,l)$ are strictly positive. Then, the cyclicity of $A$ equals the number of equivalence classes among the components. Indeed, the cyclicity of $A$ corresponds to the cyclicity on the underlying graph (the vertices corresponding to the components and the edges to the nonzero coefficients $a_(i,j)$). Since the graph is strongly connected (because the matrix is irreducible), this cyclicity is found by placing in the same equivalence class the successors and predecessors of each component.

    Let $I_0$, ..., $I_(d-1)$ be the equivalence classes for the predecessor/successor relation, arranged in order of succession.

    - If $lambda$ is a $d$-th root of unity, then $lambda$ is an eigenvalue of $A$, and an associated eigenvector is $x = (x_i)_(1 <= i <= n)$, with

      $ x_i = lambda^(-k) gamma_(infinity i) #h(1em) "si" i in I_k $

      Indeed, for $i$ in $I_k$, we have
      $
        (A x)_i &= sum_(j=1)^n a_(i,j) x_j = sum_(j=1)^n a_(i,j) lambda^(-k+1) gamma_(infinity j) \
        &= lambda^(-k+1) sum_(j=1)^n a_(i,j) gamma_(infinity j) = lambda lambda^(-k) gamma_(infinity i) = lambda x_i
      $

    - Let $lambda$ be an eigenvalue of modulus $1$, and $x$ an associated eigenvector. We then write:

      $ abs(x) = abs(A x) <= A abs(x) $

      In fact, equality must hold, otherwise by the strict inequality propagation lemma, $1$ would no longer be the maximal eigenvalue. Note in passing that $abs(x)$ is collinear with $gamma_infinity$. For complex numbers, the absolute value of a sum equals the sum of the absolute values only if all (nonzero) elements have the same phase. Since the coefficients of $A$ are nonnegative, this implies that all predecessors of a given component $x_i$ under $A$ have the same phase. Moreover, by construction, the successors also have the same phase. We can deduce that all components in the same equivalence class have the same phase. Furthermore, if $phi(k)$ is the phase of class $I_k$, then $phi(k-1)/phi(k) = lambda$. By cyclicity, and using the convention $I_d = I_0$, we have:

      $ 1 = I_0 / I_d = product_(k=1)^d (I_(k-1)) / I_k = product_(k=1)^d lambda = lambda^d $

      $lambda$ is therefore a $d$-th root of unity.

      Finally, note that given everything stated above, the vector $x$ is collinear with the vector $y$ defined by

      $ y_i = lambda^(-k) gamma_(infinity i) #h(1em) "si" i in I_k $

      The eigenspace associated with $lambda$ therefore has dimension $1$.

      Q.E.D.
]
