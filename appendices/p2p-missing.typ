// Annexe C : Persistence et diffusion des fichiers dans les réseaux pair-à-pair

#import "../templates/prelude.typ": *

= Persistence et diffusion des fichiers dans les réseaux pair-à-pair <annexe:p2p>

L'impossibilité de finir de télécharger des fichiers est une situation fréquente dans les réseaux pair-à-pair de partage de fichiers. Si parfois ce problème semble intrinsèquement lié à la nature du réseau, il semble que même des réseaux _intelligents_ vis-à-vis du téléchargement peuvent aboutir à une situation où toutes les parties du fichier sont disponibles sauf une.

Nous proposons un modèle simple et évolutif de partage de fichiers qui peut s'appliquer à tous les protocoles de téléchargement par blocs, comme ou BitTorrent. Les simulations montrent que le cas du _fichier manquant_ peut se produire même pour des fichiers populaires, et donnent quelques pistes théoriques.

Ces nouveaux résultats permettent une autre approche des problèmes de téléchargements dans les réseaux de partage de fichiers, et de nouvelles stratégies sont proposées.

== Introduction <introduction>

A P2P file-sharing network is an interface that permits the exchange of data between users arriving and departing independently. P2P issues can be classified in three categories:

- dynamical management of subjacent overlay networks @stoica01chord @zhao01tapestry @ratnasamy01scalable @harvey03skipnet;
- publication and search of shared content @kangasharju01object @cohen02replication;
- downloading protocols.

The last domain, downloading protocols, seems less studied than the two others. However, countless people have downloading issues every day. In this paper we focus on the "unfinished download" case.

For example, imagine you want to download your favorite linux distribution. For more efficiency, you use three of the most popular file-sharing softwares, KaZaA, MLDonkey MlDonkey @fessant03mldonkey and BitTorrent @cohen-incentives. Downloads start, no problem to be seen, you leave for a week. When you come back, none of your downloads is finished, downloading is null, all you got are those messages:

/ KaZaA: ```
415312kb/714204kb downloaded;
    more sources needed
```

/ eDonkey: ```
64/65 parts downloaded;
    last seen complete: a long time ago
```

/ Bittorrent: ```
99,7% downloaded; connected to 0 seeds;
    also seeing 0.997 distributed copies
```

The KaZaA message is not so surprising knowing that KaZaA peers only upload finished downloads. As long as there exists a user sharing the whole file, downloads go on#footnote[Note that as we will see, downloads in KaZaA are less efficient than in the two others which allow partially downloaded content to be shared.], but once this (these) user(s) quit(s), all is over. The cases of eDonkey and Bittorrent are more interesting. To allow partially downloaded content to be shared, these protocols broke files into smaller blocks. Experience shows it is not just bad luck if the download stagnates at the last block.

In the next section, we introduce the approach and the different assumptions used in our model. @simul shows interesting results coming from simulations of the model. In @torpor we present some stability results for simulations of @simul. This highlights a frequent issue in real file-sharing networks, called _missing block_ issue. @comparison compares the different upload strategies and gives characteristics of safe states, where the data can potentially survive forever...

== Model <model>

The whole point of this article is to study the sharing of a single file in a totally connected overlay network, which we call _torrent_. We suppose the implicite existence of a server that organizes the users but does not possess the file itself. This fits well Bittorrent protocol, as users must connect to a so-called _tracker_ to participate. _Peers_ are users that want to download the file, and that can potentially share partial content. _Seeds_ are users that share the whole file. To resume, a torrent is made up of $S$ seeds and $P$ peers trying to get a file split in $K$ blocks.

Study of such strategies is often complex due to subjacent prisoner's dilemma. The problem is indeed to minimize the downloading time for each user and to maximize the probability that the file stays in the network even for low request frequencies. The former is an individual optimization but the latter benefits to the whole community, and both optimizations are made with detriment of the other. To simplify the problem we will make the following assumptions:

- Most models are download-oriented: the peers try to download blocks they need from peers or seeds they know. We choose an upload approach, where peers and seeds decide which block they upload and to whom it is uploaded. Even if it does not exactly reflect the reality, we think it makes strategy clearer without altering practical activity.

- Everyone that can upload a block to somebody will do so. Once again, reality is more complex (@cohen-incentives uses a choking algorithm to stimulate the exchanges), but we have a good approximation. Peers and seeds often choose a maximum upload bandwidth and a maximum number of connections and stay stuck to these maxima. As we show in @torpor, this leads to an interesting result, called "torpor" where upload can sometimes severely injure a torrent.

