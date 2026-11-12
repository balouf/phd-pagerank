// =============================================================================
// Thèse : Graphes du Web - Mesures d'importance à la PageRank
// Point d'entrée de l'édition web (une page HTML par chapitre)
// =============================================================================
//
// Site complet (deux langues, PDF, index de recherche) :
//   uv run web/build.py
// Une langue à la main :
//   typst compile --features html,bundle --format bundle --input lang=fr main-html.typ web/dist/fr
//
// Les chapitres et les environnements sont les mêmes que dans main.typ. Ce qui
// diffère est ici : pas de mise en page (thesis-layout), la couche web à la
// place (templates/web/web.typ, copie vendorisée de typst-thesis-web), et un
// `chapter(...)` par page du site.
// =============================================================================

// -----------------------------------------------------------------------------
// Imports
// -----------------------------------------------------------------------------

#import "templates/i18n.typ": lang, t, _appendix-state, reset-chapter-counters
#import "templates/thesis-style.typ": thesis-content, appendix
#import "templates/meta-data.typ": *
#import "templates/math-macros.typ": *
#import "templates/environments.typ": *
#import "templates/algorithms.typ": *
#import "templates/acronyms.typ": *
#import "templates/web/web.typ": page, part, site-assets, web-rules

// Initialiser les acronymes
#init-acronyms(acronyms)

// -----------------------------------------------------------------------------
// Règles. L'ordre compte : les règles qui remplacent un élément, puis la couche
// web, puis les règles qui renvoient l'élément reçu.
// -----------------------------------------------------------------------------

#show: thesis-content
#show: thmrules

// Préfixe des titres : « Chapitre 3 — », « Annexe A — », puis « 3.1 ».
#let numero-titre(it, n) = {
  if it.level == 1 {
    let prefix = if _appendix-state.get() { t([Annexe], [Appendix]) } else { t([Chapitre], [Chapter]) }
    [#prefix #n — ]
  } else if it.level <= 3 [#n ]
}

#show: web-rules.with(
  heading-offset: 0, // le titre d'un chapitre est le <h1> de sa page
  heading-number: numero-titre,
)

// Les compteurs repartent à chaque chapitre (en PDF, thesis-layout s'en charge).
#show heading.where(level: 1): it => it + reset-chapter-counters()

// -----------------------------------------------------------------------------
// Site
// -----------------------------------------------------------------------------

#set document(author: "Fabien Mathieu")

#let site = (
  title: t(
    "Graphes du Web — Mesures d'importance à la PageRank",
    "Web Graphs — PageRank-like Importance Measures",
  ),
  repo: "https://github.com/balouf/phd-pagerank",
  other-lang: t("en", "fr"),
  favicon: "assets/favicon.svg",
)
#let chapter = page.with(site: site)

#site-assets(extra: ("assets/favicon.svg": read("web/assets/favicon.svg")))

// -----------------------------------------------------------------------------
// Pages. Le chemin est le nom du fichier sur le site, donc l'URL publique : ne
// pas le changer. Le titre est l'entrée de la navigation.
// -----------------------------------------------------------------------------

#chapter("index.html", title: t([Accueil], [Home]))[
  #include "chapters/cover.typ"
]

#chapter("disclaimer.html", title: t([Avertissement], [Disclaimer]))[
  #include "templates/disclaimer.typ"
]

#chapter("remerciements.html", title: t([Remerciements], [Acknowledgments]))[
  #if lang == "en" { include "chapters/remerciements.en.typ" } else { include "chapters/remerciements.typ" }
]

#chapter("introduction.html", title: [Introduction])[
  #if lang == "en" { include "chapters/introduction.en.typ" } else { include "chapters/introduction.typ" }
]

// =============================================================================
// PARTIE I : Structures du Web
// =============================================================================

#part(t([Partie I — Structures du Web], [Part I — Web Structures]))

#chapter("ch1-taille.html", title: t([Ch. 1 — Taille du Web], [Ch. 1 — Web Size]))[
  #if lang == "en" { include "chapters/ch1-taille.en.typ" } else { include "chapters/ch1-taille.typ" }
]

#chapter("ch2-graphe.html", title: t([Ch. 2 — Graphes du Web], [Ch. 2 — Web Graphs]))[
  #if lang == "en" { include "chapters/ch2-graphe.en.typ" } else { include "chapters/ch2-graphe.typ" }
]

#chapter("ch3-local.html", title: t([Ch. 3 — Structures locales], [Ch. 3 — Local Structures]))[
  #if lang == "en" { include "chapters/ch3-local.en.typ" } else { include "chapters/ch3-local.typ" }
]

// =============================================================================
// PARTIE II : Algorithmes de classement de pages web : les « PageRank »
// =============================================================================

#part(t([Partie II — Les PageRank], [Part II — PageRank]))

#chapter("ch4-markov.html", title: t([Ch. 4 — Chaînes de Markov], [Ch. 4 — Markov Chains]))[
  #if lang == "en" { include "chapters/ch4-markov.en.typ" } else { include "chapters/ch4-markov.typ" }
]

#chapter("ch5-pagerank.html", title: [Ch. 5 — PageRank])[
  #if lang == "en" { include "chapters/ch5-pagerank.en.typ" } else { include "chapters/ch5-pagerank.typ" }
]

#chapter("ch6-back.html", title: [Ch. 6 — BackRank])[
  #if lang == "en" { include "chapters/ch6-back.en.typ" } else { include "chapters/ch6-back.typ" }
]

#chapter("ch7-dpr.html", title: t([Ch. 7 — PageRank distribué], [Ch. 7 — Distributed PageRank]))[
  #if lang == "en" { include "chapters/ch7-dpr.en.typ" } else { include "chapters/ch7-dpr.typ" }
]

// -----------------------------------------------------------------------------
// Conclusion
// -----------------------------------------------------------------------------

#part(none)

#chapter("conclusion.html", title: [Conclusion])[
  #if lang == "en" { include "chapters/conclusion.en.typ" } else { include "chapters/conclusion.typ" }
]

// =============================================================================
// ANNEXES
// =============================================================================

#part(t([Annexes], [Appendices]))

#appendix[
  #chapter("annexeA.html", title: t([Annexe A], [Appendix A]))[
    #if lang == "en" { include "appendices/annexeA-PF.en.typ" } else { include "appendices/annexeA-PF.typ" }
  ]
  #chapter("annexe-inria.html", title: t([Annexe B], [Appendix B]))[
    #if lang == "en" { include "appendices/annexe-inria.en.typ" } else { include "appendices/annexe-inria.typ" }
  ]
  #chapter("p2p-missing.html", title: t([Annexe C], [Appendix C]))[
    #if lang == "en" { include "appendices/p2p-missing.en.typ" } else { include "appendices/p2p-missing.typ" }
  ]
]

// -----------------------------------------------------------------------------
// Bibliographie
// -----------------------------------------------------------------------------

#part(none)

#chapter("bibliography.html", title: t([Bibliographie], [Bibliography]))[
  #bibliography("bibliography.yml", style: "ieee")
]
