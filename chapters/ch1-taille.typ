// =============================================================================
// Chapitre 1 : Qu'est-ce que le Web ?
// =============================================================================

#import "../templates/prelude.typ": *

= Qu'est-ce que le Web ? <cl-def-web>

#citation(width: 57%, [Rémy #smallcaps[Chauvin], la Biologie de l'Esprit])[
  Je parlerai par exemple de l'Esprit et du "démiurge" en me gardant bien de définir trop précisément ce que j'entends par là : parce que je ne sais pas clairement... Dans cet état affreux de notre ignorance, faut-il vraiment définir si précisément ?
]


#v(1cm)

== Genèse du Web

Sources : _Une histoire de réseaux_ @genitrix04histoire.

#lettrine("Vers")[le début des années 1960, alors que dans le ciel passait une musique (un oiseau qu'on appelait Spoutnik), les États-Unis décidèrent de mettre au point une forme de réseau décentralisé capable de résister à une attaque nucléaire qui détruirait un ou plusieurs de ses centres nerveux. C'était l'année soixante-deux.]

Quelques années plus tard, ce projet est devenu _ARPANET_. Nous sommes en 1969 et quatre universités américaines sont reliées par ce réseau d'un concept nouveau. À partir de ce moment, ce réseau n'a cessé de grossir et d'évoluer, jusqu'à devenir ce qu'on appelle aujourd'hui Internet#footnote[Le terme Internet a été introduit, semble-t-il, en 1974, par Vincent Cerf et Bob Kahn. Notons au passage que internet et Internet ne veulent pas dire la même chose ! L'un est un nom commun désignant une structure de méta-réseau, l'autre est un nom propre pour LE méta-réseau utilisant le protocole TCP/IP.], c'est-à-dire un formidable réseau de réseaux.

En 1972, la charte  _#acr("AUP")_ interdit à toute structure commerciale de se connecter sur le réseau.

En 1984, le cap de 1000 machines est franchi et le _#acr("CERN")_ rejoint Internet. Six ans plus tard, en 1990, alors que le nombre d'ordinateurs connectés atteint les 300 000, le plus grand site Internet au monde est celui du CERN, futur berceau du Web, un vaste ensemble mondial de documents dits hypertextes et hypermédias distribués sur Internet.

Cette même année 1990, l'#acr("AUP") cesse d'exister, ouvrant la voie à ce qui deviendra quelques années plus tard la _Bulle Internet_.

En 1991, Tim Berners-Lee du #acr("CERN") introduit le concept de _#acr("WWW")_ , que l'on traduit parfois en français par la _toile_. Le #acrl("WWW") est la partie d'Internet où la méthode de navigation est l'HyperTexte, et le protocole _#acr("HTTP")_.

La philosophie d'#acr("HTTP") réside dans les liens dits _hypertextes_ qui relient les pages entre elles et qui permettent de naviguer quand on les sélectionne. On parle du "Web" --- avec une majuscule --- même s'il s'agit en réalité du "#acrl("WWW")" ou "W3".

== Une définition du Web

À l'origine, comme nous venons de le voir, le _Web_ était caractérisé à la fois par un protocole, le _#acr("HTTP")_, et un langage, le _#acr("HTML")_, le premier servant à diffuser des « pages » (des fichiers) écrites dans le second, et interprétées du côté client par des navigateurs Web (_Browsers_).

De nos jours, on peut se poser des questions sur la validité de cette double caractérisation :

- Le _#acr("HTML")_ est un langage facile à apprendre permettant d'écrire des documents structurés et reliés entre eux par des hyperliens. De fait, il n'est plus utilisé aujourd'hui exclusivement à travers _#acr("HTTP")_, et on le retrouve sur de nombreux autres supports (CD-ROM, DVD-ROM...) à des fins aussi nombreuses que variées (documentation, enseignement, encyclopédie, aide...).

- Afin de délivrer du contenu multimedia, le _#acr("HTTP")_ est prévu pour servir tout type de fichier. Images, sons, vidéos, textes sous divers formats, archives, exécutables... sont ainsi accessibles grâce au protocole _#acr("HTTP")_, dans un esprit plus ou moins éloigné de la conception originelle de navigation hypertexte. Cette tendance au « tout-http » aboutit à des situations parfois paradoxales. Ainsi, pour transférer des fichiers (même gros), il existe une certaine tendance à délaisser le protocole adéquat, le _#acr("FTP")_, au profit de _#acr("HTTP")_. Comme le montre le @tab:httpftp#footnote[Un grand merci à Philippe Olivier et Nabil Benameur pour m'avoir fourni ces données.], il semble que les fichiers traditionnellement transférés par _#acr("FTP")_ le soient maintenant par _#acr("P2P") _, mais aussi par _#acr("HTTP")_ (par exemple, la plupart des serveurs de téléchargements de _sourceforge.net_ sont sous _#acr("HTTP")_).

