// =============================================================================
// Chapitre 7 : Décomposition fine du PageRank
// =============================================================================

#import "../templates/prelude.typ": *

= Décomposition fine du PageRank <pr-dpr>

#citation([Serge #smallcaps[Gainsbourg]])[Je composerai jusqu'à la décomposition]
#citation([_Mystery Men_])[It's a psychofrakulator. It creates a cloud of radically fluctuating free-deviant chaotrons which penetrate the synaptic relays. It's concatenated with a synchronous transport switch that creates a virtual tributary. It's focused onto a biobolic reflector. And what happens is that hallucinations become reality and the brain is literally fried from within.]

#v(1em)

#lettrine("L'objet")[ de ce chapitre, qui est une extension de @mathieu03aspects et de @mathieu04local, est d'étudier comment le PageRank se comporte en regard de la structure de site présentée lors de la Partie~I, @sec:structure-sites. Nous allons montrer qu'il existe une décomposition naturelle du PageRank en deux termes, le PageRank interne et le PageRank externe. Cette décomposition permet de mieux comprendre les rôles joués par les liens internes et externes. Une première application est un algorithme d'estimation du PageRank local à l'intérieur d'un site. Nous allons également montrer quelques résultats quantitatifs sur les possibilités offertes à un site d'augmenter son propre PageRank.
]

Plus précisément, la @sec:dpr-soa présente sommairement les différentes contributions existantes quant à l'utilisation de la structure en sites du Web pour calculer un PageRank. La @sec:dpr-cadre précise quelles seront les hypothèses et conventions utilisées. Les notions de PageRank interne et externe seront introduites lors de la @sec:model, et appliquées à un algorithme théorique décomposé de PageRank dans la @sec:local. Enfin, après avoir profité dans la @sec:alter de l'étude des variations locales du PageRank pour introduire le facteur _zap_ dans notre modélisation, nous donnerons dans la @sec:flowrank des algorithmes applicables aux graphes réels.

== Travaux antérieurs et contemporains <sec:dpr-soa>

Sur l'ensemble des études publiées sur le PageRank, seules quelques unes essaient de prendre avantage de la structure de site. @kamvar-exploiting donne une méthode pour calculer rapidement une bonne approximation du PageRank à l'aide d'une partition en sites.

Bianchini _et al._ décomposent le PageRank en liens internes, liens entrants, liens sortants et fuites @bianchini03inside @bianchini02pagerank. Cette décomposition permet entre autres d'apporter une certaine compréhension de la manière dont un site peut changer son propre PageRank, tout en donnant des résultats de stabilité du PageRank face à des changements dans la structure en liens internes d'un site.

Enfin, Arasu _et al._ ont montré qu'un calcul de PageRank sur le graphe quotienté selon les serveurs convergeait plus vite que sur les pages, et encore plus vite en prenant en compte la multiplicité des liens (cf @arasu01pagerank).

Par rapport à ces travaux, notre approche consiste à utiliser, comme dans @bianchini03inside @bianchini02pagerank, une décomposition exacte en flots du PageRank, avec des hypothèses plus flexibles sur la distribution de _zap_. De cette décomposition, nous déduisons un algorithme semi-distribué exact de calcul de PageRank, que nous hybridons avec l'algorithme proposé dans @kamvar-exploiting afin d'obtenir un algorithme semi-distribué rapide et avec peu d'approximations.

== Hypothèses <sec:dpr-cadre>

Nous avons vu qu'une définition structurelle d'un site pouvait être un ensemble de pages étroitement reliées entre elles par des hyperliens. La structure en blocs de la matrice d'adjacence (cf #fref(<adja-fr>) et #fref(<adja>)) nous permet d'espérer de nombreuses méthodes pour décomposer un graphe du Web en sites, et le #fref(<sec:structure-sites>), nous en donne une. Pour la suite de ce chapitre, nous supposerons donc que notre graphe du Web est muni d'une partition qui permet de le décomposer en sites, notée $cal(S)=(S_1,...,S_k)$, avec $k>1$.

Dans un premier temps, nous nous placerons dans le cas idéal où le graphe du Web $G=(V,E)$ considéré est fortement connexe et apériodique. Nous supposerons également l'absence de lien d'une page vers elle-même.

Comme il a été vu lors de la @sec:pr-ideal, si l'on considère la matrice $A$ définie par

$ A = (a_(v,w))_(v,w in V) "," quad "avec" a_(v,w) = cases(
  frac(1, d(v)) & "si" v -> w,
  0 & "sinon."
) $

on sait qu'il existe une unique distribution de probabilité, notée $P$, vérifiant

$ P = A^t P $ <eq:dpr-pr-ideal>

Nous allons chercher à mettre en évidence les liens entre $P$ et $cal(S)$.

== PageRank interne, PageRank externe <sec:model>

=== Notations

Pour $v$ dans $V$, nous désignons par $S(v)$ l'élément de $cal(S)$ tel que $v in S(v)$. Nous définissons également $delta_(cal(S)) : V times V -> {0,1}$ comme suit :

$ delta_(cal(S))(v,w) = cases(
  1 & "si" S(v) = S(w),
  0 & "sinon."
) $

Nous appellerons $A_(cal(S))$ la restriction de $A$ aux éléments internes aux composantes de $cal(S)$ :

$ A_(cal(S)) = (a_(v,w) delta_(cal(S))(v,w))_(v,w in V) $

Nous avons également besoin de définir le degré interne $d_i$ (resp. degré externe $d_e$) d'un sommet $v$ comme son degré sortant dans le graphe induit par $S(v)$ (resp. induit par ${v} union (V backslash S(v))$).

Nous sommes maintenant en mesure de définir les notions de PageRank interne et externe, et de les relier au PageRank $P$ défini par l'@eq:dpr-pr-ideal.

