// =============================================================================
// Chapitre 6 : BackRank
// =============================================================================

#import "../templates/prelude.typ": *

= BackRank <pr-back>

#citation([_Back to the Future_])[
 -- You've got to come back with me!\ 
 -- Where?\ 
 -- Back to the future.
]
#citation([Edgar #smallcaps[Morin], _Amour, poésie, sagesse_])[La vraie nouveauté naît toujours dans le retour aux sources.]

#v(1em)

#lettrine("Nous")[ venons de voir les principes théoriques généraux qui régissent les différents algorithmes de PageRank. En particulier, il est apparu que le problème de la complétion stochastique et celui de la diffusion du PageRank peuvent, voire doivent, être traités indépendamment. Dans ce chapitre, qui est le prolongement d'une série d'articles co-écrits avec Mohamed Bouklit @mathieu03effet @mathieu04effect, nous allons étudier une manière d'effectuer la complétion stochastique tout en perfectionnant le modèle du surfeur aléatoire : prendre en compte la possibilité qu'a l'utilisateur de pouvoir à tout instant de sa navigation revenir en arrière grâce à la touche _Back_ de son navigateur#footnote[Je présente par avance mes plus plates excuses aux défenseurs de la langue française, mais j'avoue préférer l'anglicisme _Back_ à _page précédente_.]. Comme nous allons le voir, l'algorithme de PageRank qui résulte de cette modélisation présente de nombreux avantages par rapport aux PageRanks classiques.
]

== De l'importance de la touche _Back_

En 1995, Catledge et Pitkow publient une étude dans laquelle il apparaît que la touche _Back_ représente $41%$ de l'ensemble des actions de navigation recueillies ($52%$ des actions étant l'usage d'hyperliens) @catledge95characterizing. Une autre étude, par Tauscher et Greenberg, datant de 1997, rend compte de $50%$ d'hyperliens et de $30%$ de _Back_ @tauscher97people. Citons enfin une étude plus récente (2004) de Milic _et al._ @milic04smartback, dont les principaux résultats sont portés dans le @tab:back-stats.

