// =============================================================================
// Chapitre 3 : Graphes et structures du web
// =============================================================================

#import "../templates/environments.typ": *
#import "../templates/math-macros.typ": *
#import "../templates/algorithms.typ": *
#import "../templates/acronyms.typ": *

= Graphes et structures du web <cl-local>



#citation([Benoît #smallcaps[Gagnon]])[La vie est un papillon éphémère arborant les ailes du paradoxe.]
#citation([#smallcaps[Tacite]])[Les sites ne changent pas d'aspect comme les hommes changent de visage.]
#citation([#smallcaps[Anonyme]])[Un bon site Web est toujours en construction.]

#v(1cm)

#lettrine("Maintenant")[ que les concepts de Web et de crawl ont été précisé, nous allons pouvoir étudier ce qu'il est possible d'en dire. Ce chapitre étant consacré aux structures, il convient de placer une structure canonique sur les crawls que l'on veut étudier. Une des structures les plus simples et les plus naturelles dans le cas des crawls du Web est la structure de graphe. Les graphes du Web, dont une définition est donnée @sec:graphewebdef, sont un sujet d'étude fréquent. Après avoir analysé de manière critique l'un des modèles les plus connus, le modèle du nœud papillon (@noeud-pap), nous mettrons en évidence dans le reste du chapitre l'importance de la structure en sites dans les graphes du Web.
]

== Graphes du Web : définition <sec:graphewebdef>

Considérons un crawl $C$. Ce crawl est constitué d'un ensemble d'URLs, dont certaines ont été visitées, et d'autres simplement détectées à travers les hyperliens des pages visitées. Il contient aussi l'ensemble des hyperliens des pages visitées. On appellera graphe du crawl $C$ le graphe orienté $G=(V,E)$, où $V$ est l'ensemble des pages du crawl, visitées ou non, et tel qu'un arc $e in E$ relie une page $i$ à une page $j$ si, et seulement si, $i$ contient un hyperlien pointant vers $j$. Par convention, les ancres#footnote[Les ancres (_anchors_) permettent de pointer vers une partie spécifique d'une page Web.] sont ignorées, et les liens multiples ne rajoutent rien au graphe (si une page $i$ possède deux hyperliens pointant vers $j$, le graphe aura toujours un seul arc de $i$ vers $j$). De même, les liens d'une page vers elle-même ne seront pas pris en compte.

Par abus de langage, nous utiliserons souvent le terme _graphe du Web_ pour désigner un tel graphe $G$. Il conviendra de toujours se rappeler qu'il s'agit toujours en fait de graphes de crawls.

== Le nœud papillon revisité <noeud-pap>

La structure en nœud papillon du graphe du Web est aujourd'hui admise par beaucoup de monde, et est très souvent évoquée par des articles scientifiques @cooper02crawling @abiteboul03adaptative @langville04deeper @raghavan03representing @arasu01pagerank @kamvar-exploiting ou de vulgarisation @tangente, de manière parfois totalement hors de propos#footnote[Par exemple, il est affirmé dans @langville04deeper et @kamvar-exploiting que Arasu _et al._ utilisent le modèle du nœud papillon pour accélérer leur calcul de PageRank @arasu01pagerank. Vérifications faites, Arasu _et al._ citent bien le modèle du nœud papillon, et proposent une méthode de calcul de PageRank basée sur... l'écriture de $A$ sous une forme triangulaire par blocs déduite de la décomposition en composantes fortement connexes (cf théorème @thm:sousfiltre). En particulier, le seul apport du modèle du nœud papillon est l'existence d'un bloc diagonal plus gros que les autres, la _#acr("SCC")_.]. Je considère pour ma part que le modèle du nœud papillon s'applique mal aux graphes dynamique en général, et aux graphes du Web en particulier. Cette section, dont les idées viennent de @mathieu01structure, va essayer de justifier cette prise de position en essayant de distinguer mythe et réalité afin de dégager le véritable intérêt de l'article _Graph Structure in the Web_.

=== Le modèle du nœud papillon

_Graph Structure in the Web_ @broder00graph est un article qui a été présenté lors de la 9#super[ième] conférence internationale sur le World Wide Web. L'article est basé sur l'analyse de deux crawls fournis par le moteur de recherche AltaVista, un crawl de 203 millions de pages daté de mai 1999 et un de 271 millions de pages d'octobre 1999. L'analyse donne plusieurs résultats sur la structure du graphe du web, le plus novateur étant la découverte d'une structure en nœud papillon :

- Environ un quart des pages considérées appartiennent à une seule et même composante fortement connexe, appelée noyau ou #acr("SCC").
- Un autre quart est formé de pages à partir desquelles on peut rejoindre le noyau, l'inverse n'étant pas vrai. C'est la composante IN.
- À l'inverse, près d'un quart des pages sont accessibles à partir du noyau, la réciproque étant fausse. Ces pages forment la composante OUT.
- Les pages qui sont accessibles à partir de IN, ou qui permettent d'accéder à OUT, et qui n'appartiennent ni à IN, ni à OUT, ni à #acr("SCC"), forment les tentacules (TENDRILS) et représentent aussi près d'un quart des pages.
- Les quatre quarts que nous venons d'évoquer forment en fait 90% des pages du crawl, soit la plus grande composante connexe. Les 10% restant sont des composantes déconnectées du reste et de taille moindre.

#figure(
  image("../figures/pap_fr.pdf", width: 70%),
  caption: [La structure en nœud papillon],
) <fig:pap_fr>

Cette structure est couramment représentée par un schéma similaire à celui de la @fig:pap_fr. La forme de nœud papillon obtenue à partir des composantes IN, #acr("SCC") et OUT donne son nom au modèle (_bow tie_).

De cet article est resté auprès de beaucoup de monde l'idée que ce découpage en quantité à peu près égales en composante IN, #acr("SCC"), OUT et tentacules est caractéristique du Web : c'est le modèle du nœud papillon.

=== Faiblesses du modèle du nœud papillon

==== Existe-t-il encore ?

