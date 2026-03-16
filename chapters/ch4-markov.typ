// =============================================================================
// Chapitre 4 : Les chaînes de Markov
// =============================================================================

#import "../templates/environments.typ": *
#import "../templates/math-macros.typ": *
#import "../templates/acronyms.typ": *

= Les chaînes de Markov <pr-markov>

#citation([#smallcaps[Mr. Monopoly] Strategy Wizard])[Always buy an unowned property if it is an orange property (always block this group if you can).]

#v(1cm)

#lettrine("Avant")[ d'attaquer l'objet central de cette partie, à savoir le(s) PageRank(s), il nous semble nécessaire de faire un rappel théorique des techniques que nous allons utiliser tout au long des pages à venir.
]

Andreï Markov (1856-1922), mathématicien russe, est connu pour avoir défini et étudié les processus stochastiques discrets sans mémoire, également connu sous le nom de _chaînes de Markov_. Cet outil du début du siècle dernier est fondamental pour comprendre l'idée du PageRank, c'est pourquoi nous allons brièvement rappeler les résultats essentiels#footnote[Pour une information plus complète sur l'œuvre de Markov, on pourra se reporter à @sheynin88markov @Saloff96.].

== Définitions

On appelle _processus aléatoire, ou stochastique, discret_ un ensemble de variables aléatoires $X_k$, avec $k in NN$. $X_k$ peut par exemple représenter la position sur le plateau de jeu d'un joueur de Monopoly à l'instant $k$.

Les chaînes de Markov discrètes sont des cas particuliers de processus stochastique discret à valeur discrète dont le futur ne dépend que du présent (pas du passé) : les états précédant l'état présent ne jouent aucun rôle. Si on appelle $V$ l'ensemble des valeurs (ou états) que peuvent prendre les variable $X_k$, la caractérisation mathématique d'une chaîne de Markov est l'égalité, pour tout $j in V$,

$ forall k in NN, P(X_k = j | X_l = i_l, l in [| 0, k-1 |]) = P(X_k = j | X_(k-1) = i_(k-1)) $

En d'autres termes, la probabilité d'être dans l'état $j$ à l'instant $k$ ne dépend que de la valeur prise à l'instant $k-1$, et pas des valeurs antérieures. _A priori_, cette probabilité peut ne pas être la même selon l'instant $k$ considéré. La chaîne de Markov peut donc se définir par les probabilités de transition entre deux états à un instant $k$ :

$ p^k_(i,j) = P(X_k = j | X_(k-1) = i) $

Dans tout ce mémoire, nous nous restreindrons au cas où les probabilités de transitions ne dépendent pas de l'instant $k$ considéré. _La chaîne de Markov correspondante est alors dite homogène._

Si $V$ est fini (nous prendrons alors $V = [| 1,n |]$), il est commode de considérer la matrice des transitions $A = (p_(i,j))_(1 <= i,j <= n)$. $A$ est une matrice stochastique par ses lignes, c'est-à-dire que $forall i in V, sum_(j=1)^n A_(i,j) = 1$. Ceci est dû au fait que le processus est complètement fermé, et que si l'on est dans l'état $i$ à l'instant $k-1$, alors on sera dans $V$ à l'instant $k$.

La matrice de transition $A$ permet d'obtenir l'évolution de notre processus. En effet, si on appelle $x^k$ le vecteur représentant la distribution des états à l'instant $k$ ($x^k_j = P(X_k = j)$), alors la proposition suivante donne $x^k$ en fonction de $x^0$ et de $A$.

#proposition[
  $x^k = (A^t)^k x^0$, où $""^t$ est l'opérateur de transposition.#footnote[Dans tout ce mémoire, nous allons user et abuser de l'opérateur de transposition. Pourquoi ne pas travailler directement sur la matrice $P^t$ et ainsi ne pas faire intervenir $""^t$ ? D'une part parce qu'il est plus confortable de considérer qu'un coefficient $a_(i,j)$ représente l'action de $i$ sur $j$ que celle de $j$ sur $i$. D'autre part parce que mes restes de classes préparatoires font que je préfère travailler sur les vecteurs colonne plutôt que sur les vecteurs ligne. Enfin parce que c'est généralement la notation d'usage dans la littérature existante.]
] <eq:markov1>

#Preuve[
  Il suffit de montrer que, pour un $k >= 1$ quelconque, on a $x^k = A^t x^(k-1)$ ; @eq:markov1 n'est alors que l'application d'une récurrence immédiate. Le résultat voulu vient du fait que :

  $ (A^t x^(k-1))_j &= sum_(i=1)^n p_(i,j) x^(k-1)_i = sum_(i=1)^n P(X^k = j | X^(k-1) = i) P(X^(k-1) = i) \
  &= sum_(i=1)^n P(X^k = j, X^(k-1) = i) = P(X^k = j) = x^k_j $
]

== Côté graphe, côté matrice

Nous venons de voir que les matrices stochastiques sont un moyen à la fois élégant et compact de rendre compte de l'évolution d'une chaîne de Markov, mais ce n'est pas le seul. La représentation en terme de graphe orienté pondéré est également très utile, et il est confortable de pouvoir passer de l'une à l'autre suivant les besoins.

