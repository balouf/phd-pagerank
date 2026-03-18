// =============================================================================
// Chapitre 5 : PageRank, une manière d'estimer l'importance des pages web
// =============================================================================

#import "../templates/prelude.typ": *

= PageRank, une manière d'estimer l'importance des pages web <pr-pagerank>

#citation([Michel #smallcaps[de Pracontal], _l'imposture scientifique_])[Lorsqu'un chercheur veut publier une communication dans une revue spécialisée, il doit passer par des comités de lecture qui évaluent la qualité de son travail selon des critères précis. Pour passer à la télévision ou dans un journal, il suffit d'avoir une bonne histoire à raconter.]
#citation([Tom #smallcaps[Fasulo]])[Surfer sur internet c'est comme pour le sexe : tout le monde se vante de faire plus qu'il ne fait. Mais pour le cas d'Internet, on se vante bien plus.]
#citation([])[Omnes Viae ad Googlem ducent]

#v(1cm)

#lettrine("Ce chapitre")[va essayer de poser les bases à la fois intuitives, axiomatiques et théoriques des méthodes de classement de type _PageRank_, mises en valeur par le célèbre moteur de recherche _Google_ @Google98. Ce travail fastidieux de _survey_ m'a été grandement facilité par Mohamed Bouklit, qui en débroussaillant, avec l'aide d'Alain Jean-Marie, le terrain avant moi @bouklit01methodes @bouklit02analyse, m'a permis d'avoir toutes les références nécessaires.]

Il existe dejà un certain nombre de _surveys_ à propos du PageRank (cf @bianchini02pagerank @bianchini03inside @langville04deeper), mais nous avons jugé ce chapitre nécessaire, car il présente l'ensemble des PageRanks sous un même point de vue, celui de l'interprétation stochastique, et met en évidence quelques résultats de convergence qu'on ne trouve pas ailleurs#footnote[Tout au moins pas appliqués aux PageRanks.].

== Une aiguille dans un océan de foin...

On trouve (de) tout sur le web, à peu près tous les usagers du réseau sont d'accord là-dessus. Savoir si l'information que je recherche existe sur la toile n'est plus crucial. De nos jours, le problème est devenu : _Comment trouver la page que je recherche ?_

- En connaissant, d'une manière ou d'une autre, l'adresse en question. Par exemple, en lisant sur un paquet de farine l'adresse d'un site qui donne des recettes de cuisine, en recevant un mail d'un ami qui recommande d'aller visiter une adresse web, ou en ayant l'adresse dans ses _Bookmarks_...
- En naviguant (surfant) sur le web, à partir d'une adresse connue. Si par exemple je recherche une page qui parle des ratons laveurs, et si je connais un site de zoologie, partir de ce site peut être une bonne façon de trouver la page que je cherche.
- En utilisant un moteur de recherche. Celui-ci, en échange d'une _requête_, c'est-à-dire d'un ensemble de mots essayant de décrire plus ou moins précisément ce que je recherche, va nous donner une liste de pages susceptibles de répondre à cette requête. D'après @lawrence99accessibility, l'utilisation des moteurs de recherche concerne 85% des internautes.

#figure(
  table(
    columns: 3,
    stroke: 0.5pt,
    inset: 0.5em,
    align: (left, right, right),
    [*Requête*], [*Google*], [*Yahoo*],
    [PageRank], [1 410 000], [807 000],
    [Raton laveur], [18 100], [25 300],
    [Amazon], [107 000 000], [66 600 000],
    [Pâte à crêpes], [46 300], [30 900],
    [Pâte à crêpe], [22 800], [47 000],
  ),
  caption: [Nombre de réponses fournies par Google et Yahoo à quelques requêtes (août 2004)],
) <gooyah-aout>

Tout le problème des moteurs de recherche est d'arriver à renvoyer les pages que l'utilisateur recherche. Seulement, les réponses à une requête donnée se comptent souvent par centaines, voire par milliers#footnote[Le problème est en fait moins crucial si on élimine les doublons --- voir le #fref(<tab:pages-uniques>) --- mais il reste important.], comme le montre le @gooyah-aout. D'un autre côté, les utilisateurs se lassent vite, et on estime que 90% des utilisateurs ne dépassent pas la première page de résultats.

Le but des moteurs est donc d'arriver à afficher dans les dix à vingt premières réponses les documents répondant le mieux à la question posée. Dans la pratique, aucune méthode de tri n'est parfaite, mais leur variété offre aux moteurs la possibilité de les combiner pour mieux affiner leurs résultats. Les principales méthodes de tri sont les suivantes :

/ Tri par pertinence: Le tri par pertinence est la méthode de tri la plus ancienne et la plus utilisée. Elle est basée sur le nombre d'occurrences des termes de la recherche dans les pages, de leur proximité, de leur place dans le texte @salton89automatic @yuwono95... Malheureusement, cette méthode présente l'inconvénient d'être facile à détourner par des auteurs désireux de placer leurs pages en tête de liste. Pour cela, il suffit de surcharger la page de mots importants, soit dans l'en-tête, soit en lettres invisibles à l'intérieur du corps de la page.

/ Étude de l'URL: On peut également donner de l'importance à une page en fonction de son #acr("URL"). Par exemple, selon le contexte, les #acrpl("URL") appartenant au _Top Level Domain_ `http:.com` pourraient avoir plus d'importance que les autres, de même que les #acrpl("URL") contenant la chaîne de caractère `http:home` @li00defining. Il a également été suggéré que les #acrpl("URL") de faible hauteur dans l'arbre-cluster étaient plus importantes que les autres @cho98efficient.

/ Liens entrants: Le comptage de citations consiste à attribuer aux pages une importance proportionnelle aux nombres de liens vers cette page connus. Cette méthode a largement été utilisée en scientométrie pour évaluer l'importance des publications @price63little.

/ PageRank: Comme nous allons le voir, le PageRank est une sorte de généralisation récursive du comptage de citations.

== Les deux axiomes du PageRank <sec:pr-axiomes>

Le PageRank, introduit par Brin _et al._ en 1998 @Page98, est la méthode de classement qui a fait la spécificité du moteur de recherche _Google_ @Google98. Il s'agit en fait d'une adaptation au Web de diverses méthodes introduites par les scientomètres#footnote[Cela fait maintenant quelques dizaines d'années qu'un nouveau domaine de la recherche est apparu qui se consacre à l'étude de la production intellectuelle humaine. Les principales branches de cette méta-science sont :
/ Bibliométrie: définie en 1969 comme «l'application des mathématiques et des méthodes statistiques aux livres, articles et autres moyens de communication».
/ Scientométrie: on peut la considérer comme la bibliométrie spécialisée au domaine de l'Information Scientifique et Technique (IST). Toutefois, la scientométrie désigne d'une manière générale l'application de méthodes statistiques à des données quantitatives (économiques, humaines, bibliographiques) caractéristiques de l'état de la science.
/ Infométrie: terme adopté en 1987 par la F.I.D. (International Federation of Documentation, IFD) pour désigner l'ensemble des activités métriques relatives à l'information, couvrant aussi bien la bibliométrie que la scientométrie.
] depuis les années 1950. Deux méthodes scientométriques en particulier doivent être évoquées :

