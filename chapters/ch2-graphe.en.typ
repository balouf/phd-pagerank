// =============================================================================
// Chapter 2: Crawlers and Sizes of the Web
// =============================================================================

#import "../templates/environments.typ": *
#import "../templates/math-macros.typ": *
#import "../templates/acronyms.typ": *

#import "@preview/subpar:0.2.2"

= Crawlers and Sizes of the Web <cl-taille>

#citation([Michel #smallcaps[Houellebecq], _Lanzarote_])[The world is medium-sized.]
#citation([Bill #smallcaps[Vaughan]])[
Size isn't everything. The whale is endangered while the ant is doing just fine.
]
#citation([Hugo von #smallcaps[Hofmannsthal]])[
One must hide depth. Where? On the surface.
]

#v(1cm)

#lettrine("Now")[
  that we have defined a framework on which to work (the accessible Web), the question of which objects we will study arises. From a mathematical point of view, the accessible Web can be countably infinite --- according to RFC 2616 @rfc2616 --- or finite --- since there exists only a finite number of servers and each has a maximum URL length. In any case, it satisfies a certain physicist's definition of infinity, which is the one we shall use here: _large compared to the number of atoms in the universe_. The accessible Web indeed contains many nearly infinite nests of pages. The page that points to all pages, of course, but also misconfigured servers, or even commercial sites that, by creating an _infinity_ of pages, try to boost their PageRank (see Part~II, @sec:alter). To give a concrete example, during the presentation of their paper _Extrapolation methods for accelerating PageRank computations_ @kamvar03extrapolation, the authors recounted how one of their experiments was disrupted by a German website that accounted for 90~% of the pages they had indexed. Upon investigation, the site in question turned out to be a pornographic website that hoped, through an infinity of tightly interlinked pages, to achieve a high ranking in search engines (the principle of _Free For All_ pages, also known as _link farms_ or _nurseries_).
]

In conclusion, it is impossible to index _all_ of the accessible Web, just as talking about its size no longer makes sense#footnote[One may note that while, a few years ago, estimating the size of the Web was a _fashionable_ topic (see @broder98technique @murray00sizing @lawrence98searching @lawrence99accessibility @bergman00deep), no one has ventured into it for two years, and the viewpoint expressed here now seems widely shared (see in particular @dahn00counting @eiron04ranking).]. In the absence of physical access to servers, the only tangible data at our disposal are therefore _crawls_, that is, the regions of the Web actually discovered, and possibly indexed, by commercial enterprises (search engines) or public institutions. The purpose of this chapter is to define _crawls_ precisely, to give orders of magnitude, and to see to what extent it is possible to compare _crawls_ or to measure a certain quality.

== Web Crawlers <chalut-def>

_Crawlers_, or _spiders_, or _agents_, are the trawlers that traverse the Web in order to generate these pieces of the Web called _crawls_. There are two main types of crawlers: static crawlers and dynamic crawlers. The principle behind all static crawlers is the same: starting from an initial set of pages, they analyze the hyperlinks contained in these pages, attempt to retrieve the pages pointed to by these hyperlinks, and so on, thereby recovering an ever-growing portion of the pages of the accessible Web. Each page is _a priori_ retrieved only once, and the process is stopped when deemed appropriate (enough pages retrieved, growth having become negligible...). The _static_ crawl thus obtained consists of:

- a set of known pages, which is the union of the initial set and the set of discovered pages;
- a set of indexed pages, a subset of the known pages consisting of pages actually visited by the crawl;
- a set of hyperlinks originating from indexed pages and pointing to known pages.

A dynamic crawler, on the other hand, is not designed to stop, but to perpetually traverse the Web and periodically revisit the pages it has visited @abiteboul03adaptative.

What we call a crawler is in fact the collection of software and hardware resources used to carry out a crawl. What determines the particular crawl that a crawler produces?

- The date on which the crawl begins.
- The set of seed pages.
- The exploration strategy for new pages (in what order should which pages be retrieved?).
- Technical limitations: bandwidth, storage and processing capacity, available time...

