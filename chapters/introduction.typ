// =============================================================================
// Introduction
// =============================================================================

#import "../templates/environments.typ": *
#import "../templates/math-macros.typ": *
#import "../templates/acronyms.typ": *

#heading(outlined: true, numbering: none)[Introduction] <chapIntro>

#citation(smallcaps[Heisenberg])[
    La méthode scientifique, qui choisit, explique, et ordonne, admet les limites qui lui sont imposées par le fait que l'emploi de la méthode transforme son objet, et que par conséquent la méthode ne peut plus se séparer de son objet.
  ]

#v(1cm)

#heading(level: 3, numbering: none)[Les moteurs de recherche aujourd'hui]

#lettrine("Depuis")[
quelques années, l'Internet, et le Web en particulier, ont subi de profondes transformations liées à de multiples changements d'ordres de grandeur. Toujours plus de données sur toujours plus de machines sont accessibles à toujours plus d'internautes. L'économie électronique s'est également développée, et ce qui n'était hier pour les entreprises commerciales qu'une simple vitrine expérimentale est devenu, souvent au prix d'essais malheureux, un secteur économique à part entière. Ces mutations ont généré de nouveaux comportements aussi bien au niveau des internautes que des administrateurs de site.  
]

Du côté des internautes, le problème qui est apparu consiste à se repérer au milieu des milliards de pages disponibles. L'utilisateur _lambda_ veut avoir les moyens d'accéder à toutes les ressources offertes par le Web, et les méthodes habituelles (navigation par hyperliens à partir d'un portail, connaissance de la bonne adresse par des moyens extra-Web) ne suffisent plus.

Du côté des sites se pose le problème symétrique de la visibilité. Un site, si bien conçu soit-il, n'a de valeur que s'il est fréquenté, tel l'arbre qui tombe dans la forêt. Ce problème de la visibilité a de multiples facettes, qui sont les mêmes que pour la visibilité dans le monde réel. La visibilité du site personnel de Monsieur Durand est pour lui l'assurance de pouvoir être connu ou contacté par les personnes qui le désirent. La visibilité d'un site commercial représente de l'argent. Être plus visible que ses concurrents permet d'acquérir une nouvelle clientèle à leurs dépens, ce qui, dans un marché encore limité mais en pleine expansion, est une condition quasi-nécessaire de survie.

Si les deux problèmes de l'accessibilité et de la visibilité sont symétriques, ils ne font pas forcément bon ménage. Si un internaute veut manger des pommes, sa principale préoccupation va être de trouver des pages Web qui parlent de pommes, voire qui en vendent. De son côté, le site d'un amateur de poires va vouloir se faire connaître de l'internaute mangeur de pommes, si possible avant qu'il n'ait trouvé un site de pommes, pour essayer de le faire changer d'avis et de le convertir à la poire.

Les moteurs de recherche ont pour but premier d'assurer l'accessibilité d'un maximum de pages Web aux internautes. Concrètement, parmi le plus grand choix possible de pages, le moteur doit renvoyer les pages répondant aux besoins de l'internaute, ce besoin étant exprimé au travers d'une _requête_. Mais ils sont de fait devenus aussi le principal média de visibilité pour les sites.

Ce placement stratégique, à la croisée de l'internaute et du site, fait du moteur de recherche la pièce maîtresse du Web actuel, et il n'est pas étonnant de voir que la société _Google_, qui possède --- à ce jour --- le quasi monopole du secteur des moteurs de recherche, est maintenant cotée en bourse.

#heading(level: 3, numbering: none)[Connaître le Web]

Une des premières qualités pour un moteur de recherche est d'avoir une base de données conséquente, autant d'un point de vue quantitatif que d'un point de vue qualitatif. Dans la Partie~I nous nous proposons de mettre en évidence la problématique que posent ces bases de données constituées par les moteurs de recherche.

Nous commençons tout d'abord par tenter de définir le Web, ce qui, comme nous allons le voir lors du @cl-def-web, n'est pas aussi facile qu'on pourrait le penser de prime abord. Ceci fait, nous pourrons au cours du @cl-taille étudier ces sous-ensembles du Web que sont les _crawls_. Les crawls sont naturellement munis d'une structure de graphe que nous détaillerons lors du @cl-local. Nous essaierons en particulier de mettre en perspective le modèle du nœud papillon, dont les conclusions sont trop souvent mal interprétées, et nous montrerons l'existence d'une très forte organisation en sites des pages Web liée à l'arbre de décomposition des URLs. Nous verrons en particulier que la structure canonique des sites permet de calculer en temps linéaire une bonne approximation d'une certaine décomposition en sites d'un graphe du Web.

#heading(level: 3, numbering: none)[Trouver les bonnes pages]

Plus que la taille de sa base de donnée, c'est la façon dont un moteur de recherche va s'en servir qui va déterminer son efficacité. Alors que pour une requête donnée, la base de données va souvent contenir quelques dizaines de milliers de pages susceptibles de fournir une réponse adaptée, l'internaute va rarement aller au delà des $10$ ou $20$ premières réponses renvoyées par le moteur. Il est donc nécessaire d'opérer un tri parmi les réponses possibles afin d'extraire, de manière automatique, les quelques pages les mieux adaptées à une requête donnée.

Les moteurs de recherche de première génération utilisaient des méthodes de pertinence lexicale et sémantique afin de réaliser ce tri : les premières pages renvoyées étaient celles qui, du point de vue de l'analyse sémantique, se rapprochaient le plus de la requête. Mais assez vite, le classement par pertinence a été dénaturé par le besoin de visibilité des sites. Beaucoup de sites se sont mis à étoffer le contenu sémantique de leurs pages à l'aide de techniques plus ou moins rusées et plus ou moins honnêtes, par exemple en surchargeant la page de texte blanc sur fond blanc. Très souvent, au lieu d'être renvoyé sur les pages les plus pertinentes, l'internaute se retrouvait alors sur des pages qui n'ont rien à voir avec sa requête, mais dont la volonté d'être visible est très grande.

Pour contrer ces techniques, de nouvelles méthodes de classement ont été introduites, dans le but d'inférer l'importance des pages Web à partir de la structure de graphe formée par les pages connues. C'est l'une de ces familles de méthodes de classement, les PageRanks, qui sera étudiée dans la Partie~II.

Le @pr-markov rappellera quelques bases théoriques sur les chaînes de Markov, et développera plus particulièrement certains liens entre la théorie des graphes et celles des processus stochastiques nécessaires à une bonne compréhension du PageRank. Le @pr-pagerank sera l'occasion de présenter un bestiaire quasi-exhaustif des algorithmes classiques de PageRank. Nous présenterons en particulier une vision du PageRank unifiée en terme d'interprétation stochastique, et mettrons en évidence les point communs, différences, avantages et inconvénients des différentes méthodes.

Enfin, au cours des @pr-back et @pr-dpr, nous présenterons quelques algorithmes de PageRank originaux dont nous pensons qu'ils peuvent apporter des améliorations significatives aux algorithmes existants.

L'algorithme _BackRank_, conçu au départ pour modéliser l'utilisation de la touche _Back_, possède quelques effets secondaires intéressants, comme une convergence plus rapide que les algorithmes classiques et l'absence de problèmes liés à l'existence de pages sans lien.

_FlowRank_ est un algorithme qui essaie de prendre en compte de manière fine le rôle des pages internes, des pages externes et du flot de _zap_ dans un calcul exact du PageRank. _BlowRank_ est une adaptation pratique de _FlowRank_ inspirée d'un autre algorithme de calcul décomposé du PageRank.

Tous ces algorithmes sont autant d'outils potentiels ayant pour but de faciliter l'arbitrage entre accessibilité et visibilité, mais ils permettent aussi de se faire une meilleure idée des mécanismes qui entrent en jeu lorsque l'on veut modéliser un comportement stochastique sur le Web.

#heading(level: 3, numbering: none)[Publications]

Voici la liste à ce jour des publications de mes travaux. @mathieu01structure @mathieu02structure @mathieu03local correspondent aux travaux sur les graphes du Web qui sont à la base de la Partie~I de ce mémoire. @mathieu03effet @mathieu04effect sont quant à eux le point de départ du @pr-back, tout comme @mathieu03aspects @mathieu04local pour le @pr-dpr. Les travaux de classification des PageRanks du @pr-pagerank ainsi que les analyses détaillées des algorithmes _BackRank_ et _BlowRank_ sont trop récents et n'ont pas encore fait l'objet de publication. Enfin, @mathieu04file est un rapport de recherche sur une modélisation des problèmes de téléchargement dans les réseaux pair-à-pair fait conjointement avec Julien Reynier. C'est un sujet prometteur, mais qui a encore besoin de mûrir, c'est pourquoi je l'ai simplement mis en annexe (#fref(<annexe:p2p>)).

Tous ces documents sont téléchargeables sur

#raw("http://www.lirmm.fr/~mathieu")

#pagebreak()

#table(
  columns: (auto, 1fr),
  stroke: none,
  inset: 0.5em,
  row-gutter: 1em,

  [@mathieu01structure],
  [F. #smallcaps[Mathieu].
   Structure supposée du graphe du Web.
   Première journée Graphes Dynamiques et Graphes du Web, décembre 2001.],

  [@mathieu02structure],
  [F. #smallcaps[Mathieu] et L. #smallcaps[Viennot].
   Structure intrinsèque du Web.
   Rapport Tech. RR-4663, #smallcaps[INRIA], 2002.],

  [@mathieu03aspects],
  [F. #smallcaps[Mathieu] et L. #smallcaps[Viennot].
   Aspects locaux de l'importance globale des pages Web.
   In _Actes de #smallcaps[Algotel03] 5ème Rencontres Francophones sur les aspects Algorithmiques des Télécommunications_, 2003.],

  [@mathieu03effet],
  [M. #smallcaps[Bouklit] et F. #smallcaps[Mathieu].
   Effet de la touche Back dans un modèle de surfeur aléatoire : application à PageRank.
   In _Actes des 1ères Journées Francophones de la Toile_, 2003.],

  [@mathieu03local],
  [F. #smallcaps[Mathieu] et L. #smallcaps[Viennot].
   Local Structure in the Web.
   In _12th international conference on the World Wide Web_, 2003.],

  [@mathieu04effect],
  [M. #smallcaps[Bouklit] et F. #smallcaps[Mathieu].
   The effect of the back button in a random walk: application for pagerank.
   In _13th international conference on World Wide Web_, 2004.],

  [@mathieu04local],
  [F. #smallcaps[Mathieu] et L. #smallcaps[Viennot].
   Local aspects of the Global Ranking of Web Pages.
   Rapport Tech. RR-5192, #smallcaps[INRIA], 2004.],

  [@mathieu04file],
  [F. #smallcaps[Mathieu] et J. #smallcaps[Reynier].
   File Sharing in P2P: Missing Block Paradigm and Upload Strategies.
   Rapport Tech. RR-5193, #smallcaps[INRIA], 2004.],
)