#figure(
  table(
    columns: 4,
    stroke: 0.5pt,
    inset: 0.5em,
    align: (left, right, left, right),
    [*Mode de navigation*], [*%*], [*Mode de navigation*], [*%*],
    [Hyperliens], [$42,5%$], [_Bookmarks_], [$2,9%$],
    [Touche _Back_], [$22,7%$], [#acr("URL") écrite à la main], [$1,6%$],
    [Nouvelle session], [$11,2%$], [Page de démarrage], [$1,1%$],
    [Autres méthodes#footnote[Chargements dynamiques, redirections automatiques, complétion automatique d'adresse...]], [$10,7%$], [Touche _Actualiser_], [$0,5%$],
    [Formulaires], [$6,6%$], [Touche _Forward_], [$0,2%$],
  ),
  caption: [Étude statistique des modes de navigation des surfeurs réels (d'après @milic04smartback)],
) <tab:back-stats>

De toutes ces études, il semble émerger un certain recul de l'emploi de la touche _Back_ entre 1995 et 2004, mais selon @cockburn01empirical, il faut tenir compte des évolutions survenues pendant cet intervalle#footnote[À l'échelle du Web, si $9$ millions de pages représentent une brindille, $9$ années représentent une éternité. Dans cet intervalle, l'ergonomie des navigateurs a évolué (_Bookmarks_, complétion automatique des URLs, consultation de l'historique...), de même que le comportement des internautes a été modifié par l'omni-présence des moteurs de recherche. Ainsi, plutôt que de revenir en arrière, certains préfèrent relancer dans leur moteur de recherche la requête qui a permis d'accéder à la page d'où ils viennent.], ainsi que de changements dans les protocoles expérimentaux utilisés.

L'autre information intéressante que nous donnent ces chiffres est le fait que dans tous les cas, on constate que l'emploi de la touche _Back_ arrive très largement en deuxième position, derrière l'utilisation des hyperliens qui reste le mode de navigation privilégié. Il faut en particulier retenir que selon toutes les études, pour $2$ clics sur un hyperlien, il y a au moins $1$ utilisation de la touche _Back_. Pourtant, l'utilisation de la touche _Back_ n'a pas d'équivalent dans les PageRank(s) « classiques », alors que des modes de navigation quantitativement moins importants comme les URLs tapées à la main et les _Bookmarks_ peuvent être pris en compte dans les algorithmes de calcul à travers le vecteur de _zap_.

Même si l'on ne sait pas vraiment à ce jour si un modèle plus proche du surfeur réel donne forcément un meilleur PageRank, l'importance de la touche _Back_ dans le comportement des internautes réels nous est apparu comme une motivation suffisante pour étudier les possibilités de l'incorporer dans un nouveau modèle de PageRank.

== Travaux antérieurs et contemporains

Kleinberg, dans l'algorithme HITS @kleinberg98, utilise aussi la matrice des liens entrants, et travaille donc sur un modèle où remonter les hyperliens est implicitement pris en compte. Néanmoins, le but de l'algorithme HITS n'est pas de modéliser la touche _Back_ mais de voir le graphe du Web comme une superposition de « hubs » et d'« autorités », les premiers pointant vers les secondes.

D'un autre côté, Fagin _et al._, dans @fagin00random proposent une étude très complète de l'influence de l'introduction de retours arrières dans une marche aléatoire, et proposent une modélisation stochastique du surfeur aléatoire tenant compte de la touche _Back_. Dans ce modèle une chaîne de Markov initiale _classique_ est considérée, à laquelle on adjoint un historique de capacité infinie des pages visitées. À chaque page $v$ est associée une probabilité $alpha(i)$ de revenir en arrière, à condition que l'historique soit non vide. Les principaux résultats obtenus sont :
- Suivant les probabilités de retour arrière, le processus peut être transitoire (asymptotiquement, la page de départ est « oubliée » et fini par ne plus influer sur la distribution de probabilité) ou ergodique (les retours arrières ramènent le surfeur infiniment souvent sur la page de départ), avec une transition de phase entre les deux.
- Dans le cas particulier où la probabilité de retour $alpha$ ne dépend pas de la page, si $alpha < 0,5$, le processus converge vers la même distribution que la chaîne de Markov _classique_ (sans retour possible).
- Les autres cas sont caractérisés, différents types de convergence sont considérés, et les valeurs limites (si elles existent) sont données.

Le principal inconvénient du modèle de Fagin _et al._ est le coût prohibitif#footnote[Avec les graphes du Web, tout algorithme dont la complexité est supérieure à $n$, ou à la rigueur $n log n$, est considéré comme prohibitif.] du calcul des distributions asymptotiques.

Dans @sydow04random, Sydow propose de réduire la complexité en limitant la taille de l'historique. Il introduit ainsi un modèle où seule la dernière page visitée est conservée en mémoire (on ne peut pas utiliser deux fois de suite la touche _Back_), et où la probabilité de _Back_ est uniforme#footnote[Comme l'historique est limité, la distribution limite n'est pas forcément égale à la distribution du modèle classique, même pour $alpha < 0,5$.]. L'algorithme résultant présente des performances comparables à celles d'un PageRank standard, en termes de vitesse de convergence et de besoin en ressources. Le classement obtenu par la distribution de probabilité asymptotique reste similaire à celui d'un PageRank standard, avec des différences significatives au niveau du classement des pages dominantes.

Par rapport à l'algorithme de Sydow, notre prise en compte de la touche _Back_ présente l'avantage de supprimer de nombreux problèmes liés aux PageRanks classiques (complétion stochastique, effeuillage et remplumage, vitesse de convergence).

== Modélisation de la touche _Back_

Adoptant une approche similaire à @sydow04random#footnote[À moins que ce ne soit Sydow qui ait adopté une approche similaire à la notre, les recherches ayant été menées indépendamment, et chacun ayant découvert les travaux de l'autre lors de la treizième conférence _WWW_.], nous choisissons d'introduire la possibilité de revenir en arrière avec un historique limité. Potentiellement, pour ramener un processus stochastique à mémoire $m$ à une chaîne de Markov sans mémoire, on peut être amené à considérer l'ensemble des chemins de longueur $m$ dans $G$. Dans le cas où $m=1$, qui est celui que nous allons étudier, l'espace de travail canonique est l'ensemble $E$ des hyperliens. Nous allons introduire deux modèles intuitifs de touche _Back_ pour le cas où $m=1$, et montrer que pour l'un d'entre eux, il est possible de réduire l'espace de travail de $E$ à $V$. Nous verrons également que ce dernier cas est compatible avec l'emploi d'un facteur _zap_.

=== Modèle réversible <sec:back-reversible>

Dans ce modèle, nous supposons qu'à chaque étape, l'utilisateur peut soit choisir un lien sortant de la page où il se trouve, soit appuyer sur la touche _Back_, ce qui va le ramener à l'étape précédente. La touche _Back_ est considérée comme un hyperlien comme les autres. En particulier, la probabilité d'utiliser la touche _Back_ est la même que celle de cliquer sur un lien donné, s'il en existe au moins $1$, et vaut $1$ en l'absence de lien sortant. Nous pensons que cette approche présente deux avantages par rapport au choix d'une probabilité de retour uniforme fait dans @sydow04random :
- Intuitivement, il semble logique que l'usage de la touche _Back_ dépende du choix disponible sur la page considérée, c'est-à-dire du nombre de liens sortants. Ceci est partiellement confirmé par les comportements observés dans @milic04smartback.
- Tout comme la page virtuelle de complétion introduite dans la @sec:pr-pagevirtuelle, la touche _Back_ que nous venons de modéliser assure une échappatoire même dans les pages sans liens, et crée une forme de complétion stochastique.

Précisons enfin que le terme _réversible_ est dû au fait que deux emplois consécutifs de la touche _Back_ s'annulent.

Formellement, le processus stochastique que nous venons d'introduire peut se décrire ainsi : pour chaque $v in V$, nous définissons $P_n (v)$ comme la probabilité de présence en $v$ à l'instant $n$. Nous introduisons également le terme $P_n^(r b)(w,v)$, pour $w,v in V$, probabilité d'être passé de $w$ à $v$ entre les instants $n-1$ et $n$. $P_n^(r b)(w,v)$ est non nul dès que $(w,v)$ ou $(v,w)$ est dans $E$, et il existe une relation très simple entre $P_n$ et $P_n^(r b)$ :

$ P_n (v) = sum_(w arrow.l.r v) P_n^(r b)(w,v) $ <rev1>

où $w arrow.l.r v$ signifie _$w$ pointé par ou pointant vers $v$_. On remarque que l'usage de la touche _Back_ implique de travailler sur le graphe non-orienté induit par $G$.

De la même façon, il est possible d'écrire une équation décrivant les termes $P_(n+1)^(r b)(w,v)$ : si $(w,v) in E$, pour aller de $w$ à $v$ entre les instants $n$ et $n+1$, on peut soit suivre le lien qui relie $w$ à $v$ (il faut pour cela être en $w$ à l'instant $n$ et choisir parmi les $d(w)+1$ possibilités), soit utiliser la touche _Back_ (il faut alors être allé de $v$ à $w$ entre les instants $n-1$ et $n$, et choisir parmi les $d(w)+1$ possibilités). Si $(w,v) in.not E$, mais $(v,w) in E$, alors la transition de $w$ à $v$ ne peut être effectuée que _via_ l'emploi de la touche _Back_. Il n'y a pas de transition dans les autres cas. Nous pouvons donc écrire :

$ P_(n+1)^(r b)(w,v) = cases(
  frac(1, d(w)+1)(P_n (w) + P_n^(r b)(v,w)) & "si" (w,v) in E,
  frac(P_n^(r b)(v,w), d(w)+1) & "si" (v,w) in E "et" (w,v) in.not E,
  0 & "sinon."
) $ <rev2>

Grâce aux Équations #ref(<rev1>, supplement: none) et #ref(<rev2>, supplement: none), il est possible de réaliser un processus itératif de calcul de $P_n$, que l'on pourra par exemple initier par la distribution

$ P_0^(r b)(w,v) = cases(
  frac(1, |E|) & "si" (w,v) in E,
  0 & "sinon."
) $

Si $G'=(V,E')$ est le graphe non-orienté induit par $G$, il semble donc nécessaire d'utiliser $|V|+|E'|$ variables, contre $|V|$ pour le PageRank standard. En injectant @rev1 dans @rev2, il est possible de réduire le nombre de variables à $|E'|$, mais cela reste très important. Ceci nous a amené à considérer le modèle du _Back_ irréversible#footnote[Il est peut-être possible de réduire le nombre de variables à $|V|$, comme nous allons le faire avec le modèle irréversible, mais nous n'avons pour l'instant pas formalisé cette réduction, et laissons donc le modèle de _Back_ réversible à un stade purement descriptif.].

