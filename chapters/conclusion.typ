// Conclusion

#import "../templates/environments.typ": *
#import "../templates/math-macros.typ": *
#import "../templates/acronyms.typ": *

= Conclusion <chapCcl>

#citation([Alain #smallcaps[Finkielkraut]])[Internet est le rendez-vous des chercheurs, mais aussi celui de tous les cinglés, de tous les voyeurs et de tous les ragots de la terre.]

Au bout de ces quelques années de thèse, il m'apparaît que ma compréhension des graphes du Web, des PageRanks et des mécanismes qui les régissent a bien augmentée depuis mes timides débuts où, suivant une piste que m'avait tracée Daniel Krob, je cherchais à détecter des _points chauds_ du Web ; compréhension que je me suis efforcé de faire partager au lecteur au long de cet ouvrage. Cette conclusion récapitule le travail déjà fait, mais aussi celui qui reste à faire.

#align(center)[---]

Le premier chapitre a présenté cette réalisation humaine qu'est le Web. Définir ce dernier a généré plus de problèmes que de solutions, et face aux multiples facettes de la toile électronique, nous avons dû limiter notre champ d'étude à ce que nous avons appelé le Web indexable.

Nous avons ensuite considéré les _crawleurs_, ces chalutiers du Web qui parcourent sans cesse le Web indexable afin d'alimenter des bases de données, et avons étudié les tailles des plus grandes de ces bases, celles des moteurs de recherche. Nous avons en particulier mis en évidence les précautions qu'il était nécessaire de prendre face aux chiffres annoncés par les moteurs de recherche commerciaux, qui semblent parfois fantaisistes.

Nous nous sommes alors attardés sur quelques aspects de la structure de graphe induite par les hyperliens : la structure en noeud papillon, et les mauvaises interprétations qui en sont parfois faites ; la structure en sites, qui est intimement liée à l'arbre de décomposition des URLs. Nous avons laissé de côté quelques aspects structurels abondamment étudiés par ailleurs, comme la répartition des degrés entrants et sortants @albert99diameter @barabasi99emergence @albert00scalefree ou encore la structure en petit monde des graphes du Web @adamic99small @kleinberg99smallworld @puniyani01intentional. Ces aspects, bien qu'intéressants, ne rentrent pas dans le cadre de cette thèse.

#align(center)[---]

La deuxième partie est rentrée dans le vif du sujet, les méthodes de classement de type PageRank. Nous avons commencé au @pr-markov par effectuer quelques rappels sur les chaînes de Markov, leur représentation à l'aide de matrices stochastiques, et l'application du théorème de Perron-Frobenius aux matrices stochastiques pour trouver des distributions stationnaires. Nous avons également étudié quelques résultats de convergence pour des matrices sous-stochastiques. Tous les résultats présentés au cours de ce chapitre on très certainement été maintes fois présentés dans la littérature, mais nous avons choisi de les redémontrer afin d'introduire un formalisme abondamment utilisé par la suite, par exemple pour décrire les matrices sous-stochastiques. La roue a certainement été réinventée plus d'une fois au cours de ce chapitre, mais nous avons ainsi eu l'assurance que la taille des dites roues était la bonne.

Au @pr-pagerank, nous avons défini les principes généraux qui régissent le PageRank, posé la problématique et répertorié les algorithmes les plus classiques. Nous avons voulu nous démarquer des autres états de l'art qui existent sur le sujet @bouklit01methodes @bouklit02analyse @bianchini02pagerank @bianchini03inside @langville04deeper par un éclairage différent, avec notamment une unification de la double interprétation --- stochastique et en termes de flots --- associée aux différents algorithmes. Certains problèmes soulevés par ce chapitre auraient mérité une étude plus approfondie, que j'espère avoir prochainement l'occasion de réaliser. Il en est ainsi du lien entre la convergence du classement d'un PageRank et celui de sa distribution, qui est traité dans la @sec:kemeny.

Les deux derniers chapitres ont ensuite été l'occasion de présenter de nouveaux algorithmes de PageRank. Le lecteur aura ainsi découvert l'algorithme _BackRank_, qui modélise la possibilité pour un surfeur de revenir en arrière au cours de sa navigation. Nous avons montré que cet algorithme n'était pas plus compliqué à mettre en place qu'un algorithme de PageRank classique, tout en présentant de nombreux avantages pour ce qui est de la convergence et de la gestion des pages sans lien. Enfin, après avoir abandonné l'interprétation stochastique du PageRank pour une décomposition en flots, nous avons introduits deux algorithmes de calcul de PageRank basés sur la structure fortement clusterisée des graphes du Web : un algorithme exact, _FlowRank_ ; un algorithme approché, inspiré de l'algorithme _BlockRank_ proposé dans @kamvar-exploiting : _BlowRank_. La décomposition sur laquelle se basent ces algorithmes ouvre la voie à un large éventail de méthodes d'estimation semi-distribuées et locales du PageRank.

L'étude de ces algorithmes est loin d'être terminée, il reste encore à les tester sur de très grands graphes et, pourquoi pas, à les incorporer à un moteur de recherche réel. À la date où j'écris ces lignes, je réalise avec Mohamed Bouklit des expériences sur les graphes disponibles sur le site du projet _WebGraph_ @Webgraph, dont le plus grand fait 118 millions de sommets. Les résultats, très prometteurs, vont dans le même sens que ceux présentés dans ce mémoire.
