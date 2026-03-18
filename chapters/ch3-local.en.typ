// =============================================================================
// Chapter 3: Graphs and structures of the web
// =============================================================================

#import "../templates/prelude.typ": *

= Graphs and structures of the web <cl-local>



#citation([Benoît #smallcaps[Gagnon]])[Life is an ephemeral butterfly bearing the wings of paradox.]
#citation([#smallcaps[Tacitus]])[Places do not change their appearance as men change their faces.]
#citation([#smallcaps[Anonymous]])[A good website is always under construction.]

#v(1cm)

#lettrine("Now")[ that the concepts of the Web and of crawling have been clarified, we can study what can be said about them. Since this chapter is devoted to structures, it is appropriate to place a canonical structure on the crawls we wish to study. One of the simplest and most natural structures in the case of Web crawls is the graph structure. Web graphs, a definition of which is given in @sec:graphewebdef, are a frequent subject of study. After critically analyzing one of the best-known models, the butterfly model (@noeud-pap), we will highlight in the remainder of this chapter the importance of the site structure in Web graphs.
]

== Web graphs: definition <sec:graphewebdef>

Consider a crawl $C$. This crawl consists of a set of URLs, some of which have been visited, and others merely detected through the hyperlinks of visited pages. It also contains the set of hyperlinks from visited pages. We will call the graph of crawl $C$ the directed graph $G=(V,E)$, where $V$ is the set of pages in the crawl, whether visited or not, and such that an arc $e in E$ connects a page $i$ to a page $j$ if, and only if, $i$ contains a hyperlink pointing to $j$. By convention, anchors#footnote[Anchors allow pointing to a specific part of a Web page.] are ignored, and multiple links add nothing to the graph (if a page $i$ has two hyperlinks pointing to $j$, the graph will still have only one arc from $i$ to $j$). Likewise, links from a page to itself will not be taken into account.

By abuse of language, we will often use the term _Web graph_ to designate such a graph $G$. One should always remember that these are in fact always crawl graphs.

== The butterfly model revisited <noeud-pap>

The butterfly structure of the Web graph is today accepted by many people, and is very often mentioned in scientific articles @cooper02crawling @abiteboul03adaptative @langville04deeper @raghavan03representing @arasu01pagerank @kamvar-exploiting or in popular science publications @tangente, sometimes in a completely irrelevant manner#footnote[For example, it is claimed in @langville04deeper and @kamvar-exploiting that Arasu _et al._ use the butterfly model to speed up their PageRank computation @arasu01pagerank. Upon verification, Arasu _et al._ do cite the butterfly model, but propose a PageRank computation method based on... writing $A$ in block triangular form derived from the strongly connected components decomposition (cf. @thm:sousfiltre). In particular, the only contribution of the butterfly model is the existence of one diagonal block larger than the others, the _#acr("SCC")_.]. I consider for my part that the butterfly model applies poorly to dynamic graphs in general, and to Web graphs in particular. This section, whose ideas come from @mathieu01structure, will try to justify this position by attempting to distinguish myth from reality in order to identify the true contribution of the article _Graph Structure in the Web_.

=== The butterfly model

_Graph Structure in the Web_ @broder00graph is an article that was presented at the 9#super[th] International Conference on the World Wide Web. The article is based on the analysis of two crawls provided by the AltaVista search engine, a crawl of 203 million pages dated May 1999 and one of 271 million pages from October 1999. The analysis yields several results on the structure of the Web graph, the most novel being the discovery of a butterfly structure:

- Approximately one quarter of the pages considered belong to a single strongly connected component, called the core or #acr("SCC").
- Another quarter consists of pages from which one can reach the core, while the reverse is not true. This is the IN component.
- Conversely, nearly one quarter of the pages are reachable from the core, while the reciprocal is false. These pages form the OUT component.
- Pages that are reachable from IN, or that allow access to OUT, and that belong to neither IN, nor OUT, nor #acr("SCC"), form the tendrils (TENDRILS) and also represent nearly one quarter of the pages.
- The four quarters we have just mentioned actually form 90% of the pages in the crawl, constituting the largest connected component. The remaining 10% are components disconnected from the rest and of smaller size.

#figure(
  image("../figures/pap_fr.pdf", width: 70%),
  caption: [The butterfly structure],
) <fig:pap_fr>

This structure is commonly represented by a diagram similar to that of @fig:pap_fr. The butterfly shape obtained from the IN, #acr("SCC"), and OUT components gives its name to the model (_bow tie_).

From this article, many people have retained the idea that this roughly equal division into IN component, #acr("SCC"), OUT, and tendrils is characteristic of the Web: this is the butterfly model.

=== Weaknesses of the butterfly model

==== Does it still exist?

