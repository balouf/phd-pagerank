// =============================================================================
// Métadonnées de la thèse
// =============================================================================

#import "i18n.typ": lang, t

// -----------------------------------------------------------------------------
// Résumés et mots clés
// -----------------------------------------------------------------------------

#let french-abstract = [
L'application des mesures d'importance de type PageRank aux graphes du Web est le sujet de cette thèse, qui est divisée en deux parties. La première introduit une famille particulière de grands graphes, les graphes du Web. Elle commence par définir la notion de Web indexable, puis donne quelques considérations sur les tailles des portions de Web effectivement indexées. Pour finir, elle donne et utilise quelques constatations sur les structures que l'on peut observer sur les graphes induits par ces portions de Web.

Ensuite, la seconde partie étudie en profondeur les mesures d'importance _à la_ PageRank. Après un rappel sur la théorie des chaînes de Markov est présentée une classification originale des algorithmes de PageRank, qui part du modèle le plus simple jusqu'à prendre en compte toutes les spécificités liées aux graphes du Web. Enfin, de nouveaux algorithmes sont proposés. L'algorithme _BackRank_ utilise un modèle alternatif de parcours du graphe du Web pour un calcul de PageRank plus rapide. La structure fortement clusterisée des graphes du Web permet quant à elle de décomposer le PageRank sur les sites Web, ce qui est réalisé par les algorithmes _FlowRank_ et _BlowRank_.
]

#let french-keywords = [
  Graphes --- Web --- Arbre de décomposition --- Matrices sous-stochastiques \ PageRank --- Surfeur aléatoire --- Algorithmes --- Retour arrière -- Flots d'importance
]

#let english-abstract = [
  The purpose of this thesis is to apply PageRank-like measures to Web graphs. The first part introduces the Web graphs. First we define the notion of indexable Web, then we give an insight on how big the effective crawls really are. Finally, we notice and use some of the structures that exist on the portions of the Web known as Web graphs.

  Then, the second part study deeply the PageRank algorithms. After a remainder on Markov chains theory is given an original classification of PageRank algorithms. From a basic model, we incorporate all the specificities needed to cope with real Web graphs. Lastly, new algorithms are proposed. BackRank uses an alternative random surfer modeling leading to a faster computation. The highly clustered structure of Web graphs allows a PageRank decomposition according to Web sites, and is the reason for introducing the algorithms FlowRank and BlowRank.
]

#let english-keywords = [
  Graphs --- WWW --- Decomposition tree --- Substochastic matrix \ PageRank --- Random walk --- Algorithms --- Backoff process --- Importance flows
]

// -----------------------------------------------------------------------------
// Informations générales
// -----------------------------------------------------------------------------

#let thesis-title = t(
  [#smallcaps[Graphes du Web] \ #smallcaps[Mesures d'importance à la PageRank]],
  [#smallcaps[Web Graphs] \ #smallcaps[PageRank-like Importance Measures]],
)

#let thesis-author = [Fabien #smallcaps[Mathieu]]
#let thesis-type = t([Thèse de doctorat], [Doctoral Dissertation])
#let thesis-date = t([8 décembre 2004], [December 8, 2004])
#let thesis-specialty = [Informatique]
#let thesis-doctoral-school = [Information, Structures, Systèmes]
#let thesis-formation = [Informatique]

// -----------------------------------------------------------------------------
// Jury
// -----------------------------------------------------------------------------

#let thesis-jury = (
  (
    name: [M. Serge #smallcaps[Abiteboul]],
    position: [Directeur de recherche, INRIA],
    role-key: "reviewer",
  ),
  (
    name: [M. Vincent #smallcaps[Blondel]],
    position: t([Professeur, UCL (Belgique)], [Professor, UCL (Belgium)]),
    role-key: "guest",
  ),
  (
    name: [M. Pierre #smallcaps[Fraigniaud]],
    position: [Directeur de recherche, CNRS],
    role-key: "reviewer",
  ),
  (
    name: [M. Michel #smallcaps[Habib]],
    position: t([Professeur, LIRMM, Montpellier], [Professor, LIRMM, Montpellier]),
    role-key: "advisor",
  ),
  (
    name: [M. Alain #smallcaps[Jean-Marie]],
    position: [Directeur de recherche, INRIA],
    role-key: "chair",
  ),
  (
    name: [M. Laurent #smallcaps[Viennot]],
    position: t([Chargé de recherche, INRIA], [Research Scientist, INRIA]),
    role-key: "coadvisor",
  ),
)

#let jury-role(key) = {
  let roles = (
    reviewer: t("rapporteur", "reviewer"),
    guest: t("invité", "guest"),
    advisor: t("directeur de thèse", "thesis advisor"),
    chair: t("président", "chair"),
    coadvisor: t("co-encadrant", "co-advisor"),
  )
  roles.at(key)
}
