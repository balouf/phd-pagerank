// =============================================================================
// Chapitre 2 : Chalutiers et tailles du Web
// =============================================================================

#import "../templates/prelude.typ": *

#import "@preview/subpar:0.2.2"

= Chalutiers et tailles du Web <cl-taille>

#citation([Michel #smallcaps[Houellebecq], _Lanzarote_])[Le monde est de taille moyenne.]
#citation([Bill #smallcaps[Vaughan]])[
La taille ne fait pas tout. La baleine est en voie d'extinction alors que la fourmi se porte bien.
]
#citation([Hugo von #smallcaps[Hofmannsthal]])[
Il faut cacher la profondeur. Où ça ? À la surface.
]

#v(1cm)

#lettrine("Maintenant")[
  que nous avons défini un cadre sur lequel travailler (le Web accessible), la question de savoir quels objets nous allons étudier se pose. D'un point vue mathématique, le Web accessible peut être infini dénombrable --- selon la RFC 2616 @rfc2616 --- ou fini --- car il n'existe qu'un nombre fini de serveurs et que chacun possède une taille limite d'URL. Il répond en tout cas à une certaine définition physicienne de l'infini, qui est celle que nous utiliserons ici : _grand devant le nombre d'atomes de l'univers_. Le Web accessible contient en effet beaucoup de nids de pages quasi-infinis. La page qui pointe vers toutes les pages, bien sûr, mais aussi des serveurs mal configurés, ou même des sites commerciaux qui essaient, en créant une _infinité_ de pages, d'augmenter leur PageRank (voir Partie~II, @sec:alter). Pour donner une exemple concret, lors de la présentation de leur article _Extrapolation methods for accelerating PageRank computations_ @kamvar03extrapolation, les auteurs ont raconté comment une de leur expérience a été perturbée par un site allemand qui occupait 90~% des pages qu'ils avaient indexées. Vérification faite, le site en question était un site pornographique qui espérait grâce à une infinité de pages étroitement reliées entre elles avoir un bon classement dans les moteurs de recherche (principe des _Free For All_, aussi appelés _farm links_ ou _pouponnières_).
]

En conclusion, il est impossible d'indexer _tout_ le Web accessible, de même que parler de sa taille n'a plus de sens#footnote[On remarquera que si, il y a quelques années, estimer la taille du Web était un sujet _à la mode_ (voir @broder98technique @murray00sizing @lawrence98searching @lawrence99accessibility @bergman00deep), plus personne ne s'y aventure depuis deux ans, et le point de vue évoqué ici semble aujourd'hui partagé (voir notamment @dahn00counting @eiron04ranking).]. En l'absence d'accès physique aux serveurs, les seules données tangibles que nous ayons à notre disposition sont donc les _crawls_, c'est-à-dire les zones du Web effectivement découvertes, et éventuellement indexées, par des entreprises commerciales (moteurs de recherche) ou des institutions publiques. L'objet de ce chapitre sera de définir précisément les _crawls_, de donner des ordres de grandeurs, et de voir dans quelle mesure il est possible de comparer des _crawls_ ou de mesurer une certaine qualité.

== Les chalutiers du Web <chalut-def>

Les _crawleurs_, ou _spiders_, ou _agents_, sont les chalutiers qui parcourent le Web afin de générer ces morceaux de Web appelés _crawls_. Il y a deux principaux types de crawleurs : les crawleurs statiques et les crawleurs dynamiques. Le principe de tous les crawleurs statiques est le même : à partir d'un ensemble de pages initial, ils analysent les hyperliens contenus dans ces pages, essaient de récupérer les pages pointées par ces hyperliens, et ainsi de suite, pour récupérer ainsi une partie sans cesse croissante des pages du Web accessible. Chaque page n'est _a priori_ récupérée qu'une seule fois, et on arrête le procédé quand on estime le moment voulu (suffisamment de pages récupérées, croissance devenue négligeable...). Le crawl _statique_ que l'on obtient alors est constitué de :

- un ensemble de pages connues, qui est la réunion de l'ensemble initial et de l'ensemble des pages découvertes ;
- un ensemble de pages indexées, sous-ensemble de celui des pages connues constitué des pages effectivement parcourues par le crawl ;
- un ensemble d'hyperliens issus des pages indexées et pointant vers les pages connues.

Un crawleur dynamique, lui, n'est pas prévu pour s'arrêter, mais pour parcourir perpétuellement le Web et revisiter périodiquement les pages qu'il a parcouru @abiteboul03adaptative.