- Le *PageRank entrant interne* $P_(e i)$ (resp. *PageRank entrant externe* $P_(e e)$) d'une page $v$ de $V$ est la probabilité, lorsque le surfeur aléatoire est en régime stationnaire, de venir en $v$ à partir d'une page de $S(v)$ (resp. à partir d'une page de $V backslash S(v)$). De cette définition sont déduites les @eq:pi et @eq:pe :

  $ P_(e i) &= A_(cal(S))^t P $ <eq:pi>
  $ P_(e e) &= (A - A_(cal(S)))^t P = P - P_(e i) $ <eq:pe>

- Le *PageRank sortant interne* $P_(s i)$ (resp. *PageRank sortant externe* $P_(s e)$) d'une page $v$ de $V$ est la probabilité, lorsque le surfeur aléatoire est en régime stationnaire, d'aller de $v$ à une page de $S(v)$ (resp. à une page de $V backslash S(v)$). L'@eq:poi et l'@eq:poe formalisent cette définition :

  $ P_(s i) &= (A_(cal(S)) dot un_n^t) times P $ <eq:poi>
  $ P_(s e) &= ((A - A_(cal(S))) dot un_n^t) times P = P - P_(s i) $ <eq:poe>

=== Lois de conservation

On peut définir un PageRank (éventuellement interne, sortant, ...) sur un site $S$ comme étant la somme des PageRanks de ses pages : $P(S) = sum_(v in S) P(v)$. Cette convention étant prise, nous pouvons énoncer les lois de conservation interne et externe d'un site :

#theoreme[
  Soit $S$ un site. Les PageRanks entrant externe et sortant externe de $S$ sont égaux :

  $ P_(e e)(S) = P_(s e)(S) quad "(loi de conservation externe)" $ <eq:cone>

  Il en est de même des PageRanks entrant interne et sortant interne :

  $ P_(e i)(S) = P_(s i)(S) quad "(loi de conservation interne)" $ <eq:coni>
] <thm:conservation>

#preuve[
  Commençons par prouver la loi de conservation interne (@eq:coni) :

  $
  P_(e i)(S) &= sum_(v in S) P_(e i)(v) = sum_(v in S) sum_(w -> v, w in S) frac(P(w), d(w)) \
  &= sum_(w in S) sum_(v <- w, v in S) frac(P(w), d(w)) = sum_(w in S) P_(s i)(w) \
  &= P_(s i)(S)
  $

  Ensuite, les @eq:pe et @eq:poe nous permettent d'écrire :

  $ P = P_(e e) + P_(e i) = P_(s e) + P_(s i) $ <eq:con1>

  L'@eq:con1 associée à la loi de conservation interne @eq:coni nous donne la loi de conservation externe :

  $ P_(s e)(S) = P_(e e)(S) + P_(e i)(S) - P_(s i)(S) = P_(e e)(S) $
]

#figure(
  image("../figures/dpr-conserv.pdf", width: 10cm),
  caption: [Loi de conservation du PageRank externe : $P_(e e)(S) = P_(s e)(S)$],
) <conserv>

La loi de conservation externe @eq:cone nous montre qu'un site restitue, à travers le PageRank sortant externe, exactement le PageRank qu'il reçoit (le PageRank entrant externe). Comme disait Lavoisier, _rien ne se perd, rien ne se crée, tout se transforme_. Si l'on considère le flot de PageRank sur le graphe quotient $G\/cal(S)$, il y a donc conservation du flot (cf @conserv). Cette remarque est à la base du calcul décomposé du PageRank.

#remarque[
  Une autre façon, peut-être plus simple, de prouver @thm:conservation aurait été de considérer directement le PageRank en tant que flot stationnaire. Il est alors évident que le flot sur tout sous-ensemble $S$ de $V$ est également stationnaire. Nous avons préféré l'approche matricielle car c'est celle que nous continuerons d'utiliser par la suite, même si nous essaierons toujours d'interpréter les résultats en terme de flot quand cela sera possible.
]

== Décomposition du calcul du PageRank <sec:local>

=== Relation entre PageRank externe et PageRank

À partir des @eq:pi et @eq:pe, nous pouvons écrire que $A^t_(cal(S)) dot P = P - P_(e e)$, et donc que $P_(e e) = ("Id" - A_(cal(S))^t) P$, où $"Id"$ est la matrice identité.

#lemme[
  La matrice $("Id" - A_(cal(S))^t)$ est inversible.
] <inversible>

#preuve[
  Il nous suffit de montrer que $A_(cal(S))$ est sous-irréductible. Cela prouvera que son rayon spectral est strictement inférieur à $1$ (@thm:sousstoch, @rem:quasireduc), et donc que $("Id" - A_(cal(S))^t)$ est inversible.

  Raisonnons par l'absurde : si $A_(cal(S))$ n'est pas sous-irréductible, il existe au moins une composante fortement connexe stochastique dans le graphe des transitions associé à $A_(cal(S))$. Cette composante est forcément interne à un site puisqu'il n'y a aucun lien externe. Elle existe donc aussi dans $A$, qui ne peut alors être irréductible que si la composante est $V$ tout entier, ce qui est impossible (nous avons fait l'hypothèse que $A$ était irréductible et que $cal(S)$ contenait au moins deux sites).
]

Le lemme @inversible nous permet alors d'exprimer $P$ comme une fonction du PageRank entrant externe $P_(e e)$ :

$ P = ("Id" - A_(cal(S))^t)^(-1) P_(e e) $ <eq:relation>

Pour calculer le PageRank d'un site $S$, il suffit donc de connaître sa structure interne, à travers la matrice $A_S$, et le PageRank entrant externe qu'il reçoit des autres.

#remarque[
  La matrice $("Id" - A_(cal(S))^t)^(-1) = sum_(k=0)^(infinity) (A^t_(cal(S)))^k$, qui est tout comme $A_(cal(S))$ une matrice diagonale par blocs, peut s'interpréter comme la matrice de transition de tous les chemins internes possibles. En effet, pour $v,w in V$, $(A_(cal(S)))^k_(v,w)$ représente la probabilité d'aller de $v$ à $w$ par un chemin de longueur $k$ qui ne suit que des liens internes (en particulier, $(A_(cal(S)))^k_(v,w) = 0$ si $S(v) != S(w)$.)
]

=== Matrice de transition du PageRank externe

Nous voulons formaliser l'intuition d'une propagation du PageRank de site à site donnée par la loi de conservation du PageRank externe (cf @conserv), et trouver une description des relations entre les différentes composantes de $P_(e e)$. En combinant les @eq:pe et @eq:relation, nous obtenons :

$ P_(e e) = (A - A_(cal(S)))^t P = (A - A_(cal(S)))^t ("Id" - A_(cal(S))^t)^(-1) P_(e e) $ <eq:prpe>

Nous pouvons ainsi définir la matrice de transition du PageRank externe :

$ A_e^t = (A - A_(cal(S)))^t ("Id" - A_(cal(S))^t)^(-1) $

Cette matrice possède quelques propriétés très intéressantes :

#lemme[
  La matrice $A_e$ est stochastique.
] <lemme:aestochast>