This applies to all types of crawlers, even if asymptotically, only the exploration strategies and technical limitations play an important role for dynamic crawlers.

=== Creation of the initial page set

It goes without saying that choosing a good seed set is fundamental to a crawler's efficiency. For commercial reasons, it is difficult to obtain the seed sets of major search engines. Many people agree, however, that major search engines use:

- a _well-chosen_ subset of the pages obtained from previous crawls @cho98efficient. The home pages of _directories_, in particular, seem to be prime candidates for inclusion in the initial set @craven04google;
- new pages submitted through one of the many existing _referencing_ methods (sometimes paid);
- it is possible that some more or less clever techniques are also used to discover new pages, such as analyzing Web server logs, or attempting to traverse up the #acrpl("URL") tree of "isolated" pages (rumors read on various pages of the site `http://www.webrankinfo.com`).

To conclude regarding the choice of the initial set, let us note that it is this set that largely determines the bow-tie structure of a _Web graph_ (see @noeud-pap).

=== Exploration strategies <sec:explore-strategies>

An ideal crawler that could retrieve and process an infinite number of pages per unit of time would have no difficulty obtaining the entire Web theoretically reachable by hyperlinks from the initial set. All exhaustive traversal methods (breadth-first or depth-first, for example) would yield the same optimal result. But real crawlers are limited by their bandwidth, their processing capacity, and the number of requests per server per minute, which must account for both politeness rules and the risk of being banned.

All these constraints mean that, at any given moment, there exists a finite limit to the number of pages that a specific search engine can index, and it seems that this number has always been, regardless of the search engine considered, considerably smaller than the finite estimates of the Indexable Web @bergman00deep @lawrence98searching @lawrence99accessibility @henzinger99measuring @broder98technique.

Each engine therefore has a physical barrier to the number of pages it can index. For example, according to Google, this barrier is approximately 4 billion documents. The exploration strategy (coupled with the choice of the initial set) will determine which 4 billion pages these will be, and thus to a large extent the quality#footnote[In a vague sense...] of a crawl. A search engine whose agents got lost in nurseries and other _pages that point to all pages_ would surely have little success. This is why some engines, such as _AltaVista_ and _Teoma_, avoid the practice of _Deep Crawling_#footnote[_Deep Crawling_ consists of trying to retrieve the maximum number of web pages from a given site.], while others, such as Google, maintain a blacklist of nurseries.

The strategy can also negatively affect an engine's barrier if it does not seek to optimize available resources. For example, due to the limit on the number of requests per site, the bandwidth consumed by exploring a single server is often negligible compared to the available bandwidth, hence the near-necessity of exploring multiple servers in parallel. For the same reasons, it is always better to have a fast server among those currently being queried.

With all these "physical" constraints taken into account, two main philosophies can be distinguished among known exploration strategies.

- Traditionally, search engines seem to have employed a _breadth-first_ exploration, with pages discovered first being explored with priority (subject to the constraints described above) @broder00graph.
- Exploration methods inspired by random walks are also being developed (see @henzinger99measuring and, to some extent, the _greedy_ strategy of @abiteboul03adaptative). These methods have the advantage of more easily retrieving pages that are important in the PageRank sense @henzinger99measuring, or even of estimating the PageRank dynamically @abiteboul03adaptative. The connections between PageRank and random walks will be developed in Part~II.

== Sizes and Evolution of Crawls <cl-taille-web>

Now that the concept of a crawl has been roughly explained, we will provide some statistics on the orders of magnitude involved when discussing crawls of the major search engines.

=== According to the operators

These data were mostly obtained from the site #link("http://searchenginewatch.com/").

#figure(
  image("../figures/se-sizes.gif", width: 11cm),
  caption: [Number of pages claimed by various search engines as of September 2, 2003]
) <se-sizes>

@se-sizes presents the claimed sizes of the five billion-page search engines as of September 2, 2003. If we study the respective evolution of the different search engines, several major periods of upheaval can be distinguished, corresponding to periods of intense competition among engines. These _Crawl Wars_ are shown in detail @se-guerres. Each of these wars resulted, for the winner or winners, in the crossing of a psychological threshold.