Le principal inconvénient du modèle du nœud papillon, c'est que selon toute vraisemblance, il ne représente plus la réalité. Le graphe du Web, c'est-à-dire le graphe du Web accessible, ne peut pas avoir une structure de nœud papillon équilibrée, puisqu'il contient entre autres la _page qui pointe vers toutes les pages_ (cf @lpqpvtlp). Il faut donc considérer que ce modèle s'applique aux graphes issus de gros crawls du Web (c'est d'ailleurs l'opinion des auteurs#footnote["This suggests that our results are relatively insensitive to the particular crawl we use, provided it is large enough.", _op. cit._]). Seulement, on constate que :

- Aujourd'hui, la plupart des grands crawls sont l'œuvre de moteurs de recherche.
- Ces moteurs recensent les sites qu'il découvrent (par crawl ou par référencement) dans des annuaires (_directories_).
- Les annuaires font de toutes évidence partie du noyau du Web.

Que peut-il donc se passer pour une page qui, pour un crawl donné, fait partie de la composante IN, ou des tentacules, ou même des composantes déconnectées :

- Si la page ou un de ses ancêtres est indexé par les annuaires, elle se retrouve _de facto_ soit dans le noyau, soit dans OUT.
- Une page fait partie du crawl parce que un de ses ancêtres faisait partie de l'ensemble initial de crawl. Si aucun ancêtre de la page n'a été mis à l'annuaire, on peut douter qu'un ancêtre soit conservé dans l'ensemble initial de crawl. Conséquence, au prochain crawl, la page disparaîtra.

En conclusion, oui, il peut y avoir une composante IN, ou des composantes déconnectées, mais ces composantes sont forcément transitoires, à cause même des relations entre crawlers et annuaires. Il faut également tenir compte du fait que les gros crawls actuels possèdent une part non négligeable de pages non-indexées (au moins 25 % d'après une étude de 2002 @showdown, 75 % d'après un article de 2004 @eiron04ranking), qui viennent automatiquement grossir la composante OUT. Pour toutes ces raisons, j'ai tendance à douter très fortement que plus de 2 (3 ?) milliards de pages indexées par Google ne fassent partie ni du noyau, ni de OUT.

==== Un modèle peu robuste

Une question que l'on peut se poser est de savoir si les paramètres considérés sont pertinents pour l'étude des graphes du Web. D'un côté, nous avons les crawls, qui essaient de parcourir tant bien que mal un Web dynamique aussi bien spatialement que temporellement, et qui ont souvent un _overlap_ très faible entre eux @broder98technique. De l'autre, des définitions comme _IN : ensemble des pages qui accèdent au noyau, mais ne sont pas accessibles de celui-ci_. Est-il raisonnable de faire cohabiter des crawls très variables et des définitions peu robustes ? Un exemple concret : imaginons qu'un individu peu scrupuleux s'empare de l'ensemble des pages initiales des crawls d'AltaVista et mette les liens vers ces pages sur sa page Web. Si cette page est dans le noyau, cela signifie l'écroulement de toutes les composantes sur #acr("SCC") et OUT#footnote[C'est d'ailleurs ce phénomène d'écroulement qui tend à se produire aujourd'hui avec les annuaires.].

Contrairement à ce qu'affirme les auteurs#footnote[«The structure that is now unfolding tells us that it is relatively insensitive to the particular large crawl we use. For instance, if AltaVista's crawler fails to include some links whose inclusion would add one of the tendrils to the #acr("SCC"), we know that the resulting change in the sizes of #acr("SCC") and TENDRIL will be small (since any individual tendril is small). Likewise, our experiments in which we found that large components survived the deletion of nodes of large in-degree show that the connectivity of the web is resilient to the removal of significant portions», _op. cit._], il suffit donc d'une page, pas si grosse que ça#footnote[Il semble que l'ensemble de départ des crawls d'Altavista de l'époque était constitué de quelques centaines de pages. Une page de _bookmarks_ peut sans problème contenir quelques centaines d'hyperliens.], pour mettre à mal le modèle du nœud papillon. On est en fait en présence d'une lacune méthodologique : en face de données sur lesquelles l'incertitude et la dynamique est très grande (les graphes du Web), cela n'a pas de sens de considérer des variables extrêmement dépendantes des conditions initiales comme des constantes universelles. Pour les même raisons, considérer le diamètre de la composante connexe n'est guère pertinent ; effectivement, sur les 2 crawls d'AltaVista étudiés, il reste à peu près constant (aux alentours de 500), mais en y regardant de plus près, des indices semblent montrer que le diamètre de 500 est dû à une unique guirlande, peut-être une page mal configurée ou un piège à robots qui aurait échappé aux filtres#footnote[«Beyond a certain depth, only a few paths are being explored, and the last path is much longer than any of the others.», _op. cit._].

==== Une expérience non reproduite

À ma connaissance, l'expérience de @broder00graph n'a pas été reproduite sur des grands crawls depuis. Les seules expériences réelles menées sur le modèle du nœud papillon portent donc sur deux crawls propriétaires d'AltaVista, peu espacés et donc vraisemblablement basés sur la même technologie (ce qui peut expliquer certains artefacts comme la constance du diamètre). De plus, si on compare la taille et les dates de ces deux crawls (mai 1999, 203 millions de pages, octobre 1999, 271 millions de pages) avec les @se-war1 et @se-war2 (#fref(<se-war1>)), on arrive à la conclusion que les crawls utilisés étaient certainement expérimentaux.

Dans @dill01selfsimilarity, on trouve pourtant que la structure en nœud papillon est une figure fractale de la structure du Web, c'est-à-dire que l'on retrouve à l'intérieur des sites et des communautés le même modèle de nœud papillon que sur le graphe tout entier. En y regardant de plus près, on s'aperçoit que la structure globale de nœud papillon est admise, et que les proportions de IN, OUT, et #acr("SCC") observés dans les sous-graphes sont extrêmement variables, ce qui va dans le sens des remarques précédentes.

=== Le modèle du nœud papillon dans un contexte sociologique

Pour bien comprendre le succès du modèle du nœud papillon, il est important de se replacer dans le contexte. Nous sommes au début de l'année 2000. La _Bulle Internet_ est encore en pleine croissance, et des articles apparaissent indiquant que les moteurs de recherche ne font plus face à la croissance du Web @brake97lost @lawrence99accessibility @bergman00deep. La société AltaVista a remporté la première _Guerre du Crawl_ (voir #fref(<se-war1>) ainsi que les conclusions de @broder98technique) en dépassant les 150 millions de pages indexées, mais il lui manque l'assurance que cette augmentation de taille va lui permettre de rattraper l'évolution du Web. Dans cette optique, _Graph Structure in the Web_ tombe à point nommé. En effet, quelle est la morale de l'article ?

- Il existe une structure globale du Web (avec un grand W).
- Cette structure est invisible si on considère une portion trop petite du Web, mais il existe un seuil au-delà duquel la structure d'un crawl est la structure du Web.
- Les crawls d'AltaVista sont assez grands pour posséder la structure du Web.

En somme, _Graph Structure in the Web_ répond à une attente à la fois existentielle (Peut-on comprendre le Web ?) et commerciale (Notre crawl est le Web.). On pourrait presque le voir comme un mécanisme issu des lois de l'offre et de la demande. À la limite, la question de savoir si ses bases scientifiques sont solides ou non devient secondaire, ce qui est peut-être un début d'explication au succès de cet article.

=== Conclusion

Le modèle du nœud papillon a très certainement eu un sens au moment de sa découverte, mais ce sens n'est pas _le Web a une structure de nœud papillon_. Il exprime plutôt une situation particulière où à cause de la _Bulle Internet_, les nouvelles pages arrivaient trop vite pour que le Web puisse les assimiler. Mais aujourd'hui, deux phénomènes font que l'on est plus dans ce cas : d'une part, la _Bulle_ a éclaté. La création de nouveaux sites se fait rare, et on assiste plus à un développement de sites existants qu'à l'apparition d'une nuée de sites non répertoriés (cf @subsec:nbre-serveurs), ce qui est un début d'explication au fait que la structure en nœud papillon se retrouve dans les graphes des sites @dill01selfsimilarity. D'autre part, les moteurs de recherche ne font plus seulement qu'indexer le Web, ils en modifient continuellement la structure par l'intermédiaire des annuaires. Ces deux effets conjugués au manque de robustesse du modèle font qu'il est peu probable que les grands crawls commerciaux aient encore la même proportion de IN, tentacules et autres composantes déconnectées que celles trouvées dans _Graph Structure in the Web_.

On retiendra quand même que Broder _et al._ ont mis en évidence l'existence d'un important noyau de pages toutes connectées les unes aux autres, ainsi que le comportement protectionniste de certains sites commerciaux qui s'incluent totalement dans la composante OUT. On retiendra également que la proportion de composante IN dans le graphe d'un crawl est une certaine indication de la difficulté d'un grand graphe structuré à s'adapter à une expansion rapide.

== Rôle des serveurs et des sites dans la structure du graphe du Web <sec:structure-sites>

La notion de site est fondamentale dans l'organisation du Web. Par exemple, beaucoup de moteurs de recherche ont pour politique de ne renvoyer qu'un nombre limité de pages par site (avec une option _plus de pages venant du même site_ disponible). Une bonne décomposition en sites a de nombreuses applications, qui vont des méthodes de calcul du PageRank @kamvar-exploiting @mathieu04local à des méthodes de compression efficaces des crawls @randall01link @guillaume02efficient.

=== Serveurs Web, sites et communautés <subsec:serveur-def>

Les concepts de serveur Web, site et communauté sont souvent rencontrés dans la littérature, avec des définitions parfois contradictoires. Nous allons expliciter ici ce que nous entendrons par serveur, site et communauté.

/ Serveur réel: Un serveur Web réel se définit comme une machine physique précise connectée à Internet et identifiée par une adresse IP, qui renvoie un code de réponse 200 et une page Web en retour d'une requête _#acr("HTTP")_ demandant la racine (_/_) sur le port 80#footnote[Le port 80 est le port standard du protocole http. D'autres ports sont plus ou moins couramment utilisés, comme le port 443 pour le http sécurisé ou le port 8080 pour un serveur secondaire, mais nous n'en tiendrons pas compte ici.]. Le site Web physique associé au serveur consiste en toutes les pages hébergés à l'adresse IP considérée.

/ Serveur virtuel: Les adresses IP n'étant pas illimitées, des solutions ont dû être envisagées pour économiser les adresses. Une de ces solutions est l'emploi de serveurs virtuels. Les serveurs virtuels, introduits avec la norme _#acr("HTTP") 1.1_, permettent à une même adresse IP de se comporter comme plusieurs serveurs différenciés par leur adresse #acr("DNS") (_Hostname_). Ce procédé est par exemple utilisé par _free_ pour l'hébergement des pages personnelles de ses clients, ou au Japon, où les ressources en adresses IP sont très limitées. Du point de vue de l'utilisateur, un serveur virtuel est indicernable d'un serveur réel, si ce n'est qu'on ne peut pas remplacer l'adresse #acr("DNS") par l'adresse IP.

/ Site logique: Un site Web logique est constitué d'un ensemble de pages fortement reliées par hyperliens. Intuitivement, un site se caractérise par une certaine homogénéité de style (imposée par le _Webmaster_) et une navigation aisée au sein des pages du site. L'étude des sites sera l'objet des sections @cl-local:site-visu et @cl-local:site-parti.

/ Communauté: La notion de communauté est en quelque sorte orthogonale à la notion de site. Une communauté est un ensemble de pages reliées par un intérêt commun. La recherche de communautés est au cœur de l'algorithme _#acr("HITS")_ de Kleinberg @kleinberg98 ainsi que du projet _CosmoWeb_ @bouklit04cosmoweb.

=== Évolution du nombre des serveurs <subsec:nbre-serveurs>

Il est plus facile d'estimer le nombre de serveurs Web (réels et virtuels) que le nombre de pages Web.

#figure(
  image("../figures/se-phy-evolution.pdf", width: 95%),
  caption: [Serveurs Web physiques (adresses IP)],
) <fig:se-phy-evolution>