Ce que nous appelons crawleur est en fait l'ensemble des moyens logiciels et matériels permettant de réaliser un crawl. Qu'est-ce qui va faire qu'un crawleur va produire un certain crawl et pas un autre ?

- La date à laquelle le crawl démarre.
- L'ensemble des pages de départ.
- La stratégie d'exploration des nouvelles pages (dans quel ordre récupérer quelles pages ?).
- Les limitations techniques : bande passante, capacité de stockage et de traitement, temps disponible...

Ceci est valable pour tous les types de crawleurs, même si asymptotiquement, seules les stratégies d'exploration et les limitations techniques jouent un rôle important pour les crawleurs dynamiques.

=== Création de l'ensemble des pages initial

Il va de soi que le choix d'un bon ensemble de départ est fondamental pour l'efficacité d'un crawleur. Pour des raisons commerciales, il est difficile d'obtenir les ensembles de départ des grands moteurs de recherche. Beaucoup de gens s'accordent cependant pour estimer que les grands moteurs de recherche utilisent :

- un sous-ensemble _bien choisi_ de l'ensemble des pages obtenues par les crawls précédents @cho98efficient. Les pages d'accueil des _annuaires_, en particulier, semblent être des candidats de choix pour faire partie de l'ensemble initiale @craven04google ;
- des nouvelles pages soumises par l'un des nombreux procédés de _référencement_ existants (parfois payants) ;
- il est possible que soient également utilisées quelques techniques plus ou moins rusées pour découvrir des nouvelles pages, comme analyser les logs des serveurs Web, ou essayer de remonter l'arbre des #acrpl("URL") des pages « isolées » (rumeurs lues sur différentes pages du site `http://www.webrankinfo.com`).

Pour conclure avec le choix de l'ensemble initial, signalons que c'est cet ensemble qui détermine en grande partie la structure de nœud papillon d'un _graphe du Web_ (voir @noeud-pap).

=== Stratégies d'exploration <sec:explore-strategies>

Un crawleur idéal qui pourrait récupérer et traiter une infinité de pages par unité de temps n'aurait pas de souci pour obtenir tout le Web théoriquement atteignable par hyperliens à partie de l'ensemble initial. Toutes les méthodes de parcours exhaustif (en largeur ou en profondeur par exemple) aboutiraient à un même résultat optimal. Mais les crawlers réels sont limités par leur bande passante, leur capacité de traitement ainsi que le nombre de requêtes par serveur et par minute, qui doit tenir compte autant des règles de politesse que du risque d'être banni.

Toutes ces contraintes font que, à un instant donné, on peut considérer qu'il existe une limite finie au nombre de pages qu'un moteur de recherche précis peut indexer, et il semble que ce nombre ait toujours été, quelque soit le moteur de recherche considéré, assez inférieur aux estimations finies du Web Indexable @bergman00deep @lawrence98searching @lawrence99accessibility @henzinger99measuring @broder98technique.

Chaque moteur possède donc une barrière physique au nombre de pages qu'il peut indexer. Par exemple, pour et d'après Google, cette barrière est d'environ 4 milliards de documents. La stratégie d'exploration (couplée avec le choix de l'ensemble initial) va décider quels seront ces 4 milliards de pages, et donc dans une large mesure quelle sera la qualité#footnote[Au sens vague...] d'un crawl. Un moteur de recherche dont les agents se perdraient dans les pouponnières et autres _pages qui pointent vers toutes les pages_ aurait sûrement peu de succès. C'est pourquoi certains moteurs, comme _AltaVista_ et _Teoma_, évitent la pratique du _Deep Crawl_#footnote[Le _Deep Crawl_ consiste à essayer de récupérer le maximum de pages web d'un site donné.], alors que d'autres, comme Google, répertorient les pouponnières dans une liste noire.

La stratégie peut aussi modifier négativement la barrière d'un moteur de recherche, si elle ne cherche pas à optimiser les ressources disponibles. Par exemple, à cause de la limite du nombre de requêtes par site, la bande passante prise par l'exploration d'un serveur est souvent minime devant la bande passante disponible, d'où la quasi-nécessité d'explorer plusieurs serveurs en parallèle. Pour les mêmes raisons, il vaut mieux toujours avoir un serveur rapide parmi les serveurs que l'on est en train de questionner.

Toutes ces contraintes « physiques » prises en compte, on distingue principalement deux philosophies dans les stratégies d'exploration connues.