The main drawback of the butterfly model is that in all likelihood, it no longer represents reality. The Web graph, that is, the graph of the accessible Web, cannot have a balanced butterfly structure, since it contains among other things the _page that points to all pages_ (cf. @lpqpvtlp). One must therefore consider that this model applies to graphs derived from large Web crawls (this is moreover the opinion of the authors#footnote["This suggests that our results are relatively insensitive to the particular crawl we use, provided it is large enough.", _op. cit._]). However, one observes that:

- Today, most large crawls are the work of search engines.
- These engines list the sites they discover (through crawling or indexing) in directories.
- Directories obviously belong to the core of the Web.

What can then happen for a page that, for a given crawl, belongs to the IN component, or to the tendrils, or even to the disconnected components:

- If the page or one of its ancestors is indexed by the directories, it ends up _de facto_ either in the core or in OUT.
- A page is part of the crawl because one of its ancestors was part of the initial crawl set. If no ancestor of the page has been added to the directory, one may doubt that an ancestor would be kept in the initial crawl set. Consequently, at the next crawl, the page will disappear.

In conclusion, yes, there can be an IN component, or disconnected components, but these components are necessarily transient, precisely because of the relationships between crawlers and directories. One must also take into account the fact that current large crawls contain a non-negligible proportion of non-indexed pages (at least 25% according to a 2002 study @showdown, 75% according to a 2004 article @eiron04ranking), which automatically inflate the OUT component. For all these reasons, I am inclined to strongly doubt that more than 2 (3?) billion pages indexed by Google belong to neither the core nor OUT.

==== A model lacking robustness

A question one may ask is whether the parameters considered are relevant for the study of Web graphs. On the one hand, we have crawls, which try as best they can to traverse a Web that is dynamic both spatially and temporally, and which often have a very low _overlap_ between them @broder98technique. On the other hand, definitions such as _IN: the set of pages that can reach the core but are not reachable from it_. Is it reasonable to combine highly variable crawls with fragile definitions? A concrete example: imagine that an unscrupulous individual seizes the set of initial pages from AltaVista's crawls and places links to these pages on their Web page. If this page is in the core, this means the collapse of all components onto #acr("SCC") and OUT#footnote[This collapse phenomenon is in fact what tends to happen today with directories.].

Contrary to what the authors claim#footnote["The structure that is now unfolding tells us that it is relatively insensitive to the particular large crawl we use. For instance, if AltaVista's crawler fails to include some links whose inclusion would add one of the tendrils to the #acr("SCC"), we know that the resulting change in the sizes of #acr("SCC") and TENDRIL will be small (since any individual tendril is small). Likewise, our experiments in which we found that large components survived the deletion of nodes of large in-degree show that the connectivity of the web is resilient to the removal of significant portions", _op. cit._], a single page, not even that large#footnote[It appears that the starting set for AltaVista's crawls at the time consisted of a few hundred pages. A bookmarks page can easily contain a few hundred hyperlinks.], suffices to undermine the butterfly model. We are in fact dealing with a methodological flaw: when faced with data subject to great uncertainty and dynamics (Web graphs), it makes no sense to treat variables that are extremely sensitive to initial conditions as universal constants. For the same reasons, considering the diameter of the connected component is hardly relevant; indeed, for the 2 AltaVista crawls studied, it remains roughly constant (around 500), but upon closer inspection, evidence seems to suggest that the diameter of 500 is due to a single chain, possibly a misconfigured page or a robot trap that escaped the filters#footnote["Beyond a certain depth, only a few paths are being explored, and the last path is much longer than any of the others.", _op. cit._].

==== An unreplicated experiment

To my knowledge, the experiment of @broder00graph has not been replicated on large crawls since. The only real experiments conducted on the butterfly model therefore concern two proprietary AltaVista crawls, close in time and thus likely based on the same technology (which may explain certain artifacts such as the constancy of the diameter). Moreover, if one compares the size and dates of these two crawls (May 1999, 203 million pages, October 1999, 271 million pages) with @se-war1 and @se-war2 (#fref(<se-war1>)), one reaches the conclusion that the crawls used were certainly experimental.

In @dill01selfsimilarity, it is nonetheless found that the butterfly structure is a fractal figure of the Web structure, meaning that one finds within sites and communities the same butterfly model as on the entire graph. Upon closer inspection, one notices that the global butterfly structure is taken for granted, and that the proportions of IN, OUT, and #acr("SCC") observed in the subgraphs are extremely variable, which supports the preceding remarks.

=== The butterfly model in a sociological context

To properly understand the success of the butterfly model, it is important to place it in context. We are at the beginning of the year 2000. The _Internet Bubble_ is still in full growth, and articles are appearing indicating that search engines can no longer keep up with the growth of the Web @brake97lost @lawrence99accessibility @bergman00deep. The AltaVista company had won the first _Crawl War_ (see #fref(<se-war1>) as well as the conclusions of @broder98technique) by surpassing 150 million indexed pages, but it lacked the assurance that this increase in size would allow it to keep pace with the evolution of the Web. In this context, _Graph Structure in the Web_ was perfectly timed. Indeed, what is the takeaway of the article?

- There exists a global structure of the Web (with a capital W).
- This structure is invisible if one considers too small a portion of the Web, but there exists a threshold beyond which a crawl's structure is the structure of the Web.
- AltaVista's crawls are large enough to possess the structure of the Web.

In short, _Graph Structure in the Web_ responds to an expectation that is both existential (Can we understand the Web?) and commercial (Our crawl is the Web.). One could almost see it as a mechanism arising from the laws of supply and demand. Ultimately, the question of whether its scientific foundations are sound or not becomes secondary, which is perhaps a beginning of an explanation for the success of this article.

=== Conclusion

The butterfly model most certainly had meaning at the time of its discovery, but that meaning is not _the Web has a butterfly structure_. It rather expresses a particular situation where, because of the _Internet Bubble_, new pages were arriving too quickly for the Web to assimilate them. But today, two phenomena mean that we are no longer in this situation: on the one hand, the _Bubble_ has burst. The creation of new sites has become rare, and we are witnessing more the development of existing sites than the appearance of a swarm of unregistered sites (cf. @subsec:nbre-serveurs), which is a beginning of an explanation for the fact that the butterfly structure is found within site graphs @dill01selfsimilarity. On the other hand, search engines no longer merely index the Web; they continuously modify its structure through directories. These two effects, combined with the model's lack of robustness, make it unlikely that large commercial crawls still have the same proportion of IN, tendrils, and other disconnected components as those found in _Graph Structure in the Web_.

One should nevertheless retain that Broder _et al._ highlighted the existence of a large core of pages all connected to one another, as well as the protectionist behavior of certain commercial sites that place themselves entirely within the OUT component. One should also retain that the proportion of the IN component in a crawl graph is a certain indication of the difficulty a large structured graph has in adapting to rapid expansion.

== Role of servers and sites in the structure of the Web graph <sec:structure-sites>

The notion of site is fundamental in the organization of the Web. For example, many search engines have a policy of returning only a limited number of pages per site (with a _more pages from the same site_ option available). A good decomposition into sites has numerous applications, ranging from PageRank computation methods @kamvar-exploiting @mathieu04local to efficient compression methods for crawls @randall01link @guillaume02efficient.

=== Web servers, sites, and communities <subsec:serveur-def>

The concepts of Web server, site, and community are often encountered in the literature, with sometimes contradictory definitions. We will make explicit here what we mean by server, site, and community.

/ Physical server: A physical Web server is defined as a specific physical machine connected to the Internet and identified by an IP address, which returns a 200 response code and a Web page in response to an _#acr("HTTP")_ request asking for the root (_/_) on port 80#footnote[Port 80 is the standard port for the HTTP protocol. Other ports are used more or less commonly, such as port 443 for secure HTTP or port 8080 for a secondary server, but we will not consider them here.]. The physical website associated with the server consists of all pages hosted at the given IP address.

/ Virtual server: Since IP addresses are not unlimited, solutions had to be devised to conserve addresses. One such solution is the use of virtual servers. Virtual servers, introduced with the _#acr("HTTP") 1.1_ standard, allow a single IP address to behave as several servers differentiated by their #acr("DNS") address (_Hostname_). This method is used, for example, by _free_ for hosting its clients' personal pages, or in Japan, where IP address resources are very limited. From the user's perspective, a virtual server is indistinguishable from a physical server, except that one cannot replace the #acr("DNS") address with the IP address.

/ Logical site: A logical website consists of a set of pages strongly connected by hyperlinks. Intuitively, a site is characterized by a certain homogeneity of style (imposed by the _Webmaster_) and easy navigation among the site's pages. The study of sites will be the subject of sections @cl-local:site-visu and @cl-local:site-parti.

/ Community: The notion of community is in some sense orthogonal to the notion of site. A community is a set of pages connected by a common interest. The search for communities is at the heart of Kleinberg's _#acr("HITS")_ algorithm @kleinberg98 as well as the _CosmoWeb_ project @bouklit04cosmoweb.

=== Evolution of the number of servers <subsec:nbre-serveurs>

It is easier to estimate the number of Web servers (physical and virtual) than the number of Web pages.

#figure(
  image("../figures/se-phy-evolution.pdf", width: 95%),
  caption: [Physical Web servers (IP addresses)],
) <fig:se-phy-evolution>

To count physical servers, it "suffices" to make an _#acr("HTTP")_ request to all possible IP addresses. Now, if we ignore IPv6 addresses, which remain relatively negligible, there are only $2^32$ possible addresses, or approximately four billion#footnote[There are in fact fewer if one removes certain _reserved_ addresses -- military addresses for example -- which are not supposed to host an accessible Web server. The _#acr("IANA")_ is the organization responsible for managing the available and unavailable address ranges. One can thus eliminate approximately 48% of the available addresses.]. This work was carried out by the _Web Characterization Project_ @wcp02, over the period 1998--2002, and the results concerning the number of servers are shown in @fig:se-phy-evolution. The number of unique physical servers is the number of physical servers minus the duplicates, that is, servers returning exactly the same content as a previously tested server.

The main remark one can make regarding these figures is the observation of a stagnation in the number of physical servers since 2001. This stagnation can be explained by the end of the _Internet Bubble_. Indeed, the Web has ceased to be a new technology, and most academic, commercial, and social actors likely to integrate into the Web have already done so. According to the _Web Characterization Project_, almost no new Web servers are being created; growth occurs individually at the server level.

#figure(
  image("../figures/se-virt-evolution.pdf", width: 95%),
  caption: [Virtual Web servers (domain names)],
) <fig:se-virt-evolution>

The study of virtual servers was carried out by the _Netcraft_ website @netcraft04. It consists of listing all declared #acr("DNS") addresses (like the _WhoIs_ site @whois04), and testing by means of an _#acr("HTTP")_ request the existence of a server at each of the addresses obtained.

The evolution of virtual Web servers, according to _Netcraft_ @netcraft04, shows a roughly linear constant progression in the number of active virtual Web servers over the last 4 years (cf. @fig:se-virt-evolution). This is in any case not, a priori, a geometric progression.

=== Intuitive and visual approach to the notion of site <cl-local:site-visu>

The concept of site is, in our view, fundamental to the structure of the Web. Its applications are numerous:

- More precise evaluation of the degree of completeness of a crawl (for each site, what proportion of pages has been visited?)
- Distinguishing purely navigational links from more relevant links (trust links to other sites).
- Allowing certain search engines to return only one or two pages per site, in order to avoid monopolization of query results.
- Refinement of the _zap_ factor in PageRank computations (see Part~II, @sec:pr-modele, as well as @brin98what @henzinger99measuring)
- PageRank algorithms based on site structure (the FlowRank algorithm, presented in Part~II, @pr-dpr, as well as its "competitor" BlockRank @kamvar-exploiting)

Most of the time, sites are approximated by servers (@adamic99small). But reality can sometimes be more complex. Large sites may rely on several servers, while conversely a server may host several sites. For example, one would want to group www.microsoft.com and download.microsoft.com and consider them as part of the same site. Conversely, not all personal site hosting providers use virtual domains; a large proportion places sites in the directories of a single server.

All these considerations lead us to raise the question of the definition of a logical site. Human users generally have no difficulty knowing what a site is, which constitutes a kind of empirical definition, but is hardly rigorous and does not lend itself to automation. Note that sites manually listed by _directories_ fall under this definition.

The Web Characterization Project @wcp02 proposes the following semantic definition:

#quote(block: true)[
  _[A Web Site (Information Definition) is] a set of related Web pages that, in the aggregate, form a composite object of informational relevance. Informational relevance implies that the object in question addresses a non-trivial information need._

  [A logical website is] a set of related pages that, in the aggregate, form a composite object delivering relevant information. This relevant information implies that the object in question addresses a non-trivial information need.
]