/ Le comptage de citations: En 1963, Price publie _Little Science, Big Science_ @price63little. Dans ce livre, premier ouvrage majeur traitant de ce qui deviendra plus tard la scientométrie, il propose de mesurer la qualité de la production scientifique grâce, entre autres, à une technique très simple, le comptage de citations : une des manières de mesurer la qualité d'une publication est de dénombrer le nombre de fois où cette publication est citée.

/ Modélisation markovienne: Les chaînes de Markov, décrites au @pr-markov, permettent non seulement de jouer au Monopoly (marque déposée), mais aussi de modéliser l'évolution d'une population répartie entre plusieurs états à condition d'arriver à estimer les probabilités de transition entre états. Par exemple, Goffman propose en 1971 l'étude de l'évolution de la recherche dans différents sous-domaines de la logique à l'aide de chaînes de Markov @goffman71mathematical.

Voyons maintenant comment Brin _et al._ ont adapté ces concepts à l'estimation de l'importance des pages Web.

=== Une page importante est pointée par des pages importantes

Transposée telle quelle aux graphes du Web, la méthode du comptage de citations revient à dire que l'importance d'une page est proportionnelle à son degré entrant, c'est-à-dire au nombre de pages qui la citent à travers un hyperlien :

$ I(v) = sum_(w -> v) 1 $

où $w -> v$ signifie _$w$ qui pointe sur $v$_.

Bien que cette mesure puisse effectivement être utilisée pour estimer l'importance des pages @cho98efficient, elle se trouve en partie dénaturée par l'inexistence d'un contrôle de qualité. En effet, lorsqu'un chercheur veut publier une communication dans une revue spécialisée, il doit passer par des comités de lecture qui évaluent la qualité de son travail selon des critères précis. À cause de cela, le fait même d'être publié donne un minimum d'importance aux articles considérés, et on a une certaine garantie que les citations que reçoit un papier ne sont pas complètement fantaisistes. Dans le cas du Web, ce garde-fou n'existe pas : à cause du faible coût intellectuel et matériel d'une page Web, n'importe qui peut pointer vers n'importe quoi sans que cela ait forcément un véritable sens#footnote[Après tout, ne dit-on pas qu'_on trouve de tout sur le Web_ ?]. Par exemple, pourquoi ne pas créer une multitude de pages vides de sens, mais qui me citent par des hyperliens, pour augmenter à l'envi ma propre importance ?

Brin _et al._ proposent de contrer ce problème par une description récursive de l'importance : Qu'est-ce qu'une page importante ? C'est une page pointée par des pages importantes. Concrètement, si une page $v$ est pointée par $k$ pages $v_1, ..., v_k$, l'importance de $v$ doit être définie par :

$ I(v) = f_v (I(v_1), ..., I(v_k)) $ <eq:importance>

Il nous reste à définir $f_v$ et résoudre @eq:importance.

=== Le surfeur aléatoire : le hasard fait bien les choses <subsec:random-surfer>

Une image d'Épinal du Web est le principe de la navigation par hyperliens : pour trouver ce qu'il cherche, l'internaute va naviguer de page en page et de clic en clic jusqu'à l'arrivée à bon port. Bien sûr, ce n'est pas ce qui se passe en pratique, autant pour des raisons techniques (il n'est pas toujours possible de rejoindre une page $p$ à partir d'une page $q$) que sociales (utilisation des moteurs de recherche, lassitude de l'internaute...)#footnote[Cf @catledge95characterizing @tauscher97people @cockburn01empirical @wang04behaviour @milic04smartback.].

Brin _et al._ ont eu pour idée de modéliser le comportement de l'internaute cliqueur par une chaîne de Markov. Tout ce qu'il fallait, c'était trouver les probabilités de transitions d'une page à une autre. Une des manières les plus simples de voir les choses est de considérer qu'une fois sur une page donnée, l'internaute va cliquer de manière équiprobable sur un des liens contenu dans cette page :

$ p_(v,w) = cases(
  1/(d(v)) "si" v -> w,
  0 "sinon"
) quad "où" d "est le degré sortant" $

Ceci est la base du modèle du surfeur aléatoire. Pour Brin _et al._, étant donné que les graphes du Web reflètent une architecture volontaire et réfléchie, les pages intéressantes doivent être structurellement facile d'accès, tout comme une ville est d'autant plus accessible par le réseau routier qu'elle est importante. Donc, comme le surfeur aléatoire se laisse guider par le réseau des hyperliens, statistiquement, il devrait tomber d'autant plus souvent sur une page que celle-ci est importante. D'où l'idée de définir l'importance d'une page Web par la probabilité asymptotique de se trouver sur cette page dans le modèle du surfeur aléatoire.

=== Cohérence des deux interprétations

Maintenant que nous avons défini deux façons de considérer l'importance d'une page, constatons qu'elles se recoupent et désignent le même phénomène : en effet, dans le modèle du surfeur aléatoire, il est possible d'estimer la probabilité asymptotique de présence sur une page $v$ en fonction de celles des pages $w$ qui pointent vers $v$ :

$ P(v) = sum_(w -> v) 1/(d(w)) P(w) $ <eq:naouaque>

On peut constater qu'on a bien une relation de transfert d'importance comme celle définie par l'@eq:importance, et que l'@eq:naouaque obéit en plus à un principe de conservation : une page donnée transmet l'intégralité de son importance, celle-ci étant équitablement répartie entre les différentes pages pointées. La probabilité, vue comme une importance, se transmet donc à travers les hyperliens à la manière d'un flot.

== Les modèles classiques <sec:pr-modele>

Bien qu'on parle souvent du PageRank au singulier, il existe en réalité une multitude de PageRank(s). Nous allons voir ici comment, à partir du modèle théorique du surfeur aléatoire que nous venons de décrire, plusieurs variations ont été introduites afin de s'adapter à la réalité des graphes du Web. Ce travail de _survey_ a déjà été effectué pour l'ensemble des PageRank(s) issus de processus rendus explicitement stochastiques @bianchini02pagerank @bianchini03inside @langville04deeper, mais nous voulons ici prendre également en compte les modèles sous-stochastiques.

=== Cas idéal <sec:pr-ideal>

Dans le cas où le graphe du Web $G = (V, E)$ que l'on veut étudier est apériodique et fortement connecté, les principes vus dans la @sec:pr-axiomes s'appliquent directement : en effet, il s'agit de rechercher une distribution de probabilité sur $V$ vérifiant :

$ forall v in V, P(v) = sum_(w -> v) (P(w))/(d(w)) $ <eq:prank>

Ceci revient à trouver la distribution asymptotique de la chaîne de Markov homogène dont la matrice de transition est :

$ A = (a_(i,j))_(i,j in V) quad "avec" a_(i,j) = cases(
  1/(d(i)) "si" i -> j,
  0 "sinon"
) $ <eq:def-a>

Comme vu lors de la @sec:markov-evolution, la suite de distribution

$ P_(n+1) = A^t P_n $

initiée par une distribution de probabilité quelconque $P_0$#footnote[Très souvent, on prend comme vecteur de probabilité initial une distribution de _zap_ $Z$ --- voir @sec:pr-completion.], converge géométriquement vers l'unique distribution $P$ vérifiant

$ P = A^t P $

c'est-à-dire vérifiant la relation @eq:prank.

Cette distribution de probabilité $P$ est appelée PageRank.

#remarque[
  Comme précisé dans notre définition de graphe du Web, les liens d'une page vers elle-même ne sont pas comptés. D'après @Page98, cela permet de «fluidifier» le calcul du PageRank.
]