- Traditionnellement, les moteurs de recherche employaient semble-t-il une exploration de type _parcours en largueur_, les pages découvertes en premier étant explorées prioritairement (sous réserve des contraintes décrites ci-dessus) @broder00graph.
- Des méthodes d'exploration inspirées des marches aléatoires se développent également (voir @henzinger99measuring et, dans une certaine mesure, la stratégie _greedy_ de @abiteboul03adaptative). Ces méthodes présentent l'avantage de récupérer plus facilement les pages importantes au sens du PageRank @henzinger99measuring, voire d'estimer le PageRank de manière dynamique @abiteboul03adaptative. Les liens entre PageRank et marche aléatoire seront développés lors de la Partie~II.

== Tailles et évolutions des crawls <cl-taille-web>

Maintenant que le concept de crawl a été grossièrement expliqué, nous allons donner quelques statistiques sur les ordres de grandeur considérés lorsque l'on parle de crawl pour les principaux moteurs de recherches.

=== Selon les organisateurs

Ces données ont pour la plupart été obtenues sur le site #link("http://searchenginewatch.com/").

#figure(
  image("../figures/se-sizes.gif", width: 11cm),
  caption: [Nombre de pages revendiquées par différents moteurs de recherche à la date du 2 septembre 2003]
) <se-sizes>

La @se-sizes présente les tailles revendiquées des cinq moteurs de recherche milliardaires à la date du 2 septembre 2003. Si on étudie l'évolution respective des différents moteurs de recherche, on peut distinguer plusieurs grandes périodes de bouleversement, qui correspondent à des périodes de compétition intense entre les moteurs. Ces _guerres du Crawl_ sont représentées en détail @se-guerres. Chacune de ces guerres s'est soldée pour le ou les vainqueurs par le franchissement d'une barre psychologique.

Entre décembre 1997 et juin 1999 a lieu la première _guerre du Crawl_, à l'issue de laquelle AltaVista dépasse la barre des 150 millions, talonné de près par NorthernLight (@se-war1).

La deuxième _guerre du crawl_ (septembre 1999 -- juin 2000) est marquée par un match serré entre Altavista et AllTheWeb, qui se conclut par la victoire écrasante de... Google, qui va se développer jusqu'à dépasser le milliard et demi de pages revendiquées, ce qui impose un nouveau standard (@se-war2).

La troisième guerre (juin 2002 -- décembre 2002) débute par un court passage d'AllTheWeb en tête de course. Google et Inktomi ripostent presque aussitôt, et en l'espace de six mois franchissent le cap des 3 milliards de pages web. Quelques mois plus tard, AllTheWeb se remet au diapason (@se-war3).

#subfig(
  figure(
    image("../figures/se-evolution.gif", width: 7.5cm),
    caption: [Évolution des moteurs (12--95 - 09--03)],
  ), <se-evolution>,
  figure(
    image("../figures/se-war1.gif", width: 7.5cm),
    caption: [Guerre du Crawl I (12--97 - 06--99)],
  ), <se-war1>,
  figure(
    image("../figures/se-war2.gif", width: 8.2cm),
    caption: [Guerre du Crawl II (09--99 - 06--00)],
  ), <se-war2>,
  figure(
    image("../figures/se-war3.gif", width: 6.8cm),
    caption: [Guerre du Crawl III (06--02 - 12--02)],
  ), <se-war3>,
  columns: (1fr, 1fr),
  caption: text(size: 10pt)[Guerres du Crawl. Légende : AV=AltaVista, ATW=AllTheWeb, EX=Excite, GG=Google, GO=GO/Infoseek, INK=Inktomi, LY=Lycos, NL=Northern Light, TMA=Teoma. Unité : 1 million de pages (@se-war1 et @se-war2) ou 1 milliard de pages (@se-evolution et @se-war3).],
  label: <se-guerres>,
) 

Actuellement (été 2004), Google affirme indexer plus de 4 milliards de pages, mais le champ de bataille s'est déplacé. La bataille entre Google et Yahoo (qui sous-traitait avec Google jusqu'en février 2004, et qui depuis utilise la base de donnée d'Inktomi) essaie de se faire plus subtile, le but étant d'avoir les résultats « les plus compréhensibles et les plus pertinents ». Yahoo préparerait d'ailleurs sa propre version du PageRank de Google, le WebRank.

=== Selon la police <subsec:se-police>