To this semantic characterization, Li, Kolak, Vu, and Takano add in @li00defining a structural approach to define the notion of _logical domain_:

#quote(block: true)[
  _A logical domain is a group of pages that has a specific semantic relation and a syntactic structure that relates them._

  A logical domain is a group of pages that possess a specific semantic relation and a syntactic structure that connects them.
]

Based on this definition, they define a set of rules (semantic and structural) to identify sites.

More modestly, our approach is to see what can be achieved by considering only the structural aspect of pages. We therefore limit ourselves to, on the one hand, the graph structure induced by hyperlinks, and on the other hand, the tree structure of URLs that reveals natural clusters in crawl graphs. Indeed, very often, a logical site obeys hierarchical rules at the level of URLs (Uniform Resource Locators @rfc1738), the most common being the existence of a characteristic common prefix.

#figure(
  image("../figures/test.pdf", width: 85%),
  caption: [#acrpl("URL"): a natural decomposition tree for Web graphs],
) <clustered>

This decomposition tree#footnote[Thanks to Fabien de Montgolfier for reminding me of the term _decomposition tree_.] structure on graphs (_clustered graphs_) was introduced by Feng _et al._ in @feng95draw as a tool for representing large graphs. Its main use is therefore to allow drawing graphs in a way that reveals any existing hierarchy, and decomposition trees are mainly used in domains where implicit or explicit diagram structures exist#footnote[One may think, for example, of modular decomposition trees.].