=== Modèle irréversible <sec:back-irreversible>

Dans ce nouveau modèle, nous supposons qu'il n'est pas possible d'utiliser la touche _Back_ deux fois d'affilée : celle-ci est grisée après utilisation, et il faut d'abord utiliser au moins une fois un lien réel avant de pouvoir en faire usage à nouveau. Bien que plus complexe en apparence, ce modèle présente des avantages certains sur le modèle réversible :

- Il est plus proche du comportement de la touche _Back_ des navigateurs réels, qui se désactive effectivement lorsque l'historique est épuisé. L'usage d'une touche _Back_ après épuisement de l'historique dans le modèle réversible se rapproche plus de l'usage de la touche _Forward_ dans les navigateurs réels. Or, si l'on en croit @milic04smartback (cf @tab:back-stats), le rôle de la touche _Forward_ reste relativement anecdotique.
- Il est compatible avec l'introduction effective d'un facteur _zap_ (cf @backbuttonandcrossing).
- Le calcul de la distribution asymptotique, même avec un facteur _zap_, ne nécessite pas plus de ressources que dans le cas d'un PageRank classique (cf @sec:pr-back-optimisation).
- L'emploi de la touche _Back_ introduit forcément une sorte d'« effet de serre » au niveau des pages sans liens, qui peut s'avérer gênant (effet similaire à celui des composantes fortement connexes récurrentes décrites dans le chapitre précédent). Le modèle irréversible réduit cet effet par rapport au modèle réversible. Considérons l'exemple de la @fig:back-greenhouse : une page $1$ possède $2$ liens, l'un vers une page sans lien $2$, l'autre vers une page d'échappement d'où tout le graphe est accessible. Si le surfeur aléatoire se retrouve en $2$, il va forcément revenir en $1$ par la touche _Back_. Retourner à nouveau en $2$ va alors créer un début d'effet de serre, or le retour en $2$ se fait avec une probabilité $frac(2,3)$ dans le modèle réversible (2 cas favorables sur 3), contre $frac(1,2)$ dans le cas irréversible : la probabilité de rester « coincé » en $2$ est plus faible dans le modèle irréversible.