Tous les chiffres que nous venons de voir sont ceux annoncés par les moteurs de recherche eux-mêmes. Comme nous sommes dans un contexte de concurrence commerciale, il est légitime de s'interroger sur la fiabilité de ces chiffres, avec le problème de définir une méthodologie adéquate.

Le site _SearchEngineShowdown_ @showdown, administré par Greg Notess, propose une méthode d'estimation grossière de la taille effective des moteurs de recherche. Le principe est d'effectuer plusieurs requêtes parallèlement sur les différents moteurs de recherche que l'on veut comparer, et de postuler que le nombre de réponses renvoyées par chaque moteur est en première approximation proportionnel au nombres d'#acrpl("URL") connues par le moteur de recherche. Si l'on connaît la taille réelle d'un des moteurs, on peut alors par une simple règle de trois estimer la taille réelle des autres moteurs. Or, en décembre 2002, il était possible de connaître la taille exacte du moteur AllTheWeb simplement en soumettant la requête `url.all:http`#footnote[Merci à Greg Notess, webmaster du site SearchEngineShowdown de m'avoir communiqué cette méthode, même si elle ne marche plus aujourd'hui. La requête _url.all:http_ ne marche en effet qu'avec les moteurs utilisant la technologie Fast, laquelle n'est plus utilisée par les grands moteurs depuis le 1#super[er] avril 2004 (et ce n'est pas un canular...).].

La @fig:se-showdown compare les tailles revendiquées et estimées par la méthode de Greg Notess de plusieurs moteurs de recherche. On peut facilement distinguer trois catégories de moteur de recherche, qui montrent autant les éventuelles exagérations des moteurs que le biais introduit par les requêtes :

/ Les réalistes : _Google_, _AllTheWeb_ et _WiseNut_ ont des valeurs estimées et revendiquées extrêmement proches, et tendent à prouver que la méthode d'estimation présente une certaine fiabilité.

/ Les sites qui voulaient trois milliards : Les estimations des taille de HotBot et MSN Search sont en nette contradiction avec les valeurs revendiquées. Il s'agit de moteurs basés sur la technologie Inktomi. Selon Inktomi, tous les ordinateurs formant leur base de données ne sont pas accessibles en même temps, et donc on ne peut jamais accéder à la totalité de la base. De plus, il est possible que les partenaires d'Inktomi (HotBot et MSN Search dans le cas présent) n'utilisent qu'une partie de la base de données, pour des raisons pratiques ou commerciales. Pour Greg Notess, ces estimations reflètent donc la portion de la base de données réellement disponibles au moment où les requêtes ont été faites. Il est évident que le biais de la méthode de Notess nous empêche de faire des affirmations catégoriques, mais l'on ne peut s'empêcher de soupçonner le chiffre de trois milliards d'être une réponse publicitaire aux trois milliards de Google (rappel : nous sommes à la fin de la troisième _guerre du Crawl_).

/ Les modestes : AltaVista, Teoma, NLResearch et Gigablast semblent revendiquer beaucoup moins que leur taille réelle, ce qui ne semble guère logique. D'après Greg Notess, l'explication de ce paradoxe vient de la façon de comptabiliser les pages connues, mais non-indexées. En effet, les sites que nous avons appelés _réalistes_ semblent revendiquer leurs #acrpl("URL") connues, indexées ou non, alors que les _modestes_ se restreignent aux pages effectivement indexées. Quand on sait que les pages non-indexées représentent au moins 25~% des pages connues, mais moins de 1~% des réponses aux requêtes#footnote[Il existe cependant des requêtes ne renvoyant que des pages non indexées. Je recommande ainsi, sous _Google_, la requête `site:.xxx`, qui renvoyait, en août 2004, 765 pages non-indexées (car non existantes, le TLD .xxx n'existant pas lors de l'expérience), dont seulement 495 pertinentes...] (sources : _SearchEngineShowdown_), on a un début d'explication du phénomène.

#figure(
  image("../figures/se-showdown.pdf", width: 14cm),
  caption: [Tailles estimées et revendiquées de différents moteurs de recherche au 31 décembre 2002 (source : @showdown)]
) <fig:se-showdown>

=== Remarques personnelles