Pour dénombrer les serveurs réels, il «suffit» de faire une requête _#acr("HTTP")_ sur toutes les adresses IP possibles. Or, si on oublie les adresses IPv6, qui restent encore relativement négligeables, il n'y a que $2^32$ adresses possibles, soit environ quatre milliards#footnote[Il y en a en fait moins si on enlève certaines adresses _réservées_ - les adresses militaires par exemple - qui ne sont pas censées héberger de serveur Web accessible. L'_#acr("IANA")_ est l'organisme chargé de gérer les tranches d'adresses disponibles ou non. On peut ainsi éliminer environ 48 % des adresses disponibles.]. Ce travail a été effectué par le _Web Characterization Project_ @wcp02, sur la période 1998-2002, et les résultats concernant le nombre de serveurs sont représentés @fig:se-phy-evolution. Le nombre de serveurs physiques uniques est le nombre de serveurs physiques diminué des doublons, c'est-à-dire des serveurs renvoyant exactement le même contenu qu'un serveur précédemment testé.

La principale remarque que l'on peut faire quant à ces chiffres est l'observation d'une stagnation du nombre de serveurs physiques depuis 2001. Cette stagnation peut s'expliquer par la fin de la _bulle Internet_. En effet, le Web a cessé d'être une nouvelle technologie, et la plupart des acteurs universitaires, commerciaux et sociaux susceptibles de s'intégrer au Web l'ont déjà fait. D'après le _Web Characterization Project_, il ne se crée presque pas, voire plus de serveurs Web, la croissance se fait individuellement au niveau des serveurs.

