// =============================================================================
// Chapter 1: What is the Web? (English version)
// =============================================================================

#import "../templates/prelude.typ": *

= What is the Web? <cl-def-web>

#citation(width: 57%, [Rémy #smallcaps[Chauvin], la Biologie de l'Esprit])[
  I shall speak, for instance, of the Mind and of the "demiurge," while carefully refraining from defining too precisely what I mean by these terms: because I do not clearly know... In this dreadful state of our ignorance, must we really define so precisely?
]


#v(1cm)

== Genesis of the Web

Sources: _A History of Networks_ @genitrix04histoire.

#lettrine("Around")[the early 1960s, while a melody drifted through the sky (a bird called Sputnik), the United States decided to develop a form of decentralised network capable of withstanding a nuclear attack that would destroy one or more of its nerve centres. It was the year sixty-two.]

A few years later, this project became _ARPANET_. It was 1969 and four American universities were connected by this network of a new kind. From that moment on, the network never stopped growing and evolving, until it became what is now called the Internet#footnote[The term Internet was apparently introduced in 1974 by Vincent Cerf and Bob Kahn. Note in passing that internet and Internet do not mean the same thing! One is a common noun designating a meta-network structure, the other is a proper noun for THE meta-network using the TCP/IP protocol.], that is to say a formidable network of networks.

In 1972, the _#acr("AUP")_ charter prohibited any commercial entity from connecting to the network.

In 1984, the milestone of 1,000 machines was reached and _#acr("CERN")_ joined the Internet. Six years later, in 1990, while the number of connected computers reached 300,000, the largest Internet site in the world was that of CERN, the future birthplace of the Web, a vast worldwide collection of so-called hypertext and hypermedia documents distributed over the Internet.

That same year, 1990, the #acr("AUP") ceased to exist, paving the way for what would become, a few years later, the _Dot-com Bubble_.

In 1991, Tim Berners-Lee of #acr("CERN") introduced the concept of the _#acr("WWW")_, sometimes referred to simply as the _Web_. The #acrl("WWW") is the part of the Internet where the navigation method is HyperText and the protocol is _#acr("HTTP")_.

The philosophy of #acr("HTTP") lies in so-called _hypertext_ links that connect pages to one another and allow navigation when selected. We speak of the "Web" --- with a capital letter --- even though it is in reality the "#acrl("WWW")" or "W3".

== A Definition of the Web

Originally, as we have just seen, the _Web_ was characterised by both a protocol, _#acr("HTTP")_, and a language, _#acr("HTML")_; the former serving to deliver "pages" (files) written in the latter, interpreted on the client side by Web browsers (_Browsers_).

Nowadays, one may question the validity of this dual characterisation:

- _#acr("HTML")_ is an easy-to-learn language for writing structured documents linked to one another by hyperlinks. In practice, it is no longer used exclusively through _#acr("HTTP")_ and can be found on many other media (CD-ROM, DVD-ROM...) for purposes as numerous as they are varied (documentation, education, encyclopaedia, help...).

- In order to deliver multimedia content, _#acr("HTTP")_ is designed to serve any type of file. Images, sounds, videos, texts in various formats, archives, executables... are all accessible through the _#acr("HTTP")_ protocol, in a spirit more or less removed from the original hypertext navigation concept. This tendency toward "all-HTTP" leads to sometimes paradoxical situations. For instance, to transfer files (even large ones), there is a certain tendency to abandon the appropriate protocol, _#acr("FTP")_, in favour of _#acr("HTTP")_. As shown in @tab:httpftp#footnote[Many thanks to Philippe Olivier and Nabil Benameur for providing me with these data.], it appears that files traditionally transferred via _#acr("FTP")_ are now transferred via _#acr("P2P")_, but also via _#acr("HTTP")_ (for example, most download servers on _sourceforge.net_ use _#acr("HTTP")_).

- Certain documents that are not _#acr("HTML")_ documents allow hyperlink navigation: proprietary documents (Acrobat PDF, Flash...) or new languages (_WML_, _XML_...).