À toute matrice $M = (m_(i,j))_(1 <= i,j <= n)$ de taille $n$, il est possible d'associer un graphe $G(M)$ orienté pondéré à $n$ sommets, dont les arêtes sont l'ensemble des couples $(i,j)$ tels que $m_(i,j) != 0$, pondérées chacune par leur coefficient $m_(i,j)$ associé.

Réciproquement, à tout graphe orienté pondéré peut correspondre la matrice $M$ définie par :

$ m_(i,j) = cases(
  "le poids de l'arête" (i,j) "si elle existe",
  0 "sinon"
) $

Dans le cas d'un graphe dont les arêtes sont non pondérées, en les considérant comme implicitement de poids $1$, on retrouve la matrice d'adjacence.

Parfois, le passage de la vision matricielle à la représentation sous forme de graphe se limite à une simple réécriture : ainsi, si la caractérisation d'une matrice stochastique#footnote[Lorsque cela n'est pas précisé, nous entendons par matrice stochastique une matrice stochastique par ses lignes, c'est-à-dire une matrice positive telle que la somme de chacune de ses lignes soit égale à $1$.] $M = (m_(i,j))_(1 <= i,j <= n)$ est

$ forall i in [| 1,n |], sum_(j=1)^n m_(i,j) = 1 $

celle d'un graphe $G = (V,E)$ représentant une chaîne de Markov homogène est

$ forall v in V, sum_(w <- v) e_(v,w) = 1 $

Il arrive cependant que les deux approches correspondent vraiment à deux visions subtilement différentes d'un même problème. Ainsi, dire qu'une matrice positive $M$ est irréductible revient à dire que

$ forall (i,j) in [| 1,n |]^2, exists k in NN, (M^k)_(i,j) > 0 $

Au niveau du graphe $G$ correspondant, cela revient à dire que pour tout couple de sommets $(i,j)$, il existe un chemin (de longueur $k$) reliant $i$ à $j$. En d'autres termes, le caractère irréductible de la matrice se traduit par la forte connexité du graphe.

Enfin, signalons qu'une chaîne de Markov est dite _ergodique_ si la matrice correspondante est irréductible et apériodique.

== Évolution d'une chaîne de Markov homogène <sec:markov-evolution>

Afin d'étudier l'évolution à long terme d'une chaîne de Markov, on peut se demander s'il est possible d'avoir des propriétés de convergence. Or, ceci est acquis grâce au théorème suivant.

#Thm[
  Soit $A$ une matrice stochastique.

  + Le rayon spectral de $A$ est $1$, et c'est une valeur propre.
  + Si $A$ est irréductible, alors il existe un unique vecteur de probabilité $P$ vecteur propre de $A^t$ pour la valeur propre $1$, et $P$ est strictement positif, c'est-à-dire que toutes ses composantes sont strictement positives.
  + Si $A$ est irréductible et apériodique, alors toutes les valeurs propres autres que $1$ sont de module strictement inférieur à $1$.
] <thm:stoch>

#Preuve[
  + $1$ est valeur propre, associée au vecteur propre $vec(1, dots.v, 1)$.

    De plus, si l'on considère un vecteur $x = (x_i)_(1 <= i <= n)$ quelconque, nous avons toujours

    $ norm(A x)_infinity <= norm(A abs(x))_infinity <= norm(x)_infinity $

    avec la convention $abs(x) = (abs(x_i))_(1 <= i <= n)$.

    Ceci implique que toute valeur propre de $A$ est inférieure à $1$.

  + Si $A$ est irréductible, alors on entre dans le cadre du théorème de Perron-Frobenius (voir #fref(<perron>)), qui assure qu'il existe, à homothétie près, un unique vecteur propre#footnote[En fait, il y a deux vecteurs propres, un droit et un gauche, le gauche de $A$ étant le droit de $A^t$ et vice versa.] de $A^t$ pour la valeur propre $1$. Ce vecteur étant strictement positif, on peut après normalisation le considérer comme un vecteur de probabilité.

  + D'après le théorème de Perron-Frobenius, si $lambda$ est une valeur propre de $A$ vérifiant $abs(lambda) = 1$, alors $lambda$ est une racine $d$-ième de l'unité, où $d$ est la cyclicité de $A$. Si $A$ est apériodique, on a alors forcément $lambda = 1$. Toutes les valeurs propres de $A$ autres que $1$ ont donc une norme strictement inférieure à 1.
]

D'après @thm:stoch, il est maintenant possible de connaître le comportement asymptotique d'une chaîne de Markov homogène.

#Thm[
  Soit $A$ une matrice stochastique irréductible apériodique de taille $n$ représentant une chaîne de Markov homogène. Si on appelle $P$ le vecteur de probabilité propre droit de $A^t$ pour la valeur $1$ (son existence ainsi que son unicité sont garanties par le théorème de Perron-Frobenius), alors

  $ (A^t)^k arrow.long_(k -> infinity) P dot un_n $

  où $un_n$ est le vecteur ligne de taille $n$ ne comportant que des $1$.
]

