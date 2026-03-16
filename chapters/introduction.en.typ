// =============================================================================
// Introduction (English translation)
// =============================================================================

#import "../templates/environments.typ": *
#import "../templates/math-macros.typ": *
#import "../templates/acronyms.typ": *

#heading(outlined: true, numbering: none)[Introduction] <chapIntro>

#citation(smallcaps[Heisenberg])[
    The scientific method, which selects, explains, and orders, acknowledges the limits imposed upon it by the fact that the use of the method transforms its object, and that consequently the method can no longer be separated from its object.
  ]

#v(1cm)

#heading(level: 3, numbering: none)[Search engines today]

#lettrine("Since")[
the last few years, the Internet, and the Web in particular, have undergone profound transformations driven by multiple changes in orders of magnitude. Ever more data on ever more machines are accessible to ever more Internet users. The electronic economy has also expanded, and what was yesterday merely an experimental showcase for commercial enterprises has become, often at the cost of unsuccessful attempts, a fully-fledged economic sector. These changes have given rise to new behaviours both among Internet users and site administrators.
]

On the users' side, the problem that has emerged is finding one's way among the billions of available pages. The average user wants to have the means to access all the resources offered by the Web, and the usual methods (hyperlink navigation from a portal, knowing the right address through extra-Web means) are no longer sufficient.

On the sites' side, the symmetric problem of visibility arises. A site, however well designed, has value only if it is visited, like the tree that falls in the forest. This problem of visibility has many facets, which are the same as for visibility in the real world. The visibility of Mr. Durand's personal site is for him the assurance of being known or contacted by those who wish to do so. The visibility of a commercial site represents money. Being more visible than one's competitors makes it possible to acquire new customers at their expense, which, in a still limited but rapidly expanding market, is a near-necessary condition for survival.

While the two problems of accessibility and visibility are symmetric, they do not necessarily go hand in hand. If an Internet user wants to eat apples, their main concern will be to find Web pages that discuss apples, or even sell them. On the other side, a pear enthusiast's site will want to make itself known to the apple-eating Internet user, if possible before they have found an apple site, in order to try to change their mind and convert them to pears.

The primary purpose of search engines is to ensure the accessibility of as many Web pages as possible to Internet users. In practice, from the largest possible selection of pages, the engine must return the pages that meet the user's needs, those needs being expressed through a _query_. But they have in fact also become the main medium of visibility for sites.

This strategic position, at the crossroads of the Internet user and the site, makes the search engine the centrepiece of today's Web, and it is no surprise to see that the company _Google_, which holds --- to this day --- a near monopoly in the search engine sector, is now publicly traded on the stock market.

#heading(level: 3, numbering: none)[Knowing the Web]

One of the foremost qualities of a search engine is having a substantial database, both from a quantitative and a qualitative standpoint. In Part~I we propose to highlight the issues raised by these databases built by search engines.

We begin by attempting to define the Web, which, as we shall see in @cl-def-web, is not as easy as one might initially think. Once this is done, we will be able, in @cl-taille, to study those subsets of the Web known as _crawls_. Crawls naturally carry a graph structure that we will detail in @cl-local. In particular, we will try to put into perspective the bow-tie model, whose conclusions are too often misinterpreted, and we will demonstrate the existence of a very strong site-level organisation of Web pages linked to the URL decomposition tree. We will show in particular that the canonical structure of sites makes it possible to compute in linear time a good approximation of a certain site decomposition of a Web graph.

#heading(level: 3, numbering: none)[Finding the right pages]

More than the size of its database, it is the way a search engine uses it that determines its effectiveness. While for a given query the database will often contain several tens of thousands of pages likely to provide a suitable answer, Internet users will rarely look beyond the first $10$ or $20$ results returned by the engine. It is therefore necessary to sort through the possible answers in order to extract, automatically, the few pages best suited to a given query.

First-generation search engines used methods of lexical and semantic relevance to perform this sorting: the first pages returned were those that, from the standpoint of semantic analysis, were closest to the query. But fairly quickly, relevance-based ranking was undermined by the sites' need for visibility. Many sites began to pad the semantic content of their pages using techniques of varying ingenuity and honesty, for example by filling the page with white text on a white background. Very often, instead of being directed to the most relevant pages, the Internet user would end up on pages that had nothing to do with their query, but whose desire for visibility was very strong.

To counter these techniques, new ranking methods were introduced, with the aim of inferring the importance of Web pages from the graph structure formed by the known pages. It is one of these families of ranking methods, the PageRanks, that will be studied in Part~II.

@pr-markov will recall some theoretical foundations on Markov chains, and will develop in particular certain connections between graph theory and the theory of stochastic processes that are necessary for a proper understanding of PageRank. @pr-pagerank will provide an opportunity to present a near-exhaustive bestiary of classical PageRank algorithms. In particular, we will present a unified view of PageRank in terms of stochastic interpretation, and highlight the commonalities, differences, advantages, and drawbacks of the various methods.

Finally, in @pr-back and @pr-dpr, we will present several original PageRank algorithms that we believe can bring significant improvements to existing algorithms.

The _BackRank_ algorithm, originally designed to model the use of the _Back_ button, has some interesting side effects, such as faster convergence than classical algorithms and the absence of problems related to the existence of dangling pages.

_FlowRank_ is an algorithm that attempts to take into account in a fine-grained manner the role of internal pages, external pages, and the _zap_ flow in an exact computation of PageRank. _BlowRank_ is a practical adaptation of _FlowRank_ inspired by another decomposed PageRank computation algorithm.

All these algorithms are potential tools aimed at facilitating the trade-off between accessibility and visibility, but they also make it possible to gain a better understanding of the mechanisms at play when one seeks to model stochastic behaviour on the Web.

#heading(level: 3, numbering: none)[Publications]

Here is the list to date of the publications of my work. @mathieu01structure @mathieu02structure @mathieu03local correspond to the work on Web graphs that forms the basis of Part~I of this thesis. @mathieu03effet @mathieu04effect are the starting point of @pr-back, just as @mathieu03aspects @mathieu04local are for @pr-dpr. The work on the classification of PageRanks in @pr-pagerank as well as the detailed analyses of the _BackRank_ and _BlowRank_ algorithms are too recent and have not yet been published. Finally, @mathieu04file is a research report on a model for download problems in peer-to-peer networks, carried out jointly with Julien Reynier. It is a promising subject, but one that still needs to mature, which is why I have simply placed it in the appendix (#fref(<annexe:p2p>)).

All these documents are available for download at

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