Avant de continuer plus loin, je voudrais mettre en avant un constat personnel de l'extrême volatilité des chiffres avancés par les moteurs de recherche. Par exemple, alors que le nombre d'#acrpl("URL") revendiquées par Google est de quatre milliards, la requête « the »#footnote[#link("http://www.google.com/search?hl=fr&ie=UTF-8&safe=off&q=the&btnG=Rechercher&lr=")] promet $5 space 840 space 000 space 000$ pages. D'un autre côté, il est en théorie possible de connaître le nombre de pages connues pour un domaine précis (par exemple `.fr`) en employant une requête du type `site:tld`. En faisant cette opération sur l'ensemble des TLDs, on devrait logiquement tomber sur près de six milliards de pages, voire plus. Cependant, l'expérience ne nous en donne que $749 space 485 space 183$ (à 0,26% près, _Google_ ne donnant que 3 chiffres significatifs). Il faut conclure de ces deux tests soit qu'au moment des expériences, Google indexait au moins $5 space 840 space 000 space 000$ pages et au plus $749 space 485 space 183$, soit que plus de 5 milliards de pages indéxées n'appartiennent pas à des TLDs existant, soit que les chiffres annoncés par Google doivent être pris avec un minimum de réserve.

Le nouveau moteur de recherche de _Yahoo_ donne lui aussi des résultats parfois étranges. Ainsi, j'ai pu constater que le nombre de résultats pouvait dépendre du rang à partir duquel on désirait voir les résultats. Ainsi, alors que la requête `"pâte à crêpes"` donne $7480$ réponses si on affiche les $20$ premières pages, ce nombre tombe à $7310$ si on demande les pages $981$ à $1000$, avec une décroissance régulière. Expérimentalement, la différence peut atteindre 5% du chiffre annoncé.