Between December 1997 and June 1999, the first _Crawl War_ took place, at the end of which AltaVista surpassed the 150 million mark, closely followed by NorthernLight (@se-war1).

The second _Crawl War_ (September 1999 -- June 2000) was marked by a tight match between AltaVista and AllTheWeb, which concluded with the crushing victory of... Google, which went on to surpass one and a half billion claimed pages, setting a new standard (@se-war2).

The third war (June 2002 -- December 2002) began with a brief period of AllTheWeb in the lead. Google and Inktomi responded almost immediately, and within six months crossed the 3 billion web page mark. A few months later, AllTheWeb caught up (@se-war3).

#subfig(
  figure(
    image("../figures/se-evolution.gif", width: 7.5cm),
    caption: [Evolution of search engines (12--95 - 09--03)],
  ), <se-evolution>,
  figure(
    image("../figures/se-war1.gif", width: 7.5cm),
    caption: [Crawl War I (12--97 - 06--99)],
  ), <se-war1>,
  figure(
    image("../figures/se-war2.gif", width: 8.2cm),
    caption: [Crawl War II (09--99 - 06--00)],
  ), <se-war2>,
  figure(
    image("../figures/se-war3.gif", width: 6.8cm),
    caption: [Crawl War III (06--02 - 12--02)],
  ), <se-war3>,
  columns: (1fr, 1fr),
  caption: text(size: 10pt)[Crawl Wars. Legend: AV=AltaVista, ATW=AllTheWeb, EX=Excite, GG=Google, GO=GO/Infoseek, INK=Inktomi, LY=Lycos, NL=Northern Light, TMA=Teoma. Unit: 1 million pages (@se-war1 and @se-war2) or 1 billion pages (@se-evolution and @se-war3).],
  label: <se-guerres>,
)