#remarque[
  Si le graphe n'est pas fortement connexe, d'après le @thm:reductible, il y a quand même convergence, mais ni unicité (la dimension de l'espace des solutions est égal au nombre de composantes fortement connexes récurrentes), ni garantie que le support de la solution soit égal à $V$ (en particulier s'il existe des composantes transitoires). L'existence de périodicité(s) peut en revanche empêcher la convergence, mais le @thm:periodique indique comment il est possible de contourner le problème.
]

=== Renormalisation simple <sec:pr-renormalisation>

La plupart du temps, un graphe du Web n'est pas fortement connexe. Il existe en particulier un nombre non négligeable de pages sans lien, qui sont soit des pages ne contenant effectivement aucun lien, soit tout simplement des pages connues, mais non indexées. Les lignes de $A$ correspondant à ces pages sans lien ne contiennent donc que des $0$, et $A$ est donc strictement sous-stochastique. En conséquent, la suite des $P_n$ va converger#footnote[Sous réserve d'apériodicité. Voir #fref(<markov:patho:aperiodique>) pour les éventuelles périodicités.] vers un vecteur nul en dehors des éventuelles composantes fortement connexes récurrentes sur lesquelles $A$ est stochastique#footnote[Compte tenu de la façon dont le graphe est construit, toute composante fortement connexe récurrente non réduite à un élément induit un processus stochastique.]. Pour éviter ce problème, on pourrait envisager d'enlever récursivement toutes les pages sans liens jusqu'à obtenir une matrice stochastique, avec l'inconvénient de considérer un graphe plus petit que le graphe initial. Une autre approche, proposée par @Page98, consiste à renormaliser $P_n$ à chaque itération :

$ P_(n+1) = 1/(norm(A^t P_n)_1) A^t P_n $

Ce procédé itératif est une méthode de la puissance (@stewart94introduction), on sait donc qu'il va converger vers un vecteur propre associé à la plus grande valeur propre de $A$. Deux cas sont alors à considérer :

- Si la matrice $A$ est sous-irréductible, alors sa valeur propre maximale est strictement inférieure à 1. D'après le @thm:sousfiltre#footnote[Voir #fref(<thm:sousfiltre>).], l'espace propre associé est de dimension $d$, où $d$ est le nombre de composantes pseudo-récurrentes, et son support est celui engendré par l'union des filtres des composantes pseudo-récurrentes. Dans le cas particulier où $A$ est pseudo-irréductible, l'espace propre est une droite, et il existe un vecteur propre associé strictement positif : grâce à la renormalisation, tout se passe alors comme dans le cas d'une matrice stochastique irréductible.

- Si la matrice $A$ n'est pas sous-irréductible, $G$ contient au moins une composante fortement connexe récurrente sur laquelle $A$ est stochastique. La valeur propre maximale de $A$ est donc $1$, ce qui signifie que la renormalisation ne va rien changer au résultat initial : le vecteur propre sera une combinaison linéaire des vecteurs propres sur les différentes composantes fortement connexes sur lesquelles $A$ est stochastique#footnote[En d'autres termes, les composantes fortement connexes récurrentes.].

==== Processus stochastique équivalent

L'utilisation de matrices sous-stochastiques fait que l'on perd l'interprétation naturelle du surfeur aléatoire. Il est cependant parfois possible de compléter la matrice en une matrice stochastique équivalente, c'est-à-dire de trouver une matrice stochastique $B$ vérifiant :
- $A <= B$
- si $A^t P = lambda P$, avec $lambda$ maximal, alors $P = B^t P$

S'il existe un unique vecteur de probabilité $P$ maximal pour $A^t$, la plus simple façon de définir une telle matrice $B$ est de considérer le défaut stochastique de $A$ : si $A$ est sous-stochastique, on définit le défaut stochastique de $A$ comme étant le vecteur $s = un_n^t - A dot un_n^t$. La matrice

$ B = A + s dot P^t $

est bien une matrice stochastique#footnote[Si $A$ est sous-stochastique et $D$ une distribution de probabilité sur $V$, par construction, $(A + s dot D^t)$ est toujours une matrice stochastique.] supérieure à $A$, et il est facile de voir que $B^t P$ est une distribution de probabilité homogène à $P$, donc égale à $P$.

La matrice $B$ présente l'avantage de donner une interprétation stochastique au procédé de renormalisation simple : asymptotiquement, le surfeur aléatoire suit à chaque étape un lien suivant les probabilités données par $A$. Quand il ne sait pas quoi faire, il _zappe_ vers une autre page selon la distribution de probabilité qui est vecteur propre maximal de $A$.

Par contre, dès que l'espace propre maximal a une dimension supérieure à $1$, le problème est délicat, voire très délicat dans le cas de composantes pseudo-récurrentes dont les filtres ont une intersection non nulle. Nous limiterons par conséquent notre étude des processus stochastiques équivalents aux cas d'unicité du vecteur propre maximal.

=== Complétion stochastique <sec:pr-completion>

Afin de remplacer $A$ par une matrice stochastique, et d'éviter à travers une simple renormalisation d'établir un processus stochastique équivalent non contrôlé, une idée naturelle est d'ajouter des transitions aux pages sans liens. Une des méthodes possibles consiste à modéliser l'emploi de la touche _Back_, et sera l'objet du @pr-back. Une autre méthode, proposée#footnote[Sans le savoir ? Voir @rem:bourde-bp.] initialement par @Page98 (sous la forme de l'@alg:pr-completion) et étudiée entre autres par @langville04deeper, consiste à définir une distribution de probabilité _par défaut_ $Z$ sur $V$, et à s'en servir pour modéliser le comportement du surfeur aléatoire quand il arrive sur une page sans lien. Concrètement, on va remplacer dans $A$ chaque ligne nulle (qui correspond donc à une page sans lien) par la ligne $Z^t$.

#alg(caption: [PageRank : modèle par complétion stochastique (d'après @Page98)])[
Données
- une matrice sous-stochastique $A$ sans périodicité ;
- une distribution de _zap_ $Z$ recouvrante ;
- un réel $epsilon$.
Résultat\
Un (le #no-emph("si") $A$ est sous-irréductible) vecteur propre de probabilité $P$ de $overline(A)^t$ associé à la valeur propre $1$.\
début\
$n<-0$, $P_n <- Z$, $delta <- 2 epsilon$\
tant que $delta > epsilon$ #i:\
$P_(n+1) <- A^t P_n$\
$mu <- norm(P_n)_1 - norm(P_(n+1))_1$\
$P_(n+1) <- P_(n+1) + mu Z$\
$delta <- norm(P_n - P_(n+1))_1$\
$n <- n+1$ #d\
retourner $P_n$
] <alg:pr-completion>