#figure(
  table(
    columns: 4,
    stroke: 0.5pt,
    inset: 0.5em,
    align: center,
    [*Year*], [*_#acr("HTTP")_*], [*_#acr("FTP")_*], [*_#acr("P2P")_*],
    [2001], [13 %], [10 %], [35 %],
    [2002], [14 %], [2 %], [50 %],
    [2004], [20 %], [_negligible_], [65 %],
  ),
  caption: [Evolution of _#acr("HTTP")_, _#acr("FTP")_, and _#acr("P2P")_ traffic (as a percentage of volume)],
) <tab:httpftp>

One can glimpse the difficulty of finding a "good" definition of the Web. For the sake of simplicity more than anything else, throughout this thesis we shall continue to define the Web according to its initial dual characterisation. Thus, we shall call _Web_ the set of documents written in _#acr("HTML")_ and available on the Internet via the _#acr("HTTP")_ protocol. We are aware of the extremely restrictive nature of this definition, but prefer to work on a well-defined and widely studied set rather than to seek an exhaustiveness that may not even be attainable.

== Accessibility of the Web

Within the Web we have just defined, the problem of visibility and accessibility of pages now arises. What can we see of the _Web_ and how can we access it? Several structurings of the Web based on these questions of visibility, accessibility, and indexability have been proposed.

=== Depths of the Web

Michael K. Bergman, in 2000, proposed the metaphor of depth to distinguish the different _Webs_ @bergman00deep. One thus distinguishes:

/ The Surface Web: the surface of the _Web_, according to Bergman, consists of all static and publicly available pages.
/ The Deep Web: conversely, the deep _Web_ consists of dynamic websites and databases accessible through a Web interface.

This vision of the _Web_ remains rather Manichaean. Danny Sullivan @sullivan00invisible proposes a third kind of _Web_, _The Shallow Web_#footnote[To remain faithful to Bergman's analogy, one could translate _Shallow Web_ as _near space_. I prefer the term _swamp_, which conveys rather well the effect of this zone of the Web on crawlers.], made up for instance of publicly available dynamic pages, such as those of the _#acr("IMDB")_ (#raw("http://www.imdb.com")), or those of the site #raw("http://citeseer.ist.psu.edu/").

=== Visibility of the Web

Chris Sherman and Gary Price propose in their book _The Invisible Web_ @sherman01invisible an approach based on visibility by the major search engines. The equivalent of the _Surface Web_ is, for Sherman and Price, the set of pages indexed by search engines. According to them, the rest of the Web then breaks down into 4 categories:

/ The Opaque Web: pages that could be indexed by search engines but are not (limitation on the number of pages indexed per site, indexing frequency, missing links to pages thus preventing crawling).
/ The Private Web: web pages that are available but voluntarily excluded by webmasters (password, metatags, or files in the page to prevent the search engine robot from indexing it).
/ The Proprietary web: pages accessible only to authorised persons (intranets, authentication systems...). The robot therefore cannot access them.
/ The Truly Invisible Web: content that cannot be indexed for technical reasons. For example, format unknown to the search engine, dynamically generated pages (including characters such as ? and &)...

=== Accessible Web

Each of the two approaches we have just seen has its advantages and disadvantages. While Bergman's definition is fairly appealing (on the one hand, a static Web accessible by clicks; on the other, a dynamic Web reachable only through queries), it does not realistically describe the current Web. The approach of Sherman and Price, namely discrimination based on indexability by search engines, is more flexible, but does not, in my opinion, always associate the right causes with the right effects#footnote[For example, all dynamic pages accessible from #raw("http://www.liafa.jussieu.fr/~fmathieu/arbre.php") @killthein should logically belong to the _opaque_ Web, whereas the categorisation of Sherman and Price seems to consign them to being completely invisible...].

A third approach, used by @broder98technique @henzinger99measuring @dahn00counting, provides a kind of synthesis of the models just mentioned. It is the model of the _accessible_ Web:

#definition[
  The accessible Web is the set of Web pages that may be pointed to by a hyperlink.

  More precisely:
  - This is equivalent to considering as part of the accessible Web any page that can be accessed simply by typing the correct address --- also referred to by the term #acr("URL") @rfc1738 --- into a browser.
  - Dynamic pages that do not have hidden variables, that is, whose possible variables are passed in the #acr("URL"), are part of the accessible Web.
]