#preuve[
  $A_e$ est de toute évidence positive, il nous suffit donc de montrer que la somme de chaque colonne de $A_e^t$ vaut $1$. Pour cela, nous commençons par réécrire $A_e^t$ :

  $
  A_e^t &= sum_(k=0)^infinity (A^t (A^t_(cal(S)))^k - (A^t_(cal(S)))^(k+1)) \
  &= A^t + sum_(k=1)^infinity (A^t (A^t_(cal(S)))^k - (A^t_(cal(S)))^k) \
  &= A^t + A^t M - M, quad "avec" M = sum_(k=1)^infinity (A^t_(cal(S)))^k
  $

  Considérons la somme $s_w$ de la colonne de $A^t M$ associée à la page $w$ :

  $ s_w = sum_(u in V) sum_(v in V) A^t_(u,v) M_(v,w) = sum_(v in V) (sum_(u in V) A^t_(u,v)) M_(v,w) = sum_(v in V) M_(v,w) $

  Ainsi, la somme de chaque colonne de $A^t M - M$ est nulle, ce qui montre que $A_e$ est stochastique, puisque la somme de chaque colonne $w$ vaut $sum_(v in V) A^t_(v,w) = 1$.
]

#lemme[
  Soit $V_("int")$ l'ensemble des pages sans lien entrant externe, et $V_("ext")$ celui des pages possédant au moins un lien entrant externe. Si l'on réordonne les pages selon $(V_("int"), V_("ext"))$, alors $A_e$ peut s'écrire

  $ A_e = mat(0, T; 0, tilde(A)_e) $

  où $tilde(A)_e$ est une matrice stochastique irréductible.
]

#preuve[
  Les colonnes de $(A - A_(cal(S)))$ correspondant à des pages de $V_("int")$ sont nulles. Il en est donc de même de celles de $A_e$, ce qui montre que $A_e$ peut s'écrire sous la forme

  $ A_e = mat(0, T; 0, tilde(A)_e) $

  $tilde(A)_e$ est stochastique, puisque $A_e$ l'est. Il reste à montrer qu'elle est irréductible. Considérons deux sommets $v$ et $w$ de $V_("ext")$, et un chemin $cal(C) = v,...,w$ qui mène de $v$ à $w$ dans $G$. Soit $i_0, i_1, ..., i_(k-1), i_k$ la suite de sommets obtenue en ne conservant dans $cal(C)$ que les sommets de $V_("ext")$ ($i_0 = v$ et $i_k = w$). Alors, $i_0, i_1, ..., i_(k-1), i_k$ est un chemin dans le graphe induit par $tilde(A)_e$. En effet, entre $i_(l-1)$ et $i_l$, il existe un sous-chemin de $cal(C)$ constitué d'un chemin interne à $S(i_(l-1))$, puis d'un saut externe menant à $i_l$. D'après la définition de $A_e$, nous avons donc

  $ tilde(A)_e_((i_(l-1), i_l)) = A_e_((i_(l-1), i_l)) > 0 $

  $i_0, i_1, ..., i_(k-1), i_k$ est donc bien un chemin dans le graphe induit par $tilde(A)_e$, ce qui montre que $tilde(A)_e$ est irréductible.

  C.Q.F.D.
]

$A_e$ possède donc un PageRank unique, qui est nul sur $V_("int")$#footnote[Ce résultat est naturel : une page qui n'a pas de lien entrant externe ne peut pas recevoir du PageRank entrant externe.] et est égal au PageRank de $tilde(A)_e$ sur $V_("ext")$. Sous réserve d'apériodicité, il peut être calculé de manière itérative. Seuls les coefficients de $tilde(A)_e$ sont nécessaires pour calculer ce PageRank. Bien que nous n'ayons pas fait de recherches poussées d'estimation de la taille de $V_("ext")$, les quelques analyses que nous avons pu effectuer, autant sur des crawls que sur des logs de serveurs (en particulier ceux de l'INRIA) semblent indiquer que l'on peut espérer $|V_("ext")| <= 0.1 |V|$.

=== Calcul décomposé théorique du PageRank <pdra>

À partir de @eq:relation et de @eq:prpe, nous pouvons établir une méthode théorique semi-distribuée de calcul du PageRank.

- Chaque site $S$ calcule, à partir de son bloc $A_S$ de la matrice des transitions internes $A_(cal(S))$, son bloc $("Id" - A_S^t)^(-1)$ de la matrice $("Id" - A_(cal(S))^t)^(-1)$.
- Les différentes lignes de $tilde(A)_e$ peuvent alors être reconstituées et centralisées.
- Le PageRank externe $P'_e$ associé à $A_e$ est alors calculé (il faut ici faire une hypothèse d'apériodicité sur $tilde(A)_e$).
- Chaque site S obtient son propre PageRank $P'(v)$, $v in S$, en appliquant $P'_e (v)$, $v in S$, à sa matrice $("Id" - A_S^t)^(-1)$.

#lemme[
  Le vecteur $P'$ ainsi obtenu est homogène au PageRank $P$ associé à $G$.
]

#preuve[
  Comme $A$ est irréductible, il nous suffit de montrer que $A^t P'$ est égal à $P$ :

  $
  A^t P' &= A^t ("Id" - A_(cal(S))^t)^(-1) P'_e \
  &= (A^t - A^t_(cal(S)))("Id" - A_(cal(S))^t)^(-1) P'_e + A_(cal(S))^t ("Id" - A_(cal(S))^t)^(-1) P'_e \
  &= A_e^t P'_e + (("Id" - A_(cal(S))^t)^(-1) - ("Id" - A_(cal(S))^t)("Id" - A_(cal(S))^t)^(-1)) P'_e \
  &= P'_e + (("Id" - A_(cal(S))^t)^(-1) - "Id") P'_e \
  &= P'_e + P' - P'_e = P'
  $

  C.Q.F.D.
]

== Intermezzo : modifier son propre PageRank <sec:alter>

Avant d'attaquer la pièce centrale de ce chapitre, l'algorithme FlowRank, nous voulons montrer que notre décomposition du PageRank permet d'expliquer dans quelle mesure un site peut modifier son propre PageRank, ce qui sera l'occasion d'introduire en douceur le facteur _zap_ dans notre modèle.

Les résultats que nous allons présenter prennent du sens si l'on accepte l'idée qu'un site modifie très difficilement son PageRank externe, alors qu'il en est tout autrement du PageRank interne. De fait, les échanges de PageRank entre sites sont étroitement surveillés par Google, qui n'hésite pas à sanctionner les sites qui échangent des liens dans le seul but d'augmenter leur PageRank externe. De telles usines à PageRank, baptisées _farm links_ ou _pouponnières_, se voient généralement gratifiées d'un PageRank nul, et se retrouvent donc classées derrière toutes les autres pages#footnote[Notons que cette politique a été l'objet de nombreux procès opposant Google à des sociétés de référencement. En dépit de soupçons quant à l'impartialité de Google quand il s'agit de définir une pouponnière, la société Google n'a jamais été reconnue coupable : un moteur de recherche classe ses résultats comme il l'entend.].