Ce procédé peut se généraliser pour compléter toute matrice sous-stochastique : La complétion par $Z$ de $A$ est alors la matrice stochastique

$ overline(A) = A + s dot Z^t $

==== Choix de $Z$ et interprétation

$Z$ représente le comportement du surfeur aléatoire lorsque $G$ ne précise pas où il doit aller, c'est-à-dire tous les changements de page qui ne sont pas dûs à l'usage des hyperliens (adresse tapée manuellement, _Bookmarks_, requête dans un moteur de recherche...). Généralement, on choisit pour $Z$ la distribution uniforme :

$ forall v in V, Z(p) = 1/n $

qui représente un _zap_ n'importe où et au hasard sur le Web connu.

Il a également été proposé de «personnaliser» $Z$, notamment par @Page98. Par exemple, il est possible de se restreindre aux pages d'accueil des sites. D'une part, cela évite de donner implicitement aux sites une mesure partielle d'importance proportionnelle au nombre de pages crawlées (voir #fref(<sec:alter>)). D'autre part, cela obéit à une certaine intuition naturelle : quand on rompt la navigation par hyperliens pour _zapper_ sur autre chose, il est probable qu'on va commencer par une page d'accueil. Cette intuition est confirmée par de nombreuses études qui démontrent l'existence de pages qui jouent le rôle de «hubs» pour les utilisateurs réels @catledge95characterizing @kleinberg98 @wang04behaviour @milic04smartback.

==== Irréductibilité de $overline(A)$

On dira d'une distribution de probabilité $Z$ qu'elle est recouvrante si son support $chi_Z$ vérifie $arrow.t.double chi_Z = V$. C'est une condition naturelle à imposer à toute distribution de _zap_, puisqu'elle garantit que toutes les pages connues sont potentiellement accessibles après un _zap_. La distribution uniforme est évidemment recouvrante. Il en est de même de la distribution sur les pages d'accueil si toutes les pages connues d'un site sont accessibles à partir de la page d'accueil. C'est aussi le cas de la distribution par importance si, et seulement si, toutes les pages de $V$ ont un degré entrant non nul.

#Thm[
  Soit $Z$ une distribution de probabilité recouvrante, et $A$ une matrice strictement sous-stochastique. La complétion par $Z$ de $A$ est irréductible si, et seulement si, $A$ est sous-irréductible.
] <thm:completion-irreductible>

#Preuve[
  Si $A$ est sous-irréductible, alors de toute page $v$ de $V$, il est possible d'accéder à une page présentant un défaut stochastique $w in chi_s$. En effet, soit $B$ une matrice stochastique irréductible telle que $A < B$, et un chemin reliant $v in V$ à $w in chi_s$ dans le graphe induit par $B$. Soit ce chemin existe dans $G$, et on a ce qu'on veut, soit il n'existe pas, ce qui implique qu'au moins une des pages $w'$ du chemin présente un défaut stochastique, et donc $w' in chi_s$.

  $overline(A)$ est donc irréductible, puisque que n'importe quel couple de pages est relié dans le graphe induit par au moins un chemin passant par $chi_s$.

  Réciproquement, si $A$ n'est pas sous-irréductible, il existe au moins une composante fortement connexe stochastique strictement inférieure à $V$. Cette composante se retrouve inchangée dans $overline(A)$, ce qui prouve que $overline(A)$ n'est pas irréductible.

  C.Q.F.D.
]

=== Source de rang : facteur _zap_ <subsec:zap-ideal>

Afin de régler le problème de l'irréductibilité, Brin _et al._ @Page98 proposent une autre incorporation de la distribution de _zap_ $Z$. Ils remplacent en effet $A$ par $(A + alpha dot (Z dot un)^t)$, et cherchent à résoudre :

$ P = c (A^t + alpha dot Z dot un) dot P $ <eq:pr-sourcederang>

Si $chi_Z = V$, on a alors la garantie d'opérer sur une matrice positive irréductible et apériodique, puisque le graphe sous-jacent est une clique#footnote[Si $Z$ est simplement recouvrante, l'irréductibilité est toujours garantie, puisqu'on peut aller de n'importe quelle page vers n'importe quelle autre page _via_ une page de $chi_Z$. En revanche, on n'a plus forcément apériodicité (il existe des contre-exemples simples, par exemple un arbre-branche complété sur sa racine), même si empiriquement, le problème ne se pose pas pour les graphes du Web.]. Le théorème de Perron-Frobenius assure donc la convergence du processus itératif vers le vecteur propre associé à la valeur propre maximale. Par contre, sauf si $alpha dot Z dot un <= Z dot s^t$, la nouvelle matrice n'est pas stochastique, ni même sous-stochastique, ce qui rend l'interprétation en terme de surfeur aléatoire délicate. Afin de pouvoir plus facilement donner une interprétation au processus itératif, Brin et Page normalisent la matrice en prenant la moyenne pondérée par $d$ de A et de $(Z dot un)^t$ :

$ A -> hat(A) = d dot A + (1-d) dot (Z dot un)^t $

La nouvelle matrice obtenue $hat(A)$ possède la (sous-)stochasticité de $A$, et elle est irréductible et apériodique. Si $A$ est stochastique, $hat(A)$ correspond au cas idéal de la @sec:pr-ideal#footnote[Les cas où $A$ est strictement sous-stochastique seront étudiés en détail dans la @sec:source-sous.]. Le vecteur propre maximal, que nous appellerons PageRank avec facteur _zap_, est alors obtenu par l'@alg:pr-zap. Ce vecteur représente la dernière version académique du PageRank présentée par Brin et Page avant que les méthodes de classement de Google ne deviennent un secret industriel. C'est à lui qu'on fait généralement référence lorsque l'on parle de PageRank.

#alg(caption: [PageRank : modèle par ajout d'un facteur _zap_ (d'après @brin98anatomy)])[
Données\
- une matrice stochastique $A$ ;
- une distribution de _zap_ $Z$ recouvrante ;
- un coefficient de _zap_ $d in ]0, 1[$ ;
- un réel $epsilon$.
Résultat\
Le vecteur propre de probabilité $P$ de $hat(A)^t$ associé à la valeur propre maximale.\
début\
$n<-0$, $P_n <- Z$, $delta <- 2 epsilon$\
tant que $delta > epsilon$ #i:\
$P_(n+1) <- d dot A^t P_n + (1-d) dot Z$\
$delta = norm(P_n - P_(n+1))_1$\
$n<- n+1$#d\
retourner $P_n$
] <alg:pr-zap>


#remarque[
  À titre d'anecdote, signalons dans l'article fondateur du PageRank (@Page98) une légère confusion : l'@alg:pr-completion est proposé pour résoudre l'@eq:pr-sourcederang. Même s'il est précisé que l'introduction de $mu$ peut avoir un léger impact sur l'influence de $Z$#footnote[«The use of [$mu$] may have a small impact on the influence of [$Z$].», _op. cit._], le qualificatif «léger» peut relever de l'euphémisme : dans l'@eq:pr-sourcederang, $Z$ permet d'avoir une matrice apériodique irréductible. On a donc la garantie d'un unique vecteur propre strictement positif. En revanche, dans l'@alg:pr-completion, on travaille implicitement sur la complétion par $Z$ de $A$, et nous venons de voir que l'influence de $Z$ est quasi-nulle dès que $A$ n'est pas sous-irréductible#footnote[Rappelons qu'il suffit pour cela de deux pages qui ne pointent que l'une sur l'autre.] (@thm:completion-irreductible). Heureusement, la confusion a disparu dans les articles suivants, notamment avec la normalisation du facteur _zap_ @brin98anatomy.
] <rem:bourde-bp>