#figure(
  image("../figures/se-virt-evolution.pdf", width: 95%),
  caption: [Serveurs Web virtuels (noms de domaines)],
) <fig:se-virt-evolution>

L'étude des serveurs virtuels a été réalisée par le site _Netcraft_ @netcraft04. Elle consiste à répertorier l'ensemble des adresses #acr("DNS") déclarées (comme le site _WhoIs_ @whois04), et à tester par une requête _#acr("HTTP")_ l'existence d'un serveur sur chacune des adresses obtenues.

L'évolution des serveurs Web virtuels, d'après _Netcraft_ @netcraft04, montre une progression constante à peu près linéaire du nombre de serveurs Web virtuels actifs au cours des 4 dernières années (cf @fig:se-virt-evolution). Ce n'est en tout cas à priori pas une progression géométrique.

=== Approche intuitive et visuelle de la notion de site <cl-local:site-visu>

Le concept de site est selon nous fondamental dans la structure du Web. Ses applications sont nombreuses :

- Évaluation plus précise du degré d'aboutissement d'un crawl (pour chaque site, quelle est la quantité de pages visitées ?)
- Distinguer des liens purement navigationnels de liens plus pertinents (liens de confiance en d'autres sites).
- Permettre à certains moteurs de recherche de ne renvoyer qu'une ou deux pages par site, afin d'éviter une monopolisation des réponses à une requête.
- Affinement du facteur _zap_ dans les calculs de PageRank (voir Partie~II, @sec:pr-modele, ainsi que @brin98what @henzinger99measuring)
- Algorithmes de PageRank basés sur la structure de site (l'algorithme FlowRank, présenté Partie~II, @pr-dpr, ainsi que son «concurrent» BlockRank @kamvar-exploiting)

La plupart du temps, les sites sont approximés par les serveurs (@adamic99small). Mais la réalité peut parfois être plus complexe. Des gros sites peuvent reposer sur plusieurs serveurs, alors qu'inversement un serveur peut héberger plusieurs sites. Par exemple, on aurait envie de regrouper www.microsoft.com et download.microsoft.com et de les considérer comme faisant partie d'un même site. À l'inverse, tous les hébergeurs de sites personnels n'utilisent pas les domaines virtuels, une grande partie met les sites dans les répertoires d'un serveur unique.

Toutes ces considérations nous amènent à nous poser la question de la définition d'un site logique. Les internautes (humains) n'ont en général aucun problème pour savoir ce qu'est un site, ce qui constitue en quelque sorte une définition empirique, mais n'est guère rigoureux et ne se prête guère à l'automatisation. Notons que les sites référencés à la main par les _annuaires_ rentrent dans cette définition.

Le Web Characterization Project @wcp02 propose quant à lui la définition sémantique suivante :

#quote(block: true)[
  _[A Web Site (Information Definition) is] a set of related Web pages that, in the aggregate, form a composite object of informational relevance. Informational relevance implies that the object in question addresses a non-trivial information need._

  [Un site Web logique est] un ensemble de pages similaires qui, par leur réunion, forment un objet composite délivrant une information pertinente. Cette information pertinente implique que l'objet en question réponde à un besoin d'information non-trivial.
]

À cette caractérisation sémantique, Li, Kolak, Vu et Takano superposent dans @li00defining une approche structurelle pour définir proposent la notion de _domaine logique_ :

#quote(block: true)[
  _A logical domain is a group of pages that has a specific semantic relation and a syntactic structure that relates them._

  Un domaine logique est un groupe de pages qui possèdent une relation sémantique spécifique et une structure syntaxique qui les relie.
]

Se basant sur cette définition, ils définissent un ensemble de règles (sémantiques et structurelles) pour identifier des sites.

Plus modestement, notre approche est de voir ce qu'il est possible de réaliser en ne considérant que le côté structurel des pages. Nous nous limitons donc à d'une part la structure de graphe induite par les hyperliens, d'autre part la structure en arbre des URLs qui fait apparaître des clusters naturels sur les graphes des crawls. En effet, très souvent, un site logique obéit à des règles hiérarchiques au niveau des URLs (Uniform Resource Locators @rfc1738), la plus commune étant l'existence d'un préfixe commun caractéristique.

#figure(
  image("../figures/test.pdf", width: 85%),
  caption: [Les #acrpl("URL") : un arbre de décomposition naturel pour les graphes du web],
) <clustered>

Cette structure d'arbre de décomposition#footnote[Merci à Fabien de Montgolfier de m'avoir rappelé le terme _arbre de décomposition_.] sur les graphes (_clustered graphs_) a été introduite par Feng _et al._ dans @feng95draw comme un outil de représentation des grands graphes. Sa principale utilisation est donc de permettre de dessiner des graphes de manière à laisser apparaître l'éventuelle hiérarchie existante, et on emploie surtout les arbres de décomposition dans les domaines où des structures de diagrammes implicites ou explicites existent#footnote[On pensera par exemple aux arbres de décomposition modulaire.].

Tout le problème est alors de trouver pour un graphe donné l'arbre de décomposition qui offre la meilleure représentation structurelle @brinkmeier-communities. Dans le cas des graphes du Web, l'arbre des #acrpl("URL") offre un arbre de décomposition intrinsèque.

==== Définition

Soit $G(V,E)$ un graphe. Un arbre de décomposition de $G$ est la donnée d'un arbre $T$ dont les feuilles correspondent aux sommets $V$. Chaque nœud interne $n$ de $T$ définit un cluster (ensemble de sommets) $V_T(n)$. Ce cluster est constitué de l'ensemble des sommets de $V$ correspondant aux feuilles du sous-arbre de $T$ de racine $n$. Par exemple, le cluster associé à la racine de $T$ est l'ensemble $V$ tout entier.