=== Coefficient d'amplification <subsec:amplifact>

Considérons un site $S in cal(S)$, son PageRank $P(S)$ et son PageRank entrant externe $P_(e e)(S)$. Nous définissons le coefficient d'amplification $alpha$ de $S$ comme le rapport entre PageRank et PageRank entrant externe :

$ alpha(S) = frac(P(S), P_(e e)(S)) $

Puisque $P = ("Id" - A^t_(cal(S)))^(-1) P_(e e)$, $alpha(S)$ dépend seulement de la structure de $S$ et de la distribution du PageRank externe sur $S$#footnote[Notons que cette distribution peut dans une certaine mesure être influencée par des modifications de la structure de $S$. Mais comme nous l'avons vu, des variations trop importantes peuvent être le signe d'une pouponnière.].

La seule connaissance de $S$ nous donne une estimation de $alpha(S)$ :

#lemme[
  Un encadrement du coefficient d'amplification $alpha(S)$ est

  $ frac(1, 1-omega) <= alpha(S) <= frac(1, 1-Omega) $ <amp>

  avec $omega = min_(v in S) frac(d_i (v), d(v))$ et $Omega = max_(v in S) frac(d_i (v), d(v))$.
] <lemme:ampli1>

#preuve[
  Si l'on considère l'espace vectoriel associé à $S$, pour tout vecteur élémentaire $e_v$, $v in S$, nous avons $||A_S (e_v)||_1 = frac(d_i (v), d(v))$, et donc $omega ||X||_1 <= ||A_(cal(S)) X||_1 <= Omega ||X||_1$ pour tout vecteur $X > 0$ défini sur $S$.

  On en déduit la première inégalité de @amp :

  $ P(S) = sum_(v in S) P(v) = ||sum_(k in NN) (A_S^t)^k (P_(e e))||_1 >= sum_(k=0)^infinity omega^k ||P_(e e)||_1 = frac(1, 1-omega) P_(e e)(S) $

  ainsi que la seconde :

  $ P(S) = sum_(v in S) P(v) = ||sum_(k in NN) (A_S^t)^k (P_(e e))||_1 <= sum_(k=0)^infinity Omega^k ||P_(e e)||_1 = frac(1, 1-Omega) P_(e e)(S) $
]

La conséquence de @amp est que dès que $Omega = 1$, rien n'empêche un site d'amplifier arbitrairement un PageRank. Dans le cas limite où $omega = 1$ (site sans lien sortant externe, par exemple un site commercial n'ayant pas envie que l'internaute aille voir ailleurs), on a une amplification infinie et un phénomène de court-circuit. Nous retrouvons le phénomène bien connu du puits de rang (cf @Page98), vu cette fois du point de vue de l'amplification : un ensemble de pages sans lien sortant va absorber et accumuler tout le PageRank externe reçu jusqu'à épuisement du flot.

Heureusement, la sur-amplification est contrôlée par le facteur _zap_.

=== Introduction du facteur _zap_ <amor-flot>

Nous allons à partir de maintenant quitter le cadre idéal où $G$ est fortement connexe et apériodique pour considérer un graphe du Web $G$ quelconque. Il nous faut donc en particulier choisir quel modèle de PageRank adopter, et notre choix s'est naturellement porté sur le PageRank non-compensé avec facteur _zap_. Grâce au @thm:nonc-mu, nous savons en effet que c'est un modèle strictement équivalent au PageRank $mu$-compensé généralement utilisé, à la différence près qu'il permet de travailler avec un flot de _zap_ constant.

$P$ est donc maintenant l'unique vecteur vérifiant $P = d A^t P + (1-d) Z$, $Z$ étant une distribution recouvrante et $d$ le facteur _zap_.

Nous avons également besoin d'étiqueter le flot de _zap_. Nous pourrions le répartir en flot externe et interne, selon que le _zap_ nous fasse sortir du site où l'on est ou non, mais nous avons jugé plus judicieux de considérer le flot de _zap_ comme un flot externe dans sa totalité, et de séparer le flot externe en flot externe de clic et flot externe de _zap_. Nous allons continuer à réserver les termes de PageRank externe entrant et PageRank externe sortant au flot externe de clic, et nous allons par analogie avec l'électricité définir deux nouveaux flots de PageRank liés au _zap_ : le *PageRank induit*, noté $P_("ind")$, qui est la probabilité#footnote[Même si le modèle non-compensé fait que l'on ne devrait plus parler de probabilité, nous nous permettrons sporadiquement de continuer à utiliser ce terme, même si il est plus correct de parler de flot.] <ftn:proba-flot> de venir sur une page par _zap_, et le *PageRank dissipé*, noté $P_("dis")$, qui est la probabilité#footnote[Voir note de bas de page précédente.] de quitter une page par _zap_.

Nous avons maintenant un bestiaire constitué de six PageRanks, ou plutôt de six flots, qui sont récapitulés dans le @tab:sixflow (rappel : $s$ est le défaut stochastique, définit par $s = un^t - A dot un^t$).

#figure(
  table(
    columns: 3,
    stroke: 0.5pt,
    inset: 0.5em,
    align: center,
    [*flot*], [*entrant*], [*sortant*],
    [interne], [$P_(e i) = d A_(cal(S))^t P$], [$P_(s i) = d (A_(cal(S)) un^t) times P$],
    [externe (clic)], [$P_(e e) = d (A - A_(cal(S)))^t P$], [$P_(s e) = d ((A - A_(cal(S))) un^t) times P$],
    [externe (_zap_)], [$P_("ind") = (1-d) Z$], [$P_("dis") = (1-d) P + d s times P$],
  ),
  caption: [Les six flots de PageRank dans le modèle non-compensé],
) <tab:sixflow>

On remarquera au passage que $P = P_(e i) + P_(e e) + P_("ind") = P_(s i) + P_(s e) + P_("dis")$.

Les lois de conservation interne et externe sont toujours valables. Nous ne chercherons pas cette fois à le prouver par un calcul matriciel, et nous nous contenterons de les justifier par le fait que l'on est présence d'un flot stationnaire. En particulier, la loi de conservation externe sur un site $S$ s'écrit maintenant :