#Preuve[
  Il s'agit d'une simple application de la méthode de la puissance, ou méthode de Jacobi. En effet, comme $1$ est valeur propre de dimension $1$, on peut décomposer $A^t$ sur l'espace propre engendré par $P$ d'une part et sur l'espace associé aux autres valeurs propres d'autre part (qui n'est pas forcément un espace propre). Ainsi, il existe une matrice de passage $T$ inversible telle que

  $ A^t = T dot mat(
    1, 0, dots, 0;
    0, "", "", "";
    dots.v, "", Q, "";
    0, "", "", ""
  ) T^(-1) $

  où $Q$ est une matrice de rayon spectral strictement inférieur à 1 (les valeurs propres de $Q$ sont celles de $A$ sauf $1$). Le rayon spectral de $Q$ implique que $Q^k$ converge de manière géométrique vers $0$. $(A^t)^k$ converge donc de manière géométrique vers :

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

  Cette matrice, que nous appellerons $A^t_infinity$, est de fait une projection, puisque $(A^t_infinity)^2 = A^t_infinity$. L'espace de projection est de dimension $1$, car la matrice est de rang $1$. Comme par passage à la limite, on a $A^t_infinity P = P$, la droite de projection est celle engendrée par $P$. $A^t_infinity$ est également une matrice stochastique (car limite de matrices stochastiques). En particulier, si $e_i$ est le vecteur de probabilité sûre en $i$, défini par $(e_i)_k = delta^k_i$, alors

  $ A^t_infinity e_i = vec((A^t_infinity)_(1,i), dots.v, (A^t_infinity)_(n,i)) = P $

  d'où $A^t_infinity = P dot un$.
]

Le comportement asymptotique de la chaîne de Markov homogène associée est alors donné par le @cor:markov-iter :

#corollaire[
  Soit $P_0$ une distribution initiale de probabilité quelconque.
  La distribution des états à l'instant $k$ $P_k = (A^t)^k P_0$ converge, quand $k$ tend vers l'infini, vers $P$.
] <cor:markov-iter>

#Preuve[
  Pour toute distribution de probabilité $P_0$, on a $(A^t)^k P_0 arrow.long_(k -> infinity) (A^t_infinity) P_0 = P dot un dot P_0 = P$.
]

Pour le lecteur désireux de se familiariser avec les applications de l'étude asymptotique des chaînes de Markov, la section suivante est consacrée à une petite analyse des probabilités dans le jeu de Monopoly (marque déposée).

== Intermezzo : Le Monopoly\u{2122} selon Markov <sec:monopoly>

Sources : @stewart96monopoly @monopoly @gaucher96monopoly

#figure(
  grid(
    columns: (6cm, 1fr),
    gutter: 1em,
    [#image("../figures/plateau.gif", width: 5cm)],
    align(left)[À peu près tout le monde connaît le jeu du Monopoly (marque déposée), jeu de plateau qui consiste à acquérir des propriétés, constituer des monopoles appelés lotissements (ensembles de propriétés de la même couleur), construire des maisons, puis des hôtels, et ultimement ruiner tous ses adversaires.

    Il y a une certaine stratégie au Monopoly. Comme dans la vraie vie financière, tout est question de négociations, de prise de risque et de retour sur investissement. Quel est le rôle des chaînes de Markov dans le Monopoly ? Une des sources de revenus (et de ruine !), la principale en fin de jeu, est l'obligation à chaque tour de payer un loyer au possesseur (s'il existe) de la propriété où son pion s'arrête.],
  ),
  caption: [Plateau de Monopoly (marque déposée)],
) <fig:monopoly-plateau>

#figure(
  table(
    columns: 6,
    stroke: 0.5pt,
    inset: 0.4em,
    align: (right, left, left, right, left, left),
    [*N°*], [*Nom*], [*Groupe*], [*N°*], [*Nom*], [*Groupe*],
    [0], [Case Départ], [], [21], [Matignon], [rouge],
    [1], [Belleville], [brun], [22], [Carte Chance], [],
    [2], [Caisse de Communauté], [], [23], [Malesherbes], [rouge],
    [3], [Lecourbe], [brun], [24], [Henri-Martin], [rouge],
    [4], [Impôts], [], [25], [Gare du Nord], [],
    [5], [Gare Montparnasse], [], [26], [Saint-Honoré], [jaune],
    [6], [Vaugirard], [bleu clair], [27], [Bourse], [jaune],
    [7], [Carte Chance], [], [28], [Cie des Eaux], [],
    [8], [Courcelles], [bleu clair], [29], [La Fayette], [jaune],
    [9], [République], [bleu clair], [30], [Allez en Prison], [],
    [10], [Simple visite], [], [31], [Breteuil], [vert],
    [11], [La Villette], [violet], [32], [Foch], [vert],
    [12], [Cie Électricité], [], [33], [Caisse de Communauté], [],
    [13], [Neuilly], [violet], [34], [Capucines], [vert],
    [14], [Paradis], [violet], [35], [Gare Saint-Lazare], [],
    [15], [Gare de Lyon], [], [36], [Carte Chance], [],
    [16], [Mozart], [orange], [37], [Champs-Élysées], [bleu foncé],
    [17], [Caisse de Communauté], [], [38], [Taxe de Luxe], [],
    [18], [Saint-Michel], [orange], [39], [La Paix], [bleu foncé],
    [19], [Pigalle], [orange], [40], [Prison], [],
    [20], [Parc Gratuit], [], [], [], [],
  ),
  caption: [Listes des cases du Monopoly (marque déposée)],
) <tab:ListesDesCasesDuMonopoly>