The whole problem is then to find, for a given graph, the decomposition tree that offers the best structural representation @brinkmeier-communities. In the case of Web graphs, the #acrpl("URL") tree provides an intrinsic decomposition tree.

==== Definition

Let $G(V,E)$ be a graph. A decomposition tree of $G$ is a tree $T$ whose leaves correspond to the vertices $V$. Each internal node $n$ of $T$ defines a cluster (a set of vertices) $V_T(n)$. This cluster consists of the set of vertices of $V$ corresponding to the leaves of the subtree of $T$ rooted at $n$. For example, the cluster associated with the root of $T$ is the entire set $V$.

A good example of the use of decomposition trees is the modeling of human relationships. There exists indeed a fairly natural graph of human relationships, where vertices are people and where a person $A$ points to a person $B$ if $A$ knows $B$). A decomposition tree that can meaningfully complement this graph is that of geographic location: world, country, (state), city, neighborhood, street, ...

==== Web graphs and the URL decomposition tree

#acrpl("URL") provide a natural decomposition tree structure on Web graphs. The set of servers#footnote[For simplicity, we will restrict ourselves to servers identified by their #acr("DNS") domain name and using port 80.] can be represented as a tree whose root is `http`, the depth-1 nodes are the TLDs#footnote[_#acr("TLD")_, or top-level domain. TLDs are divided into two categories: generic top-level domains (gTLD) and country code top-level domains (ccTLD). TLDs are managed by IANA (`http://www.iana.org`).], followed by the domain names proper and possibly subdomains. Each server, which is a leaf of the domain name tree, hosts a page hierarchy identical to the structure of the corresponding physical file system. The union of the file trees within the server tree yields the #acrpl("URL") decomposition tree.