== First simulations <simul>

In this section, we suppose $S$ and $P$ are fixed. It can be interpreted as the worst case of peer behavior: a given number of philanthropic seeds are opposed to greedy peers that leave as soon as their download is finished and are instantly replaced by other greedy peers waiting in a queue. We want to study how that sort of torrent depends on the seeds. In other word we want to investigate the chance that the networks keeps distributed copies of the file even if no seed is present.

=== Strategies <strategies>

The state of a torrent at a given moment can be represented by a logical $T=(t_(p,k))_(1 <= p <= P, 1 <= k <= K)$ matrix where:

$
t_(p,k) = cases(
  1 & "if user" p "possesses the block" k,
  0 & "otherwise"
)
$

Anytime a block upload is finished, according to our assumptions, the uploader must choose another couple $(upright("peer"), upright("block"))$ and begin another upload. Strategies in our model resume in strategies in the choice method. We propose the following strategies:

/ Globally random strategy: In GRS, each uploader chooses a couple $(p,k)$ at random.

/ Block then peer decomposition: The uploader chooses the block it will upload, then the peer that will receive it.

/ Peer then block decomposition: Inverse as above.

Decompositions strategies vary with the sub-choice method. We propose two basic methods: uniformly random choice, that is self-explicit, and positive discrimination choice, where you choose the rarest block or the poorest peer in term of download progress#footnote[We remark that a decomposition strategy that uses random in both choices is not equivalent to the globally random strategy.]. For simplicity, we call decomposition strategies by initials. For example, BRPD strategy means a #strong("B")lock is #strong("R")andomly chosen, then the #strong("P")eer is selected using positive #strong("D")iscrimination.

=== Results

We choose $S=1$ and $P=100$ and $K=120$. Everyone has the same upload bandwidth, so we can say the time to upload one block is the time unit. The ratio download/upload $r$ is infinite#footnote[Actually, for most people using ADSL, this ratio is 4 or 8. Later, we will give results for such ratios.]: the number of blocks a peer can get in a time unit is not bounded.

#figure(
  image("../figures/stable-state.pdf", width: 60%),
  caption: [Stable state in a globally random upload strategy],
) <stable-mat>

#figure(
  image("../figures/torpor.png", width: 60%),
  caption: ["torpor" state in a globally random upload strategy],
) <torpor-mat>

Simulations using the GRS starting with $P$ empty peers (the deployment phase) tend towards two different stationary states, that we will call _safe_ state and _torpor_ state. Both states are roughly equiprobable. In safe state, seeds are unnecessary and the peers suffice themselves for themselves to keep the torrent alive. In torpor, there is a block possessed only by the seed (most of the time no peer possesses it), all the peers are waiting forever for the missing block and contaminating the newcomers. If the seed quits in a torpor state, the torrent dies. @stable-mat shows the matrix $T$ in a typical stable state and @torpor-mat shows a typical torpor state (lines represent peers; line $0$ stands for the seed).

Other strategies converge towards either a stable state or a torpor state:

- BRPR and PRBR converge towards a torpor state.
- other strategies tends towards a safe state.

We note that all the safe states are not identical. Parameters like the average block density or the download speed can vary, as discussed in @comparison.

== "torpor" characteristics <torpor>

Torpor is a dangerous state where the torrent can not live without seed. This is why we want to deepen the whereabouts of this state.

=== _Torpor_ apparition

#figure(
  image("../figures/popu_blocks_statio.pdf", width: 60%),
  caption: [Population of each block in a stable state],
) <blocks>

The appearance of torpor in the deployment of a torrent is intuitively easy to understand. All safe states imply all the blocks having on average the same density (as shown by @blocks). On the contrary, torpor means having a very rare block and the others almost totally spread. In the growing phase, the obligation of upload leads to a geometric progression of every block uploaded by the seed(s). This leads to strong irregularities of the block distribution in the earlier times. If this irregularities are not correctly smoothed by the subjacent upload strategy, the death of the torrent can occur during the earlier cycles. This is why BRPR and PRBR strategies always lead to torpor and positive discriminant strategies always lead to safe states: the first ones do nothing about the block distribution while the last ones are all about equity. We can then wonder why a safe state can be reached using GRS. Intuitively, the answer is that GRS is partially positive discriminant: the probability for a block $k$ to be downloaded is basically proportional to the number of peers needing this file, and the probability for a peer $p$ to receive a block is roughly proportional to the number of blocks it needs.