==== Interprétation

Lorsque $A$ est stochastique, la double interprétation de $hat(A)$ est assez simple :

/ Transfert d'importance: avec le facteur _zap_, les pages ne transmettent qu'une fraction $d$ de leur importance. En contrepartie, chaque page $p$ se voit attribuer un PageRank Minimal d'Insertion (PRMI) égal à $(1-d) dot Z(p)$.

/ Surfeur aléatoire: à chaque étape du processus stochastique décrit par $hat(A)$, le surfeur aléatoire va cliquer au hasard sur un des liens sortants, avec une probabilité $d$, ou _zapper_ avec une probabilité $(1-d)$ quelque part sur le graphe en selon la distribution $Z$.

=== Choix de $d$ <subsec:choix_d>

Avant d'aller plus loin, il convient de parler du choix du paramètre $d$ et des raisons qui ont poussé à faire ce choix. Pour commencer, précisons une réalité empirique universelle et inaltérable : $d$ vaut $0,85$, à $0,05$ près. Depuis les débuts du PageRank, $0,85$ a en effet toujours été la valeur de référence, et à ma connaissance, les calculs pratiques de PageRank suivant le modèle de source de rang vu lors de la @subsec:zap-ideal utilisent toujours un $d$ compris entre $0,8$ et $0,9$.

==== Compromis convergence/altération du graphe

D'après le @thm:vp-secondaires, si $A$ est stochastique, ce que l'on peut supposer quitte à effectuer une complétion, les valeurs propres de $hat(A)$ autres que $1$ sont inférieures à $d$ en valeur absolue#footnote[Si $A$ possède plus d'une composante fortement connexe récurrente, $d$ est une valeur propre.]. Cela garantit aux algorithmes @alg:pr-zap et @alg:pr-hybride une convergence géométrique de raison au plus égale à $d$. On a donc intérêt à choisir $d$ le plus petit possible... sauf que plus $d$ est petit, plus l'influence du _zap_, qui est une composante extérieure au graphe intrinsèque du Web, est grande. Un $d$ petit altère, voire dénature le graphe sous-jacent. Choisir le plus grand $d$ garantissant une convergence raisonnable semble donc un bon compromis. Or, les limitations techniques font que le nombre d'itérations réalisables par un moteur de recherche comme _Google_ est de l'ordre de la centaine#footnote[Il faut en effet recalculer le PageRank périodiquement, et avec plusieurs milliards de pages à traiter, chaque itération prend un temps non négligeable.]. $d = 0,85$ offre une précision de $10^(-8)$ au bout de $114$ itérations, $10^(-11)$ au bout de $156$ itérations, et semble donc être heuristiquement le compromis recherché. En effet, comme nous le verrons dans la @sec:kemeny, $10^(-8)$ correspond au seuil de différenciation d'un graphe du Web d'un million de pages, alors que $10^(-11)$ est le seuil de différenciation pour un milliard de pages.

#Thm[
  Soit $A$ une matrice stochastique. Si $x$ est un vecteur propre de $hat(A)^t$ associé à $lambda != 1$, alors $x$ est un vecteur propre de $A^t$ et $hat(A)^t x = d A^t x$. En particulier, $abs(lambda) <= d$.
] <thm:vp-secondaires>

#Preuve[
  Comme $un$ est vecteur propre gauche de $hat(A)^t$ associé à $1$, on a

  $ un hat(A)^t x &= un dot x \
  &= lambda un dot x $

  Comme $lambda != 1$, $un dot x = 0$, d'où

  $ hat(A)^t x &= lambda x \
  &= (d dot A^t + (1-d) dot (Z dot un)) x \
  &= d A^t x $
]

#remarque[
  Dans @kamvar03extrapolation se trouve une preuve du fait que toute valeur propre autre que $1$ (qui est simple pour $hat(A)$) est inférieure à $d$. Dans @langville04deeper, il est montré en plus que les valeurs propres secondaires de $hat(A)$ sont égales à $d$ fois celles de $A$ (les multiplicités de $1$ étant comptées comme secondaires), et les auteurs affirment que leur preuve est plus compacte que celle de @kamvar03extrapolation. Le @thm:vp-secondaires montre en plus que les vecteurs propres secondaires de $hat(A)^t$ sont ceux de $A^t$, et nous affirmons que notre preuve est plus compacte que celle de @langville04deeper. Il ne reste plus qu'à trouver un théorème plus précis que le @thm:vp-secondaires, avec une preuve plus compacte...
]

== Source de rang et matrices sous-stochastiques <sec:source-sous>

Dans le modèle avec source de rang vu lors de la @subsec:zap-ideal, nous avons vu que si l'ajout d'un facteur _zap_ associé à une distribution recouvrante $Z$ garantit l'irréductibilité de $hat(A)$, la stochasticité de $hat(A)$ reste celle de $A$. Lorsque $A$ est sous-stochastique, il faut donc s'adapter, et nous allons voir dans cette section les principales solutions envisageables.

=== Modèle hybride : facteur _zap_ et renormalisation

$hat(A)$ est pseudo-irréductible (puisqu'elle est irréductible). Une première méthode envisageable pour obtenir un point fixe est donc d'appliquer la méthode de la renormalisation simple (cf @sec:pr-renormalisation) à la matrice $hat(A)$.

L'interprétation en terme de surfeur aléatoire est la même que dans le cas où $A$ est stochastique, à ceci près qu'il faut compléter le défaut stochastique de $hat(A)$ par un zap selon la loi définie par le vecteur propre maximal de probabilité associé à $hat(A)$.

=== Complétion et source de rang : $mu$-compensation

La complétion stochastique étant un moyen relativement simple d'assimiler toute matrice sous-stochastique à une matrice stochastique, il est intéressant d'hybrider la méthode de complétion stochastique avec une méthode de type _zap_ ou ajout d'une page virtuelle (voir @sec:pr-pagevirtuelle). On évite ainsi de devoir renormaliser à chaque itération, et on a une plus grande cohérence en terme d'interprétation stochastique. De plus, si on choisit une distribution de complétion égale à la distribution de _zap_ $Z$, on obtient un algorithme très simple (l'@alg:pr-hybride) : l'algorithme de $mu$-compensation. L'interprétation est tout aussi simple : à chaque étape du processus stochastique décrit par $hat(overline(A))$, le surfeur aléatoire va cliquer au hasard sur un des liens sortants (s'il en existe), avec une probabilité $d$. Dans tous les autres cas, il va zapper selon $Z$.

#alg(caption: [PageRank : $mu$-compensation (d'après @kamvar-exploiting)])[
Données
- une matrice (sous-)stochastique $A$ ;
- une distribution de _zap_ et de complétion $Z$ recouvrante ;
- un coefficient de _zap_ $d in ]0, 1[$ ;
- un réel $epsilon$.
Résultat\
Le vecteur propre de probabilité $P$ de $hat(overline(A))^t$ associé à la valeur propre maximale.\
début\
$n<-0$, $P_n <- Z$, $delta<- 2 epsilon$\
tant que $delta > epsilon$ #i:\
$P_(n+1) <- d dot A^t P_n$\
$mu <- norm(P_n)_1 - norm(P_(n+1))_1$\
$P_(n+1) <- P_(n+1) + mu Z$\
$delta <- norm(P_n - P_(n+1))_1$\
$n<- n+1$#d\
retourner $P_n$
] <alg:pr-hybride>