Un bon exemple de l'utilisation des arbres de décomposition est la modélisation des relations humaines. Il existe en effet un graphe assez naturel des relations humaines, où les sommets sont des personnes et où une personne $A$ pointe vers une personne $B$ si $A$ connaît $B$). Un arbre de décomposition qui peut compléter de manière pertinente ce graphe est celui de la localisation géographique : monde, pays, (état), ville, quartier, rue, ...

==== Graphes du Web et arbre de décomposition des URLs

Les #acrpl("URL") offrent une structure naturelle d'arbre de décomposition sur les graphes du Web. L'ensemble des serveurs#footnote[Pour simplifier, nous nous limiterons aux serveurs identifiés par leur nom de domaine #acr("DNS") et utilisant le port 80.] peut être représenté par un arbre dont la racine est `http`, les nœuds de profondeur 1 les TLDs#footnote[_#acr("TLD")_, ou domaine de premier niveau. Les TLDs sont divisés en deux catégories : les domaines génériques de premier niveau (gTLD) et les domaines de premier niveau qui sont des codes de pays (ccTLD). Les TLDs sont gérés par l'IANA (`http://www.iana.org`).], suivis des noms de domaines proprement dits et éventuellement des sous-domaines. Chaque serveur, qui est une feuille de l'arbre des noms de domaine, héberge une hiérarchie de pages identique à la structure du système de fichiers physique correspondant. La réunion des arbres des fichiers dans l'arbre des serveurs donne l'arbre de décomposition des #acrpl("URL").

Par exemple, l'#acr("URL") `http://smith.mysite.org/linux/index.html` se décompose en _#acr("HTTP")_, _org_, _mysite_, _smith_, _linux_ et enfin _index.html_, formant ainsi un chemin qui part de la racine jusqu'à la feuille correspondante dans l'arbre de décomposition (voir @clustered).

On peut éventuellement s'interroger sur la pertinence de commencer la décomposition par le domaine de premier niveau (TLD). En effet, il existe des macro-sites qui, pour avoir une meilleure visibilité, se déploient sur plusieurs TLDs (`.com` et les ccTLDs des pays d'implantation, de manière assez classique). Nous préférons quand même conserver le tri par TLD, d'une part parce que cela correspond à la philosophie initiale des noms de domaines, d'autre part parce qu'il existe aussi des noms de domaine pour lesquels le TLD change beaucoup de choses. Le lecteur majeur et averti pourra par exemple constater une différence sémantique certaine entre le contenu du site `http://www.france2.fr` et celui de `http://www.france2.com`...

==== Voir la structure des sites

#figure(
  image("../figures/frf.pdf", width: 85%),
  caption: [Matrice d'adjacence de $6 dot 10^4$ de pages parmi un crawl de $8$ millions de pages de `.fr`],
) <adja-fr>

Étant donné que d'une manière générale, les webmasters essaient d'organiser leurs sites, on peut s'attendre à ce que le concept de site Web soit intimement relié à celui l'arbre de décomposition des URLs. Nous en avons eu confirmation en observant la représentation graphique de la matrice d'adjacence $M$ du graphe d'un crawl d'environ 8 millions d'URLs _triées dans l'ordre lexicographique_ de `.fr` fait en juin 2001 dans le cadre de l'action de recherche coopérative _Soleil Levant_ @soleil01.

Nous avons représenté une petite partie de ce crawl (60 000 pages) @adja-fr, et quelques zooms sur des sous-parties intéressantes @adja. La première constatation est que la matrice d'adjacence peut de toute évidence se décomposer en deux termes, $M=D+S$, où $D$ est une matrice diagonale par blocs, et où $S$ est une matrice (très) creuse.

Les sites (et les sous-sites) apparaissent en effet comme des carrés qui coincident avec les nœuds de l'arbre des URLs. Avec un peu d'habitude, on arrive même à deviner la structure profonde des sites d'après l'aspect du _carré_ correspondant. Par exemple, les pages à fort degré sortant (typiquement, la carte du site) se traduisent par des lignes horizontales, alors que celle à fort degré entrant (les pages d'acceuil) sont caractérisées par des lignes verticales. Des carrés «bruités», c'est-à-dire avec des points présentant une structure pseudo-aléatoire (cf @aemiaif), sont souvent le signe de pages de documentation interactives (des dictionnaires par exemple). Remarquons enfin que la structure $D+S$ peut présenter un caractère récursif, comme le montre le bloc de la @algo.

#subfig(
figure(
      image("../figures/allmacintosh.pdf", width: 100%),
      caption: [allmacintosh.easynet.fr, un site de logiciels],
    ), <allmacintosh>,
figure(
      image("../figures/osx.pdf", width: 100%),
      caption: [allmacintosh.(...).fr/osx, un sous-site pour un OS spécifique],
    ), <osx>,
figure(
      image("../figures/aemiaif.lip6.pdf", width: 100%),
      caption: [aemiaif.lip6.fr/jargon, un dictionnaire interactif],
    ), <aemiaif>,
figure(
      image("../figures/algo.inria.pdf", width: 100%),
      caption: [algo.inria.fr, le site d'une équipe de l'INRIA],
    ), <algo>,
  label: <adja>,
  columns: (1fr, 1fr),
  caption: [Approche visuelle de la structure de site : zoom sur des clusters de la @adja-fr],  
  )

=== Proposition d'algorithme de partitionnement en sites <cl-local:site-parti>

Nous allons essayer, avec seulement la connaissance du graphe et des #acrpl("URL") d'un crawl, de générer le plus simplement possible une partition du graphe qui reflète la notion de site. Notre approche diffère donc de celle employée par @li00defining, qui emploie également un ensemble de règles sémantiques pour définir les sites.

==== Modèle formel

Structurellement, nous pensons qu'un site se définit comme un ensemble de pages étroitement reliées entre elles par des liens navigationnels, comme semble le confirmer les représentations de la matrice d'adjacence (cf @adja-fr).

Cela nous amène à essayer de définir une fonction qui mesure la qualité d'une partition en site par rapport au taux de liens navigationnels. Cette fonction, $f_G : cal(S) "partition de" G -> f(cal(S)) in RR$ doit atteindre un extremum lorsque $cal(S)$ approche (dans un sens à préciser) ce que nous aimerions appeler partition en sites. Une fois une telle fonction trouvée, la méthode standard pour partitionner $G$ consiste à construire une partition initiale des URLs (adaptée à la situation considérée), puis à effectuer des ajustements locaux pour essayer d'optimiser $f(cal(S))$.