Une question à se poser est : quelles sont les chances de tomber sur une case donnée ? Si certaines cases sont plus probables que d'autres, on comprend bien qu'elles auront un intérêt stratégique accru. On peut voir l'évolution de la position d'un joueur au fil des lancers de dés comme une chaîne de Markov. Ian Stewart @stewart96monopoly associe à chaque état-case 11 transitions possibles correspondant aux résultats possibles d'un lancer de dés, de 2 à 12. La probabilité de chaque transition est celle d'obtenir le résultat avec deux dés. Ian Stewart conclut que la matrice stochastique représentant la chaîne de Markov est circulante, et que la distribution de probabilité asymptotique est la distribution uniforme. En fait, si on regarde de plus près les règles, on s'aperçoit que tous les états ne sont pas équivalents, et que la distribution de probabilité limite n'est pas forcément équiprobable.

=== Bref rappel des règles et notations

Par convention, on considérera qu'il y a 41 cases : cela va de la case _Départ_ (numéro 0) à la case _Rue de la Paix_ (numéro 39), la case _Prison_ ayant le numéro 40, la case _Simple Visite_ ayant le numéro 10. Le tableau @tab:ListesDesCasesDuMonopoly récapitule les différentes cases, avec le nom et la couleur de lotissement éventuelle.

Une partie commence sur la case _Départ_. À chaque tour, le joueur lance deux dés. Au bout de trois doubles consécutifs, le joueur va en prison. S'il tombe sur une case _Chance_ ou bien _Caisse de Communauté_, il tire une carte dans la pile correspondante, et ce tirage est éventuellement suivi d'un effet immédiat au niveau de la position. Quand on est en prison, on peut en sortir gratuitement en faisant un double dans les trois tours qui suivent celui de l'emprisonnement, sinon on doit payer pour sortir. On peut sortir avant la fin des trois tours en payant.

Voici la liste détaillée des cartes _Chance_ : 1 envoie en prison, 1 envoie vers l'avenue Henri-Martin, 1 envoie vers boulevard de la Villette, 1 envoie vers la rue de la Paix, 1 envoie vers la gare de Lyon, 1 envoie sur la case Départ, 1 _Reculez de trois cases_. Il y a 9 autres cartes _Chance_ qui n'ont aucune influence sur la position.

Voici maintenant la liste détaillée des cartes _Caisse de Communauté_ : 1 _Retournez à Belleville_, 1 envoie en prison, 1 envoie sur la case Départ, 1 possibilité de tirer une carte _Chance_ (alternative avec une amende). Il y a 12 autres cartes _Caisse de Communauté_ qui n'ont aucune influence sur la position.

=== Matrice des transitions

À cause des règles, tous les états n'ont pas les même transitions : ainsi, toute transition vers la case 30 (_Allez en Prison_) doit en fait être remplacée par une transition vers la case 40 (_Prison_). De même, il faut considérer pour toute transition vers les cases _Chance_ ou _Caisse de Communauté_, les éventuelles redirections. Il y a aussi le problème des doubles : le processus stochastique utilise une mémoire (nombre de tours en prison ou nombre de doubles consécutifs déjà faits) et n'est donc pas un vrai processus de Markov. Mais comme la mémoire est finie (3 lancers), on peut se ramener à un processus sans mémoire en considérant un espace à 123 états#footnote[Une solution alternative, proposée par @monopoly, consiste à estimer pour chaque case la probabilité d'y être arrivé par 2 doubles consécutifs.] : 120 états du type $(i,j)_(i in [0, 40], j in [0, 2])$ représentant _être sur la case $i$ en ayant déjà fait $j$ doubles consécutifs_, et 3 états _prison_ représentant les trois tours que l'on peut passer en prison. Il faut d'ailleurs noter que si l'on paie, comme on a souvent intérêt à le faire en début de partie, on ne passe qu'un tour en prison, et les transitions sont donc modifiées. Il faut donc considérer les transitions pour une stratégie _prison_ et celle pour une stratégie _liberté_#footnote[D'autres facteurs peuvent également altérer les probabilités de transitions :
- La carte _Tirez une Carte Chance ou Payez une Amende de..._, qui propose deux stratégies.
- Les cartes _Sortez de prison_, qui, si elles sont conservées par les joueurs, augmentent légèrement les probabilités de tirer une carte de déplacement.
L'effet de ces variations étant relativement faible, nous nous permettons de ne pas les prendre en compte ici.].

#figure(
  image("../figures/monopoly-matrice.pdf", width: 100%),
  caption: [Matrice $123 times 123$ des transitions au Monopoly. Matrice des transitions (stratégie _prison_) dans l'espace _(case, nombre de doubles) + (prison, nombre de tours)_],
) <monopoly-matrice>

On arrive ainsi à écrire, pour chacune des 2 stratégies considérées, une matrice stochastique décrivant la stratégie en question. La @monopoly-matrice représente ainsi de manière graphique la matrice correspondant à la stratégie _prison_.

=== Probabilités asymptotiques et conclusion