$ P_(e e)(S) + P_("ind")(S) = P_(s e)(S) + P_("dis")(S) $ <eq:cone2>

L'équation nous donne un résultat intéressant : si un site $S$ possède un PageRank supérieur à $Z(S)$, son PageRank sortant externe est inférieur à son PageRank entrant externe, avec égalité si, et seulement si, $P(S) = Z(S)$ et $s(S) = 0$. Cela signifie qu'un site $S$ ne peut espérer avoir un PageRank supérieur au PageRank par défaut $Z(S)$ qu'à la condition de donner moins que ce qu'il reçoit.

=== _Zap_ et coefficient d'amplification <amor-ampli>

Avec l'introduction du facteur _zap_, l'@eq:relation devient maintenant

$ P = ("Id" - d A_(cal(S))^t)^(-1) (P_(e e) + P_("ind")) $

L'encadrement vu lors de la @subsec:amplifact est toujours valable en remplaçant $A$ par $d A$ et $P_(e e)$ par le PageRank entrant externe total $P_(e e) + P_("ind")$, et en posant par convention $frac(d_i (v), d(v)) = 0$ si $d(v) = 0$. On obtient ainsi le @lemma:amp.

#lemme[
  Le facteur d'amplification $alpha'$ défini par $alpha'(S) = frac(P(S), P_(e e)(S) + P_("ind")(S))$ vérifie

  $ frac(1, 1 - d omega) <= alpha'(S) <= frac(1, 1 - d Omega) $ <amp2>
] <lemma:amp>

#preuve[
  On procède exactement comme pour la preuve du @lemme:ampli1. Si l'on considère un site fixé $S$, et si l'on restreint $P_(e e)$ et $P_("dis")$ à leurs valeurs sur $S$, la première inégalité s'obtient en écrivant

  $
  P(S) &= sum_(v in S) P(v) = ||sum_(k in NN) (d A^t_S)^k (P_(e e) + P_("ind"))||_1 \
  &>= sum_(k=0)^infinity (d omega)^k (||P_(e e)||_1 + ||P_("ind")||_1) \
  &>= frac(1, 1 - d omega) (P_(e e)(S) + P_("ind")(S))
  $

  et la deuxième de manière similaire :

  $
  P(S) &= sum_(v in S) P(v) = ||sum_(k in NN) (d A^t_S)^k (P_(e e) + P_("ind"))||_1 \
  &<= sum_(k=0)^infinity (d Omega)^k (||P_(e e)||_1 + ||P_("ind")||_1) \
  &<= frac(1, 1 - d Omega) (P_(e e)(S) + P_("ind")(S))
  $
]

==== Valeur numérique

Pour un site réel, il est tout à fait possible d'avoir $omega = Omega = 0$ (site dépourvu de lien interne), ou au contraire $omega = Omega = 1$ (site sans lien externe, et dont toutes les pages possèdent au moins un lien). Ainsi, le coefficient d'amplification peut varier entre $1$ (le site ne tire aucun profit du PageRank qu'il reçoit) et $frac(1, 1-d)$ (utilisation maximale du PageRank reçu). Comme $d$ est une constante universelle qui vaut $0,85$, on en conclut qu'à PageRank entrant externe total fixé, le PageRank d'un site peut selon sa structure varier avec un facteur $frac(20,3)$. Par exemple un site très mal structuré peut en se restructurant avoir un nouveau PageRank égal à environ $666%$#footnote[Ce joli chiffre est une preuve supplémentaire de la nécessité d'avoir $0,85$ comme valeur de $d$.] fois l'ancien PageRank.

==== Robustesse du PageRank

Bianchini _et al._ @bianchini02pagerank @bianchini03inside montrent que l'effet que peut produire un site sur le Web est contrôlé par le PageRank de ce site. Plus précisément, si l'on considère un graphe dynamique entre deux instants $t$ et $t+1$, ils ont prouvé que :

$ sum_(v in V) |P_t (v) - P_(t+1)(v)| <= frac(2d, 1-d) sum_(s in S) P_t (s) $ <eq:bianchini-robust>

Ce résultat peut également se déduire du @lemma:amp : si un site $S$ change entre $t$ et $t+1$, la plus grande variation relative possible est celle où l'on passe de $alpha'(S) = 1$ à $alpha'(S) = frac(1, 1-d)$. Cette modification de la structure du site, qui correspond à la création d'un puits de rang, ne pouvant se faire qu'au détriment du PageRank externe, et donc du PageRank entrant externe, on a alors forcément $P_(e e)_t >= P_(e e)_(t+1)$, d'où une variation d'au plus $frac(d, 1-d) P(S)$. Comme Bianchini _et al._ travaillent ici dans un modèle compensé (la somme des PageRanks est constante), une variation de $frac(d, 1-d) P(S)$ dans $S$ génère la même variation hors de $S$, ce qui nous donne l'inégalité @eq:bianchini-robust.

=== Amplification d'une page donnée <ampli-page>

Pour un site, l'intérêt du PageRank est avant tout d'être visible par les internautes. En particulier, l'administrateur d'un site sera vraisemblablement moins intéressé par un PageRank élevé sur tout son site que par un PageRank très élevé sur quelques pages, voire sur une page. Mieux vaut donc concentrer son PageRank sur une page d'accueil généraliste plutôt que de le répartir entre plusieurs pages spécialisées. Nous allons donc considérer le problème suivant : considérons un site $S$ de $n+1$ pages alimenté par un PageRank entrant externe $P_(e e)$. Comment maximiser le PageRank d'une page donnée $v_0 in S$ ?

La réponse n'est pas difficile une fois que l'on a remarqué que la structure optimale est celle où toutes les pages de $S$ autre que $v_0$ pointent vers $v_0$ (et seulement $v_0$) et $v_0$ pointe sur au moins une autre page de $S$. $v_0$ récupère ainsi, aux dissipations près, tout le PageRank des autres pages, et récupère son propre PageRank à un facteur $d^2$ près, ce qui est le maximum possible dans un graphe où, rappelons-le, les liens d'une page vers elle-même ne sont pas pris en compte. On a alors

$ P(v_0) = frac(P_(e e)(v_0), 1 - d^2) + frac(Z(v_0), 1 + d) + d sum_(v in S, v != v_0) (frac(P_(e e)(v), 1 - d^2) + frac(Z(v), 1 + d)) $

Dans le cas particulier où $Z$ est la distribution uniforme, on obtient ainsi

$ P(v_0) <= frac(P_(e e)(S), 1 - d^2) + frac(1 + n d, (1 + d)|V|) $ <amp-page>