For example, the #acr("URL") `http://smith.mysite.org/linux/index.html` decomposes into _#acr("HTTP")_, _org_, _mysite_, _smith_, _linux_, and finally _index.html_, thus forming a path from the root to the corresponding leaf in the decomposition tree (see @clustered).

One may also question the relevance of beginning the decomposition with the top-level domain (TLD). Indeed, there exist macro-sites that, in order to achieve better visibility, deploy across several TLDs (`.com` and the ccTLDs of the countries where they operate, quite classically). We nevertheless prefer to retain sorting by TLD, on the one hand because this corresponds to the original philosophy of domain names, and on the other hand because there also exist domain names for which the TLD makes a considerable difference. The discerning adult reader may, for example, note a definite semantic difference between the content of the site `http://www.france2.fr` and that of `http://www.france2.com`...

==== Seeing the structure of sites

#figure(
  image("../figures/frf.pdf", width: 85%),
  caption: [Adjacency matrix of $6 dot 10^4$ pages from a crawl of $8$ million pages of `.fr`],
) <adja-fr>

Given that, in general, webmasters try to organize their sites, one can expect the concept of website to be intimately connected to the URL decomposition tree. We have confirmed this by observing the graphical representation of the adjacency matrix $M$ of the graph of a crawl of approximately 8 million URLs _sorted in lexicographic order_ from `.fr`, carried out in June 2001 as part of the cooperative research action _Soleil Levant_ @soleil01.

We have represented a small portion of this crawl (60,000 pages) in @adja-fr, and some zooms on interesting sub-portions in @adja. The first observation is that the adjacency matrix can obviously be decomposed into two terms, $M=D+S$, where $D$ is a block diagonal matrix, and where $S$ is a (very) sparse matrix.

Sites (and sub-sites) indeed appear as squares that coincide with the nodes of the URL tree. With a little practice, one can even guess the deep structure of sites from the appearance of the corresponding _square_. For example, pages with high out-degree (typically, the site map) result in horizontal lines, while those with high in-degree (the home pages) are characterized by vertical lines. "Noisy" squares, that is, with points exhibiting a pseudo-random structure (cf. @aemiaif), are often the sign of interactive documentation pages (dictionaries, for example). Let us finally note that the $D+S$ structure can exhibit a recursive character, as shown by the block in @algo.

#subfig(
figure(
      image("../figures/allmacintosh.pdf", width: 100%),
      caption: [allmacintosh.easynet.fr, a software site],
    ), <allmacintosh>,
figure(
      image("../figures/osx.pdf", width: 100%),
      caption: [allmacintosh.(...).fr/osx, a sub-site for a specific OS],
    ), <osx>,
figure(
      image("../figures/aemiaif.lip6.pdf", width: 100%),
      caption: [aemiaif.lip6.fr/jargon, an interactive dictionary],
    ), <aemiaif>,
figure(
      image("../figures/algo.inria.pdf", width: 100%),
      caption: [algo.inria.fr, the site of an INRIA research team],
    ), <algo>,
  label: <adja>,
  columns: (1fr, 1fr),
  caption: [Visual approach to site structure: zooming in on clusters from @adja-fr],
  )

=== Proposed algorithm for partitioning into sites <cl-local:site-parti>

We will attempt, using only the knowledge of the graph and #acrpl("URL") of a crawl, to generate as simply as possible a partition of the graph that reflects the notion of site. Our approach thus differs from that employed by @li00defining, who also uses a set of semantic rules to define sites.

==== Formal model