=== _Torpor_ robustness

In _torpor_ state, we call "patients" peers having all the blocks but the missing one. Because of the contagion of the patients, a torpor can be irremediable even using the smartest strategy, assuming peers that are able to upload do so. For example, if $S=1$ and $r=+infinity$, a _torpor_ will be stable as long as $P >= K$. The time to "heal" a patient is then greater or equal than the time to contaminate a newcomer. This result spreads with $r$ and $S$ unspecified, and a sufficient (but not necessary) condition for stability, independent from the strategy, is:

$ P >= S + S(K-1)(1 + 1/r) $ <torpor-stab>

#demo[
  A torpor is necessary stable when the contaminating power of patients is greater than the "healing" power of seeds. The number of newcomers patients can contaminate in a time unit is $P'/(K-1)$, where $P'$ is the number of patients. Seeds can heal at most $S$ patients per time unit. Healed patients (newcomers) need $(K-1)/r + 1$ time units to be recontaminated.

  As long as $P'/(K-1) >= S$, the torpor is stable (note that $P'$ can vary at each time unit). The healing bound implies $P - P' <= S((K-1)/r + 1)$. These two inequalities lead to @torpor-stab.
]

With the assumption _everyone that can upload a block to somebody will do so_, patients will always perform good strategies to contaminate other peers. On the other hand, the healing strategy of seeds must be highly precise to be efficient (each seed must heal a patient with each time unit). Thus we can say that @torpor-stab is a precise stability bound for strategies using positive discrimination first (whether it is on the peers or the blocks), while torpor stability in random oriented strategies is much more important.

=== The missing block in real networks

Although our model is upload-oriented, it captures a phenomena that occurs in real peer-to-peer sharing networks. For now, we can only give intuitive reasons for that. In eDonkey networks, users trying to get a file are waiting in a queue, and once their turn comes, they are granted one (or more) blocks. As far as we know, the choice of the block is random (except possibly for the first and the last block, for previewing purpose). The queue system is _a priori_ independent from the number of blocks users possess (although it may be possible there is a slightly negative discrimination due to the fact that "old" peers are more likely to have at the same time many blocks and good positions in queues). Thus we would say eDonkey transferts can be seen as a RPRB strategy. Knowing how this strategy is sensible to torpor phenomenons, we may have an interpretation of torpor in eDonkey.

For Bittorrent networks, apparition of torpor seems more surprising, as the strategy is globally a block-oriented positive discrimination. Then again, we can only rely on empiric observations to suppose torpor can happen when $P$ tends toward 0 (after a first rush, the torrent becomes less attractive). In future work, we will introduce a flexible processus for arriving of newcomers and try to verify this hypothesis. However, equation @torpor-stab shows that when a torpor occurs, healing can be fastidious or even impossible. A frequent strategy for the original seed of a torrent (the user that first offered the file to be shared) when downloads are stopping is to re-seed, that is to reintegrate the torrent the time for new seeds to appear, then to leave. The problem is real patients are often almost as miserly as the patients of our model. That means they stay in the torrent a few moments after the download is complete, then leave. Then we can imagine the following situation: after a torpor, the original seed decides to reintegrate the torrent. Rapidly, many patients become "seeds", so the original seed quits believing the torrent is alright. But if the torpor is not completely healed, the odds are high for the remaining patients to contaminate the torrent again once the "seeds" are gone.

==== Importance of the last block

We can wonder if it is that important if there is a block missing. With Error-Correcting Codes (ECC), it is possible to share files that can be completed without all the blocks. But ECC alone can not solve the problem for long: knowing a missing block is acceptable, peers will start to behave consequently. So ECC allow a torrent to function in torpor. We just consider a virtual torrent with $K-1$ blocks. And what happen if this virtual torrent goes in torpor?

The conclusion of this section is that the missing block is a real issue in P2P networks today, and that a real optimization of the transferts strategies can be beneficial.

== Efficiency of upload strategies <comparison>

We now want to compare the different strategies seen in @strategies on other domains than stability, such as average download speed, original diffusion, density, and robustness to _very greedy peers_.

=== Average download speed