#figure(
  image("../figures/monopoly-prob.pdf", width: 100%),
  caption: [Probabilités asymptotiques du jeu de Monopoly (marque déposée)],
) <fig:monopoly-prob>

Une fois la matrice des transitions $A$ calculée, grâce au corollaire @cor:markov-iter, on sait qu'il suffit d'itérer $P_n = A^t P_(n-1)$ ($P_0$ étant par exemple la distribution équiprobable) pour avoir une convergence vers la distribution asymptotique. Il n'y a alors plus qu'à revenir dans l'espace à $40+1$ cases pour avoir des résultats exploitables, lesquels sont représentés @fig:monopoly-prob. Pour compléter cette étude, il faudrait maintenant prendre en compte les prix de vente et les loyers pour avoir un temps moyen de retour sur investissement, sans oublier de considérer le pouvoir d'achat, mais cela n'est plus du ressort des matrices de Markov#footnote[Pour avoir une idée des résultats que l'on obtient, voir @monopoly. Attention, les résultats correspondent au jeu de monopoly international, qui comporte des cartes différentes de la version française.]. Contentons-nous pour conclure de ces quelques remarques :

- La case _Allez en prison_ a une probabilité nulle, puisqu'on n'y reste pas.
- De même, les cases _Chance_ et _Caisse de Communauté_ ont une probabilité assez faible, à cause des cartes de déplacement immédiat.
- Les deuxième et troisième quarts du plateau ont globalement des probabilités plus grandes, à cause de la sortie de prison. Cela confère un intérêt certains aux propriétés qui s'y trouvent (les groupes orange et rouge en particulier).
- Paradoxalement, on a plus de chance d'atterrir sur la _Compagnie d'Électricité_ en choisissant de rester en prison. Pourquoi ce résultat contre-intuitif ? Avec la stratégie _liberté_, la probabilité de tomber dessus en sortant de prison est de $1\/36$. Avec la stratégie _prison_, cette probabilité devient $1\/36 + 5/6 dot 1\/36 + 25/36 dot 1\/36$...

== Matrices (sous-)stochastiques : cas général

Au cours des chapitres suivants, nous aurons parfois affaire à des matrices présentant une périodicité, ou qui sont non irréductibles, ou encore sous-stochastiques#footnote[Dans ce cas, on ne peut _a priori_ plus parler de chaîne de Markov associée.], les _ou_ n'étant pas forcément exclusifs. Nous nous proposons donc d'étudier la viabilité du @cor:markov-iter sous ces différentes hypothèses.

=== Matrices non irréductibles

Intéressons-nous tout d'abord au cas où $A = (a_(i,j))_(1 <= i,j <= n)$ est stochastique, mais non irréductible. Cela veut dire que le graphe correspondant $G = (V,E)$ n'est pas fortement connexe. Considérons alors la décomposition en composantes fortement connexes de $G$ : $G = ((C_1, ..., C_k), E)$. Chaque composante $C_c$ a exactement une des deux propriétés suivantes :

#figure(
  image("../figures/markov-transit-cfc.pdf", width: 50%),
  caption: [Exemple de graphe non fortement connexe],
) <fig:markov-transit-cfc>

- Soit $exists i in C_c, j in.not C_c, a_(i,j) > 0$. La composante et ses états sont alors dits transitoires.
- Soit $forall i in C_c, j in.not C_c, a_(i,j) = 0$. La composante et ses états sont alors dits récurrents.

Si l'on quotiente $G$ selon ses composantes fortement connexes, le graphe réduit donne un ordre partiel sur les composantes (car il n'y a pas de circuit) dont les composantes récurrentes sont les maxima.

Par exemple, dans le graphe de la @fig:markov-transit-cfc, il y a quatre composantes fortement connexes, $C_1$, $C_2$, $C_3$ et $C_4$. $C_1$ et $C_3$ sont transitoires, alors que $C_2$ et $C_4$ sont récurrentes.

Nous allons maintenant réordonner les états $V$ comme suit : d'abord les $k_t$ états transitoires (toutes composantes confondues), puis les $k_1$ états d'une première composante fortement connexe récurrente, ..., jusqu'au $k_d$ états de la dernière composante fortement connexe récurrente. Dans ce réarrangement des états, la matrice stochastique associée (que nous continuerons d'appeler $A$) s'écrit maintenant :

$ A = mat(
  T, E;
  0, mat(R_1, 0, dots, 0; 0, dots.down, dots.down, dots.v; dots.v, dots.down, dots.down, 0; 0, dots, 0, R_d)
) $

où $T$ est une matrice sous-stochastique, non stochastique, de taille $k_t$, $E$ une matrice positive non nulle de taille $k_t times sum_(i=1)^d k_i$, et les $R_i$ des matrices stochastiques irréductibles de taille $k_i$.