avec égalité si, et seulement si, tout le PageRank entrant externe est concentré sur $v_0$, c'est-à-dire $P_(e e)(S) = P_(e e)(v_0)$.

On déduit de tout cela quelques stratégies pour améliorer le PageRank d'une page $v_0$, qui recoupent les recommandations que l'on peut trouver sur de nombreux sites destinés à l'amélioration de son PageRank :
- Demander aux administrateurs d'autres sites de toujours pointer, dans la mesure du possible, sur la page principale plutôt que sur une page spécifique. Éventuellement, mettre des scripts qui redirigent vers la page d'accueil tout accès d'une page extérieure au site#footnote[Cette recommandation est à prendre avec précaution : la façon dont Google considère les redirections n'est pas très claire. De plus, cela peut rendre la navigation moins ergonomique pour l'internaute.].
- Toujours penser à mettre des liens de retour vers la page d'accueil, et limiter autant que possible la profondeur du site (et donc la dissipation). Dans le cas particulier des sites à frames, mettre des balises `<noframe>` à l'intérieur desquelles la structure en étoile est explicitement représentée.

Concluons enfin par quelques remarques valables si $Z$ est la distribution uniforme :

- Avec la stratégie optimale, un site formé simplement de deux pages qui pointent l'une sur l'autre possède un PageRank qui est au moins égal au PageRank moyen, même si le PageRank entrant externe est nul : $P(v_0) >= frac(1, |V|)$.
- Si $1 << n <= |V|$ (par exemple un site qui génère dynamiquement des pages pointant sur $v_0$, comme un site de consultation d'une base donnée avec des liens autres que des formulaires), le rapport $frac(P(v_0), P_("moyen"))$ vaut approximativement $frac(d, 1+d) n$. Il est donc possible d'augmenter linéairement son PageRank sur $v_0$. Dans la réalité, ceci est valable à condition que les robots de Google prennent la peine d'explorer toutes les pages#footnote[À mon grand regret, Google n'a pas encore fini d'explorer la _page qui pointe vers toutes les pages_ (cf @lpqpvtlp page @lpqpvtlp), ce qui explique que cette dernière n'ait pas encore un PageRank maximal...], et que le but de toutes ces pages ne soit pas uniquement d'augmenter son PageRank#footnote[Dans le cas contraire, attention à la sanction.].

== Cas réel : FlowRank et BlowRank <sec:flowrank>

L'objectif de cette section est d'adapter le calcul théorique vu lors de la @pdra aux situations réelles.

=== Relations à l'équilibre avec le facteur _zap_

Maintenant que nous avons eu le temps de nous familiariser avec les flots induits et dissipés, nous pouvons réécrire les équations vues au cours de @sec:local.

Avec l'introduction du facteur _zap_, l'@eq:relation, qui décrit le lien entre PageRank entrant externe et PageRank, devient comme nous l'avons vu

$ P = ("Id" - d A_(cal(S))^t)^(-1) (P_(e e) + (1-d) Z) $ <eq:relation-zap>

La relation d'équilibre du PageRank externe, équivalent de @eq:prpe, s'obtient quant à elle en fusionnant @eq:relation-zap avec la définition de $P_(e e)$. On obtient ainsi :

$
P_(e e) &= d A^t_e P_(e e) + Z_e, quad "avec" \
A^t_e &= (A - A_(cal(S)))^t ("Id" - d A^t_(cal(S)))^(-1) quad "et" \
Z_e &= d(1-d) A^t_e Z
$ <eq:nonc-externe>

#lemme[
  Le rayon spectral de $A_e$ est inférieur à $1$.
] <lemme:conv-nonc-externe>

#preuve[
  La preuve est similaire à celle du @lemme:aestochast : nous montrons en effet que $A_e$ est sous-stochastique (au sens large). Nous allons pour cela montrer que le rayon spectral de $d A_e$ est inférieur à $d$. Comme $A_e$ est positive, il suffit, d'après le théorème de Perron-Frobenius, de montrer que pour tout vecteur $X$ positif, $||d A^t_e X||_1 <= d ||X||_1$. Pour cela, nous commençons par réécrire $d A_e^t$ :

  $
  d A_e^t &= sum_(k=0)^infinity (d A^t (d A^t_(cal(S)))^k - (d A^t_(cal(S)))^(k+1)) \
  &= d A^t + sum_(k=1)^infinity (d A^t (d A^t_(cal(S)))^k - (d A^t_(cal(S)))^k) \
  &= d A^t + d A^t M - M, quad "avec" M = sum_(k=1)^infinity (d A^t_(cal(S)))^k
  $

  Considérons maintenant un vecteur $X$ positif. Comme $d A_e^t X$, $d A^t X$, $d A^t M X$ et $M X$ sont tous des vecteurs positifs, on a

  $ 0 <= ||d A_e^t X||_1 = ||d A^t X||_1 + ||d A^t M X||_1 - ||M X||_1 $

  Le rayon spectral de $A^t$ étant inférieur à $1$, on a $||d A^t M X||_1 <= ||M X||_1$, d'où

  $ ||d A_e^t X||_1 <= ||d A^t X||_1 <= d ||X||_1 $

  C.Q.F.D.
]

#remarque[
  L'inégalité $||d A^t M X||_1 <= ||M X||_1$ utilisée dans la preuve du @lemme:conv-nonc-externe est très grossière. Dans la pratique, on peut donc légitimement s'attendre à ce que le rayon spectral de $A_e$ soit plus petit que $1$, et donc que l'@eq:nonc-externe permette de trouver $P_(e e)$ avec une raison de convergence plus petite que $d$. Les résultats présentés par Arasu _et al._ (cf @arasu01pagerank) vont dans ce sens et nous autorisent à espérer une convergence très rapide en pratique.
]

==== Application : estimation du PageRank d'un site <estimation>

Pour l'administrateur d'un site $S$, pouvoir estimer l'importance de ses pages sans faire appel à une aide extérieure ni chaluter le Web indexable peut être d'un intérêt certain. Par exemple, cette importance pourrait être incorporée à un moteur de recherche interne. Or, d'après l'@eq:relation-zap, il suffit pour cela d'arriver à estimer le PageRank entrant externe sur $S$.

En effet, si on définit la fonction $"SpeedRank"(M, X)$, inspirée de l'@alg:speedrank, comme une fonction qui renvoie, pour $M$ positive de rayon spectral strictement inférieur à $frac(1,d)$ et $X$ positif, le vecteur $P$ vérifiant $P = d M^t P + X$, alors

$ P_S = "SpeedRank"(A_S, ((P_(e e))_S + (1-d) Z_S)) $