=== PageRank non-compensé

L'algorithme de PageRank non-compensé consiste à calculer $P_(n+1) = d A^t P_n + (1-d) Z$, exactement comme dans l'@alg:pr-zap, sans se préoccuper de la renormalisation. On obtient un vecteur strictement positif, qui peut servir à définir un PageRank, comme le montre le @thm:non-compense et l'interprétation qui s'en suit.

#Thm[
  Soit $A$ une matrice sous-stochastique, $d$ un facteur de _zap_, $0 < d < 1$, et $Z$ une distribution de probabilité recouvrante pour le graphe induit par $A$.

  La suite $P_(n+1) = d A^t P_n + (1-d) Z$ converge géométriquement, avec une raison inférieure ou égale à $d$, vers un unique point fixe $P$, quelque soit le vecteur initial $P_0$. $P$ est un vecteur strictement positif, et pour toute complétion $overline(A)$ de $A$, si $overline(P)$ est la distribution de probabilité associée à $hat(overline(A))$, on a $P <= overline(P)$, avec inégalité totalement stricte sauf si $A$ est stochastique (i.e. $A = overline(A)$).
] <thm:non-compense>

#Preuve[
  Comme $forall X in RR^n$, $norm(A^t X)_1 <= norm(X)_1$, l'application $X -> d A^t X + (1-d) Z$ est $d$-lipschitzienne. Elle possède donc un point fixe unique vers lequel toute suite $X_(n+1) = d A^t X_n + (1-d) Z$ converge géométriquement, avec une raison inférieure ou égale à $d$#footnote[Notons au passage que dans le cas où $A$ est stochastique, nous avons là une preuve très simple de la convergence de raison $d$, mais le @thm:vp-secondaires donne quand même plus d'informations...].

  Ce point fixe $P$ vérifie $P = d A^t P + (1-d) Z$, et vaut donc :

  $ P = (1-d) sum_(k=0)^infinity (d A^t)^k Z $ <eq:p-noncompense>

  En particulier, il est strictement positif, puisque comme $Z$ est recouvrante, pour tout $w$ dans $V$, il existe $v$ dans $chi_Z$, $k$ dans $NN$ tel que $((d A)^k)_(v,w) > 0$, et donc

  $ P(w) >= (1-d) ((d A)^k)_(v,w) Z(v) > 0 $
]

=== Comparaison : algorithmes $mu$-compensé ou non-compensé ?

Il existe un lien très fort entre l'algorithme $mu$-compensé et l'algorithme non-compensé : ils donnent le même résultat, comme le montre le @thm:nonc-mu.

#Thm[
  Soit $A$ une matrice sous-stochastique, $Z$ une distribution recouvrante. Si $overline(P)$ est le PageRank obtenu par $mu$-compensation (cf @alg:pr-hybride), et $P$ le PageRank non-compensé, point fixe de l'application $X -> d A^t X + (1-d) Z$, alors $P$ est homogène à $overline(P)$.
] <thm:nonc-mu>

#Preuve[
  Par passage à la limite, il est facile de voir que $overline(P)$ vérifie

  $ overline(P) = d A^t overline(P) + mu Z quad "où" mu = 1 - norm(d A^t overline(P))_1 $

  On en déduit

  $ overline(P) = mu sum_(k=0)^infinity (d A^t)^k Z $ <eq:p-compense>

  Les @eq:p-noncompense et @eq:p-compense nous donnent $(1-d) overline(P) = mu P$.
]

==== Convergence

Les tests que nous avons pu effectuer montrent que avec le choix de $Z$ comme distribution initiale, il n'y a aucune différence significative entre la convergence de l'algorithme de $mu$-compensation et celui non-compensé. La convergence est dans les deux cas très rapide lors des premières itérations, et se stabilise ensuite vers une convergence de raison $d$ (cf boucle principale de la @fig:remplumage).

==== Vitesse des itérations

La $mu$-compensation doit calculer le paramètre $mu$ à chaque itération, alors que la non-compensation n'en a pas besoin. Est-ce que cela a une grande influence sur les performances ?

- Si la matrice $A$ ne tient pas en mémoire, le facteur limitant dans le calcul d'une itération est la multiplication de $A^t$ par $P_n$. Le temps utilisé pour compenser est alors négligeable, et la vitesse des itérations n'a alors aucune influence dans le choix entre les deux algorithmes.
- En revanche, si $A$, ou même simplement la matrice d'adjacence, tient en mémoire, le calcul et l'incorporation de $mu$ prend une durée comparable à celle du calcul de $A^t P$. En fait, tout calcul de norme alourdit de manière non-négligeable le calcul d'une itération, et même le calcul du paramètre de convergence $delta$ diminue considérablement les performances. On aboutit ainsi à l'algorithme SpeedRank (#ref(<alg:speedrank>, supplement: none)), qui calcule le PageRank non-compensé en estimant grossièrement le nombre d'itérations nécessaires à une bonne convergence. Nos expériences ont mis en évidence un gain de vitesse de plus de $300%$ sur les itérations entre SpeedRank et l'@alg:pr-hybride, ce qui compense plus que largement la légère sur-estimation du nombre d'itérations nécessaires pour converger.

En terme de performances, l'algorithme $mu$-compensé est donc à proscrire si l'on travaille sur des «petits» graphes. On s'étonnera au passage que Kamvar _et al._ utilisent la $mu$-compensation dans leur algorithme BlockRank @kamvar-exploiting, qui est justement basé sur la décomposition du PageRank sur des petits graphes. Pour des spécialistes de l'optimisation du calcul de PageRank (cf @kamvar03extrapolation), il est curieux de passer à côté d'un gain de vitesse de $300%$...

#alg(caption: [SpeedRank : calcul rapide du PageRank dans le cas où la matrice d'adjacence tient en mémoire vive])[
Données
- La matrice d'adjacence $M$ d'un graphe $G = ((R union S), E)$ quelconque, $R$ étant l'ensemble des sommets de degré sortant non nul ;
- une distribution de probabilité $Z$ recouvrante ;
- un coefficient de _zap_ $d in ]0, 1[$ ;
- un réel $epsilon$.
Résultat\
Avec une précision d'au moins $epsilon$, un vecteur $P$ homogène au PageRank $mu$-compensé sur $G$.\
début\
$P <- Z$, $Y <- (1-d) Z$\
$C : v -> cases(d/(d(v)) #no-emph("si") v in R, 0 "sinon")$\
pour $i$ variant de $1$ à $ln(epsilon)/ln(d)$ #i:\
$P <- M^t (C times.o P) + Y$ #comment[$times.o$ : produit terme à terme]#d\
retourner $P$
] <alg:speedrank>