- Certains documents qui ne sont pas des documents _#acr("HTML")_ permettent une navigation par hyperliens : documents propriétaires (Acrobat PDF, Flash...) ou nouveaux langages (_WML_, _XML_...).

#figure(
  table(
    columns: 4,
    stroke: 0.5pt,
    inset: 0.5em,
    align: center,
    [*Année*], [*_#acr("HTTP")_*], [*_#acr("FTP")_*], [*_#acr("P2P")_*],
    [2001], [13 %], [10 %], [35 %],
    [2002], [14 %], [2 %], [50 %],
    [2004], [20 %], [_négligeable_], [65 %],
  ),
  caption: [Évolution des trafics _#acr("HTTP")_, _#acr("FTP")_ et _#acr("P2P")_ (en pourcentage du volume)],
) <tab:httpftp>

On entrevoit la difficulté de trouver une « bonne » définition du Web. Par un souci de simplicité plus que tout autre chose, tout au long de ce mémoire, nous continuerons à définir le Web selon sa double caractérisation initiale. Ainsi, nous appellerons _Web_ l'ensemble des documents écrits en _#acr("HTML")_ et disponibles sur Internet par le protocole _#acr("HTTP")_. Nous sommes conscients du caractère extrêmement restrictif de cette définition, mais préférons travailler sur un ensemble bien défini et largement étudié plutôt que de rechercher une exhaustivité dont il n'est pas dit qu'elle puisse être atteinte.

== Accessibilité du Web

À l'intérieur du Web que nous venons de définir se pose maintenant le problème de la visibilité et de l'accessibilité des pages. Que pouvons-voir du _Web_ et comment y accéder ? Plusieurs structurations du Web basées sur ces questions de visibilité, d'accessibilité et d'indexabilité on été proposées.

=== Profondeurs du Web

Michael K. Bergman, en 2000, propose la métaphore de la profondeur pour distinguer les différents _Webs_ @bergman00deep. On distingue ainsi :

/ The Surface Web: la surface du _Web_, selon Bergman, est constituée de l'ensemble des pages statiques et publiquement disponibles.
/ The Deep Web: à l'inverse, le _Web_ profond consiste en des sites web dynamiques et des bases de données accessibles par interface Web.

Cette vision du _Web_ reste assez manichéenne. Danny Sullivan @sullivan00invisible propose une troisième sorte de _Web_, _The Shallow Web_#footnote[Pour rester fidèle à l'analogie de Bergman, on pourrait traduire _Shallow Web_ par _espace proche_. Je préfère le terme de _marécage_, qui traduit assez bien l'effet de cette zone du Web sur les crawlers.], constitué par exemple de pages dynamiques publiquement disponibles, comme celles de l'_#acr("IMDB")_ (#raw("http://www.imdb.com")), ou encore celles du site #raw("http://citeseer.ist.psu.edu/").

=== Visibilité du Web

Chris Sherman et Gary Price proposent dans leur ouvrage _The Invisible Web_ @sherman01invisible une approche basé sur la visibilité par les grands moteurs de recherche. L'équivalent du _Surface Web_ est chez Sherman et Price l'ensemble des pages indexées par les moteurs de recherche. Selon eux, le reste du Web se décompose alors en 4 catégories :

/ The Opaque Web: les pages qui pourraient être indexées par les moteurs mais qui ne le sont pas (limitation d'indexation du nombre de pages d'un site, fréquence d'indexation, liens absents vers des pages ne permettant donc pas un crawling).
/ The Private Web: les pages webs disponibles mais volontairement exclues par les webmasters (mot de passe, metatags ou fichiers dans la page pour que le robot du moteur ne l'indexe pas).
/ The Proprietary web: pages accessibles seulement pour les personnes autorisées (intranets, système d'identification...). Le robot ne peut donc pas y accéder.
/ The Truly Invisible Web: contenu qui ne peut être indexé pour des raisons techniques. Par exemple, format inconnu par le moteur, pages générées dynamiquement (incluant des caractères comme ? et &)...

=== Web accessible

Chacune des deux approches que nous venons de voir a ses avantages et ses inconvénients. S'il est vrai que la définition de Bergman est assez séduisante (d'un côté, un Web statique accessible par clics, de l'autre un Web dynamique atteignable uniquement par requêtes), elle ne décrit pas de manière réaliste le Web actuel. L'approche de Sherman et Price, à savoir une discrimination selon l'indexabilité par les moteurs de recherche, est plus souple, mais n'associe à mon avis pas toujours les bonnes causes aux bons effets#footnote[Par exemple, l'ensemble des pages dynamiques accessibles depuis #raw("http://www.liafa.jussieu.fr/~fmathieu/arbre.php") @killthein devrait logiquement appartenir au Web _opaque_, alors que la catégorisation de Sherman et Price semble les destiner à être complètement invisible...].

Une troisième approche, utilisée par @broder98technique @henzinger99measuring @dahn00counting, fait une sorte de synthèse des modèles cités à l'instant. C'est le modèle du Web _accessible_ :

#definition[
  Le Web accessible est l'ensemble des pages Web susceptibles d'être pointées par un hyperlien.

  Plus précisément :
  - Ceci est équivalent à considérer comme faisant partie du Web accessible toute page accessible simplement en tapant la bonne adresse --- également désignée par le terme #acr("URL") @rfc1738 --- dans un navigateur.
  - Les pages dynamiques ne possédant pas de variable cachée, c'est-à-dire dont les éventuelles variables sont transmises dans l'#acr("URL"), font partie du Web accessible.
]

Par convention, nous allons exclure certaines pages de notre définition du Web accessible :
- Les pages d'erreur renvoyées par un serveur (erreurs _4xx_ par exemple) ;
- Les pages dont l'accès par des robots est interdit par un `robots.txt` ;
- Les pages protégées par login et/ou mot de passe (même si login et mot de passe peuvent être donnés dans l'#acr("URL")).

Cette définition a bien évidemment elle aussi ses défauts. Par exemple, elle ne prend pas du tout en compte le problème des doublons (comment considérer deux pages au contenu strictement identique --- par exemple deux #acrpl("URL") correspondant au même fichier physique ?), ni celui de la dynamicité temporelle des pages et de leur contenu (que signifie l'accessibilité de la page d'accueil d'un journal ? L'accessibilité d'une page qui renvoie l'heure et la date ?). En toute rigueur, nous devrions ainsi parler de Web accessible à un instant $t$, et accepter d'identifier une page à son #acr("URL") malgré les redondances inévitables. Même ainsi, beaucoup de zones d'ombre persistent. Ainsi, certains administrateurs mal intentionnés ne renvoient pas le même contenu selon que le demandeur de la page soit humain ou non, afin de tromper les moteurs de recherche ; d'autres renvoient des pages adaptées au navigateur utilisé par l'internaute ; d'autres encore vérifient que l'internaute est bien passé par la page d'accueil avant de naviguer à l'intérieur du site, et le renvoie à la page d'accueil si ce n'est pas le cas ; enfin, à cause des problèmes de routage, il est tout à fait possible qu'à un instant $t$, un serveur soit tout à fait visible d'une adresse IP et inaccessible d'une autre. En plus de l'instant $t$ doivent donc être aussi définis l'adresse d'où est émise la requête ainsi que toutes les informations transmises dans la requête _#acr("HTTP")_.

== Intermezzo : la page qui pointait vers toutes les pages <lpqpvtlp>

Au cours d'une discussion avec Jean-Loup Guillaume et Matthieu Latapy, dans ce haut lieu de la recherche scientifique qu'est la salle de la machine à café, alors que nous polémiquions abondamment sur le modèle du _nœud papillon_ proposé par Broder _et al._ @broder00graph#footnote[Voir la #fref(<noeud-pap>).], une idée farfelue est tombée du gobelet : et si nous mettions en place une page Web capable de pointer vers toutes les autres ?

Après avoir été d'abord écrite par Matthieu Latapy, dont j'ai repris le code, c'est une version un peu améliorée de la page initiale qui est maintenant disponible sur #raw("http://www.liafa.jussieu.fr/~fmathieu/arbre.php") @killthein.

Le principe de cette page est celui d'une machine à écrire, ou plutôt d'une machine à cliquer. Pour atteindre une page donnée, il suffit de cliquer ses lettres une à une, l'adresse obtenue étant gardée en mémoire grâce à une variable passée en paramètre dans l'#acr("URL"). La page vérifie dynamiquement si cette adresse a un sens (si elle fait partie du Web indexable), et si c'est le cas, un hyperlien est inséré vers cette adresse#footnote[La _page qui pointe vers toutes les pages_ donne aussi le PageRank de Google (note de 0 à 10) quand il est disponible. Elle ne fait pas encore le café, hélas.]. La @fig:killthein est une capture d'écran de la _page qui pointe vers toutes les pages_ à l'œuvre.

#figure(
  image("../figures/killthein.jpg", width: 80%),
  caption: [Capture d'écran de _la page qui pointe vers toutes les pages_ en pleine action],
) <fig:killthein>

Aux limitations de longueur d'#acr("URL") près (et aux bugs de gestion des caractères d'échappement qui n'ont pas encore été corrigés), le rôle de la page, à savoir être reliée par hyperliens à virtuellement toute page du Web indexable, est atteint.

Cette page est avant tout ludique, mais elle permet de prendre ses distances quant à bon nombre d'idées reçues :

- Le but premier de cette page était de porter une petite pique contre l'interprétation qui est généralement faite du modèle du nœud papillon, et il a été je pense atteint.

- Elle permet de prendre avec un minimum de recul toutes les affirmations sur la structure du Web. Après tout, je peux affirmer connaître une partie du Web d'environ $256^(n-55)$ pages, à un facteur $10^10$ près, où $n$ est le nombre maximal de caractères que peut contenir une #acr("URL")#footnote[Le protocole #acr("HTTP") 1.1 ne spécifie pas de taille maximale d'#acr("URL") (cf @rfc2616). $n$ est donc a priori aussi grand que l'on veut. Dans les faits, chaque serveur a une limite fixée, de l'ordre de quelques kilo-octets. D'ailleurs, il fut un temps où envoyer une #acr("URL") de plus de $8$ ko était une façon efficace de planter un serveur _IIS_...]. Ce résultat, de loin supérieur à toutes les estimations de la taille du Web avancées jusqu'à présent (voir @cl-taille-web), permet aussi d'affirmer quelques statistiques étonnantes :
  - Le degré moyen du _Web que je connais_ est de $257-epsilon$, $epsilon$ étant une perturbation due aux _vraies_ pages. De plus, contrairement à tout ce que l'on pensait, la distribution des degrés ne suit pas une loi de puissance, mais ressemble bien à un Dirac.
  - Il existe une composante fortement connexe dans le _Web que je connais_, et toute page du _Web que je connais_ appartient de manière quasi-certaine à cette composante.

Bien sûr, il ne faut pas prendre ces résultats pour argent comptant ! Je serais le premier à juger suspicieux un article affirmant que le _Web_ fait plus d'un gogol de pages#footnote[Le gogol est un nombre valant $10^100$. Il n'honore pas l'écrivain russe Nicolas Gogol (1809-1852), mais a été choisi en 1938 par le neveu du mathématicien américain Edward Kassner (1878-1955), Milton, alors âgé de 9 ans. Notons qu'en anglais, gogol se dit... googol ! Le nom du célèbre moteur de recherche est directement dérivé du nom inventé par Kassner, il existe d'ailleurs un contentieux entre Google et les héritiers de Kassner. Enfin, signalons que le nombre représenté par un $1$ suivi d'un gogol de $0$ s'appelle gogolplex.], ou que les distributions à queues lourdes n'existent pas. La _page qui pointe vers toutes les pages_ n'est qu'une _idée du samedi soir_#footnote[J'emprunte ce concept d'_idée du samedi soir_ à Michel de Pracontal. C'est « le genre d'idées dont les chercheurs discutent parfois pendant leurs heures de loisirs, sans trop les prendre au sérieux » (#smallcaps[L'imposture scientifique en dix leçons], leçon 7, page 183).] qui a été mise en application et j'en suis parfaitement conscient. Mais elle a l'avantage de nous montrer en pleine lumière l'immensité du Web accessible (et en particulier l'impossibilité de l'indexer#footnote[Pour fixer les idées, en faisant un parcours en largeur de la _page qui pointe vers toutes les pages_ à raison de 10 pages par seconde, il faudrait environ 100 millions d'années pour arriver à écrire `http://free.fr`. Quant à l'adresse `http://www.lirmm.fr`, l'âge de l'univers est largement insuffisant pour qu'un robot puisse la trouver uniquement en parcourant la _page qui pointe vers toutes les pages_.]) et de nous inciter à bien comprendre que tous les résultats signifiants que l'on peut avoir sur le _Web_ portent en fait sur des crawls qui représentent une part infime du _Web indexable_ en terme de nombre de pages.

Pour en conclure avec cet _intermezzo_, précisons qu'en terme de théorie de l'information, nous doutons que la _page qui pointe vers toutes les pages_ et ses pages dynamiques valent plus que les quelques lignes de code qui se cachent derrière.