==== Choix de la fonction $f_G$

Comme le facteur le plus important selon nous pour estimer une partition en sites est le nombre de liens navigationnels, il apparaît logique de chercher une fonction $f_G$ qui dépende explicitement de $i$, nombre de liens internes. Il faut également tenir compte du nombre de sites : en effet, celui-ci n'est pas fixé à l'avance (sinon, on serait dans le cadre classique d'algorithmes de type _mincut_ ou _maxcut_). Pour éviter d'avoir comme extremum la partition triviale $G$, et pour essayer d'avoir une décomposition fine, il nous semble également important d'essayer de maximiser le nombre de sites $p$. Nous avons donc deux paramètres globaux, le nombre de sites $p$ et le nombre de liens internes $i$, et la fonction $f$ que nous recherchons doit vérifier à la fois $(partial f)/(partial p)>0$ et $(partial f)/(partial i)>0$. Plusieurs formules simples sont a priori possibles :

- $f : (p,i) -> alpha p + i$, $alpha in RR$.

  Cette solution ne sera pas retenue ici, principalement parce que le choix de $alpha$ nécessite pour être judicieux d'être égal au nombre moyen de liens par page, ce qui laisse peu de jeu. En effet, si $alpha$ est plus grand que ce nombre, on risque de se ramener à maximiser $p$ (on a intérêt à isoler des pages), alors que s'il est plus petit, pour les mêmes raisons, seul $i$ va compter.

- $f : (p,i) -> p dot i^alpha$, $alpha in RR$.

  Cette solution présente l'avantage d'être plus souple pour ce qui est du rapport entre $p$ et $i$.

- $f : (p,i) -> p^(i/|E|)$, où $|E|$ est le nombre total de liens.

  Cette dernière solution est délibérément dépourvue de paramètre car on a ainsi une quantité qui a une interprétation intuitive : pour une partition dépourvue de liens externes, on aurait $f(p,i)=p$. D'une manière générale, $f$ reste du même ordre de grandeur que $p$ en s'en approchant d'autant plus que la cohésion interne est grande. Nous appellerons donc la quantité $p^(i/|E|)$ l'indice de site, qui peut s'interpréter comme le nombre de sites isolés équivalent.

==== Problème des pages isolées
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#let big_dash = (width:2cm, height:2.6cm,
      stroke: (dash: "dashed"),)
#let small_circle = (shape: circle,
      radius: .2cm)
#let graph-options = (
  node-stroke: 1.5pt,
  edge-stroke: .7pt,
  node-corner-radius: 15pt,
  spacing: (1cm, 1cm),
)

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
[#figure(diagram(..graph-options,
      node((0, 0), align(bottom)[web], ..big_dash),
      node((.3, 0), [], name: "start", ..small_circle),
      node((1.8, 0), [Page isolée], name: "end"),
      edge(<start>, <end>, "-|>"),
    ), caption: [Page isolée]) <isol>],
[#figure(diagram(
      ..graph-options,
      spacing: (1cm, .2cm),
      node((0, 0), [index.html], name: "start"),
      node((2, -1), [sujet 1]),
      edge(<start>, "<|-"),
      node((2, 0), [sujet 2]),
      edge(<start>, "<|-"),
      node((2, 1), [sujet 3]),
      edge(<start>, "<|-"),
), caption: [Site structuré]) <struct>]
)

Le cas des pages de degré entrant 1 et de degré sortant nul pose un problème. Si elles peuvent parfois représenter un site isolé réduit à une page unique (@isol), on constate expérimentalement que dans la plupart des cas ce sont des pages crawlées, mais non visitées (voir @chalut-def) ou des pages terminales de sites structurés (@struct). D'un point de vue structurel, et en l'absence de toute autre considération, il nous semble légitime de s'assurer que les pages de degré entrant 1 et de degré sortant nul soient rattachées au site de la page parente. Cela se traduit, au niveau de la fonction $f(p,i)$ introduite précédemment, par l'inégalité suivante :

$ (forall p,i) quad f(p-1,i+1)>f(p,i) $ <pmoinsiplus>

Cette inégalité, si on essaie de l'imposer à notre fonction $f$ (ce qui est nécessaire si l'on veut que $f(p,i)$ suffise à réaliser la partition), pose le problème suivant : toute partition de paramètre $(p,i)$ telle que

$ p <= |E| - i + 1 $ <connec>

est moins performante que la partition triviale :

$ f(p,i) < f(1,|E|) $

Hélas, l'@connec est vérifiée dès que le graphe est connexe. D'une manière générale, pour un graphe composé de $k$ composantes connexes et de $|E|$ arêtes, on aura forcément pour toute partition de paramètre $(p,i)$ l'inégalité

$ f(p,i) <= f(k,|E|) $

*Bilan :* Il n'existe aucune fonction universelle $f(p,i)$ maximale pour une partition en site non triviale respectant les pages terminales.

Deux approches sont alors envisageables pour contourner ce problème, ainsi que les autres du même genre que l'on pourrait rencontrer en essayant d'affiner notre modèle :

- Continuer à chercher à maximiser $f(p,i)$ en imposant des règles externes, ce qui reviendrait par exemple à travailler sur un sous-ensemble de l'ensemble des partitions du graphe. C'est l'approche employée pour la partie structurelle de la définition de domaines logiques utilisée par @li00defining.

- Remplacer $p$ ou $i$ par de nouvelles variables qui prennent en charge le problème implicitement. C'est cette approche que nous allons étudier.

==== Altération des variables $p$ et $i$

Une première idée consisterait à pondérer le poids des arêtes de telle sorte que les liens vers des pages isolées soient plus difficiles à rompre. Ainsi, une idée assez classique et naturelle est de prendre un poids inversement proportionnel au degré entrant (cf @kleinberg98). Hélas, la nouvelle variable $i'$ introduite présente de nombreux inconvénients, surtout si elle est l'unique altération introduite :

En premier lieu, on peut considérer le cas de deux sites (au sens intuitif) reliés entre eux par une arête unique (@mono). Si l'algorithme est conçu pour ne pas séparer les pages terminales, c'est-à-dire s'il respecte la relation @pmoinsiplus, il sera obligé de fusionner les deux sites, ce qui n'est pas forcément l'effet désiré.