Currently (summer 2004), Google claims to index more than 4 billion pages, but the battlefield has shifted. The battle between Google and Yahoo (which outsourced to Google until February 2004, and has since used Inktomi's database) is attempting to become more subtle, the goal being to provide "the most understandable and most relevant" results. Yahoo is reportedly preparing its own version of Google's PageRank, called WebRank.

=== According to the auditors <subsec:se-police>

All the figures we have just seen are those announced by the search engines themselves. Since we are in a context of commercial competition, it is legitimate to question the reliability of these figures, with the challenge of defining an adequate methodology.

The site _SearchEngineShowdown_ @showdown, administered by Greg Notess, proposes a rough method for estimating the effective size of search engines. The principle is to submit several queries in parallel to the different search engines one wishes to compare, and to postulate that the number of results returned by each engine is, to a first approximation, proportional to the number of #acrpl("URL") known by that search engine. If the actual size of one of the engines is known, then a simple rule of three can be used to estimate the actual size of the others. Now, in December 2002, it was possible to know the exact size of the AllTheWeb engine simply by submitting the query `url.all:http`#footnote[Thanks to Greg Notess, webmaster of the SearchEngineShowdown site, for sharing this method with me, even though it no longer works today. The query _url.all:http_ only works with engines using Fast technology, which has no longer been used by major engines since April 1#super[st], 2004 (and this is not a hoax...).].

@fig:se-showdown compares the claimed and estimated sizes (using Greg Notess's method) of several search engines. Three categories of search engines can be easily distinguished, which reveal both the possible exaggerations of the engines and the bias introduced by the queries:

/ The realists: _Google_, _AllTheWeb_, and _WiseNut_ have estimated and claimed values that are extremely close, and tend to prove that the estimation method has a certain reliability.

/ The sites that wanted three billion: The estimated sizes of HotBot and MSN Search are in sharp contradiction with the claimed values. These are engines based on Inktomi technology. According to Inktomi, not all the computers forming their database are accessible at the same time, so one can never access the entire database. Moreover, it is possible that Inktomi's partners (HotBot and MSN Search in this case) use only a portion of the database, for practical or commercial reasons. For Greg Notess, these estimates therefore reflect the portion of the database actually available at the time the queries were made. It is clear that the bias of Notess's method prevents us from making categorical assertions, but one cannot help suspecting that the figure of three billion is a publicity response to Google's three billion (recall: we are at the end of the third _Crawl War_).

/ The modest ones: AltaVista, Teoma, NLResearch, and Gigablast seem to claim much less than their actual size, which does not seem very logical. According to Greg Notess, the explanation for this paradox lies in how known but non-indexed pages are counted. Indeed, the sites we called _realists_ seem to claim their known #acrpl("URL"), whether indexed or not, while the _modest ones_ restrict themselves to pages actually indexed. When one knows that non-indexed pages represent at least 25~% of known pages, but less than 1~% of query results#footnote[There do exist, however, queries returning only non-indexed pages. I recommend, on _Google_, the query `site:.xxx`, which returned, in August 2004, 765 non-indexed pages (since they were non-existent, the TLD .xxx not existing at the time of the experiment), of which only 495 were relevant...] (source: _SearchEngineShowdown_), we have a beginning of an explanation for the phenomenon.

#figure(
  image("../figures/se-showdown.pdf", width: 14cm),
  caption: [Estimated and claimed sizes of various search engines as of December 31, 2002 (source: @showdown)]
) <fig:se-showdown>

=== Personal remarks

Before going further, I would like to highlight a personal observation regarding the extreme volatility of the figures put forward by search engines. For example, while the number of #acrpl("URL") claimed by Google is four billion, the query "the"#footnote[#link("http://www.google.com/search?hl=fr&ie=UTF-8&safe=off&q=the&btnG=Rechercher&lr=")] promises $5 space 840 space 000 space 000$ pages. On the other hand, it is in theory possible to know the number of known pages for a specific domain (for example `.fr`) by using a query of the type `site:tld`. By performing this operation on all TLDs, one should logically arrive at close to six billion pages, or more. However, the experiment yields only $749 space 485 space 183$ (to within 0.26%, _Google_ giving only 3 significant figures). One must conclude from these two tests either that, at the time of the experiments, Google indexed at least $5 space 840 space 000 space 000$ pages and at most $749 space 485 space 183$, or that more than 5 billion indexed pages do not belong to existing TLDs, or that the figures announced by Google should be taken with a degree of caution.

The new _Yahoo_ search engine also gives sometimes peculiar results. For instance, I observed that the number of results could depend on the rank from which one wished to view the results. Thus, while the query `"pâte à crêpes"` returns $7480$ results when displaying the first $20$ pages, this number drops to $7310$ when requesting pages $981$ to $1000$, with a regular decrease. Experimentally, the difference can reach 5% of the announced figure.

Finally, one must not forget to mention the problem of duplicates. Indeed, most major engines treat, for their indexes and algorithms, `www.domain.com/`, `domain.com/`, and `www.domain.com/index.html` as different pages. The grouping is done _a posteriori_, using hashing methods to identify identical pages (which _Google_ euphemistically calls _pages with similar content_). In summary, duplicates are counted in the number of pages found, but are not returned in the results (unless explicitly requested by the user). To fix ideas, @tab:pages-uniques presents the results of a few queries for which it is possible to know the number of pages excluding duplicates#footnote[Since _Yahoo_ and _Google_ only return the first $1000$ results of a query, it is only possible to count duplicates when the number of unique pages is less than $1000$. One then simply needs to request the last 10 results to obtain the desired information.]. By convention, we have chosen to define the number of pages claimed by _Yahoo_ as the one reported when requesting the last pages.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    inset: 0.5em,
    align: (left, right, right, right, right),
    table.header(
      [], table.cell(colspan: 2)[Claimed pages], table.cell(colspan: 2)[Unique pages],
    ),
    table.hline(),
    [*Query*], [*Google*], [*Yahoo*], [*Google*], [*Yahoo*],
    table.hline(),
    [Anticonstitutionnellement], [752], [795], [442], [485],
    [Raton laveur], [18200], [23500], [801], [>1000],
    ["Pâte à crêpe"#super[\*]], [2690], [1630], [591], [489],
    ["Pâte à crêpes"#super[\*]], [7900], [5950], [745], [971],
    [Webgraph], [9040], [8180], [603], [759],
  ),
  caption: [Claimed pages or pages with similar content? A few examples as of August 28, 2004. #super[\*]Note that according to the _Petit Robert_, one should write _pâte à crêpe_ and not _pâte à crêpes_.]
) <tab:pages-uniques>

== Measurements on Crawls <sec:crawl-qualite>

The study and comparison of different crawls is a delicate subject to address. On one hand, there are commercial crawls produced by search engines, which can generally only be accessed through public queries made on the engines themselves, queries that are very often throttled. On the other hand, research laboratories often offer smaller sizes and extremely varied crawling methods. Because of these disparities, it can be difficult to compare different results, or even to know whether they are comparable. The purpose of this section is to catalogue different methods for evaluating crawls, in the case of both private and public data.

The method for estimating actual sizes proposed by Greg Notess (cf @subsec:se-police) can also serve as a measure of crawl quality. By counting the responses to 25 representative queries, one measures in a sense the ability of an engine to respond to these queries, effectively turning the query bias into a quality measure.

=== Overlap techniques

This system of comparison by queries is used in a more advanced way in the overlap comparison method, introduced by Bharat and Broder in 1998 @broder98technique and revisited by Lawrence and Giles @lawrence98searching @lawrence99accessibility.

The principle of the overlap method is as follows: to measure the overlap between the respective indexes of two engines. For example, if one can determine that a fraction $p$ of an index $A$ is in $B$, and that a fraction $q$ of $B$ is in $A$, then one can deduce that $abs(A inter B) = p abs(A) = q abs(B)$, and thus obtain the size ratio between the indexes:

$ frac(abs(A), abs(B)) = frac(q, p) $

The whole challenge is to estimate $p$ and $q$ in the absence of a freely accessible public index. This is where query-based sampling comes in: queries created by a random generator as uniform as possible are submitted to an engine. Each time, one of the results among the first 100 is chosen at random, and it is verified, using more or less strict methods, whether this result is in the other engine's index.

Compared to Notess's method, two additional sources of bias (in addition to the bias due to query selection and standard sampling biases) are introduced:

/ Ranking bias: By choosing samples only from the first 100 results (a constraint imposed by the search engines themselves), the rankings (importances) of the pages considered are statistically higher than average.

/ Verification bias: There is no perfect method for checking whether a given page belongs to an index. The various methods proposed by Bharat and Broder are based on analyzing a query supposed to define the page, and the validation criteria range from _the engine returns the correct page_ to _the engine returns a non-empty result_.

Overlap measurements had their heyday during the Crawl Wars#footnote[To go so far as to say that certain papers primarily served to show that AltaVista had the largest database is only a small step that I shall take @noeud-pap...] (see @cl-taille-web), but while they have the advantage of introducing a rigorous formalism, the cost in terms of bias and the relative complexity of the method mean that Notess's method remains very competitive.

=== Sampling by random walk

An interesting variant of Bharat and Broder's sampling method was proposed by Henzinger _et al._ @henzinger99measuring: rather than measuring one engine using another, the principle is to use as a yardstick a personal crawl derived from a random walk. This random walk does not provide a uniform sample of Web pages#footnote[Choosing a Web page _at random_ is impossible, the indexable Web being infinite.], but a sample that, up to statistical biases, obeys the probability distribution associated with the random walk. This distribution over Web pages, better known as the PageRank (see Part~II), will allow, by measuring the fraction of samples known to the engine using overlap techniques, to estimate the amount of PageRank contained in the pages known to the engine.

The specific bias of this method is that behind the random walk sampling lies an implicit crawl, the crawl that would be obtained by letting the random walk run long enough. One therefore measures the PageRank of the engine under evaluation relative to the PageRank on this virtual crawl. In particular, any divergence between the crawl strategies of the random walk and those of the engine is detrimental to the evaluation of the latter: if the engine has indexed parts of the Web that the random walk, for various technical reasons, has never touched, those parts will not count in the evaluation. Conversely, if certain sites are deliberately avoided by the engines (nurseries, for example, see #fref(<sec:explore-strategies>)), this omission will be penalized in the evaluation.
