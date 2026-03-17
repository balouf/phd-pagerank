// Conclusion (English version)

#import "../templates/prelude.typ": *

= Conclusion <chapCcl>

#citation([Alain #smallcaps[Finkielkraut]])[The Internet is the meeting place of researchers, but also of every crackpot, every voyeur, and every piece of gossip on earth.]

After these few years of doctoral work, it appears to me that my understanding of Web graphs, PageRanks, and the mechanisms governing them has grown considerably since my tentative beginnings when, following a lead laid out by Daniel Krob, I was trying to detect _hot spots_ on the Web; an understanding that I have endeavoured to share with the reader throughout this work. This conclusion summarises the work already accomplished, as well as what remains to be done.

#align(center)[---]

The first chapter presented that human achievement which is the Web. Defining the latter generated more problems than solutions, and faced with the many facets of the electronic web, we had to limit our field of study to what we called the indexable Web.

We then considered _crawlers_, those trawlers of the Web that ceaselessly traverse the indexable Web in order to populate databases, and we studied the sizes of the largest of these databases, namely those of search engines. In particular, we highlighted the precautions that were necessary when dealing with figures announced by commercial search engines, which sometimes seem fanciful.

We then dwelt on several aspects of the graph structure induced by hyperlinks: the bow-tie structure, and the misinterpretations that are sometimes made of it; the site-level structure, which is closely tied to the URL decomposition tree. We set aside certain structural aspects that have been extensively studied elsewhere, such as the distribution of in-degrees and out-degrees @albert99diameter @barabasi99emergence @albert00scalefree or the small-world structure of Web graphs @adamic99small @kleinberg99smallworld @puniyani01intentional. These aspects, although interesting, fall outside the scope of this thesis.

#align(center)[---]

The second part got to the heart of the matter: PageRank-type ranking methods. We began in @pr-markov with some reminders on Markov chains, their representation using stochastic matrices, and the application of the Perron-Frobenius theorem to stochastic matrices to find stationary distributions. We also studied some convergence results for sub-stochastic matrices. All the results presented in this chapter have most certainly been presented many times in the literature, but we chose to re-derive them in order to introduce a formalism extensively used throughout the remainder, for example to describe sub-stochastic matrices. The wheel was certainly reinvented more than once in this chapter, but we thereby ensured that the size of said wheels was the right one.

In @pr-pagerank, we defined the general principles governing PageRank, stated the problem, and catalogued the most classical algorithms. We aimed to distinguish ourselves from other surveys on the subject @bouklit01methodes @bouklit02analyse @bianchini02pagerank @bianchini03inside @langville04deeper by offering a different perspective, notably through a unification of the dual interpretation --- stochastic and flow-based --- associated with the various algorithms. Some problems raised in this chapter would have deserved a more thorough study, which I hope to have the opportunity to carry out in the near future. This is the case, for instance, for the link between the convergence of a PageRank ranking and that of its distribution, which is addressed in @sec:kemeny.

The last two chapters then provided the opportunity to present new PageRank algorithms. The reader will have discovered the _BackRank_ algorithm, which models the possibility for a surfer to go back during navigation. We showed that this algorithm is no more complicated to implement than a classical PageRank algorithm, while offering numerous advantages in terms of convergence and the handling of dangling pages. Finally, after abandoning the stochastic interpretation of PageRank in favour of a flow decomposition, we introduced two PageRank computation algorithms based on the strongly clustered structure of Web graphs: an exact algorithm, _FlowRank_; and an approximate algorithm, inspired by the _BlockRank_ algorithm proposed in @kamvar-exploiting: _BlowRank_. The decomposition on which these algorithms are based opens the way to a broad range of semi-distributed and local PageRank estimation methods.

The study of these algorithms is far from complete; they still need to be tested on very large graphs and, why not, incorporated into a real search engine. At the time of writing, I am conducting experiments with Mohamed Bouklit on the graphs available on the _WebGraph_ project website @Webgraph, the largest of which has 118 million vertices. The results, very promising, point in the same direction as those presented in this thesis.