#Thm[
  Soit $A$ une matrice stochastique réduite selon ses composantes fortement connexes transitoires et récurrentes. $A$ est de la forme

  $ A = mat(T, E; 0, R) $

  où $T$ est une matrice sous-stochastique, non stochastique, de taille $k_t$, $E$ une matrice positive non nulle de taille $k_t times sum_(i=1)^d k_i$, et

  $ R = mat(R_1, 0, dots, 0; 0, dots.down, dots.down, dots.v; dots.v, dots.down, dots.down, 0; 0, dots, 0, R_d) $

  les $R_i$ étant des matrices stochastiques irréductibles de taille $k_i$.

  Si toutes les matrices $R_i$ sont apériodiques, alors les puissances itérées de $A$ convergent. Plus précisément, on a :

  $ A^k arrow.long_(k -> infinity) mat(0, F; 0, R_infinity) $

  avec

  $ R_infinity = mat(R_(1 infinity), 0, dots, 0; 0, dots.down, dots.down, dots.v; dots.v, dots.down, dots.down, 0; 0, dots, 0, R_(d infinity)) $

  $ R_(i infinity) = lim_(k -> infinity) R_i^k = P_(i infinity) dot un_(k_i) $

  où $P_(i infinity)$ est le vecteur de probabilité de taille $k_i$ vérifiant $R_i^t P_(i infinity) = P_(i infinity)$, et

  $ F = (I d_(k_t) - T)^(-1) E R_infinity $
] <thm:reductible>

#corollaire[
  Pour toute distribution de probabilité $P_0$ sur $V$, $(A^t)^k P_0$ converge quand $k$ tend vers l'infini, et le vecteur limite est une distribution de probabilité appartenant à l'espace à $d$ dimensions engendré par le plongement canonique des $P_(i infinity)$ dans $V$.
]

#remarque[
  Quand tous les $R_i$ ne sont pas apériodiques, il n'y a pas _a priori_ de convergence. La technique que nous allons voir en @markov:patho:aperiodique permet quand même de s'assurer une convergence à moindre coût.
] <rem:periodique>

#Preuve[
  On constate tout d'abord que

  $ A^k = mat(T, E; 0, R)^k = mat(T^k, sum_(i=0)^k T^i E R^(k-i); 0, R^k) $

  #lemme[
    $ T^k arrow.long_(k -> infinity) 0 $ et la convergence est géométrique.
    De plus, $(I d_(k_t) - T)$ est inversible, et son inverse vaut $sum_(k=1)^infinity T^k$.
  ]

  En effet, étudions de plus près la structure de $T$. Nous allons réordonner les états par composantes fortement connexes, en commençant par celles qui, dans le graphe quotient $G\/C$, n'ont pas d'arête entrante (composantes ultra-transitives), et en triant par éloignement selon la distance aux composantes ultra-transitives. La matrice $T$ est alors de la forme :

  $ T = mat(T_1, G_(1,2), dots, G_(1,l); 0, dots.down, G_(i,j), dots.v; dots.v, dots.down, dots.down, G_(l-1,l); 0, dots, 0, T_l) $

  où les $T_i$ sont des matrices irréductibles sous-stochastiques, non stochastiques (par convention, la matrice unidimensionnelle $0$ est considérée comme irréductible). D'après @markov:patho:sous, chaque matrice $T_i$ de la diagonale principale a un rayon spectral $rho(T_i)$ strictement inférieur à $1$. Comme la structure de $T$ est triangulaire, le rayon spectral de $T$ est $rho(T) = max_(1 <= i <= l) rho(T_i) < 1$. Ceci assure que $T^k$ converge géométriquement vers $0$.

  Comme $1$ n'est pas valeur propre de $T$, $(I d_(k_t) - T)$ est inversible. Or, pour tout $k$, on a :

  $ (I d_(k_t) - T) sum_(j=0)^k T^j = I d_(k_t) - T^(k+1) $

  d'où

  $ sum_(j=0)^k T^j = (I d_(k_t) - T)^(-1) (I d_(k_t) - T^(k+1)) $

  On en déduit que

  $ lim_(k -> infinity) sum_(j=0)^k T^j = (I d_(k_t) - T)^(-1) $

  ce qui achève la démonstration du lemme.

  Revenons à notre démonstration. Il est maintenant acquis que $T^k arrow.long_(k -> infinity) 0$. Avec l'hypothèse d'apériodicité des $R_i$, nous avons aussi $R^k arrow.long_(k -> infinity) R_infinity$.

  Il nous reste à prouver que

  $ sum_(i=0)^k T^i E R^(k-i) arrow.long_(k -> infinity) (I d_(k_t) - T)^(-1) E R_infinity $

  Or, on a

  $ sum_(i=0)^k T^i E R^(k-i) = sum_(i=0)^k T^i E R_infinity + sum_(i=0)^k T^i E (R^(k-i) - R_infinity) $

  Le premier terme converge vers $(I d_(k_t) - T)^(-1) E R_infinity$. Quant au deuxième, on a :

  $ abs(sum_(i=0)^k T^i E (R^(k-i) - R_infinity)) <= abs(sum_(i=0)^(floor(k\/2)) T^i E (R^(k-i) - R_infinity)) + abs(sum_(i=floor(k\/2)+1)^k T^i E (R^(k-i) - R_infinity)) $

  Le premier des deux termes de droite tend vers $0$ à cause de la convergence géométrique de $R^k$ vers $R_infinity$, le deuxième à cause de la convergence (également géométrique) de $sum_(i=0)^k T^k$. Ceci assure la convergence vers $0$ du terme de gauche. C.Q.F.D.
]