==== Effeuillage-Remplumage <subsubsec:effeuilage>

En pratique, les algorithmes de PageRank sont rarement appliqués sur le graphe $G = (V, E)$ tout entier. On utilise très souvent une technique dite d'«effeuillage-remplumage» : le PageRank est d'abord calculé sur le graphe $(R, E_R)$, où $R$ est l'ensemble des sommets de $V$ possédant au moins un lien sortant. $(R, E_R)$ est appelé graphe effeuillé, ou encore rafle. Une fois qu'une bonne convergence est atteinte, on procède au «remplumage» : on se replace sur le graphe $G$ et on effectue quelques itérations de PageRank avec le PageRank sur $R$ comme estimation initiale.

Le problème est que le PageRank sur le graphe effeuillé n'est pas forcément une bonne estimation du PageRank sur $G$, comme le montre la @fig:remplumage : à cause du remplumage, le facteur de convergence $delta$ est quasiment réinitialisé. Si on veut de nouveau atteindre la condition de convergence ($delta < epsilon$), il faut effectuer presqu'autant d'itérations qu'en partant de la distribution $Z$.

#figure(
  image("../figures/remplumage.pdf", width: 80%),
  caption: [Convergence des PageRank $mu$-compensé et non-compensé ; problème du remplumage],
) <fig:remplumage>

La méthode d'effeuillage-remplumage présente quand même un intérêt si on limite le nombre d'itérations de la phase de remplumage : comme la boucle principale se fait sur la rafle, les itérations sont plus rapides. Quant au vecteur final, bien que ce ne soit pas un vecteur stationnaire, il est à mi-chemin entre le PageRank sur la rafle et celui sur $G$, et le fait que ce soit ce vecteur qui est utilisé en pratique semble indiquer que le classement que l'on obtient est digne d'intérêt.

== Convergence en norme $1$ et convergence du classement <sec:kemeny>

Dans tous les algorithmes de PageRank que nous avons présentés, comme dans tous ceux que nous allons présenter, nous utilisons comme critère de convergence la convergence en norme $1$ d'une suite $P_n$ de vecteurs positifs. Ainsi, lorsque qu'une source de rang associée à un facteur _zap_ $d$ est utilisée et que le critère de convergence $epsilon$ est atteint, nous savons que l'erreur par rapport au vecteur limite est d'au plus $epsilon/(1-d)$. Pourtant, seul le classement induit par $P$ nous intéresse _a priori_, puisque l'intérêt principal du PageRank est de fournir un ordre d'importance sur les pages Web considérées#footnote[Dans la réalité, les choses sont légèrement différentes. Le classement renvoyé pour une requête donnée est vraisemblablement le résultat de la confrontation de plusieurs estimations d'importances, la pertinence et le PageRank étant les principales d'entre elles. Connaître le PageRank quantitatif des pages peut alors avoir un intérêt.].

=== Distance de Kendall normalisée

Une première solution est de comparer à chaque itération les classements induits, et d'arrêter lorsqu'il n'y a plus de changement. On peut également définir une distance sur les classements et remplacer la convergence en norme $1$ par une convergence sur les classements. Une distance assez classique sur les classements est la distance de la différence symétrique, ou distance de Kendall#footnote[Merci à François Durand et à son rapport de maîtrise @durand007experience pour m'avoir fait connaître la distance de Kendall.] : si $sigma_1$ et $sigma_2$ sont deux classements, présenté sous la forme de permutations, alors la distance de Kendall entre ces deux permutations est le nombre minimum d'inversion de deux éléments conjoints nécessaires pour passer de l'une à l'autre. On peut montrer que cette distance est invariante par translation et que la distance d'une permutation $sigma$ à l'identité est :

$ "dist"(sigma, "id") = sum_(i < j) chi_(sigma(i) > sigma(j)) $

La distance entre deux permutations $sigma_1$ et $sigma_2$ est donc $"dist"(sigma_1, sigma_2) = "dist"(sigma_1 compose sigma_2^(-1), I d)$.

Comme la plus grande distance possible $"dist"_"max"$ entre deux permutations de taille $n$ est celle entre deux classements inversés, à savoir $(n(n-1))/2$, on pourra si l'on veut un critère de convergence indépendant de la taille du classement considérer la distance de kendall normalisée par $"dist"_"max"$.

=== Densité de PageRank

Par un simple raisonnement d'ordre de grandeur, il est possible d'établir un lien entre $epsilon$ et la convergence du classement. Le point de départ est l'étude du rapport entre le classement d'une page et son PageRank. La @fig:classvspage représente ce lien pour deux modèles de PageRank que nous allons étudier plus en détail : le PageRank $mu$-compensé standard avec _zap_ uniforme sur $V$, ainsi que le PageRank $mu$-compensé avec technique d'effeuillage-remplumage et _zap_ uniforme sur $R$. Le facteur de _zap_ $d$ vaut évidemment $0,85$.

#figure(
  image("../figures/classementvspagerank.pdf", width: 80%),
  caption: [Lien entre le classement d'une page et son PageRank],
) <fig:classvspage>

La régularité des courbes#footnote[Pour chacun des deux PageRanks étudiés ici, nous n'avons représenté qu'une seule courbe, mais expérimentalement, les autres échantillons étudiés génèrent des courbes extrêmement similaires.] nous incite à considérer la densité mésoscopique de pages à un PageRank donné : on cherche à savoir quel est le nombre $d N$ de pages dont le PageRank est compris entre $p$ et $p + d p$. On se place pour cela à l'échelle mésoscopique, c'est-à-dire que l'on suppose $d p << p$ et $d N >> 1$. Expérimentalement, nous avons constaté que l'hypothèse mésoscopique était tout à fait réaliste sur des graphes de plus d'un million de sommets. Nous avons également observé qu'il existait, pour chaque modèle de PageRank, une fonction $rho$, relativement indépendante du graphe du Web considéré#footnote[Dans le cas du PageRank avec effeuillage-remplumage, ceci est valable pour une proportion de pages sans lien donnée. Empiriquement, cette constante est souvent un invariant de crawl.], telle que, si $n$ est le nombre de pages du graphe,

$ (d N)/(d p) approx n^2 rho(n p) $

$rho$ est la densité mésoscopique normalisée (indépendante de la taille $n$ du graphe) typique du modèle de PageRank considéré. La @fig:prdensity montre des mesures expérimentales de $rho$ correspondant aux deux modèles étudiés ici.

#figure(
  image("../figures/pagerankdensity.pdf", width: 80%),
  caption: [Densité mésoscopique normalisée de pages en fonction du PageRank],
) <fig:prdensity>

== Modèles avec page virtuelle <sec:pr-pagevirtuelle>

L'ajout d'un facteur _zap_ est parfois appelé méthode d'irréductibilité maximale, dans le sens où si $chi_Z = V$, alors le graphe sous-jacent devient une clique. Il est souvent reproché à cette méthode d'être trop intrusive et de dénaturer la structure du graphe du Web. La méthode de complétion, en rajoutant $abs(chi_Z) dot abs(chi_s)$ liens fictifs, peut aussi être considérée comme intrusive.