Structurally, we believe that a site is defined as a set of pages tightly connected to one another by navigational links, as the adjacency matrix representations seem to confirm (cf. @adja-fr).

This leads us to try to define a function that measures the quality of a site partition relative to the rate of navigational links. This function, $f_G : cal(S) "partition of" G -> f(cal(S)) in RR$ must reach an extremum when $cal(S)$ approaches (in a sense to be specified) what we would like to call a site partition. Once such a function is found, the standard method for partitioning $G$ consists of constructing an initial partition of the URLs (adapted to the situation considered), then performing local adjustments to try to optimize $f(cal(S))$.

==== Choice of the function $f_G$

Since the most important factor in our view for estimating a site partition is the number of navigational links, it seems logical to seek a function $f_G$ that depends explicitly on $i$, the number of internal links. One must also take into account the number of sites: indeed, this number is not fixed in advance (otherwise, we would be in the classical framework of _mincut_ or _maxcut_ type algorithms). To avoid having the trivial partition $G$ as the extremum, and to try to obtain a fine decomposition, it also seems important to us to try to maximize the number of sites $p$. We thus have two global parameters, the number of sites $p$ and the number of internal links $i$, and the function $f$ we seek must satisfy both $(partial f)/(partial p)>0$ and $(partial f)/(partial i)>0$. Several simple formulas are a priori possible:

- $f : (p,i) -> alpha p + i$, $alpha in RR$.

  This solution will not be retained here, mainly because the choice of $alpha$, to be judicious, needs to equal the average number of links per page, which leaves little room for maneuver. Indeed, if $alpha$ is larger than this number, one risks reducing the problem to maximizing $p$ (it becomes advantageous to isolate pages), while if it is smaller, for the same reasons, only $i$ will matter.

- $f : (p,i) -> p dot i^alpha$, $alpha in RR$.

  This solution has the advantage of being more flexible regarding the ratio between $p$ and $i$.

- $f : (p,i) -> p^(i/|E|)$, where $|E|$ is the total number of links.

  This last solution is deliberately parameter-free because we thus have a quantity with an intuitive interpretation: for a partition with no external links, we would have $f(p,i)=p$. More generally, $f$ remains of the same order of magnitude as $p$, approaching it all the more closely as internal cohesion is greater. We will therefore call the quantity $p^(i/|E|)$ the site index, which can be interpreted as the equivalent number of isolated sites.

==== Problem of isolated pages
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
      node((1.8, 0), [Isolated page], name: "end"),
      edge(<start>, <end>, "-|>"),
    ), caption: [Isolated page]) <isol>],
[#figure(diagram(
      ..graph-options,
      spacing: (1cm, .2cm),
      node((0, 0), [index.html], name: "start"),
      node((2, -1), [topic 1]),
      edge(<start>, "<|-"),
      node((2, 0), [topic 2]),
      edge(<start>, "<|-"),
      node((2, 1), [topic 3]),
      edge(<start>, "<|-"),
), caption: [Structured site]) <struct>]
)

The case of pages with in-degree 1 and out-degree zero poses a problem. While they may sometimes represent an isolated site reduced to a single page (@isol), one observes experimentally that in most cases these are pages that have been crawled but not visited (see @chalut-def) or terminal pages of structured sites (@struct). From a structural point of view, and in the absence of any other consideration, it seems legitimate to us to ensure that pages with in-degree 1 and out-degree zero are attached to the site of the parent page. This translates, at the level of the function $f(p,i)$ introduced previously, into the following inequality:

$ (forall p,i) quad f(p-1,i+1)>f(p,i) $ <pmoinsiplus>

This inequality, if one tries to impose it on our function $f$ (which is necessary if one wants $f(p,i)$ to suffice for performing the partition), raises the following problem: any partition with parameter $(p,i)$ such that

$ p <= |E| - i + 1 $ <connec>

is less effective than the trivial partition:

$ f(p,i) < f(1,|E|) $

Alas, @connec is satisfied as soon as the graph is connected. More generally, for a graph composed of $k$ connected components and $|E|$ edges, for any partition with parameter $(p,i)$ we will necessarily have the inequality

$ f(p,i) <= f(k,|E|) $

*Summary:* There exists no universal function $f(p,i)$ that is maximal for a non-trivial site partition respecting terminal pages.

Two approaches are then possible to circumvent this problem, as well as others of the same kind that one might encounter when trying to refine our model:

- Continue to seek to maximize $f(p,i)$ by imposing external rules, which would amount, for example, to working on a subset of the set of partitions of the graph. This is the approach used for the structural part of the logical domain definition employed by @li00defining.

- Replace $p$ or $i$ by new variables that handle the problem implicitly. This is the approach we will study.

==== Alteration of the variables $p$ and $i$

A first idea would consist of weighting the edges so that links to isolated pages are harder to break. Thus, a fairly classical and natural idea is to take a weight inversely proportional to the in-degree (cf. @kleinberg98). Alas, the new variable $i'$ thus introduced has numerous drawbacks, especially if it is the only alteration introduced:

First, one may consider the case of two sites (in the intuitive sense) connected by a single edge (@mono). If the algorithm is designed not to separate terminal pages, that is, if it respects the relation @pmoinsiplus, it will be forced to merge the two sites, which is not necessarily the desired effect.

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
), caption: [1-connected sites]) <mono>],
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
), caption: [Examples of 3-connected sites]) <cordon>]
)


Furthermore, if one considers the two examples of 3-connected sites in @cordon, one would like the decision to merge sites, all other things being equal, to be the same in both cases. With edge weights depending on the in-degree, this will be difficult, since the connection strength varies by a factor of three between the two cases.

An alteration by weighting partitions according to their size is another solution. More generally, if one considers a partition $V = union.big_(i=1)^p P_i$ and a weighting function $h : NN^* -> RR$, one can define the new variable $p' = sum_(i=1)^p h(|P_i|)$. The simplest solution, which we will adopt here, consists of assigning zero weight to singleton partitions (which amounts in practice to working on $(p,i)$ while imposing the rule that singleton partitions are forbidden). The choice of other functions $h$ will not be treated here, but one may hope, by choosing the right function $h$, for some control over the partition distribution, for example avoiding the formation of overly large sites by weakening $h$ for large values.

==== Chosen function $f_G$

Taking into account all the remarks we have just made, we choose as our evaluation function the function $f$ which, to a partition $cal(S) = (S_1, ..., S_p)$ of $G$, associates $p'^(i/|E|)$, where $i$ is the number of internal links and $p' = sum_(i=1)^p h(|S_i|)$, with $h = chi_([2,+infinity[)$.

==== Estimating a site partition using the URL decomposition tree

Now that we possess an evaluation function $f$ for a partition, the question arises of producing an efficient partition. An intuitive method is based on the following hypothesis, supported by the observation of @adja-fr and @adja: The #acr("URL") architecture of pages reflects the architecture of sites, and therefore blocks are _a priori_ subtrees or unions of subtrees of the Tree-Graph tree. Instead of having to choose a partition from among all possible ones, we can restrict the set of candidates to those coinciding with the tree structure.

#figure(
  image("../figures/cinq-de.pdf", width: 50%),
  caption: [The five-on-a-die pattern: a block is interleaved within another],
) <cinq-de>

This solution is not perfect, and there will always be borderline cases. Thus, in Russian-doll configurations, the choice of partition level will be closely tied to the choice of functions $f$ and $h$. On the other hand, five-on-a-die configurations (a site embedded within another at the adjacency matrix level, see @cinq-de), which are difficult to disentangle automatically using only the adjacency matrix (which nevertheless carries more information than the graph alone), will not cause problems with the decomposition tree provided that the sites coincide with the tree (which is the case for all examples tested).

We will give an example of a simple algorithm for performing an intelligent and fast partition of #acrpl("URL") using the tree-graph: the Filtered Breadth-First Search (@alg:plf).

#definition[
  The lexicographic cone of a #acr("URL") is the cluster associated, in the #acrpl("URL") decomposition tree, with the internal node that is the parent of the leaf corresponding to the #acr("URL") in question.
]


#alg(caption: [Filtered Breadth-First Search (FBFS) Algorithm])[
Data\
A set of URLs together with the associated graph $G$.\
Result\
A site partition of $G$, each site having an entry page.\
begin#i\
No vertex is marked.\
while  there remains an unmarked vertex#i\
  Choose an unmarked vertex among those of lowest height\ in the decomposition tree\
  Perform a breadth-first search on the graph starting from this vertex\ ignoring arcs leaving the lexicographic cone\
  Label the set of vertices obtained according to the starting vertex,\ which will be called the _entry page_ of the site\
  if a vertex already belonging to a site is encountered#footnote[This situation only occurs if the two vertices are siblings.]#i\
  Merge the two sites
] <alg:plf>


The advantages of this initial decomposition are as follows:

- One avoids amalgamating into a single site two sets that are very close in the tree but have no direct link in the graph. Thus, so-called "personal" sites are not merged under the sole label of the hosting provider (free, voila, multimania...); similarly, a researcher's page within a laboratory will only be part of the laboratory's site if it is referenced by the latter, which seems satisfactory to us.

- Conversely, sites hosted on several closely related servers (www.inria.fr and www-rocq.inria.fr, for example) are treated as a single entity.

There remain, unfortunately, cases that the algorithm we propose does not handle. For instance, certain sites straddle several servers that have no kinship in the lexicographic tree as we have defined it (personal sites shared between several hosting providers, commercial sites available in `.com`, `.fr`, `.de`...).

==== Results

