// Appendix B: A Short Study of PageRank on the INRIA Website

#import "../templates/prelude.typ": *

= A Short Study of PageRank on the INRIA Website <annexe:inria>

Starting from a snapshot of the graph of the website `http://www.inria.fr`, we applied a PageRank-type algorithm to determine which pages received the highest ranking. Several interesting observations emerged:

- The justification for removing, in the PageRank computation, the leaves of the graph (by leaf, we mean a node with zero out-degree).

- It proved essential to remove self-links (links from a page to itself), as this causes a resonance phenomenon. On the INRIA graph, before performing this modification, the PageRank was largely dominated by

  #align(center)[`http://www.inria.fr/DR:/multimedia/Bsv-fra.html`,]

  which combines the roles of a self-referencing page and the root of a sink.

- The choice of the weight of the "random click" turns out to be crucial: if it is too small, sinks or near-sinks will absorb all the PageRank. If it is too large, the iterative aspect of PageRank will vanish, and the ranking will roughly correspond to a ranking by in-degree. In the case of INRIA, a random click probability of $10%$ at each iteration appears to be a good compromise.

*Results* #h(1em) It seems quite interesting to analyse the top ten URLs returned by our PageRank algorithm (see @PR). One can observe that, while naturally correlated with the in-degree ranking, it differs from it significantly (compare @PR and @de).

#figure(
  table(
    columns: 4,
    align: (left, center, center, center),
    stroke: 0.5pt,
    [*URL (http://www.inria.fr/...)*], [*Local PR*], [*Google PR*], [*In-deg*],
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
  caption: [The top ten URLs of www.inria.fr according to a local PageRank. Comparison with Google.],
) <PR>

In terms of relevance, the pages returned by our PageRank appear to be well chosen overall (homepage in first place, "index" or "site map" type pages), with the notable exception of two pages:

#align(center)[
  `http://www.inria.fr/rapportsactivite/RA94/RA94.kw.html` and

  `http://www.inria.fr/rapportsactivite/RA94/RA94.pers.html`.
]

Upon verification, and as one might expect, these two pages turn out to be the two main nodes of a near-sink, namely `rapportsactivite/RA94/`. These two pages, having both a high in-degree and being located in a near-sink, appear very difficult to filter out using only a local PageRank.

#figure(
  table(
    columns: 2,
    align: (left, center),
    stroke: 0.5pt,
    [*URL (http://www.inria.fr/...)*], [*In-deg*],
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
  caption: [The ten URLs with the highest in-degree],
) <de>

*Comparison with Google* #h(1em) Google assigns a ranking of 9/10 to the INRIA homepage and 8/10 to the other top ten pages of the local PageRank, with the exception of

#align(center)[
  `http://www.inria.fr/rapportsactivite/RA94/RA94.kw.html` and

  `http://www.inria.fr/rapportsactivite/RA94/RA94.pers.html`,
]

which receive a score of 6/10. Two main observations:

- The two `RA94` pages had a local PageRank nearly equal to that of the other pages, with the exception of the homepage. Google's global PageRank managed to isolate them. A plausible explanation is the likely existence of numerous links from external pages to the "index" type pages, whereas it is very likely that very few external pages point to `RA94`.

- The score of 6/10 assigned to

  #align(center)[
    `http://www.inria.fr/rapportsactivite/RA94/RA94.kw.html` and

    `http://www.inria.fr/rapportsactivite/RA94/RA94.pers.html`.
  ]

  remains high, certainly higher than one would wish. Many homepages of websites considered more noteworthy do not achieve this score.