The global download speed is bounded by the sum of upload bandwidths. For a $(S,P)$ torrent with uniform upload bandwidth $U$, the average download speed can not be greater than $overline(D)_max = (S+P)/P U$. Simulations show that whenever a safe state is reached, average download speed tends towards this limit.

If the torrent goes in torpor, average download speed can be lessened: it is a good approximation to say that only seeds can trigger the end of a download. Thus if there is one seed and if the theoretical minimum average time between 2 finished download is inferior to a time unit, peers are going to stay idle (without uploading) part of the time. More precisely, with $S$ seeds, the average download speed is bounded by $min((S dot K)/P overline(D)_max, overline(D)_max)$.

=== Speed of Deployment

The deployment is the very dangerous phase of a torrent. If the original seed leaves before it ends, the game is over. Moreover, the original seed often wants to minimize its upload time. For both reason, deployment must be fast. The minimum time for deployment is the time for the original seed to upload each block one time, that is $K$ time units. It is achieved if a positive discrimination on blocks is used.

==== Linear strategy

Sharing a file linearly (from the first to the last block) like KaZaA protocol is not a good idea from a torpor point of view. Even if peers do not quit as soon as they get their last block, the last blocks of the file are very likely to miss sooner or later. The quality of deployment in a linear strategy is also far from optimal, whatever the peer strategy is:

- If the original seed allow every peers to download its block, deployment will take $P dot K$ time unit (assuming all peers are treated equally).
- The original seed can restrain the peers allowed to download from it to a subset of size $Q < P$, so time for deployment will be $Q dot K$ time units.
- In KaZaA networks where you cannot share a file until you completely possess it, achieving the minimum deployment times implies to upload to only one peer. If the original seed quits after that, you come back to the original state, except the original seed is know a new seed whose reliability is unknown.

==== Random block strategies

Strategies where blocks are chosen at random are not really better. In fact, the more $K$ is important, the more the original seed has to upload, as shown by the following theorem:

#annexe_theoreme[
  Given a set $F = {1, ..., k}$, the mean time to choose one block of each in a random choice repeated in $F$ is equivalent to $k ln(k)$.
]

#demo[
  let $T_k$ be the stopping time (in number of draws) when in the sequence of number chosen each symbol $1, 2, ..., k$ is at least one time. Then
  $ EE(T_k) = sum_omega T_k (omega) $

  Let's look the evolution of the process:

  + a first number is chosen (with probability 1)
  + with probability $(1\/k)^(i_1) (k-1)/k$ it is chosen $i_1$ times before other one is taken.
  + with probability $(2\/k)^(i_2) (k-2)/k$ one of both is chosen $i_2$ times before an other one is taken.
  + ...
  + with probability $(1 - 1\/k)^(i_(k-1)) 1/k$ one of the $k-1$ last ones is chosen $i_(k-1)$ times before the last one is taken.

  for one of those trajectories $T_k = k + i_1 + i_2 + ... + i_(k-1)$. Thus
  $
    EE(T_k) &= sum_(i_1 ... i_(k-1)) ((k + i_1 + i_2 + ... + i_(k-1)) dot (1\/k)^(i_1) (k-1)/k ... (1-1\/k)^(i_(k-1)) 1/k) \
    &= (k-1)/k ... 1/k sum_(i_1 ... i_(k-2)) (1\/k)^(i_1) ... (1-2\/k)^(i_(k-2)) dot \
    & #h(2em) (sum_(i_(k-1)) (k + i_1 + i_2 + ... + i_(k-1)) (1-1\/k)^(i_(k-1))) \
    &= ((k-1)!) / k^(k-1) sum_(i_1 ... i_(k-2)) (1\/k)^(i_1) ... (1-2\/k)^(i_(k-2)) dot \
    & #h(2em) ((k-1 + i_1 + i_2 + ... + i_(k-2)) 1/(1-(1-1\/k)) + sum_(i_(k-1)) (1 + i_(k-1)) (1-1\/k)^(i_(k-1)))
  $

  Notice that $sum_(i in NN) (i+1) X^i = d/(d X) (1/(1-X))(X) = (1/(1-x))^2$ it also true in $RR$ for $X = x$ with $abs(x) < 1$. Thus
  $
    EE(T_k) &= 1 + 1/(1 - 1\/k) + ... + 1/(1-(1-1\/k)) \
    &= k (1\/k + 1\/(k-1) + ... + 1\/1) \
    &= k (ln(k) + gamma + epsilon(k))
  $

  with $epsilon(k)$ tending towards $0$ and $gamma$ is the Euler constant.
]