#figure(
  image("../figures/back-greenhouse.pdf", width: 50%),
  caption: [Touche _Back_ et effet de serre : rôle de l'(ir)réversibilité],
) <fig:back-greenhouse>

Afin de calculer l'évolution dans un tel modèle, nous allons introduire :
/ $P_n^(h l)(w,v)$ : probabilité d'aller de la page $w$ à la page $v$ entre les instants $n-1$ et $n$ à l'aide d'hyperlien.
/ $P_n^(i b)(v)$ : probabilité d'être arrivé sur la page $v$ à l'instant $n$ par l'emploi de la touche _Back_.

Il est possible de décrire $P_(n+1)^(h l)(w,v)$ en fonction de la situation à l'instant $n$ : pour suivre le lien qui va de $w$ à $v$, soit on est arrivé à $w$ en suivant un lien réel, et il faut choisir parmi $d(w)+1$ possibilités, soit on est arrivé en $w$ par la touche _Back_, ce qui a grisé cette dernière et limite les possibilités à $d(w)$. Nous avons ainsi, pour $(w,v) in E$,

$ P_(n+1)^(h l)(w,v) = frac(sum_(u -> w) P_n^(h l)(u,w), d(w)+1) + frac(P_n^(i b)(w), d(w)) $ <irr2>

On remarquera que comme $w -> v$, il n'y a aucune ambiguïté à effectuer une division par $d(w)$. On notera également que le sommet d'arrivée $v$ n'intervient en aucune façon dans l'expression de $P_(n+1)^(h l)(w,v)$. Si $R$ est l'ensemble des pages possédant au moins un lien, et $S$ l'ensemble des pages sans lien, on parlera donc à partir de maintenant de $P_n^(h l)(w)$, avec $w in R$, plutôt que de $P_(n+1)^(h l)(w,v)$, avec $(w,v) in E$.

De même, pour être arrivé sur une page $v$ grâce à la touche _Back_, il faut précédemment être allé de $v$ vers une page $w$ pointée par $v$ grâce à un hyperlien, puis avoir choisi la touche _Back_ parmi les $d(w)+1$ possibilités. En particulier, on ne peut pas être arrivé sur une page de $S$ par la touche _Back_, et $P_n^(i b)(v)$ est nul pour $v in S$. Pour $v in R$, nous pouvons écrire :

$ P_(n+1)^(i b)(v) = sum_(w <- v) frac(P_n^(h l)(v), d(w)+1) $ <irr1>

où $w <- v$ signifie _$w$ pointé par $v$_.

Si on définit la _Back_-attractivité d'un sommet $v$ appartenant à $R$ par

$ a(v) = sum_(w <- v) frac(1, d(w)+1) $

il est alors possible de réécrire les Équations #ref(<irr1>, supplement: none) et #ref(<irr2>, supplement: none) comme suit :

$ P_(n+1)^(i b)(v) = a(v) P_n^(h l)(v) $ <irr3>

$ P_(n+1)^(h l)(v) = frac(1, d(v)+1) sum_(w -> v) P_n^(h l)(w) + frac(P_n^(i b)(v), d(v)) $ <irr4>