We will compare here the partition obtained by Filtered Breadth-First Search with partitions obtained by quotienting by server, by directory at depth 1, and by directory at depth 2 (which typically corresponds to cuts at heights 3, 4, and 5 in the tree-graph). The study was conducted on the crawl of 8,212,791 #acrpl("URL") from `.fr` dated June 15, 2001. For brevity, we will call these partitions FBFS, server, 1-dir, and 2-dir.

#figure(
  image("../figures/site-puissance.pdf", width: 80%),
  caption: [Distribution of partitions as a function of their size, on a log-log scale. Legend: FBFS in red, server in blue, 1-dir in green, 2-dir in yellow],
) <site-puissance>

Let us first observe how the different partitions are distributed. @site-puissance shows the size distributions of the different partitions. One observes that regardless of the method used (FBFS, server, 1-dir, or 2-dir), the partitions obtained are distributed according to a power law#footnote[By abuse of language, we will often call a power law any phenomenon that, when represented on a _log-log_ scale, yields a curve forming approximately a straight line. The fact that the number of samples considered is finite, and the sensitivity of estimates to extreme values, means that it would be more accurate to merely speak of a _heavy tail_ phenomenon.], that is, the number of blocks of size $x$ is of order $C/x^alpha$. The values of the exponents (estimated by linear regression) are indicated in table @expo.

#figure(
  table(
    columns: 5,
    stroke: 0.5pt,
    inset: 0.5em,
    align: center,
    [*Partition*], [server], [1-dir], [2-dir], [FBFS],
    [$alpha$], [1.32], [1.75], [1.89], [1.59],
  ),
  caption: [Power law coefficients of the different partitions],
) <expo>

The power law is a law considered characteristic of social networks and human activities. The fact of encountering such a law in all cases studied, while it proves nothing by itself, shows that from the sole point of view of page distribution (without taking hyperlinks into account), the four distributions studied appear to be compatible with the human structure of the Web.

Let us also note the importance of "sites" of size 1 (the data in @site-puissance come from the partitions before any optimization), especially for the FBFS partition. The explanation is quite logical: size-1 partitions contain, among other things, all the errors that were not removed from the crawl: 4xx errors, errors in the #acr("URL") format... The FBFS partition isolates more errors than the others by construction, since a #acr("URL") that is isolated in the lexicographic cone of a site will be isolated by FBFS, unlike the other partitions.

#figure(
  table(
    columns: 5,
    stroke: 0.5pt,
    inset: 0.5em,
    align: center,
    [], [$p$], [$p'$], [$i/|E|$], [$p'^(i/|E|)$],
    [server], [39305], [27241], [0.9517], [16629],
    [FBFS], [289539], [58094], [0.9218], [24624],
    [1-dir], [182942], [137809], [0.7851], [10831],
    [2-dir], [250869], [189698], [0.7012], [5025],
  ),
  caption: [Characteristics of the different partitions before optimization],
) <recap>

Finally, let us compare the quality of the site decomposition of the different partitions, using the site index defined by the function $f$. The optimization is initially minimal: size-1 sites are merged with the site to which they are most strongly connected (most often, the connection is unique).

The results are reported in table @recap. One will note that FBFS, whose results for $p'$ as well as for $i$ are midway between server and 1-dir, achieves by far the best site index.

==== Optimization of partitions

The preceding results come from partitions that do not _a priori_ seek to maximize the site index. One can settle for these results, if one views the site index merely as a quality indicator, but one can also seek to maximize it. We will therefore examine what a local optimization by mixing yields, without FBFS and with FBFS. The principle of this optimization is simple: for each of the sites defined by the partition to be optimized, one attempts to improve the site index by replacing it with the local decomposition (server, 1-dir,...) that yields the best site index. It is therefore a greedy algorithm, and the result obtained, which is a local maximum, may depend on the order in which sites are processed.

#figure(
  table(
    columns: 4,
    stroke: 0.5pt,
    inset: 0.5em,
    align: center,
    [], [$p'$], [$i/|E|$], [$p'^(i/|E|)$],
    [optimization without FBFS, pass 1], [107884], [0.9376], [52341],
    [optimization without FBFS, pass 2], [113148], [0.9340], [52487],
    [optimization with FBFS, pass 1], [121963], [0.9338], [56165],
    [optimization with FBFS, pass 2], [118386], [0.9372], [56845],
  ),
  caption: [Characteristics of the different partitions after optimization],
) <optim>

The results are presented in table @optim. Two different traversal orders of the partitions were performed, in order to assess the fluctuations that the choice of traversal can generate, as well as their magnitude. The main results that can be drawn from this table are:

- A clear overall improvement in the site index, with the data $p'$ and $i$ being close to the maximum values technically achievable by this method.
- Optimization with FBFS remains better in all cases than optimization without FBFS, even though the added value is smaller than for the raw partitions.
- The fluctuations in $p'$ and $i$ in the four cases seem to suggest that it may be difficult to determine in advance the best optimization traversal order (a problem due to the use of a greedy algorithm).