Pour estimer ce PageRank entrant externe, deux approches locales sont possibles :

- Nous avons vu que le PageRank est censé, dans une certaine mesure, essayer de représenter le comportement des internautes réels (cf @subsec:random-surfer). On peut alors prendre, comme estimation du PageRank externe entrant, le nombre de clics réels de l'extérieur du site vers une page du site, mesuré à partir de l'analyse des logs du serveur Web.
- Grâce, ou à cause, du facteur $d$, le classement par degré entrant est une approximation du classement par PageRank (cf @subsec:choix_d). En comptant le nombre de références externes associé à chaque page, obtenu là aussi grâce à une analyse des logs du serveur Web, on obtient donc une autre estimation de $P_(e e)$.

Une fois que l'on a une estimation de $(P_(e e))_S$, il faut l'équilibrer par rapport à $Z_S$. Une manière, parmi beaucoup d'autres, de réaliser cet équilibrage est de faire une moyenne pondérée des deux vecteurs. On pourra par exemple renvoyer comme estimation normalisée du PageRank sur $S$

$ P_S = "SpeedRank"(A_S, (d frac((P_(e e))_S, ||(P_(e e))_S||_1) + (1-d) frac(Z_S, ||Z_S||_1))) $

On remarquera au passage que la source de rang est alors normalisée à $1$ quelque soit l'envergure du site $S$ considéré. Comme il s'agit juste d'estimer l'importance relative des pages à l'intérieur de $S$, cela ne pose aucun problème.

=== Une première approche : FlowRank

Nous avons maintenant toutes les données en main pour construire l'algorithme FlowRank. Constatons tout d'abord que grâce au facteur _zap_, $P_(e e)$ est complètement défini par l'@eq:nonc-externe, alors que l'@eq:prpe garantissait seulement d'obtenir un vecteur homogène. Afin d'éviter d'inverser explicitement les matrices $("Id" - d A_S)$, pour $S in cal(S)$, nous allons avoir recours à la fonction $"SpeedRank"$ définie précédemment. Grâce à cette fonction, toutes les valeurs que nous avons besoin de connaître peuvent être calculées :

- $(A - A_(cal(S)))^t "SpeedRank"(A_(cal(S)), e_v)$, où $e_v$ est le vecteur valant $1$ sur $v$, $0$ ailleurs, donne la colonne de $A^t_e$ associée à $v$. Ce calcul peut se limiter, en entrée comme en sortie, aux pages de $V_("ext")$. On obtient ainsi la matrice $V_("ext") times V_("ext")$ que nous avons précédemment appelée $tilde(A)_e$, et que nous continuerons par abus d'écriture à appeler $A_e$. Notons également que ce calcul peut s'effectuer localement au sein de chaque site $S(v) in cal(S)$.
- $Z_e$ vaut quant à lui $d(1-d)(A - A_(cal(S)))^t "SpeedRank"(A_(cal(S)), Z)$. Ce calcul peut lui aussi être réparti sur l'ensemble des sites. Notons que $Z_e$ est nul en dehors de $V_("ext")$, nous pouvons donc nous contenter de considérer $tilde(Z)_e$, restriction de $Z_e$ à $V_("ext")$.
- Une fois calculé $tilde(A)_e$ et $tilde(Z)_e$, il est possible de calculer $tilde(P)_(e e)$, restriction de $P_(e e)$ à $V_("ext")$ : $tilde(P)_(e e) = "SpeedRank"(tilde(A)_e, tilde(Z)_e)$.
- Le PageRank non-compensé est alors donné par $P = "SpeedRank"(A_(cal(S)), (P_(e e) + (1-d) Z))$. Encore une fois, cette étape peut se faire à l'échelle d'un site.

Toutes ces opérations sont résumées dans l'@alg:flowrank.

#alg(
  caption: [FlowRank : calcul décomposé du PageRank non-compensé],
)[
*Donnees*
- un graphe du web $G=(V,E)$ ;
- une partition en sites de $G$, $cal(S) = (S_1, ..., S_k)$ ;
- une distribution de probabilité $Z$ recouvrante ;
- un coefficient de _zap_ $d in ]0, 1[$ ;
- un réel $epsilon$ ;
- une fonction $"SpeedRank"$, inspirée de l'@alg:speedrank, telle que $P = "SpeedRank"(M, X)$ vérifie $P = d M^t P + X$, avec une précision $epsilon$.
Résultat\ 
Le vecteur de PageRank non-compensé associé à $(G, Z, d)$.\
début\
$A_e <- 0_(|V_("ext")| times |V_("ext")|)$\
pour chaque site $S$ de $cal(S)$ :#i\
Calculer $A_S$, sous-matrice $|S| times |S|$ de $A_(cal(S))$\
    Calculer $overline(A)_S$, sous-matrice $|S| times |V_("ext")|$ de $(A - A_(cal(S)))$\
    $Z_(S_e) <- d(1-d) overline(A)_S^t "SpeedRank"(A_S, Z_S)$\
    pour chaque page $v$ de $S inter V_("ext")$ :#i\
    $(A_e^t)_(*, v) <- overline(A)_S^t "SpeedRank"(A_S, e_v)$#d\
  $Z_e <- sum_(S in cal(S)) Z_(S_e)$\
  $P_(e e) <- "SpeedRank"(A_e, Z_e)$\
pour chaque site $S$ de $cal(S)$ :#i\ 
$P_S <- "SpeedRank"(A_S, (P_(e e))_S + (1-d) Z_S)$#d#d\
retourner $(P_S)_(S in cal(S))$
] <alg:flowrank>

L'algorithme FlowRank possède de nombreux avantages :