#grid(
  columns: (1fr, 2fr),
  gutter: 2em,
[#figure(diagram(
..graph-options,
spacing: (.5cm, 1cm),
range(2).map(i => node((i * 1.5, 0), align(bottom)[Site #(i+1)], ..big_dash, width: 1.5cm),),
node((.34, 0), [], ..small_circle),
edge("-|>"),
node((1.1, 0), [], ..small_circle),
), caption: [Sites 1-reliés]) <mono>],
[#figure(diagram(
..graph-options,
spacing: (.9cm, 1cm),
range(4).map(i => node((i, 0), align(bottom)[Site #(i+1)], ..big_dash, width: 1.5cm)
),
range(3).map(i => {
  node((.2,(i - 1)/5), ..small_circle)
  edge("-|>")
  node((.8,(i - 1)/5), ..small_circle)
}),
range(3).map(i => node((2.8,(i - 1)/5), ..small_circle, name: label(str(i)))),
range(3).map(i => {
node((2.2,(i - 1)/5), ..small_circle)
edge(label("2"), "-|>")
}
)
), caption: [Exemples de sites 3-reliés]) <cordon>]
)


En outre, si l'on regarde les deux exemples de sites 3-reliés de la @cordon, on aimerait que la décision de fusion des sites, toutes choses étant égales par ailleurs, soit la même dans les deux cas. Avec des poids sur les arêtes dépendant du degré entrant, cela sera difficile, puisque la force de liaison varie du simple au triple entre les deux cas.

Une altération par pondération des partitions suivant leur taille est une autre solution. D'une manière générale, si l'on considère une partition $V = union.big_(i=1)^p P_i$ et une fonction de pondération $h : NN^* -> RR$, on peut définir la nouvelle variable $p' = sum_(i=1)^p h(|P_i|)$. La solution la plus simple, que nous retiendrons ici, consiste à affecter un poids nul aux partitions monoatomiques (ce qui revient en fait à travailler sur $(p,i)$ en imposant comme règle l'interdiction des partitions monoatomiques). Le choix d'autres fonctions $h$ ne sera pas traité ici, mais on peut espérer en choisissant la bonne fonction $h$ un certain contrôle sur la distribution des partitions, par exemple éviter la formation de trop gros sites en affaiblissant $h$ sur les grandes valeurs.

==== Fonction $f_G$ choisie

Compte tenue de toutes les remarques que nous venons de faire, nous choisissons de prendre comme fonction d'évaluation la fonction $f$ qui à une partition $cal(S) = (S_1, ..., S_p)$ de $G$ associe $p'^(i/|E|)$, où $i$ est le nombre de liens internes et $p' = sum_(i=1)^p h(|S_i|)$, avec $h = chi_([2,+infinity[)$.

==== Estimation d'une partition par site à l'aide de l'arbre de décomposition des URLs

Maintenant que nous possédons une fonction $f$ d'évaluation d'une partition se pose la question de réaliser une partition efficace. Une méthode intuitive se base sur l'hypothèse suivante, confortée par l'observation des @adja-fr et @adja : L'architecture #acr("URL") des pages reflète l'architecture des sites, et donc les blocs sont _a priori_ des sous-arbres ou union de sous-arbres de l'arbre du Tree-Graph. Au lieu d'avoir à choisir une partition parmi toutes celles possibles, on pourra se limiter pour le choix des candidats aux candidats coïncidant avec la structure d'arbre.

#figure(
  image("../figures/cinq-de.pdf", width: 50%),
  caption: [Le cinq de dés : un bloc est intercalé au milieu d'un autre],
) <cinq-de>

Cette solution n'est pas parfaite, et il y aura toujours des cas litigieux. Ainsi, dans des configurations en poupée russe, le choix du niveau de partition va être très lié au choix des fonctions $f$ et $h$. Par contre, des configurations en cinq de dé (un site encastré dans un autre au niveau de la matrice d'adjacence, voir @cinq-de), difficiles à démêler automatiquement avec seulement la matrice d'adjacence (qui porte pourtant plus d'information que le graphe seul), ne poseront pas de problèmes avec l'arbre de décomposition pour peu que les sites coïncident avec l'arbre (ce qui est le cas sur tous les exemples testés).

Nous allons donner un exemple d'algorithme simple pour effectuer une partition intelligente et rapide des #acrpl("URL") à l'aide de l'arbre-graphe : le parcours en largeur filtré (@alg:plf).

#definition[
  On appellera cône lexicographique d'une #acr("URL") le cluster associé, dans l'arbre de décomposition des #acrpl("URL"), au nœud interne père de la feuille correspondant à l'#acr("URL") en question.
]


#alg(caption: [Algorithme de Parcours en Largeur Filtré (plf)])[
Données\
Un ensemble d'URLs ainsi que le graphe $G$ associé.\ 
Résultat\
Une partition en sites de $G$, chaque site possédant une page d'entrée.\
début#i\
Aucun sommet n'est marqué.\
tant que  il reste un sommet non marqué#i\
  Choisir un sommet non marqué parmi ceux de plus faible hauteur\ dans l'arbre de décomposition\
  Effectuer un parcours en largeur sur le graphe à partir de ce sommet\ en ne tenant pas compte des arcs sortant du cône lexicographique\
  Étiqueter l'ensemble des sommets obtenus d'après le sommet de départ,\ qui sera appelé _page d'entrée_ du site\
  si un sommet faisant déjà partie d'un site est rencontré#footnote[Cette situation ne se rencontrant que si les deux sommets sont frères.]#i\
  Fusionner les deux sites
] <alg:plf>


Les avantages de ce découpage initial sont les suivants :

- On évite d'amalgamer comme un seul site deux ensembles très proches dans l'arbre mais n'ayant aucun lien direct dans le graphe. Ainsi, les sites dits «persos» ne sont pas fusionnés sous le seul label du fournisseur d'espace (free, voila, multimania...) ; de même, la page d'un chercheur dans un laboratoire ne fera partie du site du laboratoire que si elle est référencée par ce dernier, ce qui nous semble satisfaisant.

- À l'inverse, des sites hébergés sur plusieurs serveurs voisins (www.inria.fr et www-rocq.inria.fr par exemple) sont traités comme une seule et même entité.

