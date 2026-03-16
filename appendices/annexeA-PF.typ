// Annexe A : Théorème de Perron-Frobenius

#import "../templates/environments.typ": *
#import "../templates/math-macros.typ": *

= Théorème de Perron-Frobenius <perron>

En 1907, Oskar Perron (1880-1975) a publié une théorie des matrices strictement positives, que Georg Ferdinand Frobenius (1849-1917) a étendu en 1908, 1909 et 1912 au cas des matrices positives au sens large#footnote[Helmut Wielandt -- 1910-2001 -- expose en 1950 une approche plus simple du problème, qui est celle utilisée de nos jours.]. Le théorème de Perron-Frobenius, qui résume cette théorie, est en quelque sorte la pièce centrale de la plupart des algorithmes de convergence des matrices stochastiques, et en particulier des algorithmes de PageRank. Nous avons donc cru intéressant de mettre une démonstration en appendice, car en plus de garantir la convergence des algorithmes, le concept de flot est inhérent à la preuve (lemme de propagation de la stricte inégalité).

#annexe_theoreme("Perron-Frobenius")[
Soit $A=(a_(i,j))_(1 <= i,j <= n)$ une matrice carrée positive de taille $n$, irréductible. Alors, il existe une valeur propre de $A$, notée $r$, strictement positive, qui a les propriétés suivantes :

#set enum(numbering: "(a)")
+ Il existe un vecteur propre gauche et un vecteur propre droit associés à $r$ strictement positifs.
+ Pour toute valeur propre $lambda$ de $A$, $abs(lambda) <= r$.
+ L'espace propre associé à $r$ est de dimension $1$.
+ Pour toute matrice $B$ positive inférieure à $A$, et pour toute valeur propre $beta$ de $B$, $abs(beta) <= r$, avec égalité seulement si $A=B$.
+ Si $1/r A$ a la cyclicité $d$, alors les valeurs de $A$ de module $r$ sont exactement les $r dot omega^j, j=1,...,d$, avec $omega=e^((2 pi i)/d)$, et les espaces propres associés sont de dimension $1$.
]