En fusionnant l'@irr3 et l'@irr4, on obtient l'@irr5

$ P_(n+1)^(h l)(v) = frac(1, d(v)+1) sum_(w -> v) P_n^(h l)(w) + frac(a(v), d(v)) P_(n-1)^(h l)(v) $ <irr5>

Et le PageRank dans tout ça ? La probabilité de présence en une page $v$ est la somme de la probabilité d'y être arrivé par la touche _Back_ et de celle d'y être arrivé en suivant un lien. En posant, par convention, $P_n^(h l)(v)=0$ pour $v in S$, on a :

$
P_n (v) &= P_n^(i b)(v) + sum_(w -> v) P_n^(h l)(w) \
&= a(v) P_(n-1)^(h l)(v) + sum_(w -> v) P_n^(h l)(w)
$

=== Incorporation du facteur _zap_ <backbuttonandcrossing>

L'ajout de la touche _Back_ irréversible nous garantit un processus stochastique quel que soit le graphe initial, à la seule condition que le support de la distribution initiale ne contienne aucune page sans lien. Le problème des impasses à courte distance, comme la page $2$ de la @fig:back-greenhouse, est résolu, mais les problèmes d'irréductibilité restent présents. Pire encore, la touche _Back_ transforme les impasses à moyenne et longue distance en puits de rang (cf @fig:back-impasse).

#figure(
  image("../figures/back-impasse.pdf", width: 50%),
  caption: [Composante fortement connexe récurrente créée par la touche _Back_],
) <fig:back-impasse>

Il est donc nécessaire d'introduire du _zap_ dans le processus. Nous avons choisi un _zap_ classique, avec un facteur $d$ et une distribution $Z$. Nous imposons que le fait de « zapper » désactive la touche _Back_ : après un _zap_, il n'est pas possible de revenir en arrière. Cela présente l'avantage pratique de ne pas avoir à considérer toutes les transitions implicitement générées par le _zap_, à savoir $(V times chi_Z) subset E$. On peut aussi interpréter ce choix au niveau de la modélisation du surfeur : selon le @tab:back-stats, beaucoup de _zaps_ réels correspondent en fait au démarrage d'une nouvelle session, et donc à un historique remis à $0$.

Maintenant que le cadre est défini, il est possible de récrire $P_n^(h l)(v)$, pour $v in R$ :

$ P_(n+1)^(h l)(v) = d (frac(1, d(v)+1) sum_(w -> v) P_n^(h l)(w) + frac(P_n^(i b)(v), d(v))) $ <damp2>

De la même façon, nous pouvons récrire la probabilité $P_n^(i b)(v)$ de se trouver à un instant $n$ sur une page $v$ avec un historique nul. En posant, par convention, $P_n^(h l)(v)=0$ pour $v in S$, on a :

$ P_(n+1)^(i b)(v) = d dot a(v) P_n^(h l)(v) + (1-d) Z(v) $ <damp1>

Et là, un problème se pose : que se passe-t-il si $chi_Z inter S != emptyset$ ? Nous allons avoir une probabilité non nulle d'être dans une page de $S$ sans retour en arrière possible. Dans cette situation, avec une probabilité $(1-d)$, notre surfeur va « zapper » ailleurs, et avec une probabilité $d$... il ne saura pas quoi faire !

Nous envisageons deux méthodes pour contourner ce problème :
- Choisir $Z$ tel que $chi_Z inter S != emptyset$. Puisque la seule condition que l'on demande à une distribution de _zap_ est d'être recouvrante, c'est tout à fait possible. Une distribution sur les pages d'accueil conviendra, à la condition qu'il n'existe pas de page d'accueil d'un site réduit à une page sans lien. On peut aussi choisir de prendre la distribution uniforme sur $R$ définie par
  $ Z(v) = cases(
    frac(1, |R|) & "si" v in R,
    0 & "sinon."
  ) $
- Compléter le processus stochastique à la volée. On connaît en effet la probabilité de ne pas savoir quoi faire entre les instants $n$ et $n+1$ : $d sum_(v in S) P_n^(i b)(v)$. Il suffit alors de répartir cette probabilité, par exemple en _zap_ selon $Z$. L'équation @damp1 devient alors :
  $ P_(n+1)^(i b)(v) = d dot a(v) P_n^(h l)(v) + [1-d + d sum_(v in S) P_n^(i b)(v)] Z(v) $ <damp-compl>

== Algorithme pratique : BackRank