By convention, we shall exclude certain pages from our definition of the accessible Web:
- Error pages returned by a server (_4xx_ errors, for example);
- Pages whose access by robots is forbidden by a `robots.txt` file;
- Pages protected by login and/or password (even if the login and password can be given in the #acr("URL")).

This definition obviously has its flaws as well. For example, it does not take into account at all the problem of duplicates (how should one consider two pages with strictly identical content --- for instance two #acrpl("URL") corresponding to the same physical file?), nor that of the temporal dynamicity of pages and their content (what does the accessibility of the front page of a newspaper mean? The accessibility of a page that returns the time and date?). Strictly speaking, we should thus speak of the Web accessible at a given instant $t$, and accept identifying a page with its #acr("URL") despite the inevitable redundancies. Even so, many grey areas persist. For instance, some ill-intentioned administrators do not return the same content depending on whether the requester of the page is human or not, in order to deceive search engines; others return pages adapted to the browser used by the visitor; still others check that the visitor has indeed passed through the home page before navigating within the site, and redirect them to the home page if this is not the case; finally, because of routing problems, it is entirely possible that at a given instant $t$, a server is perfectly visible from one IP address and inaccessible from another. In addition to the instant $t$, the address from which the request is made and all the information transmitted in the _#acr("HTTP")_ request must therefore also be defined.

== Intermezzo: the page that linked to all pages <lpqpvtlp>

During a discussion with Jean-Loup Guillaume and Matthieu Latapy, in that hallowed place of scientific research known as the coffee machine room, while we were arguing at length about the _bow-tie_ model proposed by Broder _et al._ @broder00graph#footnote[See #fref(<noeud-pap>).], a whimsical idea fell from the cup: what if we set up a Web page capable of linking to all other pages?

After being first written by Matthieu Latapy, whose code I then took over, a somewhat improved version of the original page is now available at #raw("http://www.liafa.jussieu.fr/~fmathieu/arbre.php") @killthein.

The principle of this page is that of a typewriter, or rather a click-writer. To reach a given page, one simply clicks its letters one by one, the resulting address being kept in memory through a variable passed as a parameter in the #acr("URL"). The page dynamically checks whether this address makes sense (whether it belongs to the indexable Web), and if so, a hyperlink is inserted to that address#footnote[The _page that links to all pages_ also displays the Google PageRank (a score from 0 to 10) when available. It does not yet make coffee, alas.]. @fig:killthein is a screenshot of the _page that links to all pages_ in action.

#figure(
  image("../figures/killthein.jpg", width: 80%),
  caption: [Screenshot of _the page that links to all pages_ in action],
) <fig:killthein>

Up to #acr("URL") length limitations (and character escaping bugs that have not yet been fixed), the page's purpose, namely to be connected by hyperlinks to virtually every page of the indexable Web, is achieved.

This page is above all a playful exercise, but it allows one to take a step back from a good number of received ideas:

- The primary goal of this page was to deliver a small jab at the interpretation generally given to the bow-tie model, and I believe this goal was achieved.

- It allows one to take with a minimum of hindsight all claims about the structure of the Web. After all, I can claim to know a portion of the Web of approximately $256^(n-55)$ pages, give or take a factor of $10^10$, where $n$ is the maximum number of characters that a #acr("URL") can contain#footnote[The #acr("HTTP") 1.1 protocol does not specify a maximum #acr("URL") length (cf @rfc2616). $n$ is therefore in principle as large as one wishes. In practice, each server has a fixed limit, on the order of a few kilobytes. Moreover, there was a time when sending a #acr("URL") longer than $8$ KB was an effective way to crash an _IIS_ server...]. This result, far exceeding all estimates of the Web's size put forward so far (see @cl-taille-web), also allows one to assert some astonishing statistics:
  - The average degree of the _Web I know_ is $257-epsilon$, where $epsilon$ is a perturbation due to _real_ pages. Moreover, contrary to everything previously believed, the degree distribution does not follow a power law but closely resembles a Dirac delta.
  - There exists a strongly connected component in the _Web I know_, and any page in the _Web I know_ almost certainly belongs to this component.

Of course, these results should not be taken at face value! I would be the first to find suspicious a paper claiming that the _Web_ has more than a googol of pages#footnote[A googol is a number equal to $10^100$. It does not honour the Russian writer Nikolai Gogol (1809--1852), but was coined in 1938 by the nephew of the American mathematician Edward Kasner (1878--1955), Milton, who was then 9 years old. Note that in French, googol is written... gogol! The name of the famous search engine is directly derived from the name invented by Kasner; there is in fact a legal dispute between Google and Kasner's heirs. Finally, let us mention that the number represented by a $1$ followed by a googol of $0$s is called googolplex.], or that heavy-tailed distributions do not exist. The _page that links to all pages_ is merely a _Saturday night idea_#footnote[I borrow this concept of a _Saturday night idea_ from Michel de Pracontal. It is "the kind of idea that researchers sometimes discuss during their leisure hours, without taking them too seriously" (#smallcaps[L'imposture scientifique en dix leçons], lesson 7, page 183).] that was put into practice, and I am perfectly aware of this. But it has the advantage of showing us in full light the immensity of the accessible Web (and in particular the impossibility of indexing it#footnote[To give a sense of scale, performing a breadth-first traversal of the _page that links to all pages_ at a rate of 10 pages per second, it would take approximately 100 million years to manage to type `http://free.fr`. As for the address `http://www.lirmm.fr`, the age of the universe is far too short for a robot to find it solely by crawling the _page that links to all pages_.]) and of urging us to understand clearly that all meaningful results one can obtain about the _Web_ in fact concern crawls that represent an infinitesimal fraction of the _indexable Web_ in terms of the number of pages.

To conclude this _intermezzo_, let us note that in terms of information theory, we doubt that the _page that links to all pages_ and its dynamic pages are worth more than the few lines of code that lie behind them.