Une alternative est d'employer des méthodes dites d'irréductibilité minimale#footnote[Cf @tomlin03paradigm.], c'est-à-dire d'ajouter une page virtuelle qui va jouer le rôle de «hub». Ce type de méthodes est entre autres employé par @abiteboul03adaptative @tomlin03paradigm.

=== Page virtuelle de _zap_

Le principe de la page virtuelle de _zap_ est simple : rajouter une $(n+1)$#super[ème] page, pointée et pointant vers toutes les autres, et contrôlée par $d$ et $Z$.

Formellement, si $A$ est une matrice stochastique (éventuellement complétée), on considère la matrice

$ tilde(A) = mat(d A, (1-d) un^t; Z^t, 0) $

Le vecteur asymptotique de probabilité correspondant est obtenu par l'@alg:pr-virtuelle.

#alg(caption: [PageRank : modèle avec page virtuelle])[
Données
- une matrice stochastique $A$ ;
- une distribution de _zap_ $Z$ recouvrante ;
- un coefficient de _zap_ $d in ]0, 1[$ ;
- un réel $epsilon$.
Résultat\
Le vecteur propre de probabilité $(P, v)$ de $tilde(A)^t$ associé à la valeur propre maximale.\
début\
Choisir un vecteur positif $P_0$ et un réel positif $v_0$\
$n<- 0$, $delta <- 2 epsilon$\
tant que $delta > epsilon$ #i:\
$P_(n+1) = d dot A^t P_n + v_n dot Z$\
$v_(n+1) = (1-d) norm(P_n)_1$\
$delta = norm(P_n - P_(n+1))_1$\
$n<- n+1$ #d\
retourner $P_n$
] <alg:pr-virtuelle>

=== De l'utilité de la page virtuelle

@thm:vp-virtuelle montre qu'_a priori_, dès que $d > 0,5$, l'utilisation d'une page virtuelle de _zap_ ne change strictement rien par rapport au rajout d'un facteur _zap_, aussi bien au niveau du vecteur asymptotique#footnote[En effet, à un poids de $(1-d)$ sur la page virtuelle près, les vecteurs propres maximaux sont identiques.] que de la convergence (les valeurs propres autres que $1$ sont inférieures à $max(d, 1-d)$ en valeur absolue).

#Thm[
  Soit $A$ une matrice stochastique. Comme $tilde(A)$ est stochastique, irréductible et apériodique, on sait que $1$ est une valeur propre singulière et dominante. Plus précisément, si $(lambda, (P, v))$ vérifie $tilde(A)^t (P, v) = lambda (P, v)$, alors on est dans l'un des 3 cas suivants :
  - Soit $lambda = 1$, et $(P, v)$ est alors homogène à $(hat(P), (1-d))$, où $hat(P)$ est la distribution de probabilité telle que $hat(P) = hat(A)^t hat(P)$.
  - Soit $lambda = d - 1$.
  - Soit $lambda$ ne vaut ni $1$, ni $d - 1$. $P$ est alors un vecteur propre de $A^t$, $v$ est nul, et on a $tilde(A)^t (P, 0) = (d A^t P, 0)$. En particulier, $abs(lambda) <= d$.
] <thm:vp-virtuelle>

== Gestion des ressources physiques <sec:pr-ressources>

Avant de clore ce chapitre, je voudrais mettre en avant quelques considérations techniques fondamentales. Le lecteur aura peut-être remarqué qu'aucun des algorithmes présenté ne fait jamais intervenir explicitement les matrices dont on calcule le vecteur propre maximal ($overline(A)$, $hat(A)$, $hat(overline(A))$ et $tilde(A)$). C'est un phénomène général : si on veut que toutes les constantes de l'algorithme puissent tenir en mémoire vive#footnote[Il est possible, voire nécessaire pour les très grands graphes, d'effectuer des calculs de PageRank sans charger toutes les constantes en mémoire vive et avec des accès disques optimisés @abiteboul03adaptative, mais chercher à minimiser la taille des constantes reste très important quand on veut faire un algorithme de PageRank.], il est nécessaire de réfléchir un minimum. En effet, il faut se souvenir que $A$ est une matrice creuse contenant $n dot overline(d)$ éléments non nuls, où $overline(d)$ est le degré moyen. $overline(d)$ étant relativement constant (entre $7$ et $11$ selon la prise en compte des pages non visitées et l'éventuel filtrage des liens), cela fait approximativement une taille linéaire en $n$, ce qui est à la fois beaucoup compte tenu des tailles des graphes considérés, et un minimum si on veut utiliser la structure du Web. Les matrices implicites générées par complétion et usage du facteur _zap_ sont loin d'être creuses, et leur taille peut être en $n^2$. On voit ici l'intérêt d'user d'astuces de réécriture dans les algorithmes de PageRank afin de ne jamais faire intervenir de matrice moins creuse que $A$.

Personnellement, j'effectue mes expériences de PageRank avec simplement la matrice d'adjacence, stockée sous forme de matrice logique creuse (_logical sparse matrix_) et quelques vecteurs de taille $n$ : $D : i -> d(i)$, $Z$, $s$, $T$... Les algorithmes @alg:speedrank et @alg:pr-effectif donnent des exemples du traitement effectif des algorithmes. Il est ainsi possible de traiter jusqu'à 8 millions de sommets sur un PC domestique avec 1 Go de mémoire vive, en conservant toutes les constantes en mémoire et en réalisant un minimum d'opérations#footnote[Cela peut paraître peu quand on sait qu'un Go de mémoire vive permet de stocker le PageRank de $125$ millions de pages en double flottant. Il faut cependant toujours se rappeler du gain colossal que l'on obtient quand la matrice d'adjacence est en mémoire vive.]. Pour aller plus loin, il faut utiliser des techniques de compression transparente du graphe#footnote[Voir par exemple le projet Webgraph @Webgraph.].

#alg(caption: [Algorithme hybride : page virtuelle de complétion et $mu$-compensation])[
Données
- une matrice d'adjacence $M$ d'un graphe quelconque ;
- une distribution de probabilité $Z$ recouvrante ;
- un coefficient de _zap_ $d in ]0, 1[$ ;
- un réel $epsilon$.
Résultat\
Le vecteur propre de probabilité $P$ de $hat(overline(underline(A)))^t$ associé à la valeur propre maximale.\
début\
$n<- 0$, $P_n <- Z$, $delta <- 2 epsilon$\
$T<- 1 / (M un_n^t + un_n^t)$ #comment[$1\/dot$ : inverse terme à terme]\
tant que $delta > epsilon$ #i:\
$P_(n+1) <- d dot M^t (T times.o P_n)$ #comment[$times.o$ : produit terme à terme]\
$mu <- norm(P_n)_1 - norm(P_(n+1))_1$\
$P_(n+1) <- P_(n+1) + mu Z$\
$delta <- norm(P_n - P_(n+1))_1$\
$n<- n+1$#d\
retourner $P_n$
] <alg:pr-effectif>