#preuve[
  Pour démontrer le théorème de Perron-Frobenius, nous aurons besoin du lemme suivant, que nous appellerons lemme de propagation de la stricte inégalité.

  #annexe_lemme[
    Si $A$ est une matrice positive irréductible de taille $n$, et si $x$ et $y$ sont deux vecteurs positifs tels que $x <= y$, avec au moins une composante pour laquelle il y a inégalité stricte, alors $sum_(k=0)^(n-1) A^k x < sum_(k=0)^(n-1) A^k y$.
  ] <lemme:propainegal>

  En effet, soit $i$ une composante pour laquelle il y a inégalité stricte. Comme la matrice $A$ est irréductible, pour chaque composante $j$, il existe $k in [0, n-1] inter NN$ tel que $(A^k)_(j,i) > 0$. On en déduit que $A^k x <= A^k y$, avec inégalité stricte en $j$. En utilisant l'opérateur $sum_(k=0)^(n-1) A^k$, on s'assure que chaque composante « bénificiera » par propagation de la stricte inégalité présente en $i$. En d'autres termes, $sum_(k=0)^(n-1) A^k x < sum_(k=0)^(n-1) A^k y$.

  Grâce à ce lemme, nous pouvons maintenant aborder la démonstration proprement dite.
  #set enum(numbering: "(a)")

  + Considérons l'ensemble $Gamma$ des vecteurs positifs de $RR^n$ de norme $1$ (on prendra la norme $1$ : si $x=(x_i)_(1 <= i <= n)$, $norm(x)_1 = sum_(i=1)^n abs(x_i)$).

    Pour chaque $gamma$ de $Gamma$, on pose
    $ mu_gamma = sup{x in RR : x gamma <= (A gamma)} $

    À l'évidence, $mu_gamma$ est un réel positif, puisque minoré par $0$ et majoré par $n norm(A gamma)_infinity$. Considérons maintenant $r = sup_(gamma in Gamma) mu_gamma$. $r$ est un réel (fini) strictement positif, car on a l'encadrement :

    $ 0 < (min_(1 <= i <= n) sum_(1 <= j <= n) a_(i,j)) / n <= r <= n norm(A)_infinity $

    Pour montrer que $r$ est une valeur propre, considérons une suite $(gamma_n)_(n in NN)$ d'éléments de $Gamma$ telle que $mu_(gamma_n)$ converge vers $r$. Comme $Gamma$ est compact, il est possible (théorème de Bolzano-Weierstrass) d'extraire une suite $(gamma_(phi(n)))_(n in NN)$ qui converge vers un vecteur $gamma_infinity in Gamma$.

    $gamma_infinity$ est un vecteur propre (à droite) de $A$, associé à la valeur $r$. En effet, nous avons $r gamma_infinity <= A gamma_infinity$. Si il n'y a pas égalité, alors d'après le @lemme:propainegal,
    $ r ((sum_(k=0)^(n-1) A^k) gamma_infinity) < A ((sum_(k=0)^(n-1) A^k) gamma_infinity) $
    ce qui contredit#footnote[Quitte à normaliser $(sum_(k=0)^(n-1) A^k) gamma_infinity$...] le caractère maximal de $r$.

    On a donc $r gamma_infinity = A gamma_infinity$, ce qui démontre que $gamma_infinity$ est un vecteur propre (droit) de $A$, associé à $r$. Le caractère strictement positif de $gamma_infinity$ est assuré par le lemme de propagation de la stricte inégalité.

    En raisonnant avec $A'$, on trouve une valeur propre $s$ associée à un vecteur propre gauche de $A$ strictement positif. Pour prouver (a), il nous suffit de montrer que $r=s$. Quitte à interchanger $A$ et $A'$, supposons $r <= s$. Il suffit alors de prendre $x != 0$ tel que $A x = s x$#footnote[$s$ est valeur propre de $A$, il existe donc un vecteur propre droit associé.] et de constater que $s abs(x) = abs(A x) <= A abs(x)$, ce qui impose $s <= r$, d'où l'égalité.

  + La preuve est la même que pour montrer que $r=s$. Si $lambda x = A x$, avec $x != 0$, alors $abs(lambda) abs(x) = abs(lambda x) = abs(A x) <= A abs(x)$, d'où $abs(lambda) <= r$.

  + Le fait que $r$ soit une valeur propre simple se démontre aussi grâce au lemme de propagation de la stricte inégalité. En effet, si l'espace propre est de dimension supérieure à 2, il existe un vecteur propre $gamma_diamond$ non homogène à $gamma_infinity$. Le vecteur $gamma_diamond + (max_(1 <= i <= n) (-gamma_(diamond i) / gamma_(infinity i))) gamma_infinity$ est également un vecteur propre associé à $r$. Par construction, il est non nul, positif, et une de ses composantes au moins est nulle. Par propagation de la stricte inégalité, $n-1$ itérations de $A$ vont rendre cette composante strictement positive, ce qui est contradictoire et démontre que $r$ est une racine simple.

  + Même preuve que (b) : si $beta x = B x$, avec $x != 0$, alors $abs(beta) abs(x) = abs(beta x) = abs(B x) <= B abs(x) <= A abs(x)$, d'où $abs(beta) <= r$.

    Cas d'égalité : $abs(beta) = r$ impose $abs(beta) abs(x) = r abs(x) = B abs(x) = A abs(x)$. $abs(x)$ est donc strictement positif, puisque homogène à $gamma_infinity$. $(A-B)$ est une matrice positive qui vérifie $(A-B) abs(x) = 0$, donc $(A-B) = 0$.

  + Quitte à considérer $1/r A$, on peut supposer que $r=1$. Considérons la relation d'équivalence sur les composantes suivante : deux composantes $i$ et $j$ sont équivalentes si il existe une composante $k$ telle que $a_(k,i)$ et $a_(k,j)$ soient strictement positifs, ou une composante $l$ telle que $a_(i,l)$ et $a_(j,l)$ soient strictement positifs. Alors, la cyclicité de $A$ est égale au nombre de classe d'équivalence dans les composantes. En effet, la cyclicité de $A$ correspond à la cyclicité sur le graphe sous-jacent (les sommets correspondant aux composantes et les arêtes aux coefficients $a_(i,j)$ non nuls). Comme le graphe est fortement connexe (puisque la matrice est irréductible), cette cyclicité se trouve en mettant dans la même classe d'équivalence les successeurs et les antécédents de chaque composantes.

    Soient $I_0$, ..., $I_(d-1)$ les classes d'équivalence pour la relation antécédent/successeur, rangées dans l'ordre de succession.

    - Si $lambda$ est une racine $d$-ième de l'unité, alors $lambda$ est valeur propre de $A$, et un vecteur propre associé est $x = (x_i)_(1 <= i <= n)$, avec

      $ x_i = lambda^(-k) gamma_(infinity i) #h(1em) "si" i in I_k $

      En effet, pour $i$ dans $I_k$, on a
      $
        (A x)_i &= sum_(j=1)^n a_(i,j) x_j = sum_(j=1)^n a_(i,j) lambda^(-k+1) gamma_(infinity j) \
        &= lambda^(-k+1) sum_(j=1)^n a_(i,j) gamma_(infinity j) = lambda lambda^(-k) gamma_(infinity i) = lambda x_i
      $

    - Soit $lambda$ une valeur propre de module $1$, et $x$ un vecteur propre associé. On écrit alors :

      $ abs(x) = abs(A x) <= A abs(x) $

      En fait, il y a forcément égalité, sinon par le lemme de propagation de la stricte inégalité, $1$ ne serait plus valeur propre maximale. Notons au passage que $abs(x)$ est homogène à $gamma_infinity$. Pour des nombres complexes, la valeur absolue d'une somme n'est égale à la somme des valeurs absolues que si tous les éléments (non nuls) ont même phase. Comme les coefficients de $A$ sont positifs, cela implique que tous les antécédents d'une composante donnée de $x_i$ par $A$ ont même phase. Or, par construction, les successeurs ont aussi même phase. On peut en déduire que toutes les composantes d'une même classe d'équivalence ont la même phase. De plus, si $phi(k)$ est la phase de la composante $I_k$, alors $phi(k-1)/phi(k) = lambda$. Par cyclicité, et en utilisant la convention d'écriture $I_d = I_0$, on a :

      $ 1 = I_0 / I_d = product_(k=1)^d (I_(k-1)) / I_k = product_(k=1)^d lambda = lambda^d $

      $lambda$ est donc une racine $d$-ième de l'unité.

      Remarquons enfin que compte tenu de tout ce qui a été dit, le vecteur $x$ est colinéaire au vecteur $y$ défini par

      $ y_i = lambda^(-k) gamma_(infinity i) #h(1em) "si" i in I_k $

      L'espace propre associé à $lambda$ est donc de dimension $1$.

      C.Q.F.D.
]