Il reste hélas des cas que l'algorithme que nous proposons ne prend pas en charge. Ainsi, certains sites sont à cheval sur plusieurs serveurs n'ayant aucun lien de parenté dans l'arbre lexicographique tel que nous l'avons défini (site perso partagé entre plusieurs hébergeurs, site commercial se déclinant en `.com`, `.fr`, `.de`...).

==== Résultats

Nous allons comparer ici la partition obtenu par parcours en largeur filtré aux partitions quotientées par serveur, par répertoire à profondeur 1 et par répertoire à profondeur 2 (ce qui correspond typiquement à des coupures à hauteur 3, 4 et 5 dans l'arbre-graphe). L'étude a été faite sur le crawl de 8212791 #acrpl("URL") de `.fr` daté du 15 juin 2001. Par abréviation, nous appellerons ces partitions plf, serveur, 1-rép et 2-rép.

#figure(
  image("../figures/site-puissance.pdf", width: 80%),
  caption: [Distribution des partitions en fonction de leur taille, sur une double échelle logarithmique. Légende : plf en rouge, serveur en bleu, 1-rép en vert, 2-rép en jaune],
) <site-puissance>

Observons d'abord comment se répartissent les différentes partitions. La @site-puissance montre les distributions des tailles des différentes partitions. On observe que quelque soit la méthode utilisée (plf, serveur, 1-rép ou 2-rép), les partitions obtenues se répartissent suivant une loi de puissance#footnote[Par abus de langage, nous appellerons souvent loi de puissance tout phénomène qui, représenté sur une échelle _loglog_, donne une courbe formant approximativement une droite. Le fait que le nombre d'échantillons considérés soit fini, et la sensibilité des estimations aux valeurs extrêmes fait qu'il serait plus juste de se contenter de parler de phénomène à _queue lourde_ (_heavy tail_).], c'est-à-dire que le nombre de blocs de taille $x$ est de l'ordre de $C/x^alpha$. Les valeurs des exposants (estimés par régression linéaire) sont indiquées dans le tableau @expo.

#figure(
  table(
    columns: 5,
    stroke: 0.5pt,
    inset: 0.5em,
    align: center,
    [*Partition*], [serveur], [1-rép], [2-rép], [plf],
    [$alpha$], [1.32], [1.75], [1.89], [1.59],
  ),
  caption: [Coefficients des loi de puissance des différentes partitions],
) <expo>

La loi de puissance est une loi considérée comme caractéristique des réseaux sociaux et des activités humaines. Le fait de rencontrer une telle loi dans tous les cas étudiés, à défaut de prouver quoi que ce soit, montre que du seul point de vue de la répartition des pages (sans tenir compte des hyperliens), les quatre répartitions étudiées semblent être compatibles avec la structure humaine du Web.

Remarquons également l'importance des « sites » de taille 1 (les données de la @site-puissance viennent des partitions avant toute optimisation), et cela plus particulièrement pour la partition plf. L'explication est assez logique : les partitions de taille 1 contiennent entre autres toutes les erreurs qui n'ont pas été supprimées du crawl : erreur 4xx, erreur dans l'écriture de l'#acr("URL")... La partition plf isole plus d'erreurs que les autres par construction, puisqu'une #acr("URL") isolée dans le cône lexicographique d'un site sera isolée par plf, à l'opposé des autres partitions.

#figure(
  table(
    columns: 5,
    stroke: 0.5pt,
    inset: 0.5em,
    align: center,
    [], [$p$], [$p'$], [$i/|E|$], [$p'^(i/|E|)$],
    [serveur], [39305], [27241], [0.9517], [16629],
    [plf], [289539], [58094], [0.9218], [24624],
    [1-rép], [182942], [137809], [0.7851], [10831],
    [2-rép], [250869], [189698], [0.7012], [5025],
  ),
  caption: [Tableau des caractéristiques des différentes partitions avant optimisation],
) <recap>

Enfin, comparons la qualité du découpage en site des différentes partitions, à l'aide de l'indice de site défini par la fonction $f$. L'optimisation est dans un premier temps minimale : les sites de taille 1 sont fusionnés avec le site avec lequel ils sont le plus liés (le plus souvent, la liaison est unique).

Les résultats sont reportés dans le tableau @recap. On remarquera que plf, dont les résultats pour $p'$ comme pour $i$ sont à mi-chemin entre serveur et 1-rép, obtient de loin le meilleur indice de site.

==== Optimisation des partitions

Les résultats précédents proviennent de partition qui ne cherchent pas _a priori_ à maximiser l'indice de site. On peut se contenter de ces résultats, si l'on voit simplement l'indice de site comme une indication de qualité, mais on peut aussi chercher à le maximiser. Nous allons donc voir ce que donnent une optimisation locale par mélange, sans plf et avec plf. Le principe de cette optimisation est simple : pour chacun des sites définis par la partition que l'on veut optimiser, on tente d'améliorer l'indice de site en le remplaçant par la décomposition locale (serveur, 1-rép,...) qui donne le meilleur indice de site. Il s'agit donc d'un algorithme glouton, et le résultat obtenu, qui est un maximum local, peut dépendre de l'ordre dans lequel les sites sont traités.

#figure(
  table(
    columns: 4,
    stroke: 0.5pt,
    inset: 0.5em,
    align: center,
    [], [$p'$], [$i/|E|$], [$p'^(i/|E|)$],
    [optimisation sans plf, parcours 1], [107884], [0.9376], [52341],
    [optimisation sans plf, parcours 2], [113148], [0.9340], [52487],
    [optimisation avec plf, parcours 1], [121963], [0.9338], [56165],
    [optimisation avec plf, parcours 2], [118386], [0.9372], [56845],
  ),
  caption: [Tableau des caractéristiques des différentes partitions après optimisation],
) <optim>

Les résultats sont présentés dans le tableau @optim. Deux parcours différents des partitions ont été effectués, pour se rendre compte des fluctuations que le choix du parcours peut générer, ainsi que de leur importance. Les principaux résultats que l'on peut tirer de ce tableau sont :

- Un net regain général de l'indice de site, les données $p'$ et $i$ étant proches des valeurs maximales techniquement possibles par cette méthode.
- L'optimisation avec plf reste meilleure dans tous les cas que l'optimisation sans plf, même si la valeur ajoutée est plus faible que pour les partitions brutes.
- Les fluctuations de $p'$ et de $i$ dans les quatre cas semble montrer qu'il risque d'être difficile de déterminer à l'avance le meilleur parcours d'optimisation (problème dû à l'utilisation d'un algorithme glouton).