Nous venons de définir un processus stochastique, qui grâce au facteur _zap_ est irréductible et apériodique. Le théorème de Perron-Frobenius s'applique donc#footnote[On notera au passage que nous n'avons pas besoin d'écrire explicitement la matrice des transitions associée, qui est une matrice carrée de taille $|V|+|E|$. Il nous suffit de savoir que cette matrice existe et que c'est elle qui régit implicitement notre processus.] et nous permet d'affirmer que des itérations successives des Équations #ref(<damp1>, supplement: none) et #ref(<damp2>, supplement: none) vont converger vers un point fixe unique (à renormalisation près). Les conditions initiales peuvent par exemple être une distribution selon $Z$ avec un historique nul ($P_0^(i b)=Z$ et $P_0^(h l)=0$).

=== Optimisation <sec:pr-back-optimisation>

Nous supposerons ici que nous avons choisi $Z$ tel que $Z(v)=0$ si $v in S$.

D'après l'@damp1 et l'@damp2, $P_(n+1)^(h l)(v)$ peut se définir récursivement, pour $v in R$ par :

$ P_(n+1)^(h l)(v) = frac(d, d(v)+1) sum_(w -> v) P_n^(h l)(w) + frac(d, d(v)) (d dot a(v) P_(n-1)^(h l)(v) + (1-d) Z(v)) $ <damp3>

L'@damp3 est une récurrence à deux termes, dont on sait qu'elle converge vers un point fixe. Comme seul le point fixe nous intéresse, on peut remplacer $P_(n-1)^(h l)$ par $P_n^(h l)$ en gardant une convergence vers le même point fixe (méthode de Gauss-Seidel). On obtient ainsi l'@damp4.

$ P_(n+1)^(h l)(v) = frac(d, d(v)+1) sum_(w -> v) P_n^(h l)(w) + frac(d, d(v)) (d dot a(v) P_n^(h l)(v) + (1-d) Z(v)) $ <damp4>

On remarquera au passage que les itérations se font sur les sommets de degré sortant non nul : il y a un effeuillage implicite, semblable à ce qui se pratique pour les PageRanks standards (cf @subsubsec:effeuilage).

Après que le vecteur $P_n^(h l)$ a convergé vers un vecteur $P^(h l)$, il reste à effectuer le « remplumage » pour obtenir la distribution asymptotique de présence $P$ :

$
P(v) &= sum_(w -> v) P^(h l)(w) + P^(i b)(v) \
&= sum_(w -> v) P^(h l)(w) + d dot a(v) dot P^(h l)(v) + (1-d) Z(v)
$ <eq:backrank-remplumage>

Nous avons maintenant tous les éléments constitutifs de _BackRank_ (@alg:pr-back). On remarquera au passage qu'il n'y a pas besoin d'effectuer de renormalisation, puisqu'il y a convergence vers un point fixe.

#alg(
  caption: [BackRank : modèle de PageRank avec touche _Back_ irréversible],
)[
Données
- une matrice d'adjacence $M$ d'un graphe quelconque $G=(V,E)$, avec $V=(R union S)$, où $R$ est l'ensemble des pages avec lien, $S$ celui des pages sans lien ;
- une distribution de _zap_ $Z$ sur $R$ recouvrante ;
- un coefficient de _zap_ $d in ]0, 1[$ ;
- un réel $epsilon$.
Résultat\
Le vecteur de PageRank $P$ du modèle _Back_ irréversible avec _zap_.\
début\
$D <- M un_n^t$\
$T <- 1 .\/ (D + un_n^t)$#comment[$1\/dot $ : inverse terme à terme]\
$A <- M dot T$\
$T <- T_R$\
$D <- D_R$\
$C <- 1 .\/ D$\
$B <- d dot C times.o A_R$ #comment[$times.o$ : produit terme à terme]\
$Y <- d(1-d) C times.o Z$\
$N <- M_R$\
$R_0 = d C times.o Z$\
$delta <- 2 epsilon$, $n <- 0$\
tant que $delta > epsilon$#i:\
$R_(n+1) <- T times.o (N^t R_n) + B times.o R_n$\
$R_(n+1) <- d R_(n+1)$\
$R_(n+1) <- R_(n+1) + Y$\
$delta <- ||R_(n+1) - R_n||_1$\
$n<- n+1$#d\
$R_(n) <- R_(n)$ sur $V$ (nul sur $S$)\
retourner $P=M^t R_n + d A times.o R_n + (1-d) Z$
] <alg:pr-back>

=== Résultats <subsec:backrank-results>