- En fractionnant les calculs de SpeedRank au niveau des sites, on a la possibilité de stocker la matrice en mémoire vive, ce qui permet un calcul extrêmement rapide, d'autant plus rapide que SpeedRank ne fait aucun calcul de norme.
- Mis à part le calcul de $P_(e e)$, qui est global, tous les autres calculs peuvent être effectués de manière décentralisée à l'échelle des sites. Il est ainsi possible de paralléliser une grande partie des calculs.
- Pour prendre un compte la mise à jour d'un site donné, il n'est pas nécessaire de relancer l'intégralité de l'algorithme (contrairement au cas d'un algorithme totalement centralisé). Il suffit de relancer les calculs de SpeedRank au niveau du site en question, et de réactualiser $P_(e e)$. Utiliser les précédentes valeurs comme valeurs initiales pour les SpeedRank peut rendre l'opération très rapide.

Mais il a aussi des inconvénients. Ainsi, il faut effectuer $2k + 1 + |V_("ext")|$ calculs de SpeedRank. Même si SpeedRank, comme son nom l'indique, est très rapide, ce nombre reste élevé. De même, le calcul de $P_(e e)$ est un SpeedRank sur une matrice $|V_("ext")| times |V_("ext")|$. Si cette matrice ne tient pas en mémoire vive, on perd une grande partie de l'intérêt pratique du calcul décomposé. Pour résoudre ces problèmes, nous allons nous inspirer d'un algorithme concurrent du nôtre, l'algorithme _BlockRank_.

=== Algorithme distribué de Kamvar _et al._ : BlockRank

Parallèlement à nos travaux sur la structure en blocs des graphes du Web @mathieu02structure @mathieu03local et les applications possibles au PageRank @mathieu03aspects @mathieu04local, Kamvar _et al._ ont fait des recherches très similaires. Dans @kamvar-exploiting, ils utilisent une décomposition en sites pour proposer un algorithme semi-distribué de calcul d'une estimation du PageRank : BlockRank. Cet algorithme est basé sur le calcul d'un PageRank local, qui avec nos notations est le PageRank sur $A_(cal(S))$, et d'un PageRank de site, basé sur une matrice sous-stochastique de BlockRank, notée $B$, définie sur le graphe quotient $G\/cal(S)$. L'estimation du PageRank d'une page $v$ est alors donnée par le produit du PageRank local de $v$ par le PageRank de $S(v)$, également appelé BlockRank#footnote[Pour les détails complets, voir @kamvar-exploiting.]. Bien que FlowRank et BlockRank se ressemblent au premier coup d'oeil, il existe d'importantes différences que nous voulons souligner :

- Aux erreurs introduites par $epsilon$ près, FlowRank donne le PageRank non-compensé#footnote[Rappelons encore une fois que du point de vue théorique, il n'y a strictement aucune différence entre le PageRank non-compensé et le PageRank $mu$-compensé traditionnellement utilisé.], et non une approximation. Ainsi, le problème de sous-estimation du PageRank des pages principales rencontré avec l'algorithme BlockRank @kamvar-exploiting ne se pose pas. Il y a évidemment un prix à payer au niveau de la complexité de l'algorithme.
- La clé de voûte de FlowRank est le PageRank non-compensé, et l'algorithme SpeedRank qui en découle, alors que BlockRank reste sur l'idée du PageRank $mu$-compensé, qui est trois fois plus lent sur les « petits » graphes.
- Si le PageRank local dans un site $S$ vaut, à normalisation près, $"SpeedRank"(A_S, Z_S)$, la matrice globale de FlowRank, $tilde(A)_e$, et celle de BlockRank, $B$, n'ont quasiment aucun point commun. Par exemple, $B$ possède des transitions d'un site vers lui-même. On constatera aussi qu'alors que FlowRank utilise un _zap_ externe $Z_e$ adapté à $G$, le PageRank sur $B$ utilise un _zap_ uniforme.

=== Algorithme hybride : BlowRank

Le principal avantage de BlockRank sur FlowRank est ce passage de $|V_("ext")|$ à $k = |cal(S)|$ rendu possible par les approximations. Ce gain se fait tout autant pour le nombre de calculs locaux que pour la taille de la matrice globale. Nous sommes donc tentés de réduire $tilde(A)_e$ à une matrice $k times k$. Pour cela nous devons réduire l'information de flot externe à un scalaire par site $S$, en remplaçant par exemple $(P_(e e))_S$ par $P_(e e)(S)$. Il nous faut alors définir la façon dont le PageRank entrant externe est injecté à l'intérieur de chaque site. Nous supposerons donc que chaque site $S$ est muni d'une distribution de probabilité qui estime la distribution du PageRank entrant externe. Cette distribution, que nous noterons $D_S$, pourra être la distribution uniforme sur $S$, ou plus finement une distribution sur les pages d'entrée du site, qui sont les plus susceptibles d'être pointées.

Nous pouvons maintenant considérer l'algorithme hybride BlowRank (#ref(<alg:blowrank>, supplement: none)), qui diffère de FlowRank par une réorganisation imposée du flot externe à l'entrée de chaque site : tout se passe comme si à l'entrée de chaque site, le PageRank entrant externe (par clic) était collecté et redistribué selon $D_S$.

#alg(
  caption: [BlowRank : approximation à la BlockRank de l'algorithme FlowRank],
)[
Données
- un graphe du web $G=(V,E)$ ;
- une partition en sites de $G$, $cal(S) = (S_1, ..., S_k)$, chaque site $S$ étant associé à une distribution de probabilité $D_S$ ;
- une distribution de probabilité $Z$ recouvrante ;
- un coefficient de _zap_ $d in ]0, 1[$ ;
- un réel $epsilon$ ;
- une fonction $"SpeedRank"$, inspirée de l'@alg:speedrank, telle que $P = "SpeedRank"(M, X)$ vérifie $P = d M^t P + X$, avec une précision $epsilon$.
Résultat\
Une estimation du vecteur de PageRank non-compensé associé à $(G, Z, d)$.\
début\
$B_e <- 0_(k times k)$\
pour chaque site $S$ de $cal(S)$ :#i\
  $A_S <- (A_(v,w))$, #no-emph[pour] $v$ et $w$ dans $S$\
  $(overline(A)_S)_(v,T) <- sum_(w <- v,\ w in T) A_(v,w)$, #no-emph[pour] $v in S$ et $T != S$\
  $Z_(S_i) <- "SpeedRank"(A_S, (1-d) Z_S)$\
  $Z_(S_e) <- d overline(A)_S^t Z_(S_i)$\
  $B_S <- "SpeedRank"(A_S, D_S)$\
  $(B_e^t)_(*, S) <- overline(A)_S^t B_S$ #d\
  $Z_e <- sum_(S in cal(S)) Z_(S_e)$\
  $P_(e e) <- "SpeedRank"(B_e, Z_e)$\
  pour chaque site $S$ de $cal(S)$ :#i\
  $P_S <- P_(e e)(S) B_S + Z_(S_i)$#d\
  retourner $(P_S)_(S in cal(S))$
] <alg:blowrank>

On obtient ainsi un algorithme qui ne nécessite que $2 dot k$ appels locaux à $"SpeedRank"$, plus un appel global sur une matrice $k times k$, ce qui le place en terme de performances au même niveau que BlockRank, alors que les approximations faites sont moindres, ce qui permet d'obtenir un PageRank moins perturbé par rapport au modèle global.
