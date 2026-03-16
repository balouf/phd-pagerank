// Annexe B : Petite étude du PageRank sur le site de l'INRIA

#import "../templates/environments.typ": *
#import "../templates/math-macros.typ": *

= Petite étude du PageRank sur le site de l'INRIA <annexe:inria>

À partir d'une capture du graphe du site `http://www.inria.fr`, nous avons appliqué un algorithme de type PageRank pour voir quelles étaient les pages qui obtenaient le plus fort classement. Plusieurs observations intéressantes sont apparues :

- La justification de l'ablation, dans le calcul du PageRank, des feuilles du graphes (entendre par feuille noeud de degré sortant nul).

- Il est apparu vital d'enlever les liens d'une page vers elle-même, car cela provoque un phénomène de résonance. Sur le graphe de l'INRIA, avant de procéder à cette modification, le PageRank était largement dominé par

  #align(center)[`http://www.inria.fr/DR:/multimedia/Bsv-fra.html`,]

  qui cumule le rôle de page autoréférencée et de racine d'un puits.

- Le choix de l'importance du « click aléatoire » s'avère primordial : s'il est trop petit, les puits ou quasi-puits vont absorber tout le PageRank. S'il est trop grand, l'aspect itératif du PageRank va disparaître, et le classement sera à peu près un classement selon le degré entrant. Dans le cas de l'INRIA, un click aléatoire de $10%$ à chaque itération paraît un bon compromis.

*Résultats* #h(1em) Il semble assez intéressant d'analyser les dix premières URLs renvoyées par notre algorithme de PageRank (voir @PR). On constate que, tout en étant bien sûr corrélé au classement des degrés entrant, il s'en démarque significativement (comparer le @PR et le @de).

#figure(
  table(
    columns: 4,
    align: (left, center, center, center),
    stroke: 0.5pt,
    [*URL (http://www.inria.fr/...)*], [*PR local*], [*PR Google*], [*De*],
    [index.fr.html], [$25,3$], [$9\/10$], [608],
    [rapportsactivite/RA94/RA94.kw.html], [$18,7$], [$6\/10$], [327],
    [actualites/index.fr.html], [$18,6$], [$8\/10$], [367],
    [fonctions/plan.fr.html], [$18,4$], [$8\/10$], [297],
    [valorisation/index.fr.html], [$18,2$], [$8\/10$], [302],
    [travailler/index.fr.html], [$18,2$], [$8\/10$], [312],
    [recherche/index.fr.html], [$18,2$], [$8\/10$], [297],
    [publications/index.fr.html], [$17,9$], [$8\/10$], [294],
    [inria/index.fr.html], [$17,9$], [$8\/10$], [229],
    [rapportsactivite/RA94/RA94.pers.html], [$17,6$], [$6\/10$], [320],
  ),
  caption: [Les dix premières URLs de www.inria.fr d'après un PageRank local. Comparaison avec Google.],
) <PR>

Au niveau de la pertinence, les pages renvoyées par notre PageRank apparaissent bien trouvées dans leur ensemble (page d'accueil en première place, pages de type « index » ou « plan »), à l'exception notable de deux pages :

#align(center)[
  `http://www.inria.fr/rapportsactivite/RA94/RA94.kw.html` et

  `http://www.inria.fr/rapportsactivite/RA94/RA94.pers.html`.
]

Après vérification, et comme on pouvait s'y attendre, ces deux pages s'avèrent être les deux principaux noeuds d'un quasi-puits, à savoir `rapportsactivite/RA94/`. Ces deux pages, présentant à la fois un fort degré entrant et étant dans un quasi-puits, paraissent très difficiles à écarter simplement à l'aide d'un PageRank local.

#figure(
  table(
    columns: 2,
    align: (left, center),
    stroke: 0.5pt,
    [*URL (http://www.inria.fr/...)*], [*De*],
    [index.fr.html], [608],
    [index.en.html], [391],
    [actualites/index.fr.html], [367],
    [rapportsactivite/RA94/RA94.kw.html], [327],
    [rapportsactivite/RA94/RA94.pers.html], [320],
    [travailler/index.fr.html], [312],
    [valorisation/index.fr.html], [302],
    [fonctions/recherche.fr.html], [299],
    [fonctions/annuaire.fr.html], [297],
    [fonctions/plan.fr.html], [297],
  ),
  caption: [Les dix URLs possédant le plus fort degré entrant],
) <de>

*Comparaison avec Google* #h(1em) Google attribue un classement de 9/10 à la page d'accueil de l'INRIA et de 8/10 aux autres dix premières pages du PageRank local, à l'exception de

#align(center)[
  `http://www.inria.fr/rapportsactivite/RA94/RA94.kw.html` et

  `http://www.inria.fr/rapportsactivite/RA94/RA94.pers.html`,
]

qui se voient attribuer la note de 6/10. Deux principales remarques :

- Les deux pages `RA94` avaient un PageRank local quasi-égal aux autres pages, exception faite de la page d'accueil. Le PageRank global de Google a réussi à les isoler. On peut avancer comme explication l'existence probable de nombreux liens de pages extérieures vers les pages de type « index », alors qu'il est fort probable qu'il existe très peu de pages extérieures pointant vers `RA94`.

- La note de 6/10 attribuée à

  #align(center)[
    `http://www.inria.fr/rapportsactivite/RA94/RA94.kw.html` et

    `http://www.inria.fr/rapportsactivite/RA94/RA94.pers.html`.
  ]

  reste élevée, certainement plus élevée que ce que l'on voudrait. Beaucoup de pages d'accueil de sites considérés comme plus intéressants n'ont pas cette note.