Une fois un algorithme complètement défini, il faut le soumettre à l'épreuve du feu. Afin d'effectuer des comparaisons, il nous fallait un baril de lessive $X$, et c'est le PageRank $mu$-compensé défini dans l'@alg:pr-hybride qui a été choisi. C'est en effet le PageRank le plus simple garantissant un contrôle stochastique total, mis à part le PageRank non-compensé bien sûr#footnote[Nous avons gardé la compensation pour rendre les comparaisons plus simples, puisqu'ainsi les deux concurrents fournissent une distribution de probabilité.]. La technique d'effeuillage-remplumage a été rajoutée par souci d'équité par rapport à BackRank, qui la réalise implicitement, et aussi afin d'être plus réaliste (c'est la méthode qui semble être employée en pratique pour les calculs _off-line_ sur de très gros graphes, et BackRank est conçu pour supporter de très gros graphes.). Pour les deux algorithmes, nous avons pris $d=0,85$ (sauf indication contraire) et $Z$ est la distribution uniforme sur la rafle $R$.

Le test a porté sur un crawl de 8 millions d'URLs qui, pour des raisons techniques#footnote[Les algorithmes tournent sous Matlab.] est scindé en deux échantillons de $4$ millions d'URLs.

==== Convergence

Un des premiers critères de viabilité d'un algorithme de type PageRank est sa vitesse de convergence. La @fig:backrank-convergence compare, sur une échelle semi-logarithmique, la valeur du paramètre de convergence $delta$ au bout de $n$ itérations. Pour BackRank, la condition $delta < 10^(-10)$ est atteinte au bout de $87$ itérations dans les deux échantillons, alors que pour PageRank, il faut entre $126$ et $127$ itérations. Nous avons mesuré la raison de la décroissance géométrique observée à $10^(-10)$, et trouvé $0,844$ pour le PageRank standard (la convergence est toujours inférieure à $d$, mais tend asymptotiquement vers $d$) contre $0,809$ pour BackRank. Nous supposons que cet écart, qui explique les performances de BackRank, est du au fait qu'à la différence de PageRank, BackRank utilise implicitement une méthode de Gauss-Seidel partielle. Or, il a été montré que l'utilisation d'une méthode de type Gauss-Seidel améliore considérablement la convergence d'un PageRank @arasu01pagerank.

Nous nous devons de préciser que les algorithmes utilisés sont, aux jeux de réécriture près#footnote[L'@alg:pr-hybride a été réécrit suivant le modèle de l'@alg:pr-virtuelle.], exactement ceux décrits dans cet ouvrage. En particulier, les méthodes de la puissance employées sont vraiment des méthodes de la puissance. Pour une étude plus complète des performances de convergence de BackRank, il faudrait étudier comment il se comporte soumis aux nombreuses méthodes d'accélération de la convergence qui existent @arasu01pagerank @Haveliwala99efficient @kamvar03extrapolation.

Pour conclure cette étude de la convergence, précisons que sur les échantillons considérés, une itération de BackRank prend en moyenne $2$ secondes contre $3$ secondes pour PageRank. Cette différence vient du fait que toutes les constantes de calcul, y compris la matrice d'adjacence, tiennent en mémoire vive. La $mu$-compensation a donc un coût non négligeable dans une itération. En fait, même par rapport à un PageRank non-compensé avec estimation de $delta$, BackRank ne présente qu'un faible surcoût, de l'ordre de $5%$.

#figure(
  image("../figures/backrank-convergence.pdf", width: 80%),
  caption: [Convergences comparées de BackRank et d'un PageRank standard],
) <fig:backrank-convergence>

==== Le remplumage

La finalisation du calcul du PageRank, que nous appelons remplumage, est une phase assez peu décrite. Selon @Page98, après convergence du PageRank sur le graphe restreint aux sommets de degré sortant non nul, les pages sans lien sont rajoutées au processus, _sans affecter les choses de manière significative_#footnote[« without affecting things significantly », _op. cit._]. Mais afin d'attribuer à ces nouvelles pages une importance, il faut bien réaliser au moins une itération de PageRank, ce qui implique de modifier la plupart des constantes. Dans notre essai, nous avons choisi d'effectuer quatre itérations sur le graphe complet après convergence sur le graphe effeuillé. Outre des itérations plus lentes ($6$ secondes, sachant qu'environ $50%$ des pages des échantillons étaient des pages sans lien), on constate, comme dans la @subsubsec:effeuilage page @subsubsec:effeuilage, la réinitialisation du paramètre $delta$ (cf @fig:backrank-convergence) : au bout de quatre itérations, on est au même niveau qu'après huit itérations de la boucle principale, c'est-à-dire loin d'un état stationnaire...