=== Matrices périodiques <markov:patho:aperiodique>

Si une matrice stochastique $A$ est périodique, il n'y a _a priori_ pas de convergence. On peut par exemple penser à la matrice circulante

$ C = (c_(i,j))_(1 <= i,j <= n) quad "avec" c_(i,j) = cases(1 "si" j equiv (i+1) [n], 0 "sinon") $

Les différentes itérations de $C$ décrivent une orbite de taille $n$ correspondant aux racines $n$-ièmes de l'unité, et il n'y a en particulier pas convergence au sens classique, bien qu'il existe une convergence au sens de Césaro ($1/k sum_(i=0)^k C^i$ converge).

La convergence au sens de Césaro pourrait nous permettre de retrouver la direction propre associée à la valeur propre positive maximale, mais ce n'est pas nécessaire : comme le montre le @thm:periodique, il est possible de se ramener à une convergence «classique».

#Thm[
  Soit $A$ une matrice stochastique irréductible de taille $n$, éventuellement périodique. Soit $P$ l'unique vecteur de probabilité tel que $A^t P = P$. Pour tout $alpha in ]0,1[$, on a

  $ (alpha A^t + (1-alpha) I d)^k arrow.long_(k -> infinity) P dot un_n $
] <thm:periodique>

#corollaire[
  Soit $P_0$ un vecteur de probabilité quelconque. Si on pose $B = (alpha A + (1-alpha) I d)$, alors

  $ (B^t)^k P_0 arrow.long_(k -> infinity) P $
]

#Preuve[
  La matrice $B$ définie par $B = (alpha A + (1-alpha) I d)$ est stochastique, irréductible, et apériodique, à cause de la présence de circuits de longueur $1$. $(B^t)^k$ converge donc vers $Q dot un_n$, où $Q$ est l'unique distribution de probabilité vérifiant $B^t Q = Q$. Comme $B^t P = (alpha A^t + (1-alpha) I d) P = alpha P + (1-alpha) P = P$, on a $P = Q$.

  C.Q.F.D.
]

=== Matrices sous-stochastiques <markov:patho:sous>

Le cas des matrices strictement sous-stochastiques semble _a priori_ simple à résoudre :

#Thm[
  Soit $A$ une matrice sous-stochastique, non stochastique, irréductible de taille $n$. Alors les puissances itérées de cette matrice tendent vers $0$ :

  $ A^k arrow.long_(k -> infinity) 0 $
] <thm:sousstoch>

#Preuve[
  $A$ est inférieure et non égale à une matrice stochastique irréductible. D'après le (d) du théorème de Perron-Frobenius (voir #fref(<perron>)), son rayon spectral est strictement inférieur à $1$, ce qui assure le résultat, à savoir, si on appelle $rho$ le rayon spectral, une convergence dominée par une suite géométrique de raison $rho$.
]

#remarque[
  Une matrice sous-stochastique mais non stochastique correspond à une chaîne de Markov mal définie, dans le sens où toutes les transitions possibles n'ont pas été données. Par analogie avec les automates, on parlera de chaîne de Markov incomplète#footnote[En effet, tout comme avec les automates, il est possible de compléter notre chaîne de Markov en rajoutant un état _poubelle_ recevant le _défaut stochastique_ des autres états, et pointant sûrement vers lui-même.]. Dans ce cas, pour toute distribution $P_0$ de probabilité, $(A^t)^k P_0 arrow.long_(k -> infinity) 0$, résultat peu satisfaisant en termes d'informations utiles. Ce problème est crucial dans le cadre des calculs de PageRank, et les solutions pour «compléter» une matrice sous-stochastique seront données plus en détails au @pr-pagerank.
]

#remarque[
  Le théorème @thm:sousstoch peut en fait s'appliquer à toute matrice sous-stochastique $A$ inférieure et non égale à une matrice stochastique irréductible. Nous appellerons de telles matrices des matrices sous-irréductibles.
] <rem:quasireduc>

Cependant, comme nous le verrons au @pr-pagerank, l'étude de la valeur propre maximale d'une matrice sous-irréductible ainsi que de l'espace propre associé est importante pour l'étude du PageRank, c'est pourquoi nous allons développer un peu.

==== Valeur propre maximale et espace propre associé d'une matrice positive <foot:sousfiltre>

#Thm[
  Soit $A$ une matrice positive#footnote[Bien que l'étude que nous allons faire nous intéresse avant tout du point de vue des matrices sous-irréductibles, elle est en effet valable pour toute matrice positive.].

  Soient $(C_1, ..., C_k)$ la décomposition en composantes fortement connexes du graphe $G$ associé à $A$.

  On définit le rayon spectral $rho(C_i)$ d'une composante $C_i$ comme étant le rayon spectral de $A_(C_i)$. On appellera composante pseudo-récurrente de $G$ toute composante $C_i$ vérifiant :
  - $rho(C_i)$ est maximal : $forall 1 <= j <= k$, $rho(C_j) <= rho(C_i)$.
  - les composantes accessibles à partir de $C_i$ ont un rayon spectral strictement inférieur : $forall C_j subset arrow.t.double C_i$#footnote[Pour $C subset V$, le filtre de $C$, noté $arrow.t.double C$, est l'ensemble des pages de $V$ accessibles à partir de $C$.], $rho(C_j) = rho(C_i) => C_j = C_i$.

  Alors :
  + Le rayon spectral de $A$ est égal au rayon spectral maximum des composantes fortement connexes de $G$.
  + Il existe une valeur propre maximale qui est positive (c'est la seule si les composantes pseudo-récurrentes sont apériodiques). La dimension de l'espace propre associé est alors égal au nombre $d$ de composantes pseudo-récurrentes.
  + Si $C_i$ est une composante pseudo-récurrente de $G$, il existe un vecteur propre positif de support $arrow.t.double C_i$ associé à la valeur propre maximale.
] <thm:sousfiltre>