=== Density

In Bittorrent, the number of distributed copies seen and the average download are often considered as indicators of wealth. As said before, each block in a safe state has roughly the same density, so the two parameters are basically proportional (see @blocks). From this point of view, peer-oriented discriminant strategies seem to be better, as most of the earlier blocks are possessed very fast. But as we see in next paragraph, having the biggest density is not always a good thing.

=== Robustness to _very greedy peers_

_Very greedy peers_ (VGP) are peers wanting to get their file as soon as possible and that are likely to trick the torrent to do so.

==== VGP and positive discrimination

Positive peer discrimination helps new users to get blocks faster. It increases the probability that the uploaded blocks can be uploaded many times. By construction this leads to stable states where the repartition of blocks has a small standard deviation (in PDB(DR) it is close to 0). Intensity of users arrivals is maximal, because users can upload almost every time. The problem is that the peers wait a very long time at the end to get their last block (see @speed_opti for download speed during download progress), and that it is profitable to cheat by announcing that you have to download a number of blocks larger than your real one. With $K=60$ and $P=120$ (parameters of @speed_opti), declaring 2 missing files instead of 1 increases the average download speed by 86, thus increasing the average effective download speed of the last block by 43.

#figure(
  image("../figures/speed_opti.png", width: 60%),
  caption: [Average download speed in the download progress in a positive peer discrimination strategy],
) <speed_opti>

==== VGP robust strategies

Let $f(k)$ be the average speed download of peers possessing $k$ blocks. A strategy is robust regarding VGP if asking for blocks you already have is not benefic.

A random-block strategy is VGP-robust if $f$ has the following property:

$ (f(k))/(K-k) "increases" $ <eq:VGP>

#demo[
  A peer possessing $k_1$ blocks and declaring $k_2 < k_1$ blocks will have a average download speed of $f(k_2)$ with a proportion $(K-k_1)/(K-k_2)$ of useful blocks if the block strategy is random. Thus lying is not profitable if $f(k_1) > (K-k_1)/(K-k_2) f(k_2)$. This is the case if the function $k arrow.r (f(k))/(K-k)$ increases.
]

We remark that this result stay true in a discriminant-block strategy if the state is safe, because all the block have roughly the same density. In a torpor state with seeds, this result is false: lying allow the VGP to get the missing block faster than expected, with heavy cost for the torrent (one of the few who possesses the missing block leaves sooner).

We verify easily that positive peer-discrimination does not fulfill @eq:VGP for $k = K-1$. Contrary, in GRS, the download speed (in a safe state) is basically an affine function of $k$ (see @speed_statio) that fulfill @eq:VGP. This linearity can be intuitively explained if we arbitrary change the number of blocks $k$ a given peer $p_0$ possesses (all other parameters being unchanged). The average speed download for $p_0$ will be obviously proportional to the $K-k$ missing blocks. Unlinearities noted in @speed_statio comes from random fluctuations and retroactions that have been neglected.

The conclusion of the study of VGP is that positive peer-oriented strategies are not robust, and that it is better to sacrifice some density and homogeneity (see @download for a typical download distribution in GRS) to gain robustness. Especially when that does not harm the global download speed, as we have seen.

#figure(
  image("../figures/speed_statio.pdf", width: 60%),
  caption: [Average download speed in the download progress : GRS-stable case],
) <speed_statio>

#figure(
  image("../figures/download.pdf", width: 60%),
  caption: [Repartition of download progresses among users in GRS],
) <download>

== Future work

We think it is possible to study the stability of GRS and the probability of torpor during deployment using a mean field theory. That should give a base to purpose new strategies. We also want to improve our model using variable upload bandwidth and departing and arriving of peers (@sgg gives precious information about real distributions). This will allow to make our model more accurate and to verify some hypothesis such as the apparition of torpor during the decline of the torrent and the difficulty to reseed. Lastly, we think about analyzing logs from eDonkey servers and Bittorrent trackers to validate our model.

== Conclusion

We gave a rather precise and intuitive survey of missing block issues. We showed that a block-oriented discriminant strategy is more efficient than a random strategy, so we could say Bittorrent behaves better that eDonkey from this point of view. Lastly we saw that peer-oriented discrimination is less important, it can even be damageable regarding to bad social behavior. These results could be used to enhance existing protocols. For example, a tracker aware of torpor issue could anticipate it and reseeding could be more effective.