Pour BackRank, le remplumage est beaucoup moins problématique, puisqu'il se limite à l'application de @eq:backrank-remplumage _une seule et unique fois_. Inutile donc de démarrer une nouvelle série d'itérations. Précisons quand même pour être honnête que puisque $delta$ se rapporte à $P^(h l)$ et non $P$, les variations sur $P$ peuvent être plus grandes que $delta$. Expérimentalement, il semble effectivement que lorsque $delta$ est aux alentours de $10^(-10)$, les variations au niveau de $P$ sont de l'ordre de $10^(-9)$ (légèrement inférieures en fait). Ce résultat reste malgré tout plus qu'acceptable, surtout au regard des variations de $10^(-1)$ générées par le remplumage du PageRank.

#figure(
  image("../figures/backrank-overlap.pdf", width: 80%),
  caption: [Mesures de chevauchement entre les $n$ premières pages de BackRank et de PageRank],
) <fig:backrank-overlap>

==== Classement

Les performances techniques ne sont que la moitié des critères d'évaluation d'un algorithme de type PageRank. Il faut aussi tester la pertinence du classement par importance induit par la distribution de probabilité obtenue. Une première approche consiste à comparer quantitativement les résultats renvoyés par BackRank et ceux renvoyés par le PageRank de référence. La @fig:backrank-overlap présente une telle comparaison, en donnant le pourcentage de pages communes aux $n$ premières pages renvoyées respectivement par BackRank et PageRank. On observe des fluctuations importantes sur les toutes premières pages. Au fur et à mesure que le nombre de pages considérées augmente, le chevauchement se stabilise, pour arriver à une valeur relativement stable de $0,845$ lorsque le nombre de pages considérées s'approche de $1%$ de la taille de l'échantillon ($40000$ pages). Ceci tend à prouver que BackRank offre des résultats assez proches de ceux renvoyés par PageRank, avec quelques spécificités.

Ce chevauchement à $1%$ stabilisé valant $0,845$ pour les deux échantillons nous a intrigués. En étudiant le phénomène de plus près, nous avons remarqué que le taux de chevauchement à $1%$ est une variable qui ne dépend que de $d$ (sur nos échantillons en tout cas). La @fig:backrank-d montre ce lien entre $d$ et chevauchement à $1%$ pour $0 <= d <= 1$. On remarquera en particulier que :
- Le chevauchement est une fonction décroissante de $d$. On retrouve l'idée, évoquée dans la @subsec:choix_d, du rôle lisseur du facteur _zap_.
- En particulier, le chevauchement tend vers $1$ lorsque $d$ tend vers $0$, ce qui signifie que BackRank tend, tout comme PageRank, vers la distribution par degré entrant (cf @subsec:choix_d).
- Le chevauchement tend vers $50%$ lorsque $d$ tend vers $1$, ce qui semble indiquer que BackRank est intrinsèquement à moitié différent (ou à moitié semblable ?) du PageRank standard. Il ne faut cependant pas oublier que lorsque $d=1$, le classement est sclérosé par les puits de rang et n'a plus forcément de sens. Vérification sur quelques URLs faite, ce chevauchement de $50%$ veut en effet seulement dire que BackRank ne se fait pas piéger sur exactement les même puits que PageRank.

#figure(
  image("../figures/backrank-d.pdf", width: 80%),
  caption: [Influence du facteur _zap_ dans le chevauchement à $1%$],
) <fig:backrank-d>

Nous sommes conscients de ne donner ici quelques indices de la qualité du classement par BackRank. En toute rigueur, une validation complète nécessiterait d'incorporer BackRank dans un moteur de recherche et d'effectuer une série de tests de satisfaction sur une population témoin. À défaut, nous nous contenterons d'utiliser le lecteur comme population témoin, qui pourra comparer dans les listes @liste:xba, @liste:xha, @liste:xbb et @liste:xhb les 10 premières pages renvoyées par BackRank et PageRank sur les deux échantillons considérés. On remarquera par exemple que la page principale du CNRS est classé par BackRank, mais pas par PageRank (en fait, elle est 16#super[ème]), alors que pour l'Éducation Nationale, c'est l'inverse (page classée également 16#super[ème], mais par BackRank cette fois).

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
  caption: [Échantillon 1 : les 10 pages les plus importantes selon BackRank],
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
  caption: [Échantillon 1 : les 10 pages les plus importantes selon PageRank],
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
  caption: [Échantillon 2 : les 10 pages les plus importantes selon BackRank],
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
  caption: [Échantillon 2 : les 10 pages les plus importantes selon PageRank],
) <liste:xhb>