#corollaire[
  S'il existe une seule composante pseudo-récurrente $C_p$, et si tous les sommets sont accessibles de cette composante ($arrow.t.double C_p = V$), alors les espaces propres associés aux valeurs propres maximales#footnote[Le pluriel est employé ici pour les éventuelles périodicités. En cas d'apériodicité, il n'y a bien sûr qu'une seule valeur propre maximale.] sont de dimension 1, et il existe un vecteur propre positif de support $V$ associée à la valeur propre maximale positive. On dira alors que $A$ est pseudo-irréductible.
]

#Preuve[
  La preuve est en fait très similaire à celle du @thm:reductible pour les matrices stochastiques non-irréductibles, même s'il n'est plus possible d'avoir un résultat de convergence des puissances de $A$. Grâce à l'ordre partiel induit par le graphe quotient des composantes fortement connexes, il est possible de rendre $A$ triangulaire par blocs selon les composantes fortement connexes : quitte à se placer dans la bonne permutation, on peut écrire

  $ A = mat(A_(C_1), T_(1 2), dots, T_(1 k); 0, dots.down, dots.down, dots.v; dots.v, dots.down, dots.down, T_((k-1) k); 0, dots, 0, A_(C_k)) $

  où les $T_(i j)$ sont les matrices de transition entre composantes $i$ et $j$.

  Cette décomposition triangulaire assure que le rayon spectral de $A$ est égal au rayon spectral maximum des différentes composantes $C_i$. En fait, en appliquant le théorème de Perron-Frobenius sur chacune des composantes fortement connexes, il apparaît qu'il existe une valeur propre $lambda > 0$ égale au rayon spectral, et que sa multiplicité est égale au nombre de composantes de rayon maximal.

  Si $C_i$ est pseudo-récurrente, alors la multiplicité de $lambda$ dans $A^t_(arrow.t C_i)$ est $1$. Il existe donc à homothétie près un unique vecteur propre $x$ associé à $lambda$ dans $A^t_(arrow.t C_i)$. Comme $arrow.t.double C_i$ est stable par $A^t$, le plongement de $x$ dans $V$ est un vecteur propre de $A^t$. Par construction, on a également $A^t_(C_i) x_(C_i) = lambda x_(C_i)$. D'après le théorème de Perron-Frobenius appliqué sur $A_(C_i)$, les composantes de $x_(C_i)$ sont strictement positives à homothétie près. De proche en proche, l'égalité $A^t_(arrow.t C_i) x = lambda x$ montre que $x$ est strictement positif.

  Pour chaque composante pseudo-récurrente de $G$, il existe donc un vecteur propre positif de support $arrow.t.double C_i$ associé à $lambda$.

  Il reste à montrer qu'il n'existe pas de vecteur propre associé à $lambda$ en dehors de l'espace engendré par les $d$ vecteurs propres associés aux composantes pseudo-récurrentes. Il suffit pour cela de constater que toute composante de rayon maximal non pseudo-récurrente $C_i$ génère une structure triangulaire dans l'espace associé à $lambda$ : s'il existe une composante pseudo-récurrente $C_j$ avec $C_j subset arrow.t.double C_i$, alors $A_(arrow.t C_i)$ contient (dans une base adaptée) un bloc de la forme $mat(lambda, mu; 0, lambda)$, avec $mu != 0$, ce qui montre qu'il n'est pas possible d'associer un vecteur propre de $lambda$ à $C_i$.

  C.Q.F.D.
]

=== Cas général : conclusion

Nous venons de voir qu'on peut s'arranger pour trouver un algorithme de convergence même si la matrice n'est ni apériodique, ni irréductible. Notons simplement que dans ce dernier cas, il n'y a pas unicité. En revanche, si la matrice est sous-stochastique, mais non stochastique, le vecteur asymptotique sera nul partout sauf sur d'éventuelles composantes fortement connexes récurrentes à l'intérieur desquelles la matrice est stochastique. La complétion canonique, qui consiste à rajouter un état «poubelle», n'est pas satisfaisante car elle ne change pas fondamentalement le résultat : l'état «poubelle» récupère les probabilités perdues au niveau des composantes sous-stochastiques, mais les valeurs sur les états autres que l'état _poubelle_ ne sont pas modifiées. Heureusement, les divers algorithmes de calcul de PageRank que nous allons étudier maintenant vont nous fournir d'autres méthodes de complétion pour trouver à coup sûr un vecteur ayant toutes les propriétés désirées, qui s'appellera vecteur de PageRank.