Il faut enfin ne pas oublier de parler du problème des doublons. En effet, la plupart des grands moteurs considèrent pour leurs index et algorithmes que `www.domain.com/`, `domain.com/`, et `www.domain.com/index.html` sont des pages différentes. Le regroupement est fait _a posteriori_, en utilisant des méthodes de hashage pour identifier les pages identiques (que _Google_ appelle pudiquement _pages à contenu similaire_). En résumé, les doublons sont comptés dans le nombres de pages trouvées, mais ne sont pas renvoyés dans les réponses (sauf demande explicite de l'utilisateur). Pour fixer les idées, le @tab:pages-uniques présente les résultats de quelques requêtes pour lesquelles il est possible de connaître le nombre de pages hors doublons#footnote[Comme _Yahoo_ et _Google_ ne renvoient que les $1000$ premières réponses à une requête, il n'est possible de compter les doublons que lorsque le nombre de pages uniques est inférieur à $1000$. Il suffit alors de demander les 10 dernières réponses pour avoir les informations voulues.]. Par convention, nous avons choisi de définir le nombre de pages revendiquées par _Yahoo_ comme celui revendiqué lorsque l'on demande les dernières pages.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    inset: 0.5em,
    align: (left, right, right, right, right),
    table.header(
      [], table.cell(colspan: 2)[Pages revendiquées], table.cell(colspan: 2)[Pages uniques],
    ),
    table.hline(),
    [*Requête*], [*Google*], [*Yahoo*], [*Google*], [*Yahoo*],
    table.hline(),
    [Anticonstitutionnellement], [752], [795], [442], [485],
    [Raton laveur], [18200], [23500], [801], [>1000],
    ["Pâte à crêpe"#super[\*]], [2690], [1630], [591], [489],
    ["Pâte à crêpes"#super[\*]], [7900], [5950], [745], [971],
    [Webgraph], [9040], [8180], [603], [759],
  ),
  caption: [Pages revendiquées ou pages à contenu similaire ? Quelques exemples à la date du 28 août 2004. #super[\*]Notons que d'après le _Petit Robert_, il faut écrire _pâte à crêpe_ et non _pâte à crêpes_.]
) <tab:pages-uniques>

== Mesures sur des crawls <sec:crawl-qualite>

L'étude et la comparaison des différents crawls est un sujet délicat à traiter. D'un côté, il y a les crawls commerciaux issus de moteurs de recherche, qui ne peuvent guère être accessibles qu'au travers de requêtes publiques faites sur les moteurs eux-mêmes, lesquelles requêtes sont très souvent bridées. De l'autre, les laboratoires de recherche offrent souvent des tailles plus réduites et des méthodes de crawl extrêmement variées. À cause de ces disparités, il peut être difficile de comparer différents résultats, voire de savoir s'ils sont comparables. L'objet de cette section est de répertorier différentes méthodes d'évaluation des crawls, dans le cas de données privées et celui de données publiques.

La méthode d'estimation des tailles réelles proposée par Greg Notess (cf @subsec:se-police) peut également servir de mesure de qualité de crawl. En dénombrant les réponses faites à 25 requêtes représentatives, on mesure en effet en quelque sorte la capacité d'un moteur à répondre à ces requêtes, transformant en quelque sorte le biais des requêtes en mesure de qualité.

=== Techniques de chevauchement (overlap)

Ce système de comparaison par requêtes est utilisé de manière plus poussé dans la méthode de comparaison par chevauchement, introduite par Bharat et Broder en 1998 @broder98technique et reprise par Lawrence et Giles @lawrence98searching @lawrence99accessibility.

Le principe du chevauchement est le suivant : arriver à mesurer entre deux moteurs le chevauchement de leurs index respectifs. Par exemple, si on peut déterminer qu'une fraction $p$ d'un index $A$ est dans $B$, et si une fraction $q$ de $B$ est dans $A$, alors on peut en déduire que $abs(A inter B) = p abs(A) = q abs(B)$, et ainsi avoir le rapport de taille entre les index :

$ frac(abs(A), abs(B)) = frac(q, p) $

Tout le problème est d'estimer $p$ et $q$ en l'absence d'index librement accessible au public. C'est là qu'intervient l'échantillonnage par requête : des requêtes créées par un générateur aléatoire le plus uniforme possible, sont soumises à un moteur. À chaque fois, un des réponses parmi les 100 premières est choisie au hasard, et on vérifie, par des méthodes plus ou moins strictes, si cette réponse est dans l'index de l'autre moteur.

Par rapport à la méthode de Notess, deux autres sources de biais (en plus du biais dû au choix des requêtes et des biais standards d'échantillonnage) sont introduites :

/ Le biais de classement : En choississant uniquement les échantillons parmi les 100 premières réponses (contrainte imposée par les moteurs de recherche eux-même), les classements (les importances) des pages considérées sont statistiquement plus élevés que la moyenne.

/ Le biais de vérification : Il n'y a pas de méthode parfaite pour contrôler l'appartenance d'une page donnée à un index. Les différentes méthodes proposées par Bharat et Broder sont basées sur l'analyse d'une requête censée définir la page et les critères de validation vont de _le moteur renvoie la bonne page_ à _le moteur revoie un résultat non vide_.

Les mesures par chevauchement ont eu leur heure de gloire au cours des guerres du Crawl#footnote[De là à dire que certains articles ont surtout servi à montrer qu'AltaVista avait la plus grosse basse de donnée, il n'y a qu'un pas que je franchirai @noeud-pap...] (voir @cl-taille-web), mais si elles ont l'avantage d'introduire un formalisme rigoureux, le coût en biais et la relative complexité de la méthode font que la méthode de Notess reste très compétitive.

=== Échantillonnage par marche aléatoire

Une variante intéressante de la méthode d'échantillonnage de Bharat et Broder a été proposée par Henzinger _et al._ @henzinger99measuring : plutôt que de mesurer un moteur à l'aide d'un autre, le principe est d'utiliser comme mètre-étalon un crawl personnel issu d'une marche aléatoire. Cette marche aléatoire ne fournit pas un échantillonnage uniforme des pages Web#footnote[Choisir une page Web _au hasard_ est impossible, le Web indexable étant infini.], mais un échantillonnage qui, aux biais statistiques près, obéit à la distribution de probabilité associée à la marche aléatoire. Cette distribution sur les pages Web, plus connue sous le nom de PageRank (Voir la Partie~II), va permettre, en mesurant à l'aide des techniques de chevauchement la fraction des échantillons connus du moteur, d'estimer la quantité de PageRank contenue dans les pages connues du moteur.

Le biais spécifique de cette méthode est que derrière l'échantillonnage par marche aléatoire se cache un crawl implicite, le crawl que l'on obtiendrait en laissant tourner la marche aléatoire suffisamment longtemps. On mesure donc le PageRank du moteur que l'on veut tester par rapport au PageRank sur ce crawl virtuel. En particulier, toute divergence entre les stratégies de crawl de la marche aléatoire et du moteur sont néfastes pour l'évaluation de ce dernier : si le moteur a indexé des parties du Web que la marche aléatoire, pour diverses raisons techniques, n'a jamais effleurées, ces parties ne compteront pas dans l'évaluation. À l'inverse, si certains sites sont volontairement évités par les moteurs (des pouponnières par exemple, voir #fref(<sec:explore-strategies>)), cette omission sera sanctionnée dans l'évaluation.
