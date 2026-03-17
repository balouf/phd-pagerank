// =============================================================================
// Thèse : Graphes du Web - Mesures d'importance à la PageRank
// Point d'entrée pour l'export HTML
// =============================================================================
//
// Compilation:
//   typst compile --features html --format html --input lang=fr --input html=true main-html.typ web/dist/full.html
//   typst compile --features html --format html --input lang=en --input html=true main-html.typ web/dist/full.html
// =============================================================================

// -----------------------------------------------------------------------------
// Imports
// -----------------------------------------------------------------------------

#import "templates/i18n.typ": lang, t
#import "templates/thesis-style.typ": *
#import "templates/meta-data.typ": *
#import "templates/math-macros.typ": *
#import "templates/environments.typ": *
#import "templates/algorithms.typ": *
#import "templates/acronyms.typ": *
#import "templates/html-overrides.typ": *

// Initialiser les acronymes
#init-acronyms(acronyms)

// Appliquer le style de thèse (page/headers seront ignorés en HTML, c'est OK)
#show: thesis-style

// Appliquer les show rules HTML (math → SVG, grid → SVG)
#show: html-show-rules

// Configurer les théorèmes
#show: thmrules


// -----------------------------------------------------------------------------
// Métadonnées HTML
// -----------------------------------------------------------------------------

#set document(
  title: t(
    "Graphes du Web - Mesures d'importance à la PageRank",
    "Web Graphs - PageRank-like Importance Measures",
  ),
  author: "Fabien Mathieu",
)
// Note: thesis-title utilise du markup (smallcaps), donc on garde des chaînes simples ici pour le HTML.

// -----------------------------------------------------------------------------
// Page de titre (version HTML simplifiée)
// -----------------------------------------------------------------------------

#chapter-section("cover")[
  #include "chapters/cover.typ"
]

// -----------------------------------------------------------------------------
// Avertissement
// -----------------------------------------------------------------------------

#chapter-section("disclaimer")[
  #include "templates/disclaimer.typ"
]

// -----------------------------------------------------------------------------
// Remerciements
// -----------------------------------------------------------------------------

#chapter-section("remerciements")[
  #if lang == "en" {
    include "chapters/remerciements.en.typ"
  } else {
    include "chapters/remerciements.typ"
  }
]

// -----------------------------------------------------------------------------
// Introduction
// -----------------------------------------------------------------------------

#chapter-section("introduction")[
  #if lang == "en" {
    include "chapters/introduction.en.typ"
  } else {
    include "chapters/introduction.typ"
  }
]

// =============================================================================
// PARTIE I : Structures du Web
// =============================================================================

#part-marker("part-1", t([Partie I — Structures du Web], [Part I — Structures of the Web]))

#chapter-section("ch1-taille")[
  #if lang == "en" {
    include "chapters/ch1-taille.en.typ"
  } else {
    include "chapters/ch1-taille.typ"
  }
]

#chapter-section("ch2-graphe")[
  #if lang == "en" {
    include "chapters/ch2-graphe.en.typ"
  } else {
    include "chapters/ch2-graphe.typ"
  }
]

#chapter-section("ch3-local")[
  #if lang == "en" {
    include "chapters/ch3-local.en.typ"
  } else {
    include "chapters/ch3-local.typ"
  }
]

// =============================================================================
// PARTIE II : Algorithmes de classement de pages web : les « PageRank »
// =============================================================================

#part-marker("part-2", t(
  [Partie II — Algorithmes de classement de pages web : les « PageRank »],
  [Part II — Web Page Ranking Algorithms: PageRank],
))

#chapter-section("ch4-markov")[
  #if lang == "en" {
    include "chapters/ch4-markov.en.typ"
  } else {
    include "chapters/ch4-markov.typ"
  }
]

#chapter-section("ch5-pagerank")[
  #if lang == "en" {
    include "chapters/ch5-pagerank.en.typ"
  } else {
    include "chapters/ch5-pagerank.typ"
  }
]

#chapter-section("ch6-back")[
  #if lang == "en" {
    include "chapters/ch6-back.en.typ"
  } else {
    include "chapters/ch6-back.typ"
  }
]

#chapter-section("ch7-dpr")[
  #if lang == "en" {
    include "chapters/ch7-dpr.en.typ"
  } else {
    include "chapters/ch7-dpr.typ"
  }
]

// -----------------------------------------------------------------------------
// Conclusion
// -----------------------------------------------------------------------------

#chapter-section("conclusion")[
  #if lang == "en" {
    include "chapters/conclusion.en.typ"
  } else {
    include "chapters/conclusion.typ"
  }
]

// =============================================================================
// ANNEXES
// =============================================================================

#appendix[
  #chapter-section("annexeA")[
    #if lang == "en" {
      include "appendices/annexeA-PF.en.typ"
    } else {
      include "appendices/annexeA-PF.typ"
    }
  ]
  #chapter-section("annexe-inria")[
    #if lang == "en" {
      include "appendices/annexe-inria.en.typ"
    } else {
      include "appendices/annexe-inria.typ"
    }
  ]
  #chapter-section("p2p-missing")[
    #if lang == "en" {
      include "appendices/p2p-missing.en.typ"
    } else {
      include "appendices/p2p-missing.typ"
    }
  ]
]

// -----------------------------------------------------------------------------
// Bibliographie
// -----------------------------------------------------------------------------

#chapter-section("bibliography")[
  #bibliography("bibliography.yml", style: "ieee")
]
